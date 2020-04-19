(function()
{
    'use strict';

    // Controller name is handy for logging
    var controllerId = 'trainings';

    // Define the controller on the module.
    // Inject the dependencies. 
    // Point to the controller definition function.
    angular.module('app').controller(controllerId,
        ['$modal', 'common', 'config', 'datacontext', trainings]);

    function trainings($modal, common, config, datacontext)
    {
        // Using 'Controller As' syntax, so we assign this to the vm variable (for viewmodel).
        var vm = this;
        var getLogFn = common.logger.getLogFn;
        var log = getLogFn(controllerId);
        var keyCodes = config.keyCodes;

        // Bindable properties and functions are placed on vm.
        vm.title = 'Trainings';
        vm.gridOptions = config.gridOptions;

        vm.gridOptions.columnDefs = [
            { field: 'trainingId', name: ' ', cellTemplate: 'app/training/edit-button.html', width: 45, enableFiltering: false, enableSorting: false },
            { field: 'year', filters: common.getBetweenFilter() },
            { field: 'name', name: 'Title' },
            { field: 'trainingType', filter: config.filters['trainingType'] },
            { field: 'trainingLevel', filter: config.filters['trainingLevel'] },
            { field: 'broaderTrainingArea.name', filter: config.filters['broaderTrainingArea'], name: 'Broader Training Area' },
            { field: 'startDate', cellFilter: 'date:\'dd MMM yyyy\'' },
            { field: 'endDate', cellFilter: 'date:\'dd MMM yyyy\'' },
            { field: 'province.name', name: 'Province' },
            { field: 'district.name.', name: 'District' },
            { field: 'city.name', name: 'City' },
            { field: 'fee', filters: common.getBetweenFilter()  },
            { field: 'status', filter: config.filters['trainingStatus'] },
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

            var select = 'trainingId, name, trainingType, trainingLevel, broaderTrainingArea, broaderTrainingArea.name, ' +
                         'startDate, endDate, city, city.name, district, district.name, ' +
                         'province, province.name, fee, status';

            var where = breeze.Predicate.create('trainingId', '!=', 0);

            return datacontext.training.getAll(forceRefresh, select, where)
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
