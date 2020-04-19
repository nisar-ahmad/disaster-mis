/// <reference path="edit.js" />
(function()
{
    'use strict';

    var controllerId = 'organizationDetail';

    angular.module('app').controller(controllerId,
        ['$scope', '$location', '$http', '$window', '$routeParams', 'common', 'config',
         'datacontext', 'model', organizationDetail]);

    function organizationDetail($scope, $location, $http, $window, $routeParams, common, config,
        datacontext, model)
    {
        var vm = this;
     
        var entityName = model.entityNames.organization;
        var logError = common.logger.getLogFn(controllerId, 'error');

        // Bindable properties and functions are placed on vm.
        vm.entity = undefined;
        vm.id = $routeParams.id;
        vm.public = $routeParams.public;
        vm.category = $routeParams.category;

        var entity = vm.category === '4w' ? '4W Organization' : 'Donor / Collaborating Agency';
        vm.title = entity + ' Details';

        vm.headPhotoUrl = vm.category === '4w' ? 'Files/Galleries/4W/Heads/' : 'Files/Galleries/Donors/Heads/';
        vm.logoUrl = vm.category === '4w' ? 'Files/Galleries/4W/Logos/' : 'Files/Galleries/Donors/Logos/';
        vm.profileUrl = vm.category === '4w' ? 'Files/Documents/4W/Profiles/' : 'Files/Documents/Donors/Profiles/';
        vm.registrationCertificateUrl = 'Files/Documents/4W/RegistrationCertificates/';
       
        vm.getFileIcon = common.getFileIcon;
        vm.goBack = goBack;
        vm.activate = activate;

        vm.projects = [];

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
            datacontext.organization.getById(vm.id, forceRemote, 'organizationType')
                    .then(function (data)
                    {
                        vm.entity = data.entity || data;

                    }, queryFailed);

            var url = 'api/Report/Report?id=31&where=O.OrganizationId=' + vm.id;

            return $http.get(url).then(function (result)
            {
                vm.projects = result.data;

            }, logError);
        }

        function goBack()
        {
            $window.history.back();
        }
    }

})();
