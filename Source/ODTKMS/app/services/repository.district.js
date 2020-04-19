(function()
{
    'use strict';

    var serviceId = 'repository.district';

    angular.module('app').factory(serviceId, ['model', 'repository.abstract', RepositoryDistrict]);

    function RepositoryDistrict(model, AbstractRepository)
    {
        var defaultSelect = 'districtId, name, provinceId';
        var defaultOrder = 'name';

        var resource = 'Districts';
        var entityName = model.entityNames.district;
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

        function create() {
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