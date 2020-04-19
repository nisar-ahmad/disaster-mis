(function()
{
    'use strict';

    var serviceId = 'repository.album';

    angular.module('app').factory(serviceId, ['model', 'repository.abstract', RepositoryAlbum]);

    function RepositoryAlbum(model, AbstractRepository)
    {
        var defaultSelect = 'albumId, name, albumType, relativeUrl, gallery, galleryId, accessType';
        var defaultOrder = 'name';

        var resource = 'Albums';
        var entityName = model.entityNames.album;
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
            var entity = this.manager.createEntity(entityName);
            //entity.dateCreated = entity.dateModified = moment().valueOf();
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