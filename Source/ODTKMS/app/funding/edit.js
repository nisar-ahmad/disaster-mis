(function()
{
    'use strict';

    var controllerId = 'funding';

    angular.module('app').controller(controllerId,
        ['$scope', '$location', '$filter', '$window', '$routeParams', 'common', 'config', 'datacontext', 'model', 'helper',
            funding]);

    function funding($scope, $location, $filter, $window, $routeParams, common, config, datacontext, model, helper)
    {
        var vm = this;

        var entity = 'Funding';
        var entityName = model.entityNames.funding;
        var logError = common.logger.getLogFn(controllerId, 'error');
        
        // Bindable properties and functions are placed on vm.        
        vm.id = $routeParams.id;

        var action = vm.id === 'new' ? 'Add ' : 'Edit ';

        vm.title = action + entity;

        vm.goBack = goBack;
        vm.cancel = cancel;

        vm.hasChanges = false;
        vm.isSaving = false;
        vm.save = save;
        
        vm.projects = [];
        vm.approvedActivities = [];
        vm.fundingTypes = [];
        
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

        function queryFailed(error) {
            logError(error);
            goToIndex();
        }
    
        function activate()
        {
            onDestroy();
            onHasChanges();
            
            var p0 = datacontext.project.getAll(true);
            var p1 = datacontext.approvedActivity.getAll(true);

            common.activateController([p0, p1], controllerId).then(init, queryFailed);
        }

        function init(results)
        {
            vm.fundingTypes = datacontext.enum.types.fundingTypes;
            vm.projects = results[0];
            vm.approvedActivities = results[1];
            getEntity(true);
        }

        function initDropDowns(entity)
        {            
            vm.entity.project = vm.projects[0];
            vm.entity.approvedActivity = vm.approvedActivities[0];
            vm.entity.fundingType = vm.fundingTypes[0];
        }
        
        function createEntity()
        {
            vm.entity = datacontext.funding.create();
            vm.entity.startDate = moment().valueOf();
            vm.entity.endDate = moment().add(6, 'months').valueOf();

            initDropDowns(vm.entity);            

            return vm.entity;
        }

        function getEntity(forceRemote)
        {
            if (vm.id === 'new')
                return createEntity();

            return datacontext.funding.getById(vm.id, forceRemote)
                    .then(querySucceeded, queryFailed);

            function querySucceeded(data) {
                vm.entity = data.entity || data;
            }
        }

        function save() {
            if (!canSave()) {
                return common.$q.when(null);

            } // Must return a promise

            vm.isSaving = true;

            return datacontext.save()
                .then(function (saveResult) {
                    // Save success
                    vm.isSaving = false;
                    //helper.replaceLocationUrlGuidWithId(vm.entity.documentId);
                },
                function (error) {
                    // Save error
                    vm.isSaving = false;
                });
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
            $location.path('/fundings');
        }

        function goBack() {
            $window.history.back();
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
