(function()
{
    'use strict';

    // Controller name is handy for logging
    var controllerId = 'provinces';

    // Define the controller on the module.
    // Inject the dependencies. 
    // Point to the controller definition function.
    angular.module('app').controller(controllerId,
        ['$modal', 'common', 'config', 'datacontext', provinces]);

    function provinces($modal, common, config, datacontext)
    {
        // Using 'Controller As' syntax, so we assign this to the vm variable (for viewmodel).
        var vm = this;
        var getLogFn = common.logger.getLogFn;
        var log = getLogFn(controllerId);
        var keyCodes = config.keyCodes;

        // Bindable properties and functions are placed on vm.
        vm.title = 'Provinces';
        vm.gridOptions = config.gridOptions;

        vm.gridOptions.columnDefs = [
            { field: 'provinceId', name: ' ', cellTemplate: 'app/province/edit-button.html', width: 34, enableFiltering: false, enableSorting: false },
            { field: 'name' },
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
            var select = 'provinceId, name, description';

            return datacontext.province.getAll(forceRefresh, select)
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
