(function()
{
    'use strict';

    var controllerId = 'content';

    angular.module('app').controller(controllerId,
        ['$scope', '$location', '$filter', '$window', '$routeParams', '$q', 'common', 'config', 'datacontext',
          'model', 'helper', 'fileUpload', content]);

    function content($scope, $location, $filter, $window, $routeParams, $q, common, config, datacontext,
           model, helper, fileUpload)
    {
        var vm = this;

        var entity = 'Content';
        var entityName = model.entityNames.content;
        var logError = common.logger.getLogFn(controllerId, 'error');
        var logSuccess = common.logger.getLogFn(controllerId, 'success');
        
        // Bindable properties and functions are placed on vm.        
        vm.id = $routeParams.id;

        var action = vm.id === 'new' ? 'Add ' : 'Edit ';

        vm.title = action + entity;

        vm.goBack = goBack;
        vm.cancel = cancel;

        vm.hasChanges = false;
        vm.isSaving = false;
        vm.save = save;

        vm.contentTypes = [];        
        
        vm.file = undefined;
        vm.fileUrl = 'Files/Website/';

        vm.getFileIcon = common.getFileIcon;
        vm.fileNameChanged = function () { vm.hasChanges = true; }
        
        vm.activate = activate;
 
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

            var select = 'contentId, title, contentType, description, date';
            
            vm.contentTypes = datacontext.enum.types.contentTypes;

            common.activateController([], controllerId).then(init, queryFailed);
        }

        function init(results)
        {           
            getEntity(true);
        }

        
        function createEntity()
        {
            vm.entity = datacontext.content.create();
            vm.entity.contentType = 'News';
            return vm.entity;
        }

        function getEntity(forceRemote)
        {
            if (vm.id === 'new')
                return createEntity();

            return datacontext.content.getById(vm.id, forceRemote)
                    .then(querySucceeded, queryFailed);

            function querySucceeded(data) {
                vm.entity = data.entity || data;
            }
        }

        function save() {
            if (!canSave()) {
                return common.$q.when(null);

            } // Must return a promise

            vm.isSaving = true;

            return datacontext.save()
                .then(function (saveResult) {
                    // Save success

                    var promises = [];

                    // Uploads
                    if (vm.file)
                    {
                        logSuccess('Uploading File : ' + vm.file.name + '...');

                        var p = fileUpload.upload(vm.file, vm.fileUrl, vm.entity.file, true).then(function (result)
                        {
                            vm.file = null;
                            vm.entity.file = result.data;
                            logSuccess('Uploaded File : ' + vm.entity.file);
                        }, queryFailed);

                        promises.push(p);
                    }

                    $q.all(promises).then(function () { datacontext.save(true).then(function () { vm.isSaving = false; goToIndex();}); });
                },
                function (error) {
                    // Save error
                    vm.isSaving = false;
                });
        }

        function cancel()
        {
            datacontext.cancel();

            vm.file = null;
            $('input[type=file]').val('');

            vm.hasChanges = false;

            if (vm.entity.entityAspect.entityState.isDetached())
            {
                goToIndex();
            }
        }

        function goToIndex()
        {
            $location.path('/contents');
        }

        function goBack() {
            $window.history.back();
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
