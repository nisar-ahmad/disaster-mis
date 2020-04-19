/// <reference path="edit.js" />
(function()
{
    'use strict';

    var controllerId = 'trainingActivityDetail';

    angular.module('app').controller(controllerId,
        ['$window', '$routeParams', 'common', 'config','datacontext', 'model', 'uiGmapIsReady', trainingActivityDetail]);

    function trainingActivityDetail($window, $routeParams, common, config, datacontext, model, uiGmapIsReady)
    {
        var entity = 'Training Activity';

        var vm = this;
        vm.title = entity + ' Details';

        var entityName = model.entityNames.trainingActivity;
        var logError = common.logger.getLogFn(controllerId, 'error');

        // Bindable properties and functions are placed on vm.
        vm.entity = undefined;
        vm.id = $routeParams.id;
        vm.public = $routeParams.public;
        vm.listOfParticipantsUrl = 'Files/Documents/DRM/Trainings/ParticipantLists/';
        vm.trainingAgendaUrl = 'Files/Documents/DRM/Trainings/Agendas/';
        vm.pictureUrl = 'Files/Galleries/DRM/Trainings/';

        vm.getFileIcon = common.getFileIcon;
        vm.goBack = goBack;

        var isReady = false;
        var marker = undefined;

        vm.activate = activate;

        //vm.gridOptions = config.gridOptions;

        //vm.gridOptions.columnDefs = [
        //    { field: 'name', name: 'Session Title' },
        //    { field: 'module' },
        //    { field: 'dateOfSession', cellFilter: 'date:\'dd MMM yyyy\'' },
        //    { field: 'startTime', cellFilter: 'date:\'h:mm a\'' },
        //    { field: 'endTime', cellFilter: 'date:\'h:mm a\'' },
        //    { field: 'agenda' }
        //];

        vm.map = {
            center: { latitude: 31, longitude: 71 },
            zoom: 5,
            markers: [{
                id: 0,
                latitude: 31,
                longitude: 71,
                options: {
                    //labelContent: 'Training Location',
                    //labelAnchor: "50 5"
                    //labelClass: "marker-labels"
                },
                control: {}
            }],
            control: {},
            events: {}
        };

        uiGmapIsReady.promise().then(function (maps)
        {
            isReady = true;
            placeMarker();
        });

        function placeMarker()
        {
            if (isReady && vm.entity && vm.entity.location)
            {
                var latlngStr = vm.entity.location.split(" ", 2);
                var lng = parseFloat(latlngStr[0]);
                var lat = parseFloat(latlngStr[1]);

                var latLng = new google.maps.LatLng(lat, lng);
                var gMap = vm.map.control.getGMap();

                if (!marker)
                {
                    marker = new google.maps.Marker({
                        position: latLng,
                        map: gMap,
                        title: 'Training Location'
                    });
                }

                marker.setPosition(latLng);
                gMap.panTo(latLng);
            }
        }

        activate();

        function activate()
        {
            common.activateController([getEntity(true)], controllerId);
        }

        function queryFailed(error) {
            logError(error);
            goBack();
        }

        function getEntity(forceRemote)
        {
            return datacontext.trainingActivity.getById(vm.id, forceRemote, 'organization, organization.organizationType, province, district, broaderTrainingArea')
                    .then(querySucceeded, queryFailed);

            function querySucceeded(data)
            {
                vm.entity = data.entity || data;
                placeMarker();
            }
        }

        function goBack()
        {
            $window.history.back();
        }
    }

})();
