(function()
{
    'use strict';

    var serviceId = 'datacontext';
    angular.module('app').factory(serviceId,
        ['$rootScope', 'common', 'config', 'entityManagerFactory', 'model', 'repositories', datacontext]);

    function datacontext($rootScope, common, config, emFactory, model, repositories)
    {
        var entityNames = model.entityNames;
        var events = config.events;
        var getLogFn = common.logger.getLogFn;
        var log = getLogFn(serviceId);
        var logError = getLogFn(serviceId, 'error');
        var logSuccess = getLogFn(serviceId, 'success');
        var manager = emFactory.newManager();
        var primePromise;
        var repoNames = ['enum', 'document', 'training', 'trainingSession', 'trainingCost', 'trainingEvaluation',
                         'trainingOrganization', 'participant', 'trainingSessionParticipant', 'participantDisabilityType', 
                         'resourcePerson', 'resourcePersonTraining', 'resourcePersonDisabilityType',
                         'resourcePersonArea','trainingActivity', 'potentialResourcePerson', 
                         'organization', 'project', 'funding', 'activity', 'activityCost',
                         'question', 'survey', 'surveyQuestion', 'surveyQuestionResponse',
                         'respondent', 'respondentDisabilityType', 'activityType',
                         'approvedActivity', 'album', 'mediaFile', 'area', 'thematicArea', 
                         'academicQualification', 'disabilityType', 'documentCategory', 
                         'organizationType', 'province', 'district', 'city', 'gallery', 
                         'group', 'messageLog', 'content', 'broaderTrainingArea'];
        var $q = common.$q;

        var service = {
            prime: prime,
            cancel: cancel,
            save: save,
            markDeleted: markDeleted
            // Repositories to be added on demand:
            //      attendees
            //      lookups
            //      sessions
            //      speakers
        };

        init();

        return service;

        function init()
        {
            repositories.init(manager);
            defineLazyLoadedRepos();
            setupEventForHasChangesChanged();
            setupEventForEntitiesChanged();
        }

        // Add ES5 property to datacontext for each named repo
        function defineLazyLoadedRepos()
        {
            repoNames.forEach(function(name)
            {
                Object.defineProperty(service, name, {
                    configurable: true, // will redefine this property once
                    get: function()
                    {
                        // The 1st time the repo is request via this property, 
                        // we ask the repositories for it (which will inject it).
                        var repo = repositories.getRepo(name);

                        // Rewrite this property to always return this repo;
                        // no longer redefinable
                        Object.defineProperty(service, name, {
                            value: repo,
                            configurable: false,
                            enumerable: true
                        });

                        return repo;
                    }
                });
            });
        }

        function prime()
        {
            if (primePromise)
            {
                return primePromise;
            }

            //manager.fetchMetadata().then(extendMetadata);

            //// Look in local storage and if data is there, grab it;
            //// otherwise get from 'resources'
            //var storageEnabledAndHasData = zStorage.load(manager);

            //primePromise = storageEnabledAndHasData ?
            //$q.when(log('Loading entities and metadata from Local Storage')) :
            primePromise = $q.all([service.enum.getAll()])
                                .then(extendMetadata);

            return primePromise.then(success);

            function success()
            {                
                setSelectOptions();
                //zStorage.save();
                //manager.fetchMetadata().then(extendMetadata);               

                //log('Primed the data');
            }

            function setSelectOptions()
            {
                config.filters['accessType'].selectOptions =
                    common.getSelectOptions(service.enum.types.accessTypes);

                config.filters['albumType'].selectOptions =
                    common.getSelectOptions(service.enum.types.albumTypes);

                config.filters['approvalType'].selectOptions =
                    common.getSelectOptions(service.enum.types.approvalTypes);

                //config.filters['broaderTrainingArea'].selectOptions =
                //    common.getSelectOptions(service.enum.types.broaderTrainingAreas);

                config.filters['contentType'].selectOptions =
                    common.getSelectOptions(service.enum.types.contentTypes);
                
                config.filters['deliveryStatus'].selectOptions =
                    common.getSelectOptions(service.enum.types.deliveryStatuses);

                config.filters['gender'].selectOptions =
                    common.getSelectOptions(service.enum.types.genderTypes);

                config.filters['groupType'].selectOptions =
                    common.getSelectOptions(service.enum.types.groupTypes);

                config.filters['geographicalArea'].selectOptions =
                    common.getSelectOptions(service.enum.types.geographicalAreas);

                config.filters['trainingType'].selectOptions =
                    common.getSelectOptions(service.enum.types.trainingTypes);

                config.filters['trainingLevel'].selectOptions =
                    common.getSelectOptions(service.enum.types.trainingLevels);

                config.filters['trainingStatus'].selectOptions =
                    common.getSelectOptions(service.enum.types.trainingStatuses);

                config.filters['fundingType'].selectOptions =
                    common.getSelectOptions(service.enum.types.fundingTypes);

                config.filters['relationshipType'].selectOptions =
                    common.getSelectOptions(service.enum.types.relationshipTypes);

                config.filters['questionType'].selectOptions =
                    common.getSelectOptions(service.enum.types.questionTypes);

                //service.group.getAll(true, 'groupId, name').then(function (data)
                //{
                //    var items = [];

                //    for(var i of data)
                //        items.push(i.name);

                //    config.filters['group'].selectOptions =
                //        common.getSelectOptions(items);
                //});

                service.broaderTrainingArea.getAll(true, 'broaderTrainingAreaId, name').then(function (data) {
                    var items = [];

                    for(var i of data)
                        items.push(i.name);

                    config.filters['broaderTrainingArea'].selectOptions =
                        common.getSelectOptions(items);
                });

                service.approvedActivity.getAll(true, 'approvedActivityId, name').then(function (data)
                {
                    var items = [];

                    for(var i of data)
                        items.push(i.name);

                    config.filters['approvedActivity'].selectOptions =
                        common.getSelectOptions(items);
                });

                service.academicQualification.getAll(true, 'academicQualificationId, name').then(function (data)
                {
                    var items = [];

                    for(var i of data)
                        items.push(i.name);

                    config.filters['academicQualification'].selectOptions =
                        common.getSelectOptions(items);
                });

                service.organizationType.getAll(true, 'organizationTypeId, name').then(function (data)
                {
                    var items = [];

                    for(var i of data)
                        items.push(i.name);

                    config.filters['organizationType'].selectOptions =
                        common.getSelectOptions(items);
                });

                service.thematicArea.getAll(true, 'thematicAreaId, name').then(function (data)
                {
                    var items = [];

                    for(var i of data)
                        items.push(i.name);

                    config.filters['thematicArea'].selectOptions =
                        common.getSelectOptions(items);
                });

                service.gallery.getAll(true, 'galleryId, name').then(function (data)
                {
                    var items = [];

                    for(var i of data)
                        items.push(i.name);

                    config.filters['gallery'].selectOptions =
                        common.getSelectOptions(items);
                });
            }

            function extendMetadata()
            {
                var metadataStore = manager.metadataStore;
                model.extendMetadata(metadataStore);
                registerResourceNames(metadataStore);
            }

            function registerResourceNames(metadataStore)
            {
                var types = metadataStore.getEntityTypes();

                types.forEach(function(type)
                {
                    if(type instanceof breeze.EntityType)
                    {
                        set(type.shortName, type);
                    }
                });

                function set(resourceName, entityName)
                {
                    metadataStore.setEntityTypeForResourceName(resourceName, entityName);
                }
            }
        }

        function cancel()
        {
            if (manager.hasChanges())
            {
                manager.rejectChanges();

                logSuccess('Canceled changes', null, true);
            }
        }

        function save(preventSuccessLog)
        {
            return manager.saveChanges()
                .then(saveSucceeded, saveFailed);

            function saveSucceeded(result)
            {
                if (!preventSuccessLog)
                    logSuccess('Saved data', result, true);
            }

            function saveFailed(error)
            {
                var msg = config.appErrorPrefix + 'Save failed: ' +
                    breeze.saveErrorMessageService.getErrorMessage(error);

                error.message = msg;

                logError(msg, error);

                throw error;
            }
        }

        function setupEventForHasChangesChanged()
        {
            manager.hasChangesChanged.subscribe(function(eventArgs)
            {
                var data = { hasChanges: eventArgs.hasChanges };
                // Send the message (the Controller receives it)
                common.$broadcast(events.hasChangesChanged, data);
            });
        }

        function setupEventForEntitiesChanged()
        {
            // We use this for detecting changes of any kind so we can save them to local storage
            manager.entityChanged.subscribe(function(changeArgs)
            {
                if(changeArgs.entityAction === breeze.EntityAction.PropertyChange)
                {
                    common.$broadcast(events.entitiesChanged, changeArgs);
                }
            });
        }

        function markDeleted(entity)
        {
            return entity.entityAspect.setDeleted();
        }
    }
})();