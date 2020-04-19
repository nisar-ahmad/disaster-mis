(function()
{
    'use strict';

    // Controller name is handy for logging
    var controllerId = 'trainingCosts';

    // Define the controller on the module.
    // Inject the dependencies. 
    // Point to the controller definition function.
    angular.module('app').controller(controllerId,
        ['$modal', 'common', 'config', 'datacontext', 'uiGridConstants', trainingCosts]);

    function trainingCosts($modal, common, config, datacontext, uiGridConstants)
    {
        // Using 'Controller As' syntax, so we assign this to the vm variable (for viewmodel).
        var vm = this;
        var getLogFn = common.logger.getLogFn;
        var log = getLogFn(controllerId);
        var keyCodes = config.keyCodes;

        // Bindable properties and functions are placed on vm.
        vm.title = 'Training Costs';
        vm.gridOptions = config.gridOptions;
        vm.gridOptions.showColumnFooter = true;

        vm.gridOptions.columnDefs = [
            { field: 'trainingCostId', name: ' ', cellTemplate: 'app/trainingCost/edit-button.html', width: 45, enableFiltering: false, enableSorting: false },
            { field: 'training.name', name: 'Training' },
            { field: 'funding.project.name', name: 'Project' },
            { field: 'funding.approvedActivity.name', name: 'Approved Head' },
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
            var noNullo = breeze.Predicate.create('trainingCostId', '!=', 0);

            return datacontext.trainingCost.getAll(forceRefresh, null, noNullo)
                .then(function (data) {
                    vm.gridOptions.data = data;
                    return data;
                }
            );
        }

        function refresh()
        {
            activate();
        }
    }
})();
