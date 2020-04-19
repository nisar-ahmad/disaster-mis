(function()
{
    'use strict';

    var controllerId = 'albumDetails';

    angular.module('app')
        .controller(controllerId, ['$location', '$window', '$routeParams',
                                   'common', 'config', 'datacontext', 'model', albumDetails]);

    function albumDetails($location, $window, $routeParams, common, config,  datacontext, model)
    {
        var vm = this;       
        var logError = common.logger.getLogFn(controllerId, 'error');
        var logSuccess = common.logger.getLogFn(controllerId, 'success');
        
        // Bindable properties and functions are placed on vm.
        vm.id = $routeParams.id;
        vm.public = $routeParams.public;
        vm.title = 'Album : ';

        var chunkSize = 4;
        vm.mediaFiles = [];
        
        vm.albumUrl = undefined;
        vm.entity = undefined;        
        vm.activate = activate;
        vm.goBack = goBack;

        activate();

        function queryFailed(error) {
            logError(error);
            goBack();
        }
    
        function activate()
        {
            common.activateController([getEntity(true)], controllerId);
        }     

        function getEntity(forceRemote)
        {
            return datacontext.album.getById(vm.id, forceRemote, 'gallery')
                    .then(querySucceeded, queryFailed);

            function querySucceeded(data) {
                vm.entity = data.entity || data;

                if (vm.public && vm.entity.accessType != 'Public')
                    return queryFailed('Invalid Request');

                vm.albumUrl = vm.entity.gallery.relativeUrl + vm.entity.relativeUrl;
                
                if (vm.entity.albumType != 'System')
                    loadMediaFiles();
                else if(vm.entity.relativeUrl == 'Photos/')
                {
                    var select = 'resourcePersonId, name, organizationType, organizationType.name, organization, organization.name, photo';
                    var order = 'organizationType.name, organization.name, name';

                    return datacontext.resourcePerson.getAll(true, select, null, order).then(successResource, queryFailed);

                    function successResource(data)
                    {
                        var items = [];

                        for(var item of data)
                        {
                            var mediaFile = {
                                fileType: 'Image',
                                name: item.photo,
                                description: item.name + ' (' + item.organizationType.name + ' - ' + item.organization.name + ')'
                            };

                            items.push(mediaFile);
                        }

                        vm.mediaFiles = common.getChunks(items, chunkSize);
                    }
                }
                else if(vm.entity.relativeUrl == 'Logos/')
                {
                    var select = 'organizationId, name, organizationType, organizationType.name, logo';
                    var filter = breeze.Predicate.create('category', '!=', 'FourW').and('organizationId', '!=', 0);
                    var order = 'organizationType.name, name';

                    return datacontext.organization.getAll(true, select, filter, order).then(successDonor, queryFailed);

                    function successDonor(data)
                    {
                        var items = [];

                        for(var item of data)
                        {
                            var mediaFile = {
                                fileType: 'Image',
                                name: item.logo,
                                description: item.name + ' (' + item.organizationType.name + ')'
                            };

                            items.push(mediaFile);
                        }

                        vm.mediaFiles = common.getChunks(items, chunkSize);
                    }
                }
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

        function goBack() {
            $window.history.back();
        }
    }

})();
