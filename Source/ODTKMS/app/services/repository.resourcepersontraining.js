(function()
{
    'use strict';

    var serviceId = 'repository.resourcepersontraining';

    angular.module('app').factory(serviceId, ['model', 'repository.abstract', RepositoryResourceTraining]);

    function RepositoryResourceTraining(model, AbstractRepository)
    {
        var defaultSelect = 'resourcePerson.name, trainingSession.name, resourcePerson, trainingSession';
        var defaultOrder = 'trainingSession.name, resourcePerson.name';

        var resource = 'ResourcePersonTrainings';
        var entityName = model.entityNames.resourcePersonTraining;
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

        function create(entity)
        {
            return this.manager.createEntity(entityName, entity);
        }
        
        function getById(id, forceRemote, expand)
        {
            var keys = id.split(',');
            return this._getById(entityName, keys, forceRemote, expand);
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