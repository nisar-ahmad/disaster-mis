(function()
{
    'use strict';

    var controllerId = 'document';

    angular.module('app').controller(controllerId,
        ['$scope', '$location',  '$window', '$routeParams', 'common', 'config', 'datacontext',
            'model', 'fileUpload', document]);

    function document($scope, $location, $window, $routeParams, common, config, datacontext, model, fileUpload)
    {
        var vm = this;

        var action = vm.id === 'new' ? "Add " : "Edit"
        vm.title = action + ' Document';
        vm.fileNameUrl = 'Files/Documents/Library/';        

        var entityName = model.entityNames.document;
        var logError = common.logger.getLogFn(controllerId, 'error');
        var logSuccess = common.logger.getLogFn(controllerId, 'success');

        // Bindable properties and functions are placed on vm.
        vm.entity = undefined;
        vm.id = $routeParams.id;

        vm.getFileIcon = common.getFileIcon;
        vm.activate = activate;
        vm.goBack = goBack;
        vm.cancel = cancel;
        vm.categoryChanged = categoryChanged;
        vm.populateCategories = populateCategories;

        vm.hasChanges = false;
        vm.isSaving = false;
        vm.save = save;
        
        vm.accessTypes = [];
        vm.documentCategories1 = [];
        vm.documentCategories2 = [];
        vm.documentCategories3 = [];
        vm.trainings = [];
        vm.thematicAreas =[];
       
        vm.file = undefined;
        vm.fileNameChanged = function () { vm.hasChanges = true; }
       
        // vm.canSave Property
        Object.defineProperty(vm, 'canSave', {
            get: canSave
        });

        function canSave()
        {
            return vm.hasChanges && !vm.isSaving;
        }

        activate();

        function activate()
        {
            onDestroy();
            onHasChanges();

            var p0 = datacontext.training.getAll(true);
            var p1 = datacontext.thematicArea.getAll(true);
            var p2 = datacontext.documentCategory.getAll(true);

            common.activateController([p0, p1, p2], controllerId).then(init, queryFailed);
        }

        function init(results) {
            vm.accessTypes = datacontext.enum.types.accessTypes;
            vm.trainings = results[0];
            vm.thematicAreas = results[1];
            vm.documentCategories = results[2];
            getEntity(true);
        }

        function queryFailed(error) {
            logError(error);
            goToIndex();
        }

        function initCategories()
        {
            var nullo = vm.documentCategories[0];

            vm.documentCategories1.push(nullo);
            vm.documentCategories2.push(nullo);
            vm.documentCategories3.push(nullo);

            var parentId1 = vm.entity.documentCategory1 ? vm.entity.documentCategory1.documentCategoryId : null;
            var parentId2 = vm.entity.documentCategory2 ? vm.entity.documentCategory2.documentCategoryId : null;

            populateCategories(vm.documentCategories1, 0);
            populateCategories(vm.documentCategories2, 1, parentId1);
            populateCategories(vm.documentCategories3, 2, parentId2);

            restoreNullos();
        }

        function categoryChanged(level)
        {
            var parentId = vm.entity.documentCategory1.documentCategoryId;
            var categories = vm.documentCategories2;

            if (level === 1)
            {
                populateCategories(categories, level, parentId);

                //if(!parentId)
                //{
                //    vm.entity.documentCategory2 = vm.documentCategories[0];
                //    vm.entity.documentCategory3 = vm.documentCategories[0];
                //}

                level = 2;
            }

            if (level === 2)
            {
                if (parentId)
                    parentId = vm.entity.documentCategory2.documentCategoryId;

                //if(!parentId)
                //    vm.entity.documentCategory3 = vm.documentCategories[0];

                categories = vm.documentCategories3;
                populateCategories(categories, level, parentId);
            }

            restoreNullos();
        }

        function populateCategories(categories, level, parentId)
        {
            //alert(level + ' - '  + parentId);
            categories.length = 1;

            if (level != 0 && !parentId)
                return;

            if (level === 0)
                parentId = undefined;

            for (var i = 1; i < vm.documentCategories.length; i++) {
                var c = vm.documentCategories[i];

                if (c.parentDocumentCategoryId == parentId)
                    categories.push(c);
            }
        }

        function getEntity(forceRemote)
        {
            if(vm.id === 'new')
            {                
                vm.entity = datacontext.document.create();
                initCategories();
                return vm.entity;
            }

            return datacontext.document.getById(vm.id, forceRemote)
                .then(function(data)
                {
                    vm.entity = data.entity || data;
                    initCategories();
                }, queryFailed);
        }

        function goBack()
        {
            $window.history.back();
        }

        function saveNullos()
        {
            if (vm.entity.training.trainingId === 0)
                vm.entity.training = null;

            if (vm.entity.documentCategory1.documentCategoryId === 0)
                vm.entity.documentCategory1 = null;

            if (vm.entity.documentCategory2.documentCategoryId === 0)
                vm.entity.documentCategory2 = null;

            if (vm.entity.documentCategory3.documentCategoryId === 0)
                vm.entity.documentCategory3 = null;

            if (vm.entity.thematicArea.thematicAreaId === 0)
                vm.entity.thematicArea = null;
        }

        function restoreNullos()
        {
            if (vm.entity) {

                if (!vm.entity.training)
                    vm.entity.training = vm.trainings[0];

                if (!vm.entity.documentCategory1 || vm.documentCategories1.length === 1)
                    vm.entity.documentCategory1 = vm.documentCategories[0];

                if (!vm.entity.documentCategory2 || vm.documentCategories2.length === 1)
                    vm.entity.documentCategory2 = vm.documentCategories[0];

                if (!vm.entity.documentCategory3 || vm.documentCategories3.length === 1)
                    vm.entity.documentCategory3 = vm.documentCategories[0];

                if (!vm.entity.thematicArea || vm.thematicAreas.length === 1)
                    vm.entity.thematicArea = vm.thematicAreas[0];
            }
        }

        function cancel()
        {
            datacontext.cancel();
            initCategories();

            $('input[type=file]').val('');
            vm.file = null;

            if (vm.entity.entityAspect.entityState.isDetached())
            {
                goToIndex();
            }
        }

        function goToIndex()
        {
            $location.path('/documents');
        }

        function save(preventSuccessLog)
        {
            if(!canSave())
            {
                return common.$q.when(null);

            } // Must return a promise

            vm.isSaving = true;
            saveNullos();

            return datacontext.save(preventSuccessLog)
                .then(function(saveResult)
                {
                    if (vm.file)
                    {
                        logSuccess('Uploading File : ' + vm.file.name + '...');

                        fileUpload.upload(vm.file, vm.fileNameUrl, vm.entity.fileName).then(function (result)
                        {
                            vm.file = null;
                            vm.entity.fileName = result.data;
                            logSuccess('Uploaded File : ' + vm.entity.fileName);
                            vm.isSaving = false;
                            save(true);
                        }
                        , queryFailed);
                    }

                    // Save success
                    restoreNullos();                                       
                    vm.isSaving = false;
                },
                function(error)
                {
                    // Save error
                    restoreNullos();
                    vm.isSaving = false;
                });
        }

        function onDestroy()
        {
            $scope.$on('$destroy', function()
            {
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
