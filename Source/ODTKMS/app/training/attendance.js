/// <reference path="edit.js" />
(function()
{
    'use strict';

    var controllerId = 'trainingAttendance';

    angular.module('app').controller(controllerId,
        ['$scope', '$location', '$window', '$routeParams', 'common', 'config', 'datacontext', 'model', trainingAttendance]);

    function trainingAttendance($scope, $location, $window, $routeParams, common, config, datacontext, model)
    {
        var vm = this;
        vm.title = 'Training Attendance';

        var logError = common.logger.getLogFn(controllerId, 'error');

        // Bindable properties and functions are placed on vm.
        vm.id = $routeParams.id;

        vm.goBack = goBack;
        vm.cancel = cancel;

        vm.hasChanges = true;
        vm.isSaving = false;
        vm.save = save;

        vm.items = [];
        vm.trainings = [];
        vm.sessions = [];
        vm.participants = [];

        vm.training = null;
        vm.trainingChanged = trainingChanged;
        vm.selectAll = selectAll;
        vm.activate = activate;
 
        // vm.canSave Property
        Object.defineProperty(vm, 'canSave', {
            get: canSave
        });

        function canSave()
        {
            return vm.hasChanges && !vm.isSaving;
        }
        
        activate();

        function activate()
        {
            onDestroy();
            //onHasChanges();

            var p0 = datacontext.training.getAll(true, 'trainingId, name');
            common.activateController([p0], controllerId).then(initTrainings, queryFailed);
        }

        function selectAll(index, selected)
        {
            for(var i of vm.items)
                i.sessions[index] = selected;
        }

        function initTrainings(results)
        {
            vm.trainings = results[0];
            vm.training = vm.trainings[0];

            trainingChanged();
        }

        function trainingChanged()
        {
            vm.id = vm.training.trainingId;

            if (vm.id)
            {
                var sessionFilter = breeze.Predicate.create('trainingId', '==', vm.id);
                var participantFilter = sessionFilter.and('approvalStatus', '==', 'Accepted');
                var attendanceFilter = breeze.Predicate.create('trainingSession.trainingId', '==', vm.id);

                var p0 = datacontext.trainingSession.getAll(true, 'trainingSessionId, trainingId, name', sessionFilter);
                var p1 = datacontext.participant.getAll(true, 'participantId, trainingId, name, approvalStatus', participantFilter);
                var p2 = datacontext.trainingSessionParticipant.getAll(true, null, attendanceFilter);

                common.activateController([p0, p1, p2], controllerId).then(init, queryFailed);
            }
        }

        function init(results)
        {
            vm.sessions = results[0];
            vm.participants = results[1];
            vm.sessionParticipants = results[2];

            for (var s of vm.sessions)
                s.selected = true;

            vm.items = [];

            for(var p of vm.participants)
            {
                var item = { participantId: p.participantId, name: p.name, sessions: [] };

                for (var s of vm.sessions)
                {
                    var attended = ($.grep(vm.sessionParticipants, function (o) { return o.participantId == p.participantId && o.trainingSessionId == s.trainingSessionId; }).length > 0);
                    item.sessions.push(attended);
                    s.selected &= attended;
                }

                vm.items.push(item);
            }
        }

        function queryFailed(error) {
            logError(error);
            goToIndex();
        }

        function goBack()
        {
            $window.history.back();
        }

        function cancel()
        {
            trainingChanged();
            //datacontext.cancel();
            //vm.hasChanges = false;
        }

        function goToIndex()
        {
            $location.path('/trainings');
        }

        function save()
        {
            if (!canSave())
            {
                return common.$q.when(null);

            } // Must return a promise

            vm.isSaving = true;

            for (var i of vm.items)
            {
                var participantId = i.participantId;

                for (var s = 0; s < vm.sessions.length; s++)
                {
                    var trainingSessionId = vm.sessions[s].trainingSessionId;

                    var selected = i.sessions[s];
                    var original = $.grep(vm.sessionParticipants, function (e) { return e.participantId == participantId && e.trainingSessionId == trainingSessionId; });
                    var exists = original.length;

                    if (selected && !exists)
                    {
                        // add
                        //var participant = $.grep(vm.participants, function (e) { return e.participantId == participantId; })[0];

                        //alert(participant.participantId + ' ' + vm.sessions[s].trainingSessionId);

                        var obj = { trainingSessionId: trainingSessionId, participantId: participantId };
                        var newEntity = datacontext.trainingSessionParticipant.create(obj);

                        vm.sessionParticipants.push(newEntity);
                    }
                    else if (!selected && exists)
                    {
                        // remove
                        var entityAspect = original[0].entityAspect;

                        if (!entityAspect.entityState.isDetached())
                            entityAspect.setDeleted();

                        vm.sessionParticipants = vm.sessionParticipants.filter(function (e) { return !(e.participantId == participantId && e.trainingSessionId == trainingSessionId); });
                    }
                }
            }

            return datacontext.save()
                .then(function (saveResult)
                {
                    // Save success
                    vm.isSaving = false;
                },
                function (error)
                {
                    // Save error
                    vm.isSaving = false;
                });
        }

        function onDestroy()
        {
            $scope.$on('$destroy', function()
            {
                datacontext.cancel();
            });
        }

        //function onHasChanges()
        //{
        //    $scope.$on(config.events.hasChangesChanged,
        //        function(event, data)
        //        {
        //            vm.hasChanges = data.hasChanges;
        //        });
        //}
    }

})();
