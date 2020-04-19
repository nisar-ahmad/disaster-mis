/// <reference path="edit.js" />
(function()
{
    'use strict';

    var controllerId = 'group';

    angular.module('app').controller(controllerId,
        ['$scope', '$location', '$window', '$routeParams', 'common', 'config', 'datacontext', 'model',
            area]);

    function area($scope, $location, $window, $routeParams, common, config, datacontext, model)
    {
        var entity = 'Group';

        var vm = this;
        vm.title = 'Edit '+ entity;

        var logError = common.logger.getLogFn(controllerId, 'error');

        // Bindable properties and functions are placed on vm.
        vm.entity = undefined;
        vm.id = $routeParams.id;
       
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

            vm.groupTypes = datacontext.enum.types.groupTypes;            

            common.activateController([getEntity(true)], controllerId);
        }

        function queryFailed(error)
        {
            logError(error);
            goToIndex();
        }

        function getEntity(forceRemote)
        {
            var val = $routeParams.id;

            if(val === 'new')
            {
                vm.title = 'Add ' + entity;
                vm.entity = datacontext.group.create();
                vm.entity.groupType = vm.groupTypes[0];
                return vm.entity;
            }

            return datacontext.group.getById(val, forceRemote)
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
            $location.path('/groups');
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
