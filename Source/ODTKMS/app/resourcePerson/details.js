/// <reference path="edit.js" />
(function()
{
    'use strict';

    var controllerId = 'resourcePersonDetail';

    angular.module('app').controller(controllerId,
        ['$window', '$routeParams', 'uiGridConstants', 'common', 'config', 'datacontext', 'model', resourcePersonDetail]);

    function resourcePersonDetail($window, $routeParams, uiGridConstants, common, config, datacontext, model)
    {
        var entity = 'Resource Person';

        var vm = this;
        vm.title = entity + ' Details';

        var entityName = model.entityNames.resourcePerson;
        var logError = common.logger.getLogFn(controllerId, 'error');

        // Bindable properties and functions are placed on vm.
        vm.entity = undefined;
        vm.id = $routeParams.id;
        vm.public = $routeParams.public;

        vm.photoUrl = 'Files/Galleries/ResourcePersons/Photos/';
        vm.resumeUrl = 'Files/Documents/ResourcePersons/Resumes/';

        vm.getFileIcon = common.getFileIcon;
        vm.goBack = goBack;
        vm.activate = activate;

        vm.disabilityTypes = [];
        vm.disabilityTypesSelected = [];

        vm.areas = [];
        vm.areasSelected = [];

        vm.gridOptions = config.gridOptions;
        vm.gridOptions.showColumnFooter = true;

        vm.gridOptions.columnDefs = [
            { field: ' ', width: 20, cellTemplate: '<div class="ui-grid-cell-contents">{{rowRenderIndex+1}}</div>', enableFiltering: false, enableSorting: false },
            { field: 'trainingSession.training.name', name: 'Training', width: 150 },
            { field: 'trainingSession.name', name: 'Session', footerCellFilter: 'number', aggregationType: uiGridConstants.aggregationTypes.count },
            { field: 'trainingSession.dateOfSession', name: 'Date', cellFilter: "date:'dd MMM yyyy'", filters: common.getBetweenFilter() },
            { field: 'trainingSession.startTime', name: 'Start Time', cellFilter: "date:'h:mm a'" },
            { field: 'trainingSession.endTime', name: 'End Time', cellFilter: "date:'h:mm a'" },
            { field: 'isPaid', name: 'Paid?', cellFilter: 'yesNo', filter: config.filters['yesNo'], width:55 },
            { field: 'amountPaid', width:100, filters: common.getBetweenFilter(), cellFilter: 'number', footerCellFilter: 'number', aggregationType: uiGridConstants.aggregationTypes.sum }
        ];

        activate();

        function activate()
        {
            var p0 = datacontext.disabilityType.getAll(true);
            var p1 = datacontext.area.getAll(true);

            common.activateController([p0, p1, getEntity(true)], controllerId).then(init, queryFailed);
        }

        function queryFailed(error) {
            logError(error);
            goBack();
        }

        function init(results)
        {
            vm.disabilityTypes = results[0];
            vm.areas = results[1];
        }

        function getEntity(forceRemote)
        {
            return datacontext.resourcePerson.getById(vm.id, forceRemote,
                    'organizationType, organization, district, district.province')
                    .then(querySucceeded, queryFailed);

            function querySucceeded(data)
            {
                vm.entity = data.entity || data;

                vm.entity.entityAspect.loadNavigationProperty("resourcePersonDisabilityTypes")
                         .then(function (data)
                         {
                             var items = data.results || data;

                             for (var a of items)
                                 vm.disabilityTypesSelected.push(a.disabilityTypeId);

                         }, queryFailed);                

                vm.entity.entityAspect.loadNavigationProperty("resourcePersonAreas")
                    .then(function (data)
                    {
                        var items = data.results || data;

                        for (var a of items)
                            vm.areasSelected.push(a.areaId);

                    }, queryFailed);

                var select = 'resourcePersonId, trainingSession, trainingSession.name, trainingSession.dateOfSession, ' +
                             'trainingSession.startTime, trainingSession.endTime, ' +
                             'isPaid, amountPaid, trainingSession.training, trainingSession.training.name';

                var filter = breeze.Predicate.create('resourcePersonId', '==', vm.id);

                datacontext.resourcePersonTraining.getAll(true, select, filter)
                            .then(function (data)
                            {
                                vm.gridOptions.data = data;
                                return data;

                            }, queryFailed);
            }
        }

        function goBack()
        {
            $window.history.back();
        }
    }

})();
