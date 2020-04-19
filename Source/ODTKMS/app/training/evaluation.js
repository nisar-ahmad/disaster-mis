/// <reference path="edit.js" />
(function()
{
    'use strict';

    var controllerId = 'trainingEvaluation';

    angular.module('app').controller(controllerId,
        ['$scope', '$location', '$window', '$routeParams', 'common', 'config', 'datacontext', 'model', trainingEvaluation]);

    function trainingEvaluation($scope, $location, $window, $routeParams, common, config, datacontext, model)
    {
        var vm = this;
        vm.title = 'Training Evaluation';

        var logError = common.logger.getLogFn(controllerId, 'error');

        // Bindable properties and functions are placed on vm.
        vm.trainingId = $routeParams.trainingId;
        vm.participantId = $routeParams.participantId;

        if (vm.trainingId && vm.participantId)
            vm.public = true;

        vm.goBack = goBack;

        vm.hasChanges = true;
        vm.isSaving = false;
        vm.save = save;

        vm.evaluations = [];
        vm.questions = [];

        vm.trainings = [];
        vm.participants = [];

        vm.training = null;
        vm.participant = null;

        vm.trainingChanged = trainingChanged;
        vm.participantChanged = participantChanged;

        vm.next = next;
        vm.prev = prev;

        vm.activate = activate;

        vm.index = 0;
 
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
            
            if (vm.public)
            {
                var trainingFilter = breeze.Predicate.create('trainingId', '==', vm.trainingId);
                var participantFilter = breeze.Predicate.create('participantId', '==', vm.participantId)
                                                                .and('trainingId', '==', vm.trainingId);

                var p0 = datacontext.training.getAll(true, 'trainingId, surveyId, name', trainingFilter);
                var p1 = datacontext.participant.getAll(true, 'participantId, name, trainingId, approvalStatus', participantFilter);

                common.activateController([p0, p1], controllerId).then(initPublic, queryFailed);
            }
            else
            {
                var p0 = datacontext.training.getAll(true, 'trainingId, surveyId, name');
                common.activateController([p0], controllerId).then(initTrainings, queryFailed);
            }           
        }

        function next()
        {
            vm.participant = vm.participants[vm.index + 1];
            participantChanged();
        }

        function prev()
        {
            vm.participant = vm.participants[vm.index - 1];
            participantChanged();
        }

        function initPublic(results)
        {
            vm.trainings = results[0];
            vm.participants = results[1];

            vm.training = vm.trainings[0];
            vm.participant = vm.participants[0];

            if (!vm.training || !vm.participant)
                return goBack();

            var questionFilter = breeze.Predicate.create('surveyId', '==', vm.training.surveyId);
            var p0 = datacontext.surveyQuestion.getAll(true, 'surveyId, questionId, question', questionFilter);

            common.activateController([p0], controllerId).then(initQuestions, queryFailed);
        }

        function initQuestions(results)
        {
            vm.questions = results[0];
            participantChanged();
        }

        function initTrainings(results)
        {
            vm.trainings = results[0];
            vm.training = vm.trainings[0];

            trainingChanged();
        }

        function trainingChanged()
        {
            vm.trainingId = vm.training.trainingId;

            if (vm.trainingId)
            {
                var participantFilter = breeze.Predicate.create('trainingId', '==', vm.trainingId)
                                                           .and('approvalStatus', '==', 'Accepted');

                var questionFilter = breeze.Predicate.create('surveyId', '==', vm.training.surveyId);

                var p0 = datacontext.participant.getAll(true, 'participantId, name, trainingId, approvalStatus', participantFilter);
                var p1 = datacontext.surveyQuestion.getAll(true, 'surveyId, questionId, question', questionFilter);

                common.activateController([p0, p1], controllerId).then(initParticipants, queryFailed);
            }
        }

        function initParticipants(results)
        {            
            vm.participants = results[0];       
            vm.questions = results[1];
            vm.participant = vm.participants[0];

            participantChanged();
        }

        function participantChanged()
        {
            if (vm.participants.length == 0)
                return;

            vm.index = vm.participants.indexOf(vm.participant);

            vm.participantId = vm.participant.participantId;

            if (vm.participantId)
            {
                var evaluationFilter = breeze.Predicate.create('trainingId', '==', vm.trainingId)
                                                          .and('participantId', '==', vm.participantId);

                var p0 = datacontext.trainingEvaluation.getAll(true, null, evaluationFilter);
                common.activateController([p0], controllerId).then(init, queryFailed);
            }
        }

        function init(results)
        {
            vm.evaluations = results[0];

            for(var sq of vm.questions)
            {
                var q = sq.question;
                var evaluation = $.grep(vm.evaluations, function (e) { return e.questionId == q.questionId; })[0];

                if (!evaluation)
                {
                    q.response = q.reason = null;                     

                    if (q.isScaleType)
                        q.response = '2';
                    else if (q.type == 'YesNo')
                        q.response = '0';
                }
                else
                {
                    q.response = evaluation.response;

                    if (q.response && q.response.indexOf('|') >= 0)
                        q.responseArray = q.response.split('|');

                    q.reason = evaluation.reason;
                }
            }
        }

        function queryFailed(error) {
            logError(error);
            goBack();
        }

        function goBack()
        {
            $window.history.back();
        }

        function validate()
        {
            for (var sq of vm.questions)
            {
                var q = sq.question;

                if (q.isScaleType && q.askReason && !q.reason)
                    return false;

                if (q.type == 'Text' && !q.reason)
                    return false;

                if (q.responseArray.length)
                    q.response = q.responseArray.join('|');

                if (!q.type =='Text' && !q.response)
                    return false;
            }

            return true;
        }

        function save()
        {
            var isValid = validate();

            if(!isValid)
                logError('Please respond to all questions and mention reasons where asked.');

            if (!canSave() || !isValid)
            {
                return common.$q.when(null);

            } // Must return a promise

            vm.isSaving = true;

            for (var sq of vm.questions)
            {
                var q = sq.question;

                var original = $.grep(vm.evaluations, function (e) { return e.questionId == q.questionId; });
                var exists = original.length;

                var responseDate = moment();

                if (!exists)
                {                    
                    // add
                    var obj = {
                        trainingId: vm.trainingId,
                        participantId: vm.participantId,
                        questionId: q.questionId,
                        surveyId: sq.surveyId,
                        response: q.response,
                        reason: q.reason,
                        responseDate: responseDate
                    };

                    var newEntity = datacontext.trainingEvaluation.create(obj);
                    vm.evaluations.push(newEntity);
                }
                else if (exists)
                {
                    // update
                    var entity = original[0];

                    entity.response = q.response;
                    entity.reason = q.reason;
                    entity.responseDate = responseDate.valueOf();

                    //entity.entityAspect.setModified();
                }                             
            }

            return datacontext.save()
                .then(function (saveResult)
                {
                    // Save success
                    vm.isSaving = false;

                    if (vm.public)
                    {
                        //common.setData('thanksMessage', 'Thank You for providing your valuable feedback!');
                        //common.setData('thanksUrl', '/');
                        $location.path('/thanks');
                    }
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
    }

})();
