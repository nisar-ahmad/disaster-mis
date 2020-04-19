(function()
{
    'use strict';

    // Controller name is handy for logging
    var controllerId = 'documents';

    // Define the controller on the module.
    // Inject the dependencies. 
    // Point to the controller definition function.
    angular.module('app').controller(controllerId,
        ['$modal', '$routeParams', 'common', 'config', 'datacontext', documents]);

    function documents($modal, $routeParams, common, config, datacontext)
    {
        // Using 'Controller As' syntax, so we assign this to the vm variable (for viewmodel).
        var vm = this;
        var getLogFn = common.logger.getLogFn;
        var log = getLogFn(controllerId);
        var keyCodes = config.keyCodes;

        vm.public = $routeParams.public;

        // Bindable properties and functions are placed on vm.
        vm.title = 'Documents';
        vm.gridOptions = config.gridOptions;
        vm.gridOptions.appScopeProvider = vm;

        vm.gridOptions.columnDefs = [
            { field: 'documentId', name: ' ', cellTemplate: 'app/document/edit-button.html', width: 45, enableFiltering: false, enableSorting: false },
            { field: 'name', name: 'Title' },
            { field: 'documentCategory1.name', name: 'Document Category 1', filter: config.filters['documentCategory'] },
            { field: 'thematicArea.name', name: 'Thematic Area', filter: config.filters['thematicArea'] },
            { field: 'training.name', name: 'Training' },
            //{ field: 'edition'},
            { field: 'yearOfPublication', cellFilter: 'date:\'dd MMM yyyy\'' },
            { field: 'compilingAgency' },
            //{ field: 'publisherName' },
            //{ field: 'price' }
            //{ field: 'physicalLocation' }
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
            var select = 'documentCategory1, documentCategory1.name, thematicArea, thematicArea.name,' +
                         'training, training.name, documentId, name, fileName, yearOfPublication, compilingAgency';
                         //'authors, publisherName, price'

            var where = breeze.Predicate.create('documentId', '!=', 0);

            return datacontext.document.getAll(forceRefresh, select, where)
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
