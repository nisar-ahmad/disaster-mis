(function()
{
    'use strict';

    var controllerId = 'survey';

    angular.module('app').controller(controllerId,
        ['$scope', '$location', '$window', '$routeParams', 'common', 'config', 'datacontext', 'model', survey]);

    function survey($scope, $location, $window, $routeParams, common, config, datacontext, model )
    {
        var entity = 'Survey';

        var vm = this;
        vm.title = 'Edit ' + entity;

        var entityName = model.entityNames.survey;
        var logError = common.logger.getLogFn(controllerId, 'error');
        var logSuccess = common.logger.getLogFn(controllerId, 'success');

        // Bindable properties and functions are placed on vm.
        vm.entity = undefined;
        vm.id = $routeParams.id;
        vm.trainingId = $routeParams.trainingId;
        vm.public = $routeParams.public;

        vm.goBack = goBack;
        vm.cancel = cancel;

        vm.hasChanges = false;
        vm.isSaving = false;
        vm.save = save;
               
        vm.activate = activate;

        vm.surveyQuestionsOriginal = [];

        vm.gridOptions = config.gridOptions;

        vm.gridOptions.columnDefs = [
            { field: 'questionId', name: ' ', width: 45, enableFiltering: false, enableSorting: false, visible: false },
            { field: 'type', filter: config.filters['questionType'] },
            { field: 'broaderTrainingArea.name', filter: config.filters['broaderTrainingArea'] },
            { field: 'statement' },
            { field: 'choices' },
            { field: 'active', cellFilter: 'yesNo', filter: config.filters['yesNo'] },
            { field: 'dateCreated', filterCellFiltered: true, cellFilter: "date:'dd MMM yyyy'", filters: common.getBetweenFilter() }
        ];

        vm.gridApi = null;
        vm.gridOptions.onRegisterApi = onRegisterApi;

        function onRegisterApi(gridApi)
        {
            vm.gridApi = gridApi;

            if (vm.gridApi.selection)
            {
                vm.gridApi.selection.on.rowSelectionChanged($scope, function (row)
                {
                    vm.hasChanges = true;
                });

                vm.gridApi.selection.on.rowSelectionChangedBatch($scope, function (rows)
                {
                    vm.hasChanges = true;
                });
            }
        }

        // vm.canSave Property
        Object.defineProperty(vm, 'canSave', {
            get: canSave
        });

        function canSave()
        {
            return vm.hasChanges && !vm.isSaving;
        }
        
        activate();

        function queryFailed(error) {
            logError(error);
            goToIndex();
        }
    
        function activate()
        {
            onDestroy();
            onHasChanges();

            var p0 = datacontext.question.getAll(true);
       
            common.activateController([p0], controllerId).then(init, queryFailed);
        }

        function init(results)
        {
            vm.questions = results[0];
            vm.gridOptions.data = vm.questions;

            getEntity(true);
        }

        function createEntity()
        {
            vm.entity = datacontext.survey.create();
            vm.entity.welcomeMessage = 'Welcome, please take a moment to provide your valuable feedback.';
            vm.entity.exitMessage = 'Thank you for your valuable feedback!';
            vm.entity.active = true;

            return vm.entity;
        }

        function getEntity(forceRemote)
        {
            if (vm.id === 'new')
            {
                vm.title = 'Add ' + entity;
                return createEntity();
            }

            return datacontext.survey.getById(vm.id, forceRemote)
                    .then(querySucceeded, queryFailed);

            function querySucceeded(data) {
                vm.entity = data.entity || data;
                vm.entity.entityAspect.loadNavigationProperty("surveyQuestions").then(success, queryFailed);

                function success(data)
                {
                    vm.surveyQuestionsOriginal = data.results || data;

                    for (var sq of vm.surveyQuestionsOriginal)
                    {
                        var row = $.grep(vm.questions, function (e) { return e.questionId == sq.questionId; })[0];

                        if(row)
                            vm.gridApi.selection.selectRow(row);
                    }

                    vm.hasChanges = false;
                }
            }
        }

        function save()
        {
            if (!canSave())
            {
                return common.$q.when(null);

            } // Must return a promise

            vm.isSaving = true;

            if (vm.id != 'new')
            {
                var selectedQuestions = vm.gridApi.selection.getSelectedRows();

                for(var q of vm.questions)
                {
                    var selected = (selectedQuestions.indexOf(q) >= 0);
                    var original = $.grep(vm.surveyQuestionsOriginal, function (e) { return e.questionId == q.questionId; });
                    var exists = original.length;

                    if (selected && !exists)
                    {
                        // add
                        var obj = { surveyId: vm.entity.surveyId, questionId: q.questionId };
                        var newEntity = datacontext.surveyQuestion.create(obj);

                        vm.surveyQuestionsOriginal.push(newEntity);
                    }
                    else if (!selected && exists)
                    {
                        // remove
                        var entityAspect = original[0].entityAspect;

                        if (!entityAspect.entityState.isDetached())
                            entityAspect.setDeleted();

                        vm.surveyQuestionsOriginal = vm.surveyQuestionsOriginal.filter(function (e) { return e.questionId != q.questionId; });
                    }
                }
            }

            return datacontext.save()
                .then(function (saveResult)
                {
                    // Save success
                    vm.isSaving = false;

                    if (vm.id === 'new')
                        $location.path('/survey/' + vm.entity.surveyId);

                },
                function (error)
                {
                    // Save error
                    vm.isSaving = false;
                });
        }

        function cancel()
        {
            datacontext.cancel();
            vm.hasChanges = false;

            if (vm.entity.entityAspect.entityState.isDetached())
            {
                goToIndex();
            }
        }

        function goToIndex()
        {
             $location.path('/surveys');
        }

        function goBack()
        {
            vm.gridOptions.onRegisterApi = null;
            $window.history.back();
        }

        function onDestroy()
        {
            $scope.$on('$destroy', function()
            {
                vm.gridOptions.onRegisterApi = null;
                datacontext.cancel();
            });
        }

        function onHasChanges()
        {
            $scope.$on(config.events.hasChangesChanged,
                function(event, data)
                {
                    vm.hasChanges = data.hasChanges;
                });
        }
    }

})();
