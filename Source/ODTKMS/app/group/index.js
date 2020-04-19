(function()
{
    'use strict';

    // Controller name is handy for logging
    var controllerId = 'groups';

    // Define the controller on the module.
    // Inject the dependencies. 
    // Point to the controller definition function.
    angular.module('app').controller(controllerId,
        ['$modal', 'common', 'config', 'datacontext', groups]);

    function groups($modal, common, config, datacontext)
    {
        // Using 'Controller As' syntax, so we assign this to the vm variable (for viewmodel).
        var vm = this;
        var getLogFn = common.logger.getLogFn;
        var log = getLogFn(controllerId);
        var keyCodes = config.keyCodes;

        // Bindable properties and functions are placed on vm.
        vm.title = 'Groups';
        vm.gridOptions = config.gridOptions;

        vm.gridOptions.columnDefs = [
            { field: 'groupId', name: ' ', cellTemplate: 'app/group/edit-button.html', width: 34, enableFiltering: false, enableSorting: false },            
            { field: 'name'},
            { field: 'groupType', filter: config.filters['groupType']},
            { field: 'description' }
        ];

        vm.refresh = refresh;

        activate();

        function activate()
        {
            common.activateController([getAll(true)], controllerId);
        }

        function getAll(forceRefresh)
        {
            var select = 'groupId, groupType, name, description';

            return datacontext.group.getAll(forceRefresh, select)
                .then(function(data)
                {
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
