(function()
{
    'use strict';

    // Controller name is handy for logging
    var controllerId = 'questions';

    // Define the controller on the module.
    // Inject the dependencies. 
    // Point to the controller definition function.
    angular.module('app').controller(controllerId,
        ['common', 'config', 'datacontext', questions]);

    function questions(common, config, datacontext)
    {
        // Using 'Controller As' syntax, so we assign this to the vm variable (for viewmodel).
        var vm = this;
        var getLogFn = common.logger.getLogFn;
        var log = getLogFn(controllerId);
        var keyCodes = config.keyCodes;

        // Bindable properties and functions are placed on vm.
        vm.title = 'Questions';
        vm.gridOptions = config.gridOptions;

        vm.gridOptions.columnDefs = [
            { field: 'questionId', name: ' ', cellTemplate: 'app/question/edit-button.html', width: 45, enableFiltering: false, enableSorting: false },
            { field: 'type', filter: config.filters['questionType'] },
            { field: 'broaderTrainingArea.name', name: 'Area', filter: config.filters['broaderTrainingArea'] },
            { field: 'statement' },                     
            { field: 'active', cellFilter: 'yesNo', filter: config.filters['yesNo'] },
            { field: 'dateCreated', filterCellFiltered: true, cellFilter: "date:'dd MMM yyyy'", filters: common.getBetweenFilter() },
            { field: 'choices' }
        ];

        vm.refresh = refresh;

        activate();

        function activate()
        {
            common.activateController([getAll(true)], controllerId);
        }

        function getAll(forceRefresh)
        {
            //var select = 'districtId, name, province, province.name';

            return datacontext.question.getAll(forceRefresh)
                .then(function(data)
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
