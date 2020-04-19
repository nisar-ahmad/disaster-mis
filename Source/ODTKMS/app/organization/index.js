(function()
{
    'use strict';

    // Controller name is handy for logging
    var controllerId = 'organizations';

    // Define the controller on the module.
    // Inject the dependencies. 
    // Point to the controller definition function.
    angular.module('app').controller(controllerId,
        ['$modal', '$routeParams', 'common', 'config', 'datacontext', organizations]);

    function organizations($modal, $routeParams, common, config, datacontext)
    {
        // Using 'Controller As' syntax, so we assign this to the vm variable (for viewmodel).
        var vm = this;
        var getLogFn = common.logger.getLogFn;
        var log = getLogFn(controllerId);
        var keyCodes = config.keyCodes;

        vm.id = $routeParams.id;
        vm.category = $routeParams.category;

        // Bindable properties and functions are placed on vm.

        vm.title = vm.category === '4w' ? '4W Organizations' : 'Donors & Collaborating Agencies';
        vm.gridOptions = config.gridOptions;
        vm.gridOptions.appScopeProvider = vm;


        if (vm.category == '4w')
        {
            vm.gridOptions.columnDefs = [
                { field: 'organizationId', name: ' ', cellTemplate: 'app/organization/edit-button.html', width: 45, enableFiltering: false, enableSorting: false },
                { field: 'name' },
                { field: 'organizationType.name', name: 'Organization Type', filter: config.filters['organizationType'] },
                { field: 'relationshipType', filter: config.filters['relationshipType'] },
                { field: 'headName' },
                { field: 'contactPersonName' },
                { field: 'contactPersonDesignation' },
                { field: 'contactPersonLandline' },
                { field: 'contactPersonMobile' },
                { field: 'contactPersonEmail' },
            ];
        }
        else
        {
            vm.gridOptions.columnDefs = [
                { field: 'organizationId', name: ' ', cellTemplate: 'app/organization/edit-button.html', width: 45, enableFiltering: false, enableSorting: false },
                { field: 'name' },
                { field: 'organizationType.name', name: 'Organization Type', filter: config.filters['organizationType'] },
                { field: 'relationshipType', filter: config.filters['relationshipType'] },
                { field: 'headName' },
                { field: 'headEmail' },
                { field: 'headLandline' },
                { field: 'headMobile' }                
            ];
        }

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

            var select = 'organizationId, name, organizationType, organizationType.name, relationshipType, '+
                         'headName, headEmail, headLandline, headMobile, contactPersonName, contactPersonDesignation, contactPersonLandline, ' +
                         'contactPersonMobile, contactPersonEmail, category';

            var category = vm.category === '4w' ? 'FourW' : 'Default';
            var filter = breeze.Predicate.create('category', '==', category).and('organizationId', '!=', 0);

            return datacontext.organization.getAll(forceRefresh, select, filter)
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
