﻿(function()
{
    'use strict';

    var serviceId = 'repository.abstract';

    angular.module('app').factory(serviceId, ['$q', 'common', 'config', AbstractRepository]);

    function AbstractRepository($q, common, config)
    {
        var EntityQuery = breeze.EntityQuery;
        var logError = common.logger.getLogFn(this.serviceId, 'error');

        var _predicates =
            {
            isNotNullo: breeze.Predicate.create('id', '!=', 0),
            isNullo: breeze.Predicate.create('id', '==', 0)
        };

        // Abstract repo gets its derived object's this.manager
        function Ctor()
        {
            this.isLoaded = false;
        }

        Ctor.extend = function(repoCtor)
        {
            // Allow this repo to have access to the Abstract Repo's functions,
            // then put its own Ctor back on itself.
            // See http://stackoverflow.com/questions/8453887/why-is-it-necessary-to-set-the-prototype-constructor
            repoCtor.prototype = new Ctor();
            repoCtor.prototype.constructor = repoCtor;
        };

        // Shared by repository classes
        Ctor.prototype.getEntityByIdOrFromWip = getEntityByIdOrFromWip;
        Ctor.prototype._getAllLocal = _getAllLocal;
        Ctor.prototype._getAll = _getAll;
        Ctor.prototype._getById = _getById;
        Ctor.prototype._getInlineCount = _getInlineCount;
        Ctor.prototype._getLocalEntityCount = _getLocalEntityCount;
        Ctor.prototype._queryFailed = _queryFailed;
        Ctor.prototype._setIsPartialTrue = _setIsPartialTrue;
        // Convenience functions for the Repos
        Ctor.prototype.log = common.logger.getLogFn(this.serviceId);
        Ctor.prototype.$q = common.$q;
        Ctor.prototype._predicates = _predicates;

        return Ctor;  

        function getEntityByIdOrFromWip(val)
        {
            // val can be an ID or a wipKey
            var wipEntityKey = val;

            if(common.isNumber(val))
            {
                val = parseInt(val);

                wipEntityKey = this.zStorageWip.findWipKeyByEntityId(this.entityName, val);

                // Not found...
                if(!wipEntityKey)
                {
                    // Returns a promise with the entity because 
                    // the entity may be in LocalStorage or remote (async). 
                    return this._getById(this.entityName, val);
                }
            }

            var importedEntity = this.zStorageWip.loadWipEntity(wipEntityKey);

            if(importedEntity)
            {
                // Need to re-validate the entity we are re-hydrating
                importedEntity.entityAspect.validateEntity();

                return $q.when({ entity: importedEntity, key: wipEntityKey });
            }

            return $q.reject({ error: 'Couldn\'t find entity for WIP key ' + wipEntityKey });
        }

        function _getAllLocal(resource, ordering, predicate, entity)
        {
            return EntityQuery.from(resource)
                .where(predicate)
                .orderBy(ordering)
                .toType(entity)
                .using(this.manager)
                .executeLocally();
        }

        function _getAll(entity, resource, forceRemote, select, where, order, dontSetPartials)
        {
            var self = this;
            var items = [];
            var nullo = undefined;

            if (!resource)
                resource = entity + 's';

            if (!forceRemote)
            {
                // Get from local cache
                items = self._getAllLocal(resource, order, where);
                //self.log('Retrieved ' + items.length + ' [' + entity + '] from local cache', items.length, true);
                return $q.when(items);
            }

            // Load all trainings to cache via remote query
            return EntityQuery.from(resource)
                .select(select)
                .where(where)
                .orderBy(order)
                .toType(entity)
                .using(this.manager).execute()
                .then(querySucceeded, self._queryFailed);

            function querySucceeded(data)
            {
                if (dontSetPartials)
                    return data.results;

                items = self._setIsPartialTrue(data.results);
                //self.log('Retrieved ' + items.length + ' [' + entity + '] from remote data source', items.length, true);
                items = self._getAllLocal(resource, order, where, entity);
                return items;
            }
        }

        function _getById(entityName, id, forceRemote, expand)
        {
            var self = this;
            var manager = self.manager;

            if(!forceRemote)
            {
                // check cache first
                var entity = manager.getEntityByKey(entityName, id)

                if(entity && !entity.isPartial)
                {
                    //self.log('Retrieved [' + entityName + '] id:' + id + ' from cache.', entity, true);

                    if(entity.entityAspect.entityState.isDeleted())
                    {
                        entity = null; // hide session marked-for-delete
                    }

                    return $q.when(entity);
                }
            }

            // Hit the server
            // It was not found in cache, so let's query for it.
            return manager.fetchEntityByKey(entityName, id)
                            .then(querySucceeded, self._queryFailed);

            function querySucceeded(data)
            {
                entity = data.entity;

                if (!entity)
                {
                    self.log('Could not find [' + entityName + '] id:' + id, null, true);
                    return null;
                }

                //self.log('Retrieved [' + entityName + '] id ' + id
                //    + ' from remote data source', entity, true);

                entity.isPartial = false;

                if (!expand)
                    return entity;
                
                return EntityQuery.fromEntities(entity)
                        .expand(expand)
                        .using(self.manager).execute()
                        .then(success, self._queryFailed);

                function success(data)
                {
                    entity = data.results[0];
                    entity.isPartial = false;
                    return entity;
                }
            }
        }

        function _getLocalEntityCount(resource)
        {
            var entities = EntityQuery.from(resource)
                .using(this.manager)
                .executeLocally();
            return entities.length;
        }

        function _getInlineCount(data) { return data.inlineCount; }

        function _queryFailed(error)
        {
            var msg = config.appErrorPrefix + 'Error retrieving data.' + error.message;
            logError(msg, error);
            throw error;
        }

        function _setIsPartialTrue(entities)
        {
            for(var i = entities.length; i--;)
            {
                entities[i].isPartial = true;
            }

            return entities;
        }
    }
})();