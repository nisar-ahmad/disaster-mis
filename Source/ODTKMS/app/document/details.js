/// <reference path="edit.js" />
/// <reference path="details.js" />
(function()
{
    'use strict';

    var controllerId = 'documentDetail';

    angular.module('app').controller(controllerId,
        ['$window', '$routeParams', 'common', 'config', 'datacontext', 'model', documentDetail]);

    function documentDetail($window, $routeParams, common, config, datacontext, model)
    {
        var entity = 'Document';

        var vm = this;
        vm.title = entity + ' Details';

        var entityName = model.entityNames.document;
        var logError = common.logger.getLogFn(controllerId, 'error');

        // Bindable properties and functions are placed on vm.
        vm.entity = undefined;
        vm.id = $routeParams.id;
        vm.public = $routeParams.public;
        vm.fileNameUrl = 'Files/Documents/Library/';
        vm.getFileIcon = common.getFileIcon;
        vm.goBack = goBack;
        vm.activate = activate;

        activate();

        function activate()
        {
            common.activateController([getEntity(true)], controllerId);
        }

        function queryFailed(error) {
            logError(error);
            goBack();
        }

        function getEntity(forceRemote)
        {
            return datacontext.document.getById(vm.id, forceRemote, 'documentCategory1,documentCategory2,documentCategory3,thematicArea,training')
                    .then(querySucceeded, queryFailed);

            function querySucceeded(data)
            {
                vm.entity = data.entity || data;
            }
        }

        function goBack()
        {
            $window.history.back();
        }
    }

})();
