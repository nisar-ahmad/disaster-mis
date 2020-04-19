(function()
{
    'use strict';

    // Controller name is handy for logging
    var controllerId = 'respondents';

    // Define the controller on the module.
    // Inject the dependencies. 
    // Point to the controller definition function.
    angular.module('app').controller(controllerId,
        ['$modal', 'common', 'config', 'datacontext', 'uiGridConstants', respondents]);

    function respondents($modal, common, config, datacontext, uiGridConstants)
    {
        // Using 'Controller As' syntax, so we assign this to the vm variable (for viewmodel).
        var vm = this;
        var getLogFn = common.logger.getLogFn;
        var log = getLogFn(controllerId);
        var keyCodes = config.keyCodes;

        // Bindable properties and functions are placed on vm.
        vm.title = 'Respondents';
        vm.gridOptions = config.gridOptions;

        vm.gridOptions.columnDefs = [
            { field: 'respondentId', name: ' ', cellTemplate: 'app/respondent/edit-button.html', width: 45, enableFiltering: false, enableSorting: false, enableColumnMenu: false },
            { field: 'name' },
            { field: 'gender', filter: config.filters['gender'] },
            { field: 'age', name:'Age', filters: common.getBetweenFilter() },
            { field: 'academicQualification.name', name: 'Academic Qualification', filter: config.filters['academicQualification'] },
            { field: 'yearsOfExperience', filters: common.getBetweenFilter() },
            { field: 'district.name', name: 'District' },
            { field: 'organization.name', name: 'Organization' },
            { field: 'cell' },
            { field: 'email' },
        ];

        vm.refresh = refresh;

        activate();

        function activate()
        {
            common.activateController([getAll(true)], controllerId);
        }

        function getAll(forceRefresh) {

            var select = 'respondentId, name, gender, dateOfBirth, academicQualification, academicQualification.name, ' +
                         'yearsOfExperience, district, district.name, organization, organization.name, '+
                         'cell, email';

            var where = breeze.Predicate.create('respondentId', '!=', 0);

            return datacontext.respondent.getAll(forceRefresh, select, where)
                .then(function (data)
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
