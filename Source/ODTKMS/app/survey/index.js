(function()
{
    'use strict';

    // Controller name is handy for logging
    var controllerId = 'surveys';

    // Define the controller on the module.
    // Inject the dependencies. 
    // Point to the controller definition function.
    angular.module('app').controller(controllerId,
        ['$routeParams', 'common', 'config', 'datacontext', 'uiGridConstants', surveys]);

    function surveys($routeParams, common, config, datacontext, uiGridConstants)
    {
        // Using 'Controller As' syntax, so we assign this to the vm variable (for viewmodel).
        var vm = this;
        var getLogFn = common.logger.getLogFn;
        var log = getLogFn(controllerId);
        var keyCodes = config.keyCodes;

        vm.public = $routeParams.public;

        // Bindable properties and functions are placed on vm.
        vm.title = 'Surveys';
        vm.gridOptions = config.gridOptions;
        vm.gridOptions.appScopeProvider = vm;

        vm.gridOptions.columnDefs = [
            { field: 'surveyId', name: ' ', cellTemplate: 'app/survey/edit-button.html', width: 60, enableFiltering: false, enableSorting: false, enableColumnMenu: false },
            { field: 'name' },
            { field: 'description' },
            { field: 'welcomeMessage' },
            { field: 'exitMessage' },
            { field: 'active', cellFilter: 'yesNo' },
            { field: 'startDate', filterCellFiltered: true, cellFilter: "date:'dd MMM yyyy'", filters: common.getBetweenFilter() },
            { field: 'endDate', filterCellFiltered: true, cellFilter: "date:'dd MMM yyyy'", filters: common.getBetweenFilter() }
        ];

        vm.refresh = refresh;

        activate();

        function activate()
        {
            common.activateController([getAll(true)], controllerId);
        }

        function getAll(forceRefresh) {

            var select = 'surveyId, name, description, welcomeMessage, exitMessage, active, ' +
                         'startDate, endDate';

            var surveyId = vm.public ? 1 : 0;

            var where = breeze.Predicate.create('surveyId', '>', surveyId);

            if (vm.public)
                where = where.and('active', '==', true);

            return datacontext.survey.getAll(forceRefresh, select, where)
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
