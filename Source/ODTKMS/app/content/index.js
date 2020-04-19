(function()
{
    'use strict';

    // Controller name is handy for logging
    var controllerId = 'contents';

    // Define the controller on the module.
    // Inject the dependencies. 
    // Point to the controller definition function.
    angular.module('app').controller(controllerId,
        ['$modal', 'common', 'config', 'datacontext', contents]);

    function contents($modal, common, config, datacontext)
    {
        // Using 'Controller As' syntax, so we assign this to the vm variable (for viewmodel).
        var vm = this;
        var getLogFn = common.logger.getLogFn;
        var log = getLogFn(controllerId);
        var keyCodes = config.keyCodes;

        // Bindable properties and functions are placed on vm.
        vm.title = 'Contents';
        vm.gridOptions = config.gridOptions;

        vm.gridOptions.columnDefs = [
            { field: 'contentId', name: ' ', cellTemplate: 'app/content/edit-button.html', width: 45, enableFiltering: false, enableSorting: false },
            { field: 'contentType', filter: config.filters['contentType'] },
            { field: 'title' },
            { field: 'description' },
            { field: 'date', cellFilter: 'date:\'dd MMM yyyy\'', filters: common.getBetweenFilter() },
            { field: 'location' },
            { field: 'file' }
        ];

        vm.refresh = refresh;

        activate();

        function activate()
        {
            common.activateController([getAll(true)], controllerId);
                //.then(function() { log('Activated ' + vm.title); });
        }

        function getAll(forceRefresh) 
        {
            var select = 'contentId, contentType, title, description, file, date, location';

            return datacontext.content.getAll(forceRefresh, select)
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
