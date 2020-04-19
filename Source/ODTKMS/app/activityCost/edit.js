/// <reference path="edit.js" />
(function()
{
    'use strict';

    var controllerId = 'activityCost';

    angular.module('app').controller(controllerId,
        ['$scope', '$location', '$filter', '$window', '$routeParams', 'common', 'config', 'datacontext', 'model', 'helper',
            activityCost]);

    function activityCost($scope, $location, $filter, $window, $routeParams, common, config, datacontext, model, helper)
    {
        var entity = 'Activity Cost';

        var vm = this;
        vm.title = 'Edit '+ entity;

        var logError = common.logger.getLogFn(controllerId, 'error');

        // Bindable properties and functions are placed on vm.
        vm.entity = undefined;
        vm.id = $routeParams.id;

        vm.goBack = goBack;
        vm.cancel = cancel;

        vm.hasChanges = false;
        vm.isSaving = false;
        vm.save = save;
        
        vm.activities = [];
        vm.fundings = [];

        vm.label = getLabel;

        vm.activate = activate;
 
        // vm.canSave Property
        Object.defineProperty(vm, 'canSave', {
            get: canSave
        });

        function canSave()
        {
            return vm.hasChanges && !vm.isSaving;
        }

        function getLabel(funding)
        {
            return funding.project.name + ' - ' + funding.approvedActivity.name + ' - ' + funding.cashAmount;
        }
        
        activate();

        function activate()
        {
            onDestroy();
            onHasChanges();

            //var select = 'fundingId, approvedActivity, approvedActivity.name, project, project.name, cashAmount';
            var noNullo = breeze.Predicate.create('activityId', '!=', 0);

            var p0 = datacontext.activity.getAll(true, 'activityId, name', noNullo);
            var p1 = datacontext.funding.getAll(true);

            common.activateController([p0, p1], controllerId).then(init, queryFailed);
        }

        function init(results)
        {
            vm.activities = results[0];
            vm.fundings = results[1];
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
                vm.entity = datacontext.activityCost.create();
                
                vm.entity.activity = vm.activities[0];
                vm.entity.funding = vm.fundings[0];                

                return vm.entity;
            }

            return datacontext.activityCost.getById(val, forceRemote)
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
            $location.path('/activityCosts');
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
