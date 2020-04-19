/// <reference path="edit.js" />
(function()
{
    'use strict';

    var controllerId = 'trainingSession';

    angular.module('app').controller(controllerId,
        ['$scope', '$location', '$filter', '$window', '$routeParams', 'common', 'config', 'datacontext', 'model', 'helper',
            trainingSession]);

    function trainingSession($scope, $location, $filter, $window, $routeParams, common, config, datacontext, model, helper)
    {
        var entity = 'Training Session';

        var vm = this;
        vm.title = 'Edit '+ entity;

        var entityName = model.entityNames.trainingSession;
        var logError = common.logger.getLogFn(controllerId, 'error');

        // Bindable properties and functions are placed on vm.
        vm.entity = undefined;
        vm.id = $routeParams.id;

        vm.goBack = goBack;
        vm.cancel = cancel;

        vm.hasChanges = false;
        vm.isSaving = false;
        vm.save = save;
        
        vm.trainings = [];

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

            var noNullo = breeze.Predicate.create('trainingId', '!=', 0);
            var p0 = datacontext.training.getAll(true, 'name', noNullo);

            common.activateController([p0], controllerId).then(init, queryFailed);
        }

        function init(results)
        {
            vm.trainings = results[0];
            getEntity(true);
        }

        function queryFailed(error) {
            logError(error);
            goToIndex();
        }

        function getEntity(forceRemote)
        {
            var val = $routeParams.id;

            if(val === 'new')
            {
                vm.title = 'Add ' + entity;
                vm.entity = datacontext.trainingSession.create();
                
                vm.entity.training = vm.trainings[0];
                vm.entity.dateOfSession = moment().valueOf();
                vm.entity.startTime = moment({ hour: 9 }).valueOf();
                vm.entity.endTime = moment({ hour: 17 }).valueOf();

                return vm.entity;
            }

            return datacontext.trainingSession.getById(val, forceRemote)
                    .then(querySucceeded, queryFailed);

            function querySucceeded(data) {
                vm.entity = data.entity || data;
            }
        }

        function goBack()
        {
            $window.history.back();
        }

        function cancel()
        {
            datacontext.cancel();
            vm.hasChanges = false;

            //helper.replaceLocationUrlGuidWithId(vm.entity.documentId);

            if (vm.entity.entityAspect.entityState.isDetached())
            {
                goToIndex();
            }
        }

        function goToIndex()
        {
            $location.path('/trainingSessions');
        }

        function save()
        {
            if(!canSave())
            {
                return common.$q.when(null);

            } // Must return a promise

            vm.isSaving = true;

            vm.entity.dateOfSession = moment(vm.entity.dateOfSession).utc().hours(0).minutes(0).seconds(0).milliseconds(0).valueOf();
            vm.entity.startTime = moment(vm.entity.startTime).utc().year(1900).month(0).date(1).valueOf();
            vm.entity.endTime = moment(vm.entity.endTime).utc().year(1900).month(0).date(1).valueOf();

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
