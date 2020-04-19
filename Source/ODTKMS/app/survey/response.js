/// <reference path="edit.js" />
(function()
{
    'use strict';

    var controllerId = 'surveyResponse';

    angular.module('app').controller(controllerId,
        ['$scope', '$location', '$window', '$routeParams', 'common', 'config', 'datacontext', 'model', surveyResponse]);

    function surveyResponse($scope, $location, $window, $routeParams, common, config, datacontext, model)
    {
        var vm = this;
        vm.title = 'Survey Response';

        var logError = common.logger.getLogFn(controllerId, 'error');

        // Bindable properties and functions are placed on vm.
        vm.surveyId = $routeParams.surveyId;
        vm.respondentId = $routeParams.respondentId;

        if (vm.surveyId && vm.respondentId)
            vm.public = true;

        vm.goBack = goBack;

        vm.hasChanges = true;
        vm.isSaving = false;
        vm.save = save;

        vm.evaluations = [];
        vm.questions = [];

        vm.surveys = [];
        vm.respondents = [];

        vm.survey = null;
        vm.respondent = null;

        vm.surveyChanged = surveyChanged;
        vm.respondentChanged = respondentChanged;

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
                var surveyFilter = breeze.Predicate.create('surveyId', '==', vm.surveyId);
                var respondentFilter = breeze.Predicate.create('respondentId', '==', vm.respondentId);

                var p0 = datacontext.survey.getAll(true, 'surveyId, name, welcomeMessage', surveyFilter);
                var p1 = datacontext.respondent.getAll(true, 'respondentId, name, approvalStatus', respondentFilter);

                common.activateController([p0, p1], controllerId).then(initPublic, queryFailed);
            }
            else
            {
                var p0 = datacontext.survey.getAll(true, 'surveyId, name, welcomeMessage');
                common.activateController([p0], controllerId).then(initsurveys, queryFailed);
            }           
        }

        function next()
        {
            vm.respondent = vm.respondents[vm.index + 1];
            respondentChanged();
        }

        function prev()
        {
            vm.respondent = vm.respondents[vm.index - 1];
            respondentChanged();
        }

        function initPublic(results)
        {
            vm.surveys = results[0];
            vm.respondents = results[1];

            vm.survey = vm.surveys[0];
            vm.respondent = vm.respondents[0];

            if (!vm.survey || !vm.respondent)
                return goBack();

            var questionFilter = breeze.Predicate.create('surveyId', '==', vm.survey.surveyId);
            var p0 = datacontext.surveyQuestion.getAll(true, 'surveyId, questionId, question', questionFilter);

            common.activateController([p0], controllerId).then(initQuestions, queryFailed);
        }

        function initQuestions(results)
        {
            vm.questions = results[0];
            respondentChanged();
        }

        function initsurveys(results)
        {
            vm.surveys = results[0];
            vm.survey = vm.surveys[0];

            surveyChanged();
        }

        function surveyChanged()
        {
            vm.surveyId = vm.survey.surveyId;

            if (vm.surveyId)
            {
                var questionFilter = breeze.Predicate.create('surveyId', '==', vm.survey.surveyId);

                var p0 = common.$http.get('api/Report/Respondents/' + vm.survey.surveyId);
                var p1 = datacontext.surveyQuestion.getAll(true, 'surveyId, questionId, question', questionFilter);

                common.activateController([p0, p1], controllerId).then(initrespondents, queryFailed);
            }
        }

        function initrespondents(results)
        {            
            vm.respondents = results[0].data;
            vm.questions = results[1];
            vm.respondent = vm.respondents[0];

            respondentChanged();
        }

        function respondentChanged()
        {
            if (!vm.respondent)
                return;

            vm.index = vm.respondents.indexOf(vm.respondent);

            vm.respondentId = vm.respondent.respondentId;

            if (vm.respondentId)
            {
                var evaluationFilter = breeze.Predicate.create('surveyId', '==', vm.surveyId)
                                                          .and('respondentId', '==', vm.respondentId);

                var p0 = datacontext.surveyQuestionResponse.getAll(true, null, evaluationFilter);
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
                        surveyId: vm.surveyId,
                        respondentId: vm.respondentId,
                        questionId: q.questionId,
                        response: q.response,
                        reason: q.reason,
                        responseDate: responseDate
                    };

                    var newEntity = datacontext.surveyQuestionResponse.create(obj);
                    vm.evaluations.push(newEntity);
                }
                else if (exists)
                {
                    // update
                    var entity = original[0];

                    entity.response = q.response;
                    entity.reason = q.reason;
                    entity.responseDate = responseDate.valueOf();

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
