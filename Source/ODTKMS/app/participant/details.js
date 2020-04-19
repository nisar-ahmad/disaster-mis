/// <reference path="edit.js" />
(function()
{
    'use strict';

    var controllerId = 'participantDetail';

    angular.module('app').controller(controllerId,
        ['$scope', '$location', '$filter', '$window', '$routeParams', 'common', 'config',
         'datacontext', 'model', 'helper', participantDetail]);

    function participantDetail($scope, $location, $filter, $window, $routeParams, common, config,
        datacontext, model, helper)
    {
        var entity = 'Participant';

        var vm = this;
        vm.title = entity + ' Details';

        var entityName = model.entityNames.participant;
        var logError = common.logger.getLogFn(controllerId, 'error');

        // Bindable properties and functions are placed on vm.
        vm.entity = undefined;
        vm.id = $routeParams.id;
        vm.public = $routeParams.public;
        vm.paymentProofDocumentUrl = 'Files/Documents/Participants/PaymentProofDocuments/';
        vm.getFileIcon = common.getFileIcon;
        vm.goBack = goBack;
        vm.activate = activate;

        vm.disabilityTypes = [];
        vm.disabilityTypesSelected = [];

        activate();

        function activate()
        {
            var p0 = datacontext.disabilityType.getAll(true);
            var p1 = datacontext.area.getAll(true);

            common.activateController([p0, p1, getEntity(true)], controllerId).then(init, queryFailed);
        }

        function queryFailed(error) {
            logError(error);
            goBack();
        }

        function init(results)
        {
            vm.disabilityTypes = results[0];
        }

        function getEntity(forceRemote)
        {
            return datacontext.participant.getById(vm.id, forceRemote, 'training,organizationType,organization,academicQualification,district,district.province')
                    .then(querySucceeded, queryFailed);

            function querySucceeded(data)
            {
                vm.entity = data.entity || data;

                vm.entity.entityAspect.loadNavigationProperty("participantDisabilityTypes")
                        .then(successDisability, queryFailed);

                function successDisability(data)
                {
                    var items = data.results || data;

                    for (var a of items)
                        vm.disabilityTypesSelected.push(a.disabilityTypeId);

                }

            }
        }

        function goBack()
        {
            $window.history.back();
        }
    }

})();
