/// <reference path="edit.js" />
(function()
{
    'use strict';

    var controllerId = 'fundingDetail';

    angular.module('app').controller(controllerId,
        ['$scope', '$location', '$filter', '$window', '$routeParams', 'common', 'config',
         'datacontext', 'model', 'helper', fundingDetail]);

    function fundingDetail($scope, $location, $filter, $window, $routeParams, common, config,
        datacontext, model, helper)
    {
        var entity = 'Funding';

        var vm = this;
        vm.title = entity + ' Details';

        var entityName = model.entityNames.funding;
        var logError = common.logger.getLogFn(controllerId, 'error');

        // Bindable properties and functions are placed on vm.
        vm.entity = undefined;
        vm.id = $routeParams.id;
        vm.public = $routeParams.public;
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
            return datacontext.funding.getById(vm.id, forceRemote, 'project,approvedActivity')
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
