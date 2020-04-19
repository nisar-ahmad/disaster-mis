/// <reference path="edit.js" />
(function()
{
    'use strict';

    var controllerId = 'drmLogin';

    angular.module('app').controller(controllerId,
        ['$scope', '$location', '$routeParams', '$http', 'common', 'datacontext', drmLogin]);

    function drmLogin($scope, $location, $routeParams, $http, common, datacontext)
    {
        var vm = this;
        vm.title = 'Submit Your Training Activity';

        var logError = common.logger.getLogFn(controllerId, 'error');
        var logSuccess = common.logger.getLogFn(controllerId, 'success');

        // Bindable properties and functions are placed on vm.
        vm.userName = undefined;
        vm.password = $routeParams.id;

        vm.login = login;

        activate();

        function activate()
        {
            common.activateController([], controllerId);
        }

        function login()
        {
            if (!vm.userName || !vm.password)
            {
                logError('Invalid User name or password');
                return;
            }

            var body = { Email: vm.userName, Password: vm.password };

            $http.post('api/Report/Login4W', JSON.stringify(body), {
                transformRequest: angular.identity,
                headers: { 'Content-Type': 'application/json' }
            }).then(success, failed);

            function success(result) {
                var orgId = result.data;
                common.setData('4wOrgId', orgId);
                $location.path('/4wTrainings/' + orgId + '/public');
            }

            function failed() {
                logError('Invalid username or password');
            }
            //var where = breeze.Predicate.create('username', '==', vm.userName).and('passwordHash', '==', vm.password);

            //datacontext.organization.getAll(true, null, where).then(function (data)
            //{
            //    $location.path('/4wTrainings/1');
            //});
        }
    }
})();
