(function()
{
    'use strict';

    var controllerId = 'album';

    angular.module('app')
        .controller(controllerId, ['$scope', '$location', '$filter', '$window', '$routeParams', '$modal',
                                   'common', 'config', 'datacontext', 'model', 'helper', 'fileUpload', album]);

    function album($scope, $location, $filter, $window, $routeParams, $modal, common, config, 
                     datacontext, model, helper, fileUpload)
    {
        var vm = this;       
        var logError = common.logger.getLogFn(controllerId, 'error');
        var logSuccess = common.logger.getLogFn(controllerId, 'success');
        
        // Bindable properties and functions are placed on vm.
        vm.id = $routeParams.id;
        vm.uploadMediaFile = uploadMediaFile;

        var entity = 'Album';
        var action = vm.id === 'new' ? 'Add ' : 'Edit ';
        vm.title = action + entity;

        vm.goBack = goBack;
        vm.cancel = cancel;

        vm.hasChanges = false;
        vm.isSaving = false;
        vm.save = save;
        
        vm.items = [];
        vm.albumTypes = [];
        vm.accessTypes = [];

        var allGalleries = [];

        var chunkSize = 4;
        vm.mediaFiles = [];
        vm.albumUrl = undefined;
        
        vm.mediaFile = undefined;
        vm.file = undefined;
        vm.item = undefined;

        vm.entity = undefined;

        vm.setRelativeUrl = setRelativeUrl;
        vm.albumTypeChanged = albumTypeChanged;
        vm.activate = activate;

        var imageExtensions = ['jpg', 'jpeg', 'png', 'gif'];
        var videoExtensions = [ 'mp4', 'webm', 'ogg' ];

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

            var p0 = datacontext.gallery.getAll(true);

            common.activateController([p0], controllerId).then(init, queryFailed);
        }

        function init(results)
        {
            vm.accessTypes = datacontext.enum.types.accessTypes;
            vm.albumTypes = datacontext.enum.types.albumTypes.slice(0);            
            vm.albumTypes.pop();

            allGalleries = results[0];
            getEntity(true);
        }

        function initDropDowns(entity)
        {            
            vm.entity.albumType = vm.albumTypes[0];
            vm.entity.accessType = vm.accessTypes[0];

            albumTypeChanged();
        }
        
        function createEntity()
        {
            vm.entity = datacontext.album.create();
            initDropDowns(vm.entity);

            return vm.entity;
        }

        function getEntity(forceRemote)
        {
            if (vm.id === 'new')           
                return createEntity();

            return datacontext.album.getById(vm.id, forceRemote)
                    .then(querySucceeded, queryFailed);

            function querySucceeded(data) {
                vm.entity = data.entity || data;
                albumTypeChanged(true);
                loadMediaFiles();
            }
        }

        function loadMediaFiles()
        {
            vm.entity.entityAspect.loadNavigationProperty("mediaFiles")
                        .then(successItems, queryFailed);

            function successItems(data)
            {
                vm.mediaFiles = common.getChunks(data.results, chunkSize);
                return vm.mediaFiles;
            }
        }

        function albumTypeChanged(get)
        {
            vm.items = [];

            function setEntity()
            {
                if (get)
                {
                    vm.entity.gallery = $.grep(allGalleries, function (o) { return o.albumType === vm.entity.albumType; })[0]
                    vm.albumUrl = vm.entity.gallery.relativeUrl + vm.entity.relativeUrl;

                    var id = vm.entity.relativeUrl.substring(0, vm.entity.relativeUrl.length - 1);

                    if (id)
                        vm.item = $.grep(vm.items, function (o) { return o.id == id; })[0];
                }
                else
                {
                    vm.item = vm.items[0];                
                    setRelativeUrl();
                }                
            }

            switch (vm.entity.albumType)
            {
                case 'Training':
                    var filter = breeze.Predicate.create('trainingId', '!=', 0);
                    datacontext.training.getAll(true, 'trainingId, name', filter).then(function (results)
                    {
                        for(var i of results)
                           vm.items.push({ id: i.trainingId, name: i.name });

                        setEntity();

                    }, queryFailed);
                    break;
                case 'Project':
                    datacontext.project.getAll(true, 'projectId, name').then(function (results)
                    {
                        for(var i of results)
                           vm.items.push({ id: i.projectId, name: i.name });

                        setEntity();

                    }, queryFailed);
                    break;
                case 'Activity':
                    datacontext.activity.getAll(true, 'activityId, name').then(function (results)
                    {
                        for(var i of results)
                           vm.items.push({ id: i.activityId, name: i.name });

                        setEntity();

                    }, queryFailed);
                    break;
                case 'Training4W':
                    datacontext.trainingActivity.getAll(true, 'trainingActivityId, titleOfTraining').then(function (results)
                    {
                        for(var i of results)
                           vm.items.push({ id: i.trainingActivityId, name: i.titleOfTraining });

                        setEntity();

                    }, queryFailed);
                    break;
                case 'TNA':
                    datacontext.survey.getAll(true, 'surveyId, name').then(function (results)
                    {
                        for(var i of results)
                           vm.items.push({ id: i.surveyId, name: i.name });

                        setEntity();

                    }, queryFailed);
                    break;
                default:
                    setRelativeUrl();
                    break;
            }
        }

        function setRelativeUrl()
        {
            if (vm.entity)
            {
                var url = undefined;

                switch (vm.entity.albumType)
                {
                    case 'General':
                        url = vm.entity.albumId;
                        break;
                    default:
                        if (vm.item)
                            url = vm.item.id;
                }

                if (url)
                {
                    url += '/';
                    vm.entity.relativeUrl = url;
                    vm.entity.gallery = $.grep(allGalleries, function (o) { return o.albumType === vm.entity.albumType; })[0]
                    vm.albumUrl = vm.entity.gallery.relativeUrl + vm.entity.relativeUrl;
                }
            }
        }

        function uploadMediaFile()
        {            
            if (!vm.file || !vm.mediaFile || !vm.mediaFile.description)
            {
                logError("Please select a valid file and provide caption");
                return;
            }

            logSuccess('Uploading File : ' + vm.file.name);

            var ext = common.getFileExtension(vm.file.name);
            var isImage = $.grep(imageExtensions, function (o) { return o === ext; }).length > 0;

            fileUpload.upload(vm.file, vm.albumUrl, null, isImage).then(function (result)
            {
                vm.file = null;
                vm.mediaFile.name = result.data;

                var fileType = 'Unknown';

                if (isImage)
                    vm.mediaFile.fileType = 'Image';
                else
                {
                    var isVideo = $.grep(videoExtensions, function (o) { return o === ext; }).length;

                    if (isVideo)
                        vm.mediaFile.fileType = 'Video';
                }

                vm.mediaFile.album = vm.entity;
                vm.mediaFile = datacontext.mediaFile.create(vm.mediaFile);
                vm.mediaFile.dateUploaded = moment().valueOf();

                vm.isSaving = false;

                datacontext.save(true).then(function ()
                {
                    logSuccess('Uploaded File : ' + vm.mediaFile.name);

                    vm.mediaFile = undefined;
                    $('input[type=file]').val('');
                    vm.file = null;

                    loadMediaFiles();
                }, queryFailed);
            });
        }

        function save(preventLogSuccess) {
            if (!canSave()) {
                return common.$q.when(null);

            } // Must return a promise

            if (vm.entity.albumType != 'General' && !vm.item)
            {
                logError(vm.entity.albumType + ' is required!');
                return;
            }

            vm.isSaving = true;
            vm.entity.gallery = $.grep(allGalleries, function (o) { return o.albumType === vm.entity.albumType; })[0];
            vm.entity.dateCreated = vm.entity.dateModified = moment().valueOf();

            return datacontext.save(preventLogSuccess)
                .then(function (saveResult) {
                    // Save success
                    vm.isSaving = false;

                    if (vm.id === 'new');
                        $location.path('/album/' + vm.entity.albumId);                        
                    
                    //helper.replaceLocationUrlGuidWithId(vm.entity.documentId);
                },
                function (error) {
                    // Save error
                    vm.isSaving = false;
                });
        }

        function cancel()
        {
            datacontext.cancel();

            vm.mediaFile = undefined;
            $('input[type=file]').val('');
            vm.file = null;

            albumTypeChanged();

            vm.hasChanges = false;
            //helper.replaceLocationUrlGuidWithId(vm.entity.documentId);

            if (vm.entity.entityAspect.entityState.isDetached())
            {
                goToIndex();
            }
        }

        function goToIndex()
        {
            $location.path('/albums');
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
