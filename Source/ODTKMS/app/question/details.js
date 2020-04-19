﻿/// <reference path="edit.js" />
(function()
{
    'use strict';

    var controllerId = 'questionDetail';

    angular.module('app').controller(controllerId,
        ['$window', '$routeParams', 'common', 'datacontext', questionDetail]);

    function questionDetail($window, $routeParams, common, datacontext)
    {
        var entity = 'Question';

        var vm = this;
        vm.title = entity + ' Details';

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
            return datacontext.question.getById(vm.id, forceRemote)
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
