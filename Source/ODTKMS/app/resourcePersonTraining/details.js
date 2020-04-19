/// <reference path="edit.js" />
(function()
{
    'use strict';

    var controllerId = 'resourcePersonTrainingDetail';

    angular.module('app').controller(controllerId,
        ['$scope', '$location', '$filter', '$window', '$routeParams', 'common', 'config',
         'datacontext', 'model', 'helper', resourcePersonTrainingDetail]);

    function resourcePersonTrainingDetail($scope, $location, $filter, $window, $routeParams, common, config,
        datacontext, model, helper)
    {
        var entity = 'Resource Person Training';

        var vm = this;
        vm.title = entity + ' Details';

        var entityName = model.entityNames.resourcePersonTraining;
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
            getEntity(true);
        }

        function queryFailed(error) {
            logError(error);
            goBack();
        }

        function getEntity(forceRemote)
        {
            return datacontext.resourcePersonTraining.getById(vm.id, forceRemote, 'resourcePerson,trainingSession')
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
