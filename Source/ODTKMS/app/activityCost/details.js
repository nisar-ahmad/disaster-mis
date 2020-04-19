/// <reference path="edit.js" />
(function()
{
    'use strict';

    var controllerId = 'activityCostDetail';

    angular.module('app').controller(controllerId,
        ['$scope', '$location', '$filter', '$window', '$routeParams', 'common', 'config',
         'datacontext', 'model', 'helper', activityCostDetail]);

    function activityCostDetail($scope, $location, $filter, $window, $routeParams, common, config,
        datacontext, model, helper)
    {
        var entity = 'Activity Cost';

        var vm = this;
        vm.title = entity + ' Details';

        var entityName = model.entityNames.activityCost;
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
            return datacontext.activityCost.getById(vm.id, forceRemote, 'activity, funding, funding.project, funding.approvedActivity')
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
