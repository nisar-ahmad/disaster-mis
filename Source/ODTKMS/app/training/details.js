/// <reference path="edit.js" />
(function()
{
    'use strict';

    var controllerId = 'trainingDetail';

    angular.module('app').controller(controllerId,
        ['$location', '$window', '$routeParams', 'common', 'config', 'datacontext', 'model', 'uiGmapIsReady', trainingDetail]);

    function trainingDetail($location, $window, $routeParams, common, config, datacontext, model, uiGmapIsReady)
    {
        var entity = 'Training';

        var vm = this;
        vm.title = entity + ' Details';

        var entityName = model.entityNames.training;
        var logError = common.logger.getLogFn(controllerId, 'error');

        // Bindable properties and functions are placed on vm.
        vm.entity = undefined;
        vm.id = $routeParams.id;
        vm.public = $routeParams.public;
        vm.sessions = [];

        vm.goBack = goBack;
        vm.register = register;
        vm.allowRegister = allowRegister;

        var isReady = false;
        var marker = undefined;

        vm.activate = activate;

        vm.gridOptions = config.gridOptions;
        var allOrganizations = [];
        vm.organizations = [];

        vm.gridOptions.columnDefs = [
            { field: 'name', name: 'Session Title' },
            { field: 'module' },
            { field: 'dateOfSession', cellFilter: 'date:\'dd MMM yyyy\'' },
            { field: 'startTime', cellFilter: 'date:\'h:mm a\'' },
            { field: 'endTime', cellFilter: 'date:\'h:mm a\'' },
            { field: 'agenda' }
        ];

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
            events: { }
        };

        uiGmapIsReady.promise().then(function (maps)
        {
            isReady = true;
            placeMarker();
        });

        activate();

        function allowRegister() { return vm.entity && (vm.entity.status == 'Planned' || vm.entity.status == 'Scheduled'); }

        function register()
        {
            common.setData('trainingId', vm.id);
            $location.path('/participant/new/public');
        }

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

        function activate()
        {
            var filter = breeze.Predicate.create('category', '==', 'Default').and('organizationId', '!=', 0);
            var select = 'organizationId, name, organizationType, organizationType.name, headName, relationshipType, category, logo';

            var p0 = datacontext.organization.getAll(true, select, filter);
            common.activateController([p0], controllerId).then(init, queryFailed);
        }

        function init(results)
        {
            allOrganizations = results[0];
            getEntity(true);
        }

        function queryFailed(error) {
            logError(error);
            goBack();
        }

        function getEntity(forceRemote)
        {
            return datacontext.training.getById(vm.id, forceRemote, 'province,district,city,broaderTrainingArea')
                    .then(querySucceeded, queryFailed);

            function querySucceeded(data)
            {
                vm.entity = data.entity || data;
                placeMarker();

                vm.entity.entityAspect.loadNavigationProperty("participants")
                            .then(successParticipants, queryFailed);

                function successParticipants(data)
                {
                    vm.totalParticipants = data.results.length;
                }

                vm.entity.entityAspect.loadNavigationProperty("trainingCosts")
                            .then(successCosts, queryFailed);

                function successCosts(data)
                {
                    var costs = data.results;

                    vm.totalCost = 0;

                    for(var c of costs)
                        vm.totalCost += c.cost;
                }

                vm.entity.entityAspect.loadNavigationProperty("trainingSessions")
                            .then(successItems, queryFailed);

                function successItems(data)
                {
                    vm.gridOptions.data = data.results;
                    return vm.gridOptions.data;
                }                

                vm.entity.entityAspect.loadNavigationProperty("trainingOrganizations")
                            .then(successOrgs, queryFailed);

                function successOrgs(data)
                {
                    var orgs = data.results;

                    for(var o of orgs)
                    {
                        var org = $.grep(allOrganizations, function (e) { return e.organizationId === o.organizationId; })[0];
                        vm.organizations.push(org);
                    }

                    return vm.organizations;
                }
            }
        }

        function goBack()
        {
            $window.history.back();
        }
    }

})();
