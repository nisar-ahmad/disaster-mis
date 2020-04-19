/// <reference path="edit.js" />
(function()
{
    'use strict';

    var controllerId = 'trainingCalendar';

    angular.module('app').controller(controllerId,
        ['$scope', '$location', '$routeParams', '$window', '$timeout', '$compile', 'common', 'config',
         'datacontext', 'model', trainingCalendar]);

    function trainingCalendar($scope, $location, $routeParams, $window, $timeout, $compile, common, config,
        datacontext, model)
    {
        var vm = this;
        vm.title = 'Trainings Calendar';
        var logError = common.logger.getLogFn(controllerId, 'error');
 
        vm.goBack = goBack;
        
        var trainings = [];
        vm.public = $routeParams.public;

        vm.eventSources = [
                {
                    events: []
                    //color: 'black',     // an option!
                    //textColor: 'yellow' // an option!
                }
        ]

        vm.activate = activate;
        vm.refresh = refresh;

        vm.uiConfig = {
            calendar: {
                firstDay: 1,
                height: 550,
                //selectable: true,
                //editable: true,
                header:{
                  left: 'month agendaWeek agendaDay',
                  center: 'title',
                  right: 'today prev,next'
                },
                //dayClick: vm.onClick,
                //select: onMouseOver,
                eventClick: eventClick,
                eventRender: eventRender
                //eventDrop: $scope.alertOnDrop,
                //eventResize: $scope.alertOnResize
              }
        };
        
        activate();

        function activate()
        {
            common.activateController([getAll(true)], controllerId);
        }

        function eventRender(event, element, view) {
            $timeout(function () {

                var startDate = event.start.format('DD MMM YYYY');
                var endDate = startDate;

                if (event.end)
                    endDate = event.end.format('DD MMM YYYY');

                var content = '\'<div class="form-group"><label> Title : </label>' + event.title + '</div>' +
                              '<div class="form-group"><label>City : </label>' + event.city + '</div>' +
                              '<div class="form-group"><label>Area : </label>' + event.area + '</div>' +
                              '<div class="form-group"><label>Level : </label>' + event.level + '</div>' +
                              '<div class="form-group"><label>Type : </label>' + event.type + '</div>' +
                              '<div class="form-group"><label>Start : </label>' + startDate + '</div>' +
                              '<div class="form-group"><label>End : </label>' + endDate + '</div>\'';

                $(element).attr('popover-title', 'Training Details')
                          .attr('popover-html', content)
                          .attr('popover-trigger', 'mouseenter')
                          .attr('popover-placement', 'right')
                          .attr('data-container', 'body');
                            
                $compile(element)($scope);
            });
        }

        function eventClick(event)
        {
            var path = '/training/' + event.id + '/details';

            if (vm.public)
                path += '/public';

            $location.path(path);
        }
       
       function getAll(forceRefresh) {

            var select = 'trainingId, name, trainingType, trainingLevel, broaderTrainingArea, startDate, endDate, city, city.name';
            var where = breeze.Predicate.create('trainingId', '!=', 0);

            return datacontext.training.getAll(forceRefresh, select, where).then(function (data) {
                    trainings = data;

                    vm.eventSources[0].events.length = 0

                    for(var t of trainings)
                    {
                        //var start = t.startDate;
                        //var end = start;

                        //if(t.endDate)
                        //    end = moment(t.endDate);

                        //var allDay = moment.duration(end.diff(start)).asHours() > 8;

                        var event = { id: t.trainingId, 
                                      title: t.name,
                                      start: t.startDate,
                                      end: t.endDate,
                                      allDay: true,
                                      city: t.city.name,
                                      area: t.broaderTrainingArea,
                                      level: t.trainingLevel,
                                      type: t.trainingType
                                     }

                        vm.eventSources[0].events.push(event);
                    }

                    return data;
                }
            );
        }

        function refresh()
        {
            activate();
        }

        function queryFailed(error) {
            logError(error);
            goToIndex();
        }

        function goBack()
        {
            $window.history.back();
        }

        function goToIndex()
        {
            $location.path('/trainings');
        }
    }

})();
