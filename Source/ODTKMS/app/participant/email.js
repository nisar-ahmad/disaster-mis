/// <reference path="edit.js" />
(function()
{
    'use strict';

    var controllerId = 'participantEmail';

    angular.module('app').controller(controllerId,
        ['$scope', '$location', '$filter', '$window', '$routeParams', 'common', 'config',
         'datacontext', 'model', 'notify', participantEmail]);

    function participantEmail($scope, $location, $filter, $window, $routeParams, common, config,
        datacontext, model, notify)
    {
        var vm = this;
        vm.title = 'Email Participants';

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

        vm.subject = undefined;
        vm.message = undefined;
        vm.specific = undefined;

        vm.groupChanged = groupChanged;
        vm.userGroupChanged = userGroupChanged;

        activate();
        
        Object.defineProperty(vm, 'showTo', {
            get: function(){ return vm.group == 'Specific' || vm.group == 'Group';}
        });

        Object.defineProperty(vm, 'showUserGroup', {
            get: function(){ return vm.group == 'Group';}
        });

        function activate()
        {
            var filter = breeze.Predicate.create('trainingId', '!=', 0);
            var p0 = datacontext.training.getAll(true, null, filter);

            var select = 'groupId, groupType, name, members';
            var groupFilter = breeze.Predicate.create('groupType', '==', 'Email');

            var p1 = datacontext.group.getAll(true, select, groupFilter);

            common.activateController([p0, p1], controllerId).then(init, queryFailed);
        }

        function queryFailed(error) {
            logError(error);
        }

        function trainingChanged() {
            updateMessage();
            vm.sendDisabled = false;
        }

        function updateMessage() {

            vm.subject = 'Re: ' + vm.training.name;
            vm.message = '<br />Dear Participant,<br /><br />';

            if (vm.group == 'Evaluation')
                vm.message += "Thank you for participating in training (" + vm.training.name + "). Please take a moment to evaluate your experience " + 
                              "by clicking on the following link:<br /><a href='[evaluation-link]'>[evaluation-link]</a><br /><br />";

            vm.message += "<strong>Training Details:</strong> <br /> <a href='[training-link]'>[training-link]</a><br /><br />Regards,<br />NIDM Admin";
        }

        function groupChanged()
        {
            if(vm.group == 'Group')
                vm.specific = vm.userGroup.members;
            else
                vm.specific = null;

            updateMessage();
        }

        function userGroupChanged()
        {
            vm.specific = vm.userGroup.members;
        }

        function init(results)
        {
            vm.trainings = results[0];
            vm.userGroups = results[1];

            vm.userGroup = vm.userGroups[0];
            vm.training = vm.trainings[0];
            vm.group = vm.groups[0];

            trainingChanged();
        }

        function send()
        {
            vm.sendDisabled = true;

            if(!vm.subject || !vm.message)
            {
                logError('Subject and Message must not be empty!');
                return;
            }

            if (vm.group == 'Specific' && !vm.specific)
            {
                logError('"To" field must not be empty!');
                return;
            }

            var message = {};
            message.type = 'Participant';
            message.id = vm.training.trainingId;
            message.group = vm.group;
            message.to = vm.specific;
            message.subject = vm.subject;
            message.body = vm.message;
            
            notify.email(message).then(
                function (data) { logSuccess('Emails Sent Successfully!'); vm.sendDisabled = false; }, queryFailed);
        }

        function goBack()
        {
            $window.history.back();
        }
    }

})();
