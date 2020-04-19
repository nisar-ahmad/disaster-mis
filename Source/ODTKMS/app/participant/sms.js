/// <reference path="edit.js" />
(function()
{
    'use strict';

    var controllerId = 'participantSms';

    angular.module('app').controller(controllerId,
        ['$scope', '$location', '$filter', '$window', '$routeParams', 'common', 'config',
         'datacontext', 'model', 'notify', participantSms]);

    function participantSms($scope, $location, $filter, $window, $routeParams, common, config,
        datacontext, model, notify)
    {
        var vm = this;
        vm.title = 'SMS Participants';

        var logError = common.logger.getLogFn(controllerId, 'error');
        var logSuccess = common.logger.getLogFn(controllerId, 'success');

        // Bindable properties and functions are placed on vm.
        vm.send = send;      
        vm.goBack = goBack;
        vm.activate = activate;
        vm.trainingChanged = trainingChanged;

        vm.trainings = [];
        vm.training = undefined;

        vm.groups = config.participantGroups;
        vm.group = undefined;
       
        vm.userGroups = [];
        vm.userGroup = undefined;

        vm.message = undefined;
        vm.specific = undefined;

        vm.groupChanged = groupChanged;
        vm.userGroupChanged = userGroupChanged;        

        Object.defineProperty(vm, 'showTo', {
            get: function(){ return vm.group == 'Specific' || vm.group == 'Group';}
        });

        Object.defineProperty(vm, 'showUserGroup', {
            get: function(){ return vm.group == 'Group';}
        });

        activate();

        function groupChanged()
        {
            if(vm.group == 'Group')
                vm.specific = vm.userGroup.members;
            else
                vm.specific = null;
        }

        function userGroupChanged()
        {
            vm.specific = vm.userGroup.members;
        }


        function activate()
        {
            var filter = breeze.Predicate.create('trainingId', '!=', 0);
            var p0 = datacontext.training.getAll(true, null, filter);

            var select = 'groupId, groupType, name, members';
            var groupFilter = breeze.Predicate.create('groupType', '==', 'SMS');

            var p1 = datacontext.group.getAll(true, select, groupFilter);

            common.activateController([p0, p1], controllerId).then(init, queryFailed);
        }

        function queryFailed(error) {
            logError(error);
            goBack();
        }

        function init(results)
        {
            vm.trainings = results[0];
            vm.training = vm.trainings[0];
            
            vm.userGroups = results[1];
            vm.userGroup = vm.userGroups[0];

            vm.group = vm.groups[0];
        }

        function trainingChanged()
        {
            vm.group = vm.groups[0];
            vm.message = '';
            vm.specific = '';
            vm.sendDisabled = false;
        }

        function send()
        {
            if(!vm.message)
            {
                logError('Message must not be empty!');
                return;
            }

            if (vm.group == 'Specific' && !vm.specific)
            {
                logError('"To" field must not be empty!');
                return;
            }

            vm.sendDisabled = true;

            var message = {};
            message.type = 'Participant';
            message.id = vm.training.trainingId;
            message.group = vm.group;
            message.to = vm.specific;
            message.body = vm.message;
            
            notify.sms(message).then(function (data) { logSuccess('SMS Sent Successfully!') },
                function (error)
                {
                    logError(error);
                    vm.sendDisabled = false;
                });
        }        

        function goBack()
        {
            $window.history.back();
        }
    }

})();
