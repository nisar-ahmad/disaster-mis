(function()
{
    'use strict';

    // Controller name is handy for logging
    var controllerId = 'fundings';

    // Define the controller on the module.
    // Inject the dependencies. 
    // Point to the controller definition function.
    angular.module('app').controller(controllerId,
        ['$modal', 'common', 'config', 'datacontext', 'uiGridConstants', fundings]);

    function fundings($modal, common, config, datacontext, uiGridConstants)
    {
        // Using 'Controller As' syntax, so we assign this to the vm variable (for viewmodel).
        var vm = this;
        var getLogFn = common.logger.getLogFn;
        var log = getLogFn(controllerId);
        var keyCodes = config.keyCodes;

        // Bindable properties and functions are placed on vm.
        vm.title = 'Project Fundings';
        vm.gridOptions = config.gridOptions;
        vm.gridOptions.showColumnFooter = true;

        vm.gridOptions.columnDefs = [
            { field: 'fundingId', name: ' ', cellTemplate: 'app/funding/edit-button.html', width: 45, enableFiltering: false, enableSorting: false },
            { field: 'project.name', name: 'Project' },
            { field: 'approvedActivity.name', name: 'Approved Head', filter: config.filters['approvedActivity'] },
            { field: 'fundingType', filter: config.filters['fundingType'] },
            { field: 'cashAmount', cellFilter: 'number', filters: common.getBetweenFilter(), footerCellFilter: 'number', aggregationType: uiGridConstants.aggregationTypes.sum },
            { field: 'startDate', cellFilter: "date:'dd MMM yyyy'", filters: common.getBetweenFilter() },
            { field: 'endDate', cellFilter: "date:'dd MMM yyyy'", filters: common.getBetweenFilter() }
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

            var select = 'fundingId, approvedActivity, approvedActivity.name, project, project.name, fundingType, ' +
                          'cashAmount, startDate, endDate';

            return datacontext.funding.getAll(forceRefresh, select)
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
