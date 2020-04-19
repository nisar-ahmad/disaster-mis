(function()
{
    'use strict';

    // Controller name is handy for logging
    var controllerId = 'projects';

    // Define the controller on the module.
    // Inject the dependencies. 
    // Point to the controller definition function.
    angular.module('app').controller(controllerId,
        ['$modal', 'common', 'config', 'datacontext', projects]);

    function projects($modal, common, config, datacontext)
    {
        // Using 'Controller As' syntax, so we assign this to the vm variable (for viewmodel).
        var vm = this;
        var getLogFn = common.logger.getLogFn;
        var log = getLogFn(controllerId);
        var keyCodes = config.keyCodes;

        // Bindable properties and functions are placed on vm.
        vm.title = 'Projects';
        vm.gridOptions = config.gridOptions;

        vm.gridOptions.columnDefs = [
            { field: 'projectId', name: ' ', cellTemplate: 'app/project/edit-button.html', width: 45, enableFiltering: false, enableSorting: false },          
            { field: 'name', name:'Project' },
            { field: 'organization.name', name: 'Donor' },
            { field: 'description' },
            { field: 'projectNumber' },
            { field: 'startDate', cellFilter: 'date:\'dd MMM yyyy\'', filters: common.getBetweenFilter() },
            { field: 'endDate', cellFilter: 'date:\'dd MMM yyyy\'', filters: common.getBetweenFilter() },
            { field: 'duration', filters: common.getBetweenFilter() }
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

        function getAll(forceRefresh) 
        {
            var select = 'projectId, organization, organization.name, name, description, projectNumber,' +
                         'startDate, endDate';

            var filter = breeze.Predicate.create('projectId', '!=', 0);

            return datacontext.project.getAll(forceRefresh, select, filter)
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
