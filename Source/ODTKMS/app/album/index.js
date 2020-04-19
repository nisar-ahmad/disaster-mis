(function()
{
    'use strict';

    // Controller name is handy for logging
    var controllerId = 'albums';

    // Define the controller on the module.
    // Inject the dependencies. 
    // Point to the controller definition function.
    angular.module('app').controller(controllerId,
        ['$modal', 'common', 'config', 'datacontext', albums]);

    function albums($modal, common, config, datacontext)
    {
        // Using 'Controller As' syntax, so we assign this to the vm variable (for viewmodel).
        var vm = this;
        var getLogFn = common.logger.getLogFn;
        var log = getLogFn(controllerId);

        // Bindable properties and functions are placed on vm.
        vm.title = 'Albums';
        vm.gridOptions = config.gridOptions;

        vm.gridOptions.columnDefs = [
            { field: 'albumId', name: ' ', cellTemplate: 'app/album/edit-button.html', width: 34, enableFiltering: false, enableSorting: false },
            { field: 'name' },
            { field: 'albumType', name: 'Gallery', filter: config.filters['albumType'] },
            { field: 'accessType', name: 'Visibility', filter: config.filters['accessType']},
            { field: 'dateCreated', cellFilter: 'date:\'dd MMM yyyy\'', filters: common.getBetweenFilter() },
            { field: 'dateModified', cellFilter: 'date:\'dd MMM yyyy\'', filters: common.getBetweenFilter() }
        ];

        vm.refresh = refresh;

        activate();

        function activate()
        {
            common.activateController([getAll(true)], controllerId);
        }

        function getAll(forceRefresh)
        {
            var select = 'albumId, albumType, name, accessType, dateCreated, dateModified';
            var filter = breeze.Predicate.create('albumId', '!=', 0).and('albumType', '!=', 'System');

            return datacontext.album.getAll(forceRefresh, select, filter)
                .then(function(data)
                {
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
