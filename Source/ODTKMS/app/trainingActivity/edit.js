/// <reference path="edit.js" />
(function()
{
    'use strict';

    var controllerId = 'trainingActivity';

    angular.module('app').controller(controllerId,
        ['$scope', '$location', '$filter', '$window', '$routeParams', '$q', 'common', 'config', 'datacontext',
            'model', 'helper', 'uiGmapIsReady', 'fileUpload', trainingActivity]);

    function trainingActivity($scope, $location, $filter, $window, $routeParams, $q, common, config, datacontext,
        model, helper, uiGmapIsReady, fileUpload)
    {
        var entity = '4W Training Activity';

        var vm = this;
        vm.title = 'Edit '+ entity;

        var entityName = model.entityNames.trainingActivity;
        var logError = common.logger.getLogFn(controllerId, 'error');
        var logSuccess = common.logger.getLogFn(controllerId, 'success');

        // Bindable properties and functions are placed on vm.
        vm.entity = undefined;
        vm.id = $routeParams.id;
        vm.orgId = $routeParams.orgId;

        vm.goBack = goBack;
        vm.cancel = cancel;

        vm.hasChanges = false;
        vm.isSaving = false;
        vm.save = save;
        
        var allOrganizations = [];
        var allDistricts = [];

        vm.provinces = [];
        vm.districts = [];

        vm.organizationType = undefined;
        vm.organizationTypes = [];
        vm.organizations = [];

        vm.collaboratingOrganizations = [];
        vm.trainingTypes = [];
        vm.trainingLevels = [];
        vm.broaderTrainingAreas = [];
        vm.approvalStatuses = [];

        vm.provinceChanged = provinceChanged;
        vm.orgTypeChanged = orgTypeChanged;

        vm.activate = activate;

        vm.listOfParticipants = undefined;
        vm.trainingAgenda = undefined;
        vm.picture1 = undefined;
        vm.picture2 = undefined;
        vm.picture3 = undefined;
        vm.picture4 = undefined;
        vm.picture5 = undefined;

        vm.listOfParticipantsUrl = 'Files/Documents/DRM/Trainings/ParticipantLists/';
        vm.trainingAgendaUrl = 'Files/Documents/DRM/Trainings/Agendas/';
        vm.pictureUrl = 'Files/Galleries/DRM/Trainings/';

        vm.getFileIcon = common.getFileIcon;
        vm.fileNameChanged = function () { vm.hasChanges = true; }

        vm.orgTypeChanged = orgTypeChanged;
        vm.provinceChanged = provinceChanged;


        vm.placeMarker = placeMarker;

        var isReady = false;
        var marker = undefined;

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
            events: { click: mapClicked }
        };

        uiGmapIsReady.promise().then(function (maps)
        {
            isReady = true;
            vm.placeMarker();
        });

        function mapClicked(mapModel, eventName, originalEventArgs)
        {
            // 'this' is the directive's scope
            var e = originalEventArgs[0];
            var lat = e.latLng.lat();
            var lng = e.latLng.lng();

            vm.entity.location = lng + ' ' + lat;

            $scope.$apply();
            vm.placeMarker();
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
            onHasChanges();

            var p0 = datacontext.organizationType.getAll(true);
            var p1 = datacontext.organization.getAll(true);
            var p2 = datacontext.province.getAll(true);
            var p3 = datacontext.district.getAll(true);
            var p4 = datacontext.broaderTrainingArea.getAll(true);

            common.activateController([p0, p1, p2, p3, p4], controllerId).then(init, queryFailed);
        }

        function init(results)
        {
            vm.collaboratingOrganizations = datacontext.enum.types.collaboratingOrganizations;
            vm.trainingTypes = datacontext.enum.types.trainingTypes;
            vm.trainingLevels = datacontext.enum.types.trainingLevels;            
            vm.approvalStatuses = datacontext.enum.types.approvalTypes;

            vm.organizationTypes = results[0];
            allOrganizations = results[1];
            vm.provinces = results[2];
            allDistricts = results[3];
            vm.broaderTrainingAreas = results[4];
            
            getEntity(true);
        }

        function initLocations(location)
        {
            vm.districts = allDistricts.filter(function (district) { return district.provinceId === location.province.provinceId; });
        }

        function initOrganizations()
        {
            if (vm.orgId)
            {
                vm.entity.organization = $.grep(allOrganizations, function (o) { return o.organizationId == vm.orgId; })[0];
                vm.organizationType = $.grep(vm.organizationTypes, function (o) { return o.organizationTypeId === vm.entity.organization.organizationTypeId; })[0];
                vm.organizations = allOrganizations.filter(function (o) { return o.organizationTypeId === vm.organizationType.organizationTypeId; });
            }
            else
            {
                vm.organizations = allOrganizations.filter(function (o) { return o.organizationTypeId === vm.organizationType.organizationTypeId; });
                vm.entity.organization = vm.organizations[0];
            }
        }

        function initDropDowns(entity)
        {
            entity.trainingType = vm.trainingTypes[0];
            entity.trainingLevel = vm.trainingLevels[0];
            entity.broaderTrainingArea = vm.broaderTrainingAreas[0];
            entity.collaboratingOrganization = vm.collaboratingOrganizations[0];
            entity.approvalStatus = vm.approvalStatuses[0];

            if (!vm.entity.district)
                vm.entity.district = allDistricts[0];

            if (!vm.organizationType)
                vm.organizationType = vm.organizationTypes[0];

            initLocations(entity);
            initOrganizations();
        }

        function queryFailed(error) {
            logError(error);
            goToIndex();
        }

        function getEntity(forceRemote)
        {
            var val = $routeParams.id;

            if(val === 'new')
            {
                vm.title = 'Add ' + entity;
                vm.entity = datacontext.trainingActivity.create();
                
                vm.entity.district = $.grep(allDistricts, function (o) { return o.name === 'Islamabad'; })[0];            
                vm.entity.province = $.grep(vm.provinces, function (o) { return o.provinceId === vm.entity.district.provinceId; })[0];
                vm.entity.startDate = vm.entity.endDate = moment().valueOf();

                vm.organizationType = $.grep(vm.organizationTypes, function (o) { return o.name === 'Government'; })[0];                
                initDropDowns(vm.entity);

                vm.entity.location = "73.0667 33.7167"; // Islamabad
                placeMarker();

                return vm.entity;
            }

            return datacontext.trainingActivity.getById(val, forceRemote)
                    .then(querySucceeded, queryFailed);

            function querySucceeded(data) {
                vm.entity = data.entity || data;
                vm.entity.organization = $.grep(allOrganizations, function (o) { return o.organizationId === vm.entity.organizationId; })[0];
                vm.organizationType = $.grep(vm.organizationTypes, function (o) { return o.organizationTypeId === vm.entity.organization.organizationTypeId; })[0];
                
                initLocations(vm.entity);
                initOrganizations();

                placeMarker();
            }
        }

        function goBack()
        {
            $window.history.back();
        }

        function cancel()
        {
            datacontext.cancel();

            vm.listOfParticipants = null;
            vm.trainingAgenda = null;
            vm.picture1 = null;
            vm.picture2 = null;
            vm.picture3 = null;
            vm.picture4 = null;
            vm.picture5 = null;

            $('input[type=file]').val('');

            vm.hasChanges = false;

            //helper.replaceLocationUrlGuidWithId(vm.entity.documentId);

            if (vm.entity.entityAspect.entityState.isDetached())
            {
                goBack();
            }
        }

        function goToIndex()
        {
            $location.path('/4wTrainings');
        }

        function save()
        {
            if(!canSave())
            {
                return common.$q.when(null);

            } // Must return a promise

            vm.isSaving = true;
            vm.entity.noOfParticipants = vm.entity.genderRepresentationMale + vm.entity.genderRepresentationFemale;

            return datacontext.save()
                .then(function(saveResult)
                {
                    // Save success

                    var promises = [];

                    if (vm.listOfParticipants)
                    {
                        logSuccess('Uploading File : ' + vm.listOfParticipants.name);

                        var p = fileUpload.upload(vm.listOfParticipants, vm.listOfParticipantsUrl, vm.entity.listOfParticipants).then(function (result)
                        {
                            vm.listOfParticipants = null;
                            vm.entity.listOfParticipants = result.data;
                            logSuccess('Uploaded File : ' + vm.entity.listOfParticipants);
                        }, queryFailed);

                        promises.push(p);
                    }

                    if (vm.trainingAgenda)
                    {
                        logSuccess('Uploading File : ' + vm.trainingAgenda.name);

                        var p = fileUpload.upload(vm.trainingAgenda, vm.trainingAgendaUrl, vm.entity.trainingAgenda).then(function (result)
                        {
                            vm.trainingAgenda = null;
                            vm.entity.trainingAgenda = result.data;
                            logSuccess('Uploaded File : ' + vm.entity.trainingAgenda);
                        }, queryFailed);

                        promises.push(p);
                    }

                    var pictureUrl = vm.pictureUrl + vm.entity.trainingActivityId;

                    if (vm.picture1)
                    {
                        logSuccess('Uploading File : ' + vm.picture1.name);

                        var p = fileUpload.upload(vm.picture1, pictureUrl, vm.entity.picture1).then(function (result)
                        {
                            vm.picture1 = null;
                            vm.entity.picture1 = result.data;
                            logSuccess('Uploaded File : ' + vm.entity.picture1);
                        }, queryFailed);

                        promises.push(p);
                    }

                    if (vm.picture2)
                    {
                        logSuccess('Uploading File : ' + vm.picture2.name);

                        var p = fileUpload.upload(vm.picture2, pictureUrl, vm.entity.picture2).then(function (result)
                        {
                            vm.picture2 = null;
                            vm.entity.picture2 = result.data;
                            logSuccess('Uploaded File : ' + vm.entity.picture2);
                        }, queryFailed);

                        promises.push(p);
                    }

                    if (vm.picture3)
                    {
                        logSuccess('Uploading File : ' + vm.picture3.name);

                        var p = fileUpload.upload(vm.picture3, pictureUrl, vm.entity.picture3).then(function (result)
                        {
                            vm.picture3 = null;
                            vm.entity.picture3 = result.data;
                            logSuccess('Uploaded File : ' + vm.entity.picture3);
                        }, queryFailed);

                        promises.push(p);
                    }

                    if (vm.picture4)
                    {
                        logSuccess('Uploading File : ' + vm.picture4.name);

                        var p = fileUpload.upload(vm.picture4, pictureUrl, vm.entity.picture4).then(function (result)
                        {
                            vm.picture4 = null;
                            vm.entity.picture4 = result.data;
                            logSuccess('Uploaded File : ' + vm.entity.picture4);
                        }, queryFailed);

                        promises.push(p);
                    }

                    if (vm.picture5)
                    {
                        logSuccess('Uploading File : ' + vm.picture5.name);

                        var p = fileUpload.upload(vm.picture5, pictureUrl, vm.entity.picture5).then(function (result)
                        {
                            vm.picture5 = null;
                            vm.entity.picture5 = result.data;
                            logSuccess('Uploaded File : ' + vm.entity.picture5);
                        }, queryFailed);

                        promises.push(p);
                    }

                    $q.all(promises).then(function () { datacontext.save(true).then(function () { vm.isSaving = false; }); });
                    
                    //helper.replaceLocationUrlGuidWithId(vm.entity.documentId);
                },
                function(error)
                {
                    // Save error
                    vm.isSaving = false;
                });
        }

        function provinceChanged() {
            var provinceId = vm.entity.province.provinceId;
            vm.districts = allDistricts.filter(function (e) { return e.provinceId === provinceId; });
            vm.entity.district = vm.districts[0];
        }

        function orgTypeChanged() {
            vm.organizations = allOrganizations.filter(function (e) { return e.organizationTypeId === vm.organizationType.organizationTypeId; });
            vm.entity.organization = vm.organizations[0];
        }

        function onDestroy()
        {
            $scope.$on('$destroy', function()
            {
                datacontext.cancel();
            });
        }

        function onHasChanges()
        {
            $scope.$on(config.events.hasChangesChanged,
                function(event, data)
                {
                    vm.hasChanges = data.hasChanges;
                });
        }
    }

})();
