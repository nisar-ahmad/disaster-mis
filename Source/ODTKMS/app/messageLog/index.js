(function()
{
    'use strict';

    // Controller name is handy for logging
    var controllerId = 'messageLogs';

    // Define the controller on the module.
    // Inject the dependencies. 
    // Point to the controller definition function.
    angular.module('app').controller(controllerId,
        ['common', 'config', 'datacontext', messageLogs]);

    function messageLogs(common, config, datacontext)
    {
        // Using 'Controller As' syntax, so we assign this to the vm variable (for viewmodel).
        var vm = this;
        var getLogFn = common.logger.getLogFn;
        var log = getLogFn(controllerId);
        var keyCodes = config.keyCodes;

        // Bindable properties and functions are placed on vm.
        vm.title = 'Email / SMS LOGS';
        vm.gridOptions = config.gridOptions;

        vm.gridOptions.columnDefs = [
            { field: 'messageLogId', name: ' ', cellTemplate: 'app/messageLog/edit-button.html', width: 34, enableFiltering: false, enableSorting: false },
            { field: 'timeStamp' , cellFilter: "date:'dd MMM yyyy - h:mm a'", filters: common.getBetweenFilter()},
            { field: 'type', filter: config.filters['groupType']},
            { field: 'group' },
            { field: 'subject'},
            { field: 'members'},
            //{ field: 'message', cellTemplate: '<div ng-bind-html="row.entity[col.field]"></div>'},
            { field: 'deliveryStatus', filter: config.filters['deliveryStatus'] }
        ];

        vm.refresh = refresh;

        activate();

        function activate()
        {
            common.activateController([getAll(true)], controllerId);
        }

        function getAll(forceRefresh)
        {
            return datacontext.messageLog.getAll(forceRefresh)
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
