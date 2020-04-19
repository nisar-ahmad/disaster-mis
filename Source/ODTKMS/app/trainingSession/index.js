(function()
{
    'use strict';

    // Controller name is handy for logging
    var controllerId = 'trainingSessions';

    // Define the controller on the module.
    // Inject the dependencies. 
    // Point to the controller definition function.
    angular.module('app').controller(controllerId,
        ['$modal', 'common', 'config', 'datacontext', trainingSessions]);

    function trainingSessions($modal, common, config, datacontext)
    {
        // Using 'Controller As' syntax, so we assign this to the vm variable (for viewmodel).
        var vm = this;
        var getLogFn = common.logger.getLogFn;
        var log = getLogFn(controllerId);
        var keyCodes = config.keyCodes;

        // Bindable properties and functions are placed on vm.
        vm.title = 'Training Sessions';
        vm.gridOptions = config.gridOptions;

        vm.gridOptions.columnDefs = [
            { field: 'trainingSessionId', name: ' ', cellTemplate: 'app/trainingSession/edit-button.html', width: 45, enableFiltering: false, enableSorting: false },
            { field: 'training.name', name: 'Training' },
            { field: 'name', name: 'Session' },
            { field: 'module' },
            { field: 'dateOfSession', cellFilter: "date:'dd MMM yyyy'" },
            { field: 'startTime', cellFilter: "date:'h:mm a'"},
            { field: 'endTime', cellFilter: "date:'h:mm a'"},
            { field: 'agenda' }
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

            var select = 'trainingSessionId, training, training.name, name, module, dateOfSession,' +
                         'startTime, endTime, agenda';

            var filter = breeze.Predicate.create('trainingSessionId', '!=', 0);
            var order = 'training.name, dateOfSession, startTime'

            return datacontext.trainingSession.getAll(forceRefresh, select, filter, order)
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
