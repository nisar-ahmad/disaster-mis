﻿(function()
{
    'use strict';

    var serviceId = 'repository.trainingorganization';

    angular.module('app').factory(serviceId, ['model', 'repository.abstract', RepositoryTrainingOrganization]);

    function RepositoryTrainingOrganization(model, AbstractRepository)
    {
        var defaultSelect = 'trainingId, organizationId';
        var defaultOrder = 'trainingId, organizationId';

        var resource = 'TrainingOrganizations';
        var entityName = model.entityNames.trainingOrganization;
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

        function create(entity) {
            return this.manager.createEntity(entityName, entity);
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