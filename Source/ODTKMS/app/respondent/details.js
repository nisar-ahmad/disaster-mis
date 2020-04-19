/// <reference path="edit.js" />
(function()
{
    'use strict';

    var controllerId = 'respondentDetail';

    angular.module('app').controller(controllerId,
        ['$window', '$routeParams', 'common', 'datacontext', respondentDetail]);

    function respondentDetail($window, $routeParams, common, datacontext)
    {
        var entity = 'Respondent';

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
            return datacontext.respondent.getById(vm.id, forceRemote, 'organizationType,organization,academicQualification,district,district.province')
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
