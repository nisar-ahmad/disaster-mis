/// <reference path="edit.js" />
(function()
{
    'use strict';

    var controllerId = 'trainingCostDetail';

    angular.module('app').controller(controllerId,
        ['$http', '$window', '$routeParams', 'common', 'config', 'datacontext', 'model', trainingCostDetail]);

    function trainingCostDetail($http, $window, $routeParams, common, config, datacontext, model)
    {
        var vm = this;
        vm.title = 'Training Costs';

        var logError = common.logger.getLogFn(controllerId, 'error');

        // Bindable properties and functions are placed on vm.
        vm.id = $routeParams.id;

        vm.goBack = goBack;
        vm.activate = activate;

        vm.training = undefined;
        vm.totalParticipants = 100;
        vm.trainingCosts = [];       

        Object.defineProperty(vm, 'totalCost', {
            get: function()
            {
                var totalCost = 0;

                for(var c of vm.trainingCosts)
                    totalCost += c.cost ? parseInt(c.cost) : 0;

                return totalCost;

            }
        });

        Object.defineProperty(vm, 'costPerParticipant', {
            get: function() {  return vm.totalParticipants ? vm.totalCost / vm.totalParticipants : 0; }
        });

        activate();

        function activate()
        {
            var url = 'api/Report/ParticipantsAttended/' + vm.id;
            var select = 'trainingId, name, startDate, endDate';
            var filter = breeze.Predicate.create('trainingId', '==', vm.id);

            var p0 = datacontext.trainingCost.getAll(true, null, filter);
            var p1 = datacontext.training.getAll(true, select, filter);         
            var p2 = $http.get(url);


            common.activateController([p0, p1, p2], controllerId).then(init, queryFailed);
        }

        function queryFailed(error) {
            logError(error);
            goBack();
        }

        function init(results)
        {
            vm.trainingCosts = results[0];
            vm.training = results[1][0];
            vm.totalParticipants = results[2].data;
        }

        function goBack()
        {
            $window.history.back();
        }
    }

})();
