(function () {
    'use strict';

    // Controller name is handy for logging
    var controllerId = 'documentCategories';

    // Define the controller on the module.
    // Inject the dependencies. 
    // Point to the controller definition function.
    angular.module('app').controller(controllerId,
        ['$modal', 'common', 'config', 'datacontext', provinces]);

    function provinces($modal, common, config, datacontext) {
        // Using 'Controller As' syntax, so we assign this to the vm variable (for viewmodel).
        var vm = this;
        var getLogFn = common.logger.getLogFn;
        var log = getLogFn(controllerId);
        var keyCodes = config.keyCodes;

        // Bindable properties and functions are placed on vm.
        vm.title = 'Document Categories';
        vm.gridOptions = config.gridOptions;

        vm.gridOptions.columnDefs = [
            { field: 'documentCategoryId', name: ' ', cellTemplate: 'app/documentCategory/edit-button.html', width: 34, enableFiltering: false, enableSorting: false },
            { field: 'name' },
            { field: 'level' },
            { field: 'parentDocumentCategory.name', name: 'Parent Category' },
            { field: 'description' }
        ];

        vm.refresh = refresh;

        activate();

        function activate() {
            common.activateController([getAll(true)], controllerId);
        }

        function getAll(forceRefresh) {
            var select = 'documentCategoryId, name, level, parentDocumentCategory, parentDocumentCategory.name, description';
            var filter = breeze.Predicate.create('documentCategoryId', '!=', 0);
            var order = 'level, name'

            return datacontext.documentCategory.getAll(forceRefresh, select, filter, order)
                .then(function (data) {
                    vm.gridOptions.data = data;
                    return data;
                }
            );
        }

        function refresh() {
            activate();
        }
    }
})();
