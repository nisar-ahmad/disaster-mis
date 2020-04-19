(function()
{
    'use strict';

    // Controller name is handy for logging
    var controllerId = 'activities';

    // Define the controller on the module.
    // Inject the dependencies. 
    // Point to the controller definition function.
    angular.module('app').controller(controllerId,
        ['$modal', 'common', 'config', 'datacontext', activities]);

    function activities($modal, common, config, datacontext)
    {
        // Using 'Controller As' syntax, so we assign this to the vm variable (for viewmodel).
        var vm = this;
        var getLogFn = common.logger.getLogFn;
        var log = getLogFn(controllerId);
        var keyCodes = config.keyCodes;

        // Bindable properties and functions are placed on vm.
        vm.title = 'Activities';
        vm.gridOptions = config.gridOptions;

        vm.gridOptions.columnDefs = [
            { field: 'activityId', name: ' ', cellTemplate: 'app/activity/edit-button.html', width: 45, enableFiltering: false, enableSorting: false },
            { field: 'project.name', name: 'Project' },
            { field: 'activityType.name', name: 'Activity Type' },
            { field: 'name', name: 'Title' },
            { field: 'description' },
            { field: 'dateOfActivity', cellFilter: 'date:\'dd MMM yyyy\'' },
            { field: 'city.name', name: 'City' }
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
            var select = 'activityId, activityType, activityType.name, city, city.name, project, ' +
                         'project.name, name, description, dateOfActivity';

            var where = breeze.Predicate.create('activityId', '!=', 0);

            return datacontext.activity.getAll(forceRefresh, select, where)
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
