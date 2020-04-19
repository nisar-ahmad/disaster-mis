(function()
{
    'use strict';

    // Controller name is handy for logging
    var controllerId = 'participants';

    // Define the controller on the module.
    // Inject the dependencies. 
    // Point to the controller definition function.
    angular.module('app').controller(controllerId,
        ['$modal', 'common', 'config', 'datacontext', 'uiGridConstants', participants]);

    function participants($modal, common, config, datacontext, uiGridConstants)
    {
        // Using 'Controller As' syntax, so we assign this to the vm variable (for viewmodel).
        var vm = this;
        var getLogFn = common.logger.getLogFn;
        var log = getLogFn(controllerId);
        var keyCodes = config.keyCodes;

        // Bindable properties and functions are placed on vm.
        vm.title = 'Participants';
        vm.gridOptions = config.gridOptions;

        vm.gridOptions.columnDefs = [
            { field: 'participantId', name: ' ', cellTemplate: 'app/participant/edit-button.html', width: 45, enableFiltering: false, enableSorting: false, enableColumnMenu: false },
            { field: 'training.name', name: 'Training' },
            { field: 'name' },
            { field: 'gender', filter: config.filters['gender'] },
            { field: 'age', filters: common.getBetweenFilter() },
            { field: 'academicQualification.name', name: 'Academic Qualification', filter: config.filters['academicQualification'] },
            { field: 'yearsOfExperience', filters: common.getBetweenFilter() },
            { field: 'district.province.name', name: 'Province' },
            { field: 'district.name', name: 'District' },
            { field: 'organization.name', name: 'Organization' },
            { field: 'cell' },
            { field: 'email' },
            { field: 'amountPaid' },
            { field: 'approvalStatus', filter: config.filters['approvalType'] }
        ];

        vm.refresh = refresh;

        activate();

        function activate()
        {
            common.activateController([getAll(true)], controllerId);
        }

        function getAll(forceRefresh) {

            var select = 'participantId, name, gender, dateOfBirth, academicQualification, academicQualification.name, '+
                         'yearsOfExperience, district, district.name, district.province, district.province.name, organization, organization.name, '+
                         'training, training.name, cell, email, amountPaid, approvalStatus';

            var where = breeze.Predicate.create('participantId', '!=', 0);

            return datacontext.participant.getAll(forceRefresh, select, where)
                .then(function (data)
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
