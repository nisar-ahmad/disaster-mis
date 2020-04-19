(function()
{
    'use strict';

    // Controller name is handy for logging
    var controllerId = 'trainingSchedule';

    // Define the controller on the module.
    // Inject the dependencies. 
    // Point to the controller definition function.
    angular.module('app').controller(controllerId,
        ['$routeParams',  '$location', 'common', 'config', 'datacontext', 'uiGridGroupingConstants', trainingSchedule]);

    function trainingSchedule($routeParams, $location, common, config, datacontext, uiGridGroupingConstants)
    {
        // Using 'Controller As' syntax, so we assign this to the vm variable (for viewmodel).
        var vm = this;
        var getLogFn = common.logger.getLogFn;
        var log = getLogFn(controllerId);        
        var keyCodes = config.keyCodes;
        var logError = common.logger.getLogFn(controllerId, 'error');

        vm.public = $routeParams.public;

        // Bindable properties and functions are placed on vm.
        vm.title = 'Training Calendar';
        vm.trainings = {};
        vm.years = [];
        vm.year = null;

        vm.broaderTrainingAreas = ['-- All Areas --'];
        vm.broaderTrainingArea = null;

        var allTrainings = {};

        vm.refresh = refresh;
        vm.filterChanged = filterChanged;
        vm.click = click;

        activate();

        function activate()
        {
            var p0 = datacontext.broaderTrainingArea.getAll(true);
            common.activateController([p0], controllerId).then(init, logError);
        }

        function init(results)
        {
            for (var a of results[0])
              vm.broaderTrainingAreas.push(a.name);

            vm.broaderTrainingArea = vm.broaderTrainingAreas[0];

            return getAll(true);
        }

        function click(row)
        {
            var path = '/training/' + row.trainingId + '/details';

            if (vm.public)
                path += '/public';

            $location.path(path);
        }

        function filterChanged()
        {
            vm.trainings = {};
            var allAreas = (vm.broaderTrainingAreas.indexOf(vm.broaderTrainingArea) === 0);

            for (var key in allTrainings)
            {
                var monthTrainings = allTrainings[key];
                var year = moment(key, 'MMMM YYYY').year();

                if (!allAreas)
                    monthTrainings = $.grep(monthTrainings, function (t) { return t.broaderTrainingArea == vm.broaderTrainingArea; });
                
                if (vm.year == year)
                    vm.trainings[key] = monthTrainings;
            }

            var count = 1;

            for (var key in vm.trainings)
            {                
                for (var i = 0; i < vm.trainings[key].length; i++)
                    vm.trainings[key][i].index = count++;
            }
        }

        function getAll(forceRefresh) {

            var select = 'trainingId, name, trainingType, trainingLevel, broaderTrainingArea, broaderTrainingArea.name, '+
                         'startDate, endDate, city, city.name,  city.district, city.district.province, fee, status';

            var where = breeze.Predicate.create('trainingId', '!=', 0).and('status', '!=', 'Draft').and('status', '!=', 'Cancelled');
            var order = 'startDate';

            return datacontext.training.getAll(forceRefresh, select, where, order)
                .then(function (data)
                {
                    angular.forEach(data, function (row)
                    {
                        var startDate = moment(row.startDate);
                        var endDate = moment(row.endDate);

                        var startDay = startDate.date();
                        var endDay = endDate.date();

                        row.month = startDate.format('MMMM YYYY');
                        row.dates = (startDay == endDay ? startDay : startDay + ' - ' + endDay);

                        if (vm.years.indexOf(row.year) < 0)
                            vm.years.push(row.year);

                        switch (row.status)
                        {
                            case 'Postponed':
                                row.class = 'text-danger';
                                break;
                            case 'Completed':
                                row.class = 'text-primary';
                                break;
                            case 'Planned':
                            case 'Scheduled':
                                row.class = 'text-success';
                                break;
                            default:
                                row.class = '';
                        }

                        if (!allTrainings[row.month])
                            allTrainings[row.month] = [];

                        allTrainings[row.month].push(row);

                    });

                    vm.year = vm.years[vm.years.length-1]; // moment().get('year');
                    filterChanged();

                    return vm.trainings;
                }
            );
        }

        function refresh()
        {
            activate();
        }
    }
})();
