(function()
{
    'use strict';

    var controllerId = 'activity';

    angular.module('app')
        .controller(controllerId, ['$scope', '$location', '$filter', '$window', '$routeParams', '$modal', 
                                   'common', 'config', 'datacontext', 'model', 'helper', 'RowEditor', 'uiGridConstants', activity])
        .controller('RowEditCtrl', ['$modalInstance', RowEditCtrl])
        .service('RowEditor', RowEditor)
        .constant('ActivityCostSchema', {
                type: 'object',
                properties: {
                    fundingId: { type: "number", title: "Funding" },
                    description: { type: 'string', title: 'Description' },
                    cost: { type: 'number', title: 'Cost' }
                }
        });

    //RowEditor.$inject = ['$rootScope', '$modal'];
    function RowEditor($modal)
    {
        var service = {};
        service.editEntity = editEntity;
        service.onSaved = undefined;

        function editEntity(entity, fundings, add)
        {
            $modal.open({
                templateUrl: 'app/activity/edit-modal.html',
                controller: ['$modalInstance', 'ActivityCostSchema', 'entity', 'fundings', 'add', 'datacontext', 'RowEditor', RowEditCtrl],
                controllerAs: 'vm',
                resolve: {
                    entity: function () { return entity; },
                    fundings: function () { return fundings; },
                    add: function () { return add; }
                }
            });
        }

        return service;
    }

    function RowEditCtrl($modalInstance, ActivityCostSchema, entity, fundings, add, datacontext, RowEditor)
    {
        var vm = this;

        vm.schema = ActivityCostSchema;
        vm.entity = angular.copy(entity);

        var fundingMap = [];
        for(var f of fundings)
        {
            var obj = { value: f.fundingId, name: f.project.name + ' - ' + f.approvedActivity.name + ' - ' + f.cashAmount}
            fundingMap.push(obj);
        }

        vm.form = [
            {          
                key: 'fundingId',
                type: 'select',
                titleMap: fundingMap
            },            
            'cost',
            'description'            
        ];

        vm.save = save;

        function save()
        {
            // Copy row values over
            //entity = angular.extend(entity, vm.entity);
            entity.fundingId = vm.entity.fundingId;
            entity.description = vm.entity.description;
            entity.cost = vm.entity.cost;

            if (add)
                entity = datacontext.activityCost.create(entity);
            else
                entity.entityAspect.setModified();

            datacontext.save().then(function (saveResult)
            {
                RowEditor.onSaved(entity);
                $modalInstance.close(entity);
            });
        }
    }

    function activity($scope, $location, $filter, $window, $routeParams, $modal, common, config, 
                     datacontext, model, helper, RowEditor, uiGridConstants)
    {
        var vm = this;       
        var logError = common.logger.getLogFn(controllerId, 'error');
        
        // Bindable properties and functions are placed on vm.
        vm.id = $routeParams.id;
        vm.editRow = RowEditor.editEntity;
        RowEditor.onSaved = onItemSaved;
        vm.addItem = addItem;

        var entity = 'Activity';
        var action = vm.id === 'new' ? 'Add ' : 'Edit ';
        vm.title = action + entity;

        vm.goBack = goBack;
        vm.cancel = cancel;

        vm.hasChanges = false;
        vm.isSaving = false;
        vm.save = save;
        
        vm.projects = [];
        vm.cities = []; 
        vm.fundings = [];

        vm.entity = undefined;

        vm.gridOptions = config.gridOptions;
        vm.gridOptions.showColumnFooter = true;
        vm.gridOptions.appScopeProvider = vm;

        vm.gridOptions.columnDefs = [
            { field: 'activityCostId', name: '', cellTemplate: 'app/activity/edit-item-button.html', width: 34, enableFiltering: false, enableSorting: false },
            { field: 'funding.project.name', name: 'Funding' },
            //{ field: 'fundingId', name: 'Funding' },
            { field: 'cost', cellFilter: 'number', footerCellFilter: 'number', aggregationType: uiGridConstants.aggregationTypes.sum },
            { field: 'description', name: 'Description' }
        ];

        vm.activate = activate;

        function onItemSaved(entity)
        {
            loadItems();
        }

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

            var filter = breeze.Predicate.create('projectId', '!=', 0);
            
            var p0 = datacontext.project.getAll(true, null, filter);
            var p1 = datacontext.activityType.getAll(true);
            var p2 = datacontext.city.getAll(true);
            var p3 = datacontext.funding.getAll(true);

            common.activateController([p0, p1, p2, p3], controllerId).then(init, queryFailed);
        }

        function init(results)
        {
            vm.projects = results[0];
            vm.activityTypes = results[1];
            vm.cities = results[2];
            vm.fundings = results[3];

            getEntity(true);
        }

        function initDropDowns(entity)
        {            
            vm.entity.project = vm.projects[0];
            vm.entity.activityType = vm.activityTypes[0];
            vm.entity.city = vm.cities[0];
        }
        
        function createEntity()
        {
            vm.entity = datacontext.activity.create();
            initDropDowns(vm.entity); 

            return vm.entity;
        }

        function getEntity(forceRemote)
        {
            if (vm.id === 'new')
            {
                vm.gridOptions.data = [];
                return createEntity();
            }

            return datacontext.activity.getById(vm.id, forceRemote)
                    .then(querySucceeded, queryFailed);

            function querySucceeded(data) {
                vm.entity = data.entity || data;
                loadItems();
            }
        }

        function loadItems()
        {
            vm.entity.entityAspect.loadNavigationProperty("activityCosts")
                        .then(successItems, queryFailed);

            function successItems(data)
            {
                vm.gridOptions.data = data.results;
                return vm.gridOptions.data;
            }
        }

        function addItem()
        {
            var obj = { fundingId: vm.fundings[0].fundingId, description: '', cost: 0, activity: vm.entity };
            RowEditor.editEntity(obj, vm.fundings, true);
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
            $location.path('/activities');
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
