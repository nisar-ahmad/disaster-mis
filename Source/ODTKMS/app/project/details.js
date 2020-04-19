/// <reference path="edit.js" />
(function()
{
    'use strict';

    var controllerId = 'projectDetail';

    angular.module('app').controller(controllerId,
        ['$scope', '$location', '$filter', '$window', '$routeParams', 'common', 'config',
         'datacontext', 'model', 'uiGridConstants',  projectDetail]);

    function projectDetail($scope, $location, $filter, $window, $routeParams, common, config,
        datacontext, model, uiGridConstants)
    {
        var entity = 'Project';

        var vm = this;
        vm.title = entity + ' Details';

        var entityName = model.entityNames.project;
        var logError = common.logger.getLogFn(controllerId, 'error');

        // Bindable properties and functions are placed on vm.
        vm.entity = undefined;
        vm.id = $routeParams.id;
        vm.public = $routeParams.public;

        vm.logoUrl = 'Files/Galleries/Donors/Logos/';
        vm.proposalUrl = 'Files/Documents/Projects/Proposals/';
        vm.loaUrl = 'Files/Documents/Projects/LOAs/';
        vm.workplanUrl = 'Files/Documents/Projects/Workplans/';
        vm.otherDocumentsUrl = 'Files/Documents/Projects/OtherDocuments/';

        vm.getFileIcon = common.getFileIcon;
        vm.goBack = goBack;
        vm.activate = activate;

        vm.totalFunding = 0;
        vm.totalActivityCost = 0;
        vm.totalTrainingCost = 0;

        vm.fundingOptions = $.extend(true, {}, config.gridOptions);
        vm.trainingCostOptions = $.extend(true, {}, config.gridOptions);
        vm.activityCostOptions = $.extend(true, {}, config.gridOptions);

        vm.fundingOptions.showColumnFooter = true;

        vm.fundingOptions.columnDefs = [
            { field: ' ', width: 20, cellTemplate: '<div class="ui-grid-cell-contents">{{rowRenderIndex+1}}</div>', enableFiltering: false, enableSorting: false },
            { field: 'approvedActivity.name', name: 'Approved Head', filter: config.filters['approvedActivity'] },
            { field: 'fundingType', filter: config.filters['fundingType'] },            
            { field: 'startDate', cellFilter: "date:'dd MMM yyyy'", filters: common.getBetweenFilter() },
            { field: 'endDate', cellFilter: "date:'dd MMM yyyy'", filters: common.getBetweenFilter() },
            { field: 'cashAmount', cellFilter: 'number', filters: common.getBetweenFilter(), footerCellFilter: 'number', aggregationType: uiGridConstants.aggregationTypes.sum }
        ];

        vm.trainingCostOptions.showColumnFooter = true;

        vm.trainingCostOptions.columnDefs = [
            { field: ' ', width: 20, cellTemplate: '<div class="ui-grid-cell-contents">{{rowRenderIndex+1}}</div>', enableFiltering: false, enableSorting: false },
            { field: 'training.name', name: 'Training' },
            { field: 'funding.approvedActivity.name', name: 'Approved Head', filter: config.filters['approvedActivity'] },
            { field: 'cost', cellFilter: 'number', footerCellFilter: 'number', aggregationType: uiGridConstants.aggregationTypes.sum }
        ];
                
        vm.activityCostOptions.showColumnFooter = true;

        vm.activityCostOptions.columnDefs = [
            { field: ' ', width: 20, cellTemplate: '<div class="ui-grid-cell-contents">{{rowRenderIndex+1}}</div>', enableFiltering: false, enableSorting: false },
            { field: 'activity.name', name: 'Activity' },
            { field: 'funding.approvedActivity.name', name: 'Approved Head', filter: config.filters['approvedActivity'] },
            { field: 'cost', cellFilter: 'number', footerCellFilter: 'number', aggregationType: uiGridConstants.aggregationTypes.sum }
        ];

        activate();

        function activate()
        {
            var select = 'fundingId, projectId, approvedActivity, approvedActivity.name, ' +
                         'fundingType, startDate, endDate, cashAmount';
            var filter = breeze.Predicate.create('projectId', '==', vm.id);

            var p1 = datacontext.funding.getAll(true, select, filter)
                .then(function (data)
                {
                    vm.fundingOptions.data = data;

                    for(var o of data)
                        vm.totalFunding += o.cashAmount;

                }, logError);

            select = 'training, training.name, funding, funding.projectId, funding.approvedActivity, funding.approvedActivity.name, cost';
            filter = breeze.Predicate.create('funding.projectId', '==', vm.id);

            var p2 = datacontext.trainingCost.getAll(true, select, filter)
                .then(function (data)
                {
                    vm.trainingCostOptions.data = data;

                    for(var o of data)
                        vm.totalTrainingCost += o.cost;

                }, logError);

            select = 'activity, activity.name, funding, funding.projectId, funding.approvedActivity, funding.approvedActivity.name, cost';
            filter = breeze.Predicate.create('funding.projectId', '==', vm.id);

            var p3 = datacontext.activityCost.getAll(true, select, filter)
                .then(function (data)
                {
                    vm.activityCostOptions.data = data;

                    for(var o of data)
                        vm.totalActivityCost += o.cost;

                }, logError);

            common.activateController([getEntity(true), p1, p2, p3 ], controllerId);
        }

        function queryFailed(error) {
            logError(error);
            goBack();
        }

        function getEntity(forceRemote)
        {
            return datacontext.project.getById(vm.id, forceRemote, 'organization')
                    .then(function (data)
                    {
                        vm.entity = data.entity || data;
                    }, queryFailed);
           
        }

        function goBack()
        {
            $window.history.back();
        }
    }

})();
