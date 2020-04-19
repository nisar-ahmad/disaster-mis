(function()
{
    'use strict';

    var serviceId = 'repository.activity';

    angular.module('app').factory(serviceId, ['model', 'repository.abstract', RepositoryActivity]);

    function RepositoryActivity(model, AbstractRepository)
    {
        var defaultSelect = 'activityId, name';
        var defaultOrder = 'name';

        var resource = 'Activities';
        var entityName = model.entityNames.activity;
        var EntityQuery = breeze.EntityQuery;
        var Predicate = breeze.Predicate;

        function Ctor(mgr)
        {
            this.serviceId = serviceId;
            this.entityName = entityName;
            this.manager = mgr;

            // Exposed data access functions
            this.getAll = getAll;
            this.getById = getById;
            this.create = create;
        }

        AbstractRepository.extend(Ctor);

        return Ctor;

        function create()
        {
            var entity = this.manager.createEntity(entityName);
            entity.dateOfActivity = moment().valueOf();
            return entity;
        }
        
        function getById(id, forceRemote, expand)
        {
            return this._getById(entityName, id, forceRemote, expand);
        }

        function getAll(forceRemote, select, where, order)
        {
            if (!select)
                select = defaultSelect;

            if (!order)
                order = defaultOrder;

            return this._getAll(entityName, resource, forceRemote, select, where, order);
        }
    }
})();