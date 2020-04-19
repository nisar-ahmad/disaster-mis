(function()
{
    'use strict';

    var controllerId = 'resourcePersonTraining';

    angular.module('app').controller(controllerId,
        ['$scope', '$location', '$filter', '$window', '$routeParams', 'common', 'config', 'datacontext', 'model', 'helper',
            resourcePersonTraining]);

    function resourcePersonTraining($scope, $location, $filter, $window, $routeParams, common, config, datacontext, model, helper)
    {
        var entity = 'Resource Person Training';

        var vm = this;
        vm.title = 'Edit '+ entity;

        var entityName = model.entityNames.resourcePersonTraining;
        var logError = common.logger.getLogFn(controllerId, 'error');

        // Bindable properties and functions are placed on vm.
        vm.entity = undefined;
        vm.id = $routeParams.id;

        vm.goBack = goBack;
        vm.cancel = cancel;

        vm.hasChanges = false;
        vm.isSaving = false;
        vm.save = save;
        
        vm.resourcePersons = [];
        //vm.trainings = [];
        vm.trainingSessions = [];
        //vm.training = undefined;
        //vm.trainingChanged = trainingChanged;

        vm.activate = activate;
 
        // vm.canSave Property
        Object.defineProperty(vm, 'canSave', {
            get: canSave
        });

        function canSave()
        {
            return vm.hasChanges && !vm.isSaving;
        }
        
        activate();

        function activate()
        {
            onDestroy();
            onHasChanges();

            var resourceNotNull = breeze.Predicate.create('resourcePersonId', '!=', 0);
            var sessionNotNull = breeze.Predicate.create('trainingSessionId', '!=', 0);

            var p0 = datacontext.resourcePerson.getAll(true, null, resourceNotNull);
            var p1 = datacontext.trainingSession.getAll(true, null, sessionNotNull);
            //var p2 = datacontext.training.getAll(true);

            common.activateController([p0, p1], controllerId).then(init, onError);
        }

        //function trainingChanged()
        //{

        //}

        function init(results)
        {
            vm.resourcePersons = results[0];
            vm.trainingSessions = results[1];
            //vm.trainings = results[2];

            if (vm.resourcePersons.length === 0 || vm.trainingSessions.length === 0) {
                onError('Please add at least one resource person and one training session first');
                return;
            }

            getEntity(true);
        }

        function initDropDowns(entity)
        {
            entity.resourcePerson = vm.resourcePersons[0];
            entity.trainingSession = vm.trainingSessions[0];
            //vm.training = vm.trainings[0];
        }

        function onError(error) {
            logError(error);
            goToIndex();
        }

        function getEntity(forceRemote)
        {
            if(vm.id === 'new')
            {
                vm.title = 'Add ' + entity;
                
                var newEntity = { resourcePerson: vm.resourcePersons[0], trainingSession: vm.trainingSessions[0], isPaid: false, amountPaid:0 };
                vm.entity = newEntity;//datacontext.resourcePersonTraining.create(newEntity);
                //initDropDowns(vm.entity);
                vm.hasChanges = true;
                return vm.entity;
            }

            return datacontext.resourcePersonTraining.getById(vm.id, forceRemote)
                    .then(querySucceeded, onError);

            function querySucceeded(data) {
                vm.entity = data.entity || data;
                //vm.training = vm.entity.trainingSession.training;
            }
        }

        function goBack()
        {
            $window.history.back();
        }

        function cancel()
        {
            datacontext.cancel();
            //helper.replaceLocationUrlGuidWithId(vm.entity.documentId);

            if (vm.entity.entityAspect.entityState.isDetached())
            {
                goToIndex();
            }
        }

        function goToIndex()
        {
            $location.path('/resourcePersonTrainings');
        }

        function save()
        {
            if(!canSave())
            {
                return common.$q.when(null);

            } // Must return a promise

            vm.isSaving = true;

            if (vm.id === 'new')
                vm.entity = datacontext.resourcePersonTraining.create(vm.entity);

            return datacontext.save()
                .then(function(saveResult)
                {
                    // Save success
                    vm.isSaving = false;
                    //helper.replaceLocationUrlGuidWithId(vm.entity.documentId);
                },
                function(error)
                {
                    // Save error
                    vm.hasChanges = true;
                    vm.isSaving = false;
                });
        }

        function onDestroy()
        {
            $scope.$on('$destroy', function()
            {
                datacontext.cancel();
            });
        }

        function onHasChanges()
        {
            $scope.$on(config.events.hasChangesChanged,
                function(event, data)
                {
                    vm.hasChanges = data.hasChanges;
                });
        }
    }

})();
