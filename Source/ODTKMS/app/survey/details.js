/// <reference path="edit.js" />
(function()
{
    'use strict';

    var controllerId = 'surveyDetail';

    angular.module('app').controller(controllerId,
        ['$http', '$window', '$routeParams', 'common', 'datacontext', 'model', surveyDetail]);

    function surveyDetail($http, $window, $routeParams, common, datacontext, model)
    {
        var entity = 'Survey';

        var vm = this;
        vm.title = entity + ' Summary Report';

        var logError = common.logger.getLogFn(controllerId, 'error');

        // Bindable properties and functions are placed on vm.
        vm.entity = undefined;
        vm.choiceMap = model.choiceMap;

        vm.id = $routeParams.id;
        vm.questions = [];

        vm.goBack = goBack;
        vm.activate = activate;
        vm.charts = [];

        vm.filterChanged = filterChanged;        

        vm.charts['province'] = { type: 0, labels: [], data: [], series: ['Provinces'] };
        vm.charts['gender'] = { type: 0, labels: [], data: [], series: ['Genders'] };
        vm.charts['sector'] = { type: 0, labels: [], data: [], series: ['Sectors'] };

        activate();

        function activate()
        {
            var p0 = datacontext.survey.getById(vm.id, true, '');
            var p1 = datacontext.province.getAll(true, 'provinceId, name');
            var p2 = datacontext.organizationType.getAll(true, 'organizationTypeId, name');

            common.activateController([p0, p1, p2], controllerId).then(init, queryFailed);
        }

        function queryFailed(error) {
            logError(error);
            goBack();
        }

        function init(results)
        {
            vm.genderTypes = datacontext.enum.types.genderTypes;

            vm.entity = results[0].entity || results[0];
            vm.provinces = results[1];
            vm.organizationTypes = results[2];

            filterChanged();
        }

        function filterChanged() {

            var provinceId = null;
            var organizationTypeId = null;

            if (vm.province)
                provinceId = vm.province.provinceId;

            if (vm.organizationType)
                organizationTypeId = vm.organizationType.organizationTypeId;

            var filter = '?genderType=' + vm.genderType + '&provinceId=' + provinceId + '&organizationTypeId=' + organizationTypeId;

            var p0 = $http.get('api/Report/Survey/' + vm.id + filter)

            common.$q.all([p0]).then(refresh, queryFailed);
        }

        function refresh(results) {
            vm.data = results[0].data;

            loadCharts();
        }

        function loadCharts() {

            initChart(vm.charts['province'], vm.data.Provinces);
            initChart(vm.charts['gender'], vm.data.Genders);
            initChart(vm.charts['sector'], vm.data.Sectors);

            for(var i = 0; i < vm.data.Questions.length; i++)
            {
                var q = vm.data.Questions[i];
                var labels = vm.choiceMap[q.Type];

                var chart = { labels: [labels[0], labels[1]],
                              data: [q.Choice1, q.Choice2]};

                if(q.Type != 'YesNo')
                {
                    chart.labels.push(labels[2]);
                    chart.labels.push(labels[3]);
                    chart.labels.push(labels[4]);

                    chart.data.push(q.Choice3);
                    chart.data.push(q.Choice4);
                    chart.data.push(q.Choice5);
                }

                vm.charts[i] = chart;
            }
        }

        function initChart(chart, data) {

            chart.labels = [];
            chart.data = [];

            for (var key in data) {
                chart.labels.push(key);
                chart.data.push(data[key]);
            }
        }

        function goBack()
        {
            $window.history.back();
        }
    }

})();
