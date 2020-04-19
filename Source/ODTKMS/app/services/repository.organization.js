(function()
{
    'use strict';

    var serviceId = 'repository.organization';

    angular.module('app').factory(serviceId, ['model', 'repository.abstract', RepositoryOrganization]);

    function RepositoryOrganization(model, AbstractRepository)
    {
        var defaultSelect = 'organizationId, name, organizationTypeId, category';
        var defaultOrder = 'name';

        var resource = 'Organizations';
        var entityName = model.entityNames.organization;
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
            return this.manager.createEntity(entityName);
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