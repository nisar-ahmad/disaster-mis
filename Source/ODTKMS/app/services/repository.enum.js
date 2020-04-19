(function()
{
    'use strict';

    var serviceId = 'repository.enum';

    angular.module('app').factory(serviceId, ['model', 'repository.abstract', RepositoryEnum]);

    function RepositoryEnum(model, AbstractRepository, zStorage)
    {
        var entityName = 'enums';
        var entityNames = model.entityNames;
        var EntityQuery = breeze.EntityQuery;

        function Ctor(mgr)
        {
            this.serviceId = serviceId;
            this.entityName = entityName;
            this.manager = mgr;

            // Exposed data access functions
            this.getAll = getAll;
        }

        // Allow this repo to have access to the Abstract Repo's functions,
        // then put its own Ctor back on itself.
        //Ctor.prototype = new AbstractRepository(Ctor);
        //Ctor.prototype.constructor = Ctor;
        AbstractRepository.extend(Ctor);

        return Ctor;

        // Formerly known as datacontext.getLookups()
        function getAll()
        {
            var self = this;

            return EntityQuery.from('Enums')
                .using(self.manager).execute()
                .then(querySucceeded, self._queryFailed);

            function querySucceeded(data)
            {
                model.createNullos(self.manager);
                self.types = data.results[0];

                //self.log('Retrieved [Enums]', data, true);

                return true;
            }
        }
    }
})();