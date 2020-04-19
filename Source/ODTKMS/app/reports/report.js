(function () {
    'use strict';

    // Controller name is handy for logging
    var controllerId = 'report';

    // Define the controller on the module.
    // Inject the dependencies. 
    // Point to the controller definition function.
    angular.module('app').controller(controllerId,
        ['$scope', '$http', '$timeout', '$modal', '$routeParams', 'common', 'config', 'datacontext', 'uiGridConstants', report]);

    function report($scope, $http, $timeout, $modal, $routeParams, common, config, datacontext, uiGridConstants) {
        // Using 'Controller As' syntax, so we assign this to the vm variable (for viewmodel).
        var vm = this;
        var getLogFn = common.logger.getLogFn;
        var logSuccess = getLogFn(controllerId, 'success');
        var logError = getLogFn(controllerId, 'error');

        var keyCodes = config.keyCodes;

        vm.id = $routeParams.id;
        vm.isRefreshing = false;
        var baseUrl = 'api/Report/Report?id=';

        // Bindable properties and functions are placed on vm.
        vm.title = 'Report';
        vm.gridApi = undefined;
        vm.gridOptions = config.gridOptions;
        vm.gridOptions.enablePaging = false;

        vm.gridOptions.enableRowSelection = true;
        vm.gridOptions.enableRowHeaderSelection = true;
        vm.gridOptions.multiSelect = true;

        vm.gridOptions.showColumnFooter = true;
        vm.gridOptions.showGridFooter = true;
        vm.gridOptions.appScopeProvider = vm;

        vm.chart = {
            labels: [],
            series: [],
            data: []
        }

        vm.chartType = 0;

        var map = {
            "3": {
                title: 'Training Cost & Revenue',
                labels: ['Training'],
                series: ['Cost', 'Revenue']
            },
            "4": {
                title: 'Training Province–wise Disability Segregation',
                labels: ['Training', 'Province'],
                series: ['Participants', 'Special Ability']
            },
            "5": {
                title: 'Training Province–wise Gender Segregation',
                labels: ['Training', 'Province'],
                series: ['Participants', 'Male', 'Female']
            },
            "7": {
                title: 'Training Sector–wise Gender Segregation',
                labels: ['Training', 'Sector'],
                series: ['Participants', 'Male', 'Female', 'Special Ability']
            },
            "9": {
                title: 'Training Province–wise Sector',
                labels: ['Training', 'Province', 'Sector'],
                series: ['Participants']
            },
            "10": {
                title: 'Training Segregation by Departments',
                labels: ['Training', 'Sector', 'Department'],
                series: ['Participants', 'Male', 'Female', 'Special Ability']
            },
            "11": {
                title: 'Training Province–wise Sector segregation',
                labels: ['Training', 'Province', 'Sector'],
                series: ['Participants', 'Male', 'Female', 'Special Ability']
            },
            "13": {
                title: 'Training Costs',
                labels: ['Training'],
                series: ['Cost']
            },
            "14": {
                title: 'Training Revenue',
                labels: ['Training'],
                series: ['Revenue', 'Cost']
            },
            "15": {
                title: 'Training Attendance Report',
                labels: ['Training'],
                series: ['Participants']
            },
            "17": {
                title: 'Training Status Report',
                labels: ['Training'],
                series: ['Status']
            },
            "18": { title: 'Trainings conducted with Collaborating Agencies' },
            "19": {
                title: 'Public Report of Trainings by Year',
                labels: ['Year'],
                series: ['Participants', 'Trainings', 'Assessment', 'CBDRM', 'CBDRM', 'CCCM', 'Climate Change', 'Disaster Reporting/Media Management', 'DRM/DRR', 'Gender/Age & Disability', 'Hazard Mitigation', 'Disaster Reporting/Media Management', 'Health', 'Information Management', 'Planning', 'Reconstruction/Rehab', 'Recovery', 'Response', 'School Safety', 'Supply Chain & Warehouse Management', 'Other']
            },
            "192": {
                title: 'Training Level Public Report by Year',
                labels: ['Year'],
                series: ['Participants', 'Trainings', 'International', 'National', 'Province', 'Division', 'District', 'Other']
            },
            "193": {
                title: 'Training Type Public Report by Year',
                labels: ['Year'],
                series: ['Trainings', 'Participants', 'Practitioner', 'Training of Trainers', 'Other']
            },
            "194": {
                title: 'Province-wise Public Report By Year',
                labels: ['Year', 'Province'],
                series: ['Trainings', 'Participants']
            },
            "20": {
                title: 'Gender & Disability Report By Year',
                labels: ['Year'],
                series: ['Trainings', 'Special Ability', 'Male', 'Female']
            },
            "203": {
                title: 'Sector-wise Participant Report',
                labels: ['Year', 'Sector'],
                series: ['Participants']
            },
            "21": {
                title: 'Province Public Report By Year',
                labels: ['Year', 'Province'],
                series: ['Year', 'Participants']
            },
            "210": {
                title: 'Age Group Report By Year',
                labels: ['Year', 'Age Group'],
                series: ['Participants', 'Healthy', 'Disabled', 'Male', 'Female']
            },
            "22": {
                title: 'Participants and No. of Trainings By Province',
                labels: ['Province'],
                series: ['Participants', 'Trainings']
            },
            "23": {
                title: 'Male-Female By Govt Department',
                labels: ['Department'],
                series: ['Male', 'Female']
            },
            "24": {
                title: 'Participant Segregation'
            },
            "25": { title: 'Participants who did not attend' },
            "26": {
                title: 'Participant Trend Analysis: Cross Broader Training Area',
                labels: ['Broader Training Area'],
                series: ['Participants']
            },
            "27": {
                title: 'Participant Trend Analysis: Cross Geographical Location',
                labels: ['Geographical Location'],
                series: ['Participants']
            },
            "28": {
                title: 'Participant Trend Analysis: Cross Sector',
                labels: ['Sector'],
                series: ['Participants']
            },
            "29": {
                title: 'Participant Trend Analysis: Cross Government Department',
                labels: ['Sector', 'Department'],
                series: ['Participants']
            },
            "30": {
                title: 'Donors & Collaborating Agencies with Project Briefs'
            },
            "31": {
                title: 'Reconciliation of Fundings and Costs',
                labels: ['Project', 'Funding Type'],
                series: ['Total Funding', 'Training Cost', 'Activity Cost', 'Total Cost', 'Balance']
            },
            "32": { title: 'Resource Persons Amount Paid' },
            "33": { title: '4W Organizations Registered with NIDM' },
            "34": { title: '4W Training Activities' }
        }

        vm.selectedRows = null;
        vm.gridApi = null;
        vm.gridOptions.onRegisterApi = onRegisterApi;

        function onRegisterApi(gridApi) {
            vm.gridApi = gridApi;

            if (vm.gridApi.selection) {
                vm.gridApi.selection.on.rowSelectionChanged(null, function (row) {
                    //console.log('selection changed');
                    loadChart();
                });

                vm.gridApi.selection.on.rowSelectionChangedBatch(null, function (rows) {
                    //console.log('batch changed');
                    loadChart();
                });
            }
        }

        vm.refresh = refresh;
        onDestroy();
        refresh();

        function refresh() {
            common.activateController([getAll()], controllerId);
        }

        function loadChart(type) {

            if (!type)
                type = vm.chartType;

            var c = vm.chart;

            c.series = [];
            c.labels = [];
            c.data = [];

            var m = map[vm.id];

            vm.selectedRows = vm.gridApi.selection.getSelectedRows();
            vm.isChartVisible = m.series;

            //if(rows.length == 0)
            //    rows = vm.gridOptions.data;

            if (vm.isChartVisible && vm.selectedRows.length) {

                //if(type == 0)
                c.series = m.series;

                for(var row of vm.selectedRows)
                {
                    var label = '';

                    for (var i = 0; i < m.labels.length; i++) {
                        label += row[m.labels[i]];

                        if (i < m.labels.length - 1)
                            label += ' - '
                    }

                    if (label.length > 50)
                        label = label.substring(0, 50) + '...';

                    c.labels.push(label);
                }

                if (type == 1) {

                    for(var s of m.series)
                    {
                        for(var row of vm.selectedRows)
                            c.data.push(row[s]);
                    }

                    return;
                }

                for(var s of m.series)
                {
                    var series = [];

                    for(var row of vm.selectedRows)
                        series.push(row[s]);

                    c.data.push(series);
                }
            }
        }

        function getAll() {
            var url = baseUrl + vm.id;

            if (map[vm.id])
                vm.title = map[vm.id].title;

            return $http.get(url).then(function (result) {
                vm.gridOptions.columnDefs = [];
                vm.gridOptions.data = result.data;

                loadChart();

                return refreshGrid();

            }, function (err) { logError(err); });
        }

        function refreshGrid() {
            vm.isRefreshing = true;

            return $timeout(function () {
                vm.isRefreshing = false;
                logSuccess('Report Loaded');
            }, 0);
            //vm.gridApi.core.queueGridRefresh();
        }

        function onDestroy() {
            $scope.$on('$destroy', function () {
                vm.gridOptions.onRegisterApi = null;
            });
        }
    }
})();
