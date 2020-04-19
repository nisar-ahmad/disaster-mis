(function()
{
    'use strict';

    // Controller name is handy for logging
    var controllerId = 'activityCosts';

    // Define the controller on the module.
    // Inject the dependencies. 
    // Point to the controller definition function.
    angular.module('app').controller(controllerId,
        ['$modal', 'common', 'config', 'datacontext', 'uiGridConstants', activityCosts]);

    function activityCosts($modal, common, config, datacontext, uiGridConstants)
    {
        // Using 'Controller As' syntax, so we assign this to the vm variable (for viewmodel).
        var vm = this;
        var getLogFn = common.logger.getLogFn;
        var log = getLogFn(controllerId);
        var keyCodes = config.keyCodes;

        // Bindable properties and functions are placed on vm.
        vm.title = 'Activity Costs';
        vm.gridOptions = config.gridOptions;
        vm.gridOptions.showColumnFooter = true;

        vm.gridOptions.columnDefs = [
            { field: 'activityCostId', name: ' ', cellTemplate: 'app/activityCost/edit-button.html', width: 45, enableFiltering: false, enableSorting: false },
            { field: 'activity.name', name: 'Training' },
            { field: 'funding.project.name', name: 'Funding Project' },
            { field: 'funding.approvedActivity.name', name: 'Approved Heads' },
            { field: 'cost', cellFilter: 'number', footerCellFilter: 'number', aggregationType: uiGridConstants.aggregationTypes.sum }
        ];

        //vm.gridOptions.onRegisterApi = function (grid) {
        //    getAll(true);
        //}

        vm.refresh = refresh;

        activate();

        function activate()
        {
            common.activateController([getAll(true)], controllerId);
                //.then(function() { log('Activated ' + vm.title); });
        }

        function getAll(forceRefresh) {
            return datacontext.activityCost.getAll(forceRefresh)
                .then(function (data) {
                    vm.gridOptions.data = data;
                    return data;
                }
            );
        }

        function refresh()
        {
            getAll(true);
        }
    }
})();
