(function()
{
    'use strict';

    // Controller name is handy for logging
    var controllerId = 'resourcePersons';

    // Define the controller on the module.
    // Inject the dependencies. 
    // Point to the controller definition function.
    angular.module('app').controller(controllerId,
        ['$modal', 'common', 'config', 'datacontext', resourcePersons]);

    function resourcePersons($modal, common, config, datacontext)
    {
        // Using 'Controller As' syntax, so we assign this to the vm variable (for viewmodel).
        var vm = this;
        var getLogFn = common.logger.getLogFn;
        var log = getLogFn(controllerId);
        var keyCodes = config.keyCodes;

        // Bindable properties and functions are placed on vm.
        vm.title = 'Resource Persons';
        vm.gridOptions = config.gridOptions;

        vm.gridOptions.columnDefs = [
            { field: 'resourcePersonId', name: ' ', cellTemplate: 'app/resourcePerson/edit-button.html', width: 45, enableFiltering: false, enableSorting: false },
            { field: 'name'},
            { field: 'gender', filter: config.filters['gender'] },
            { field: 'yearsOfExperience', filters: common.getBetweenFilter() },
            { field: 'academicQualification.name', name: 'Academic Qualification', filter: config.filters['academicQualification'] },
            { field: 'district.province.name', name: 'Province' },
            { field: 'district.name', name: 'District' },
            { field: 'organization.name', name: 'Organization' },
            { field: 'age', filters: common.getBetweenFilter() },
            { field: 'cell'},
            { field: 'email' },
            { field: 'approvalStatus', filter: config.filters['approvalType'] }
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
            var select = 'resourcePersonId, name, gender, yearsOfExperience, academicQualification, '+
                         'academicQualification.name, district, district.name, district.province, district.province.name, organization, ' +
                         'organization.name, dateOfBirth, cell, email, approvalStatus';

            var where = breeze.Predicate.create('resourcePersonId', '!=', 0);

            return datacontext.resourcePerson.getAll(forceRefresh, select, where)
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
