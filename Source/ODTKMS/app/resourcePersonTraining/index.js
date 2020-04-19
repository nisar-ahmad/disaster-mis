(function()
{
    'use strict';

    // Controller name is handy for logging
    var controllerId = 'resourcePersonTrainings';

    // Define the controller on the module.
    // Inject the dependencies. 
    // Point to the controller definition function.
    angular.module('app').controller(controllerId,
        ['$modal', 'common', 'config', 'datacontext', resourcePersonTrainings]);

    function resourcePersonTrainings($modal, common, config, datacontext)
    {
        // Using 'Controller As' syntax, so we assign this to the vm variable (for viewmodel).
        var vm = this;
        var getLogFn = common.logger.getLogFn;
        var log = getLogFn(controllerId);
        var keyCodes = config.keyCodes;

        // Bindable properties and functions are placed on vm.
        vm.title = 'Resource Person Training';
        vm.gridOptions = config.gridOptions;

        vm.gridOptions.columnDefs = [
            { field: 'resourcePersonId', name: ' ', cellTemplate: 'app/resourcePersonTraining/edit-button.html', width: 45, enableFiltering: false, enableSorting: false },
            { field: 'resourcePerson.name', name: 'Resource Person' },
            { field: 'trainingSession.training.name', name: 'Training' },
            { field: 'trainingSession.name', name: 'Session' },
            { field: 'trainingSession.dateOfSession', name: 'Date', cellFilter: "date:'dd MMM yyyy'" },
            { field: 'trainingSession.startTime', name: 'Start Time', cellFilter: "date:'h:mm a'" },
            { field: 'trainingSession.endTime', name: 'End Time', cellFilter: "date:'h:mm a'" },
            { field: 'isPaid', name: 'Is Paid?', cellFilter: 'yesNo', filter: config.filters['yesNo'] },
            { field: 'amountPaid', filters: common.getBetweenFilter() }
        ];

        vm.refresh = refresh;

        activate();

        function activate()
        {
            common.activateController([getAll(true)], controllerId);
        }

        function getAll(forceRefresh)
        {
            var select = 'resourcePersonId, trainingSessionId, resourcePerson, resourcePerson.name, ' +
                         'trainingSession, trainingSession.name, trainingSession.dateOfSession, ' +
                         'trainingSession.startTime, trainingSession.endTime, ' +
                         'isPaid, amountPaid, trainingSession.training, trainingSession.training.name';

            return datacontext.resourcePersonTraining.getAll(forceRefresh, select)
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
