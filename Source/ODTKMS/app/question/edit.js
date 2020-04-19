/// <reference path="edit.js" />
(function()
{
    'use strict';

    var controllerId = 'question';

    angular.module('app').controller(controllerId,
        ['$scope', '$location', '$window', '$routeParams', 'common', 'config', 'datacontext', 'model',
            question]);

    function question($scope, $location, $window, $routeParams, common, config, datacontext, model)
    {
        var entity = 'Question';

        var vm = this;
        vm.title = 'Edit '+ entity;

        var logError = common.logger.getLogFn(controllerId, 'error');

        // Bindable properties and functions are placed on vm.
        vm.entity = undefined;
        vm.id = $routeParams.id;

        vm.questionTypes = [];
        vm.broaderTrainingAreas = [];
       
        vm.hasChanges = false;
        vm.isSaving = false;

        vm.activate = activate;
        vm.save = save;        
        vm.cancel = cancel;
        vm.goBack = goBack;
         
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

            vm.questionTypes = datacontext.enum.types.questionTypes;

            var p0 = datacontext.broaderTrainingArea.getAll(true);

            common.activateController([p0], controllerId).then(init, queryFailed);
        }

        function init(results)
        {
            vm.broaderTrainingAreas = results[0];
            getEntity(true);
        }

        function queryFailed(error)
        {
            logError(error);
            goToIndex();
        }

        function getEntity(forceRemote)
        {
            if (vm.id === 'new')
            {
                vm.title = 'Add ' + entity;

                vm.entity = datacontext.question.create();
                vm.entity.dateCreated = moment().valueOf();

                vm.entity.broaderTrainingArea = vm.broaderTrainingAreas[0];
                vm.entity.type = vm.questionTypes[0];
                vm.entity.active = true;

                return vm.entity;
            }

            return datacontext.question.getById(vm.id, forceRemote)
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

            if (vm.entity.entityAspect.entityState.isDetached())
            {
                goToIndex();
            }
        }

        function goToIndex()
        {
            $location.path('/questions');
        }

        function save()
        {
            if(!canSave())
            {
                return common.$q.when(null);

            } // Must return a promise

            vm.isSaving = true;

            return datacontext.save()
                .then(function(saveResult)
                {
                    // Save success
                    vm.isSaving = false;
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
