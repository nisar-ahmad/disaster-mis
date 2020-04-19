(function()
{
    'use strict';

    var controllerId = 'resourcePerson';

    angular.module('app').controller(controllerId,
        ['$scope', '$location', '$filter', '$window', '$routeParams', '$q', 'common', 'config',
            'datacontext', 'model', 'helper', 'fileUpload', resourcePerson]);

    function resourcePerson($scope, $location, $filter, $window, $routeParams, $q, common, config,
                            datacontext, model, helper, fileUpload)
    {
        var entity = 'Resource Person';

        var vm = this;
        vm.title = 'Edit '+ entity;

        var entityName = model.entityNames.resourcePerson;
        var logError = common.logger.getLogFn(controllerId, 'error');
        var logSuccess = common.logger.getLogFn(controllerId, 'success');

        // Bindable properties and functions are placed on vm.
        vm.entity = undefined;
        vm.id = $routeParams.id;

        vm.goBack = goBack;
        vm.cancel = cancel;

        vm.hasChanges = false;
        vm.isSaving = false;
        vm.save = save;
        
        vm.salutations = config.salutations;
        vm.districts = [];

        vm.disabilityTypes = [];
        vm.disabilityTypesOriginal = [];
        vm.disabilityTypesSelected = [];

        vm.academicQualifications = [];
        vm.organizations = [];

        vm.areas = [];
        vm.areasOriginal = [];
        vm.areasSelected = [];

        vm.genderTypes = [];
        vm.accountTypes = [];
        vm.approvalTypes = [];

        var allOrganizations = [];
        var allDistricts = [];

        vm.province = undefined;
        vm.organizationTypes = [];

        vm.photo = undefined;
        vm.resume = undefined;
        vm.photoUrl = 'Files/Galleries/ResourcePersons/Photos/';
        vm.resumeUrl = 'Files/Documents/ResourcePersons/Resumes/';        

        vm.orgTypeChanged = orgTypeChanged;
        vm.provinceChanged = provinceChanged;
        vm.getFileIcon = common.getFileIcon;
        vm.fileNameChanged = function () { vm.hasChanges = true; }

        vm.activate = activate;        
 
        // vm.canSave Property
        Object.defineProperty(vm, 'canSave', {
            get: canSave
        });

        function canSave()
        {
            return vm.hasChanges && !vm.isSaving;
        }
        
        activate();

        function queryFailed(error) {
            logError(error);
            goToIndex();
        }

        function activate()
        {
            onDestroy();
            onHasChanges();

             var notNullo = breeze.Predicate.create('organizationId', '!=', 0);

            var p0 = datacontext.disabilityType.getAll(true);
            var p1 = datacontext.district.getAll(true);
            var p2 = datacontext.organization.getAll(true);
            var p3 = datacontext.academicQualification.getAll(true);
            var p4 = datacontext.area.getAll(true);
            var p5 = datacontext.province.getAll(true);
            var p6 = datacontext.organizationType.getAll(true);

            common.activateController([p0, p1, p2, p3, p4, p5, p6], controllerId).then(init, queryFailed);
        }

        function init(results)
        {
            vm.genderTypes = datacontext.enum.types.genderTypes;
            vm.accountTypes = datacontext.enum.types.accountTypes;
            vm.approvalTypes = datacontext.enum.types.approvalTypes;

            vm.disabilityTypes = results[0];
            allDistricts = results[1];
            allOrganizations = results[2];
            vm.academicQualifications = results[3];
            vm.areas = results[4];
            vm.provinces = results[5];
            vm.organizationTypes = results[6];

            getEntity(true);
        }

        function initLocations() {
            vm.districts = allDistricts.filter(function (district) { return district.provinceId === vm.province.provinceId; });
        }

        function initOrganizations() {
            vm.organizations = allOrganizations.filter(function (o) { return o.organizationId === 0 || o.organizationTypeId === vm.entity.organizationType.organizationTypeId; });
        }

        function initDropDowns(entity)
        {
            entity.title = vm.salutations[0];
            entity.gender = vm.genderTypes[0];
            entity.academicQualification = vm.academicQualifications[0];
            entity.approvalStatus = vm.approvalTypes[0];
            entity.accountType = vm.accountTypes[0];

            if (!vm.entity.organizationType)
                vm.entity.organizationType = vm.organizationTypes[0];

            if (!vm.entity.district)
                vm.entity.district = allDistricts[0];

            vm.entity.organization = $.grep(allOrganizations, function (o) { return o.organizationTypeId === vm.entity.organizationType.organizationTypeId; })[0];

            if (!vm.entity.organization)
                vm.entity.organization = allOrganizations[0];

            vm.province = $.grep(vm.provinces, function (o) { return o.provinceId === vm.entity.district.provinceId; })[0];

            initLocations();
            initOrganizations();
        }

        function provinceChanged() {
            var provinceId = vm.province.provinceId;
            vm.districts = allDistricts.filter(function (e) { return e.provinceId === provinceId; });
            vm.entity.district = vm.districts[0];
        }

        function orgTypeChanged() {
            vm.organizations = allOrganizations.filter(function (e) { return e.organizationId === 0 || e.organizationTypeId === vm.entity.organizationType.organizationTypeId; });
            vm.entity.organization = vm.organizations[0];
        }

        function getEntity(forceRemote)
        {
            var val = $routeParams.id;

            if(val === 'new')
            {
                vm.title = 'Add ' + entity;
                return createEntity();
            }

            return datacontext.resourcePerson.getById(val, forceRemote)
                    .then(querySucceeded, queryFailed);

            function querySucceeded(data) {
                vm.entity = data.entity || data;

                if (!vm.entity.organizationId)
                    vm.entity.organization = allOrganizations[0];
                else
                    vm.entity.organization = $.grep(allOrganizations, function (o) { return o.organizationId === vm.entity.organizationId; })[0];

                if (!vm.entity.organizationType)
                    vm.entity.organizationType = $.grep(vm.organizationTypes, function (o) { return o.organizationTypeId === vm.entity.organizationTypeId; })[0];

                vm.entity.district = $.grep(allDistricts, function (o) { return o.districtId === vm.entity.districtId; })[0];
                vm.province = $.grep(vm.provinces, function (o) { return o.provinceId === vm.entity.district.provinceId; })[0];

                initLocations();
                initOrganizations();

                vm.entity.entityAspect.loadNavigationProperty("resourcePersonDisabilityTypes")
                    .then(successDisability, queryFailed);

                function successDisability(data) {
                    vm.disabilityTypesOriginal = data.results || data;

                    for (var a of vm.disabilityTypesOriginal)
                        vm.disabilityTypesSelected.push(a.disabilityTypeId);
                }

                vm.entity.entityAspect.loadNavigationProperty("resourcePersonAreas")
                    .then(successArea, queryFailed);

                function successArea(data) {
                    vm.areasOriginal = data.results || data;

                    for (var a of vm.areasOriginal) 
                        vm.areasSelected.push(a.areaId);
                }
            }
        }

        function createEntity()
        {
            vm.entity = datacontext.resourcePerson.create();

            vm.entity.district = $.grep(allDistricts, function (o) { return o.name === 'Islamabad'; })[0];
            vm.entity.organizationType = $.grep(vm.organizationTypes, function (o) { return o.name === 'Government'; })[0];

            initDropDowns(vm.entity);

            return vm.entity;
        }

        function save() {
            if (!canSave()) {
                return common.$q.when(null);

            } // Must return a promise

            if (!vm.entity.organization.organizationId && !vm.entity.otherOrganization)
            {
                logError('Please select an organization or specify in other organization!');
                return;
            }

            vm.isSaving = true;

            // Save Special Abilities
            for (var a of vm.disabilityTypes)
            {
                var selected = $.grep(vm.disabilityTypesSelected, function (e) { return e == a.disabilityTypeId; }).length;
                var original = $.grep(vm.disabilityTypesOriginal, function (e) { return e.disabilityTypeId == a.disabilityTypeId; });
                var exists = original.length;

                if (selected && !exists) {
                    // add
                    var obj = { resourcePerson: vm.entity, disabilityType: a };
                    var newEntity = datacontext.resourcePersonDisabilityType.create(obj);

                    vm.disabilityTypesOriginal.push(newEntity);
                }
                else if (!selected && exists) {
                    // remove
                    var entityAspect = original[0].entityAspect;

                    if (!entityAspect.entityState.isDetached())
                        entityAspect.setDeleted();

                    vm.disabilityTypesOriginal = vm.disabilityTypesOriginal.filter(function (e) { return e.disabilityTypeId != a.disabilityTypeId; });
                }
            }

            // Save Areas
            for (var a of vm.areas)
            {
                var selected = $.grep(vm.areasSelected, function (e) { return e == a.areaId; }).length;
                var original = $.grep(vm.areasOriginal, function (e) { return e.areaId == a.areaId; });
                var exists = original.length;

                if (selected && !exists) {
                    // add
                    var obj = { resourcePerson: vm.entity, area: a };
                    var newEntity = datacontext.resourcePersonArea.create(obj);

                    vm.areasOriginal.push(newEntity);
                }
                else if (!selected && exists) {
                    // remove
                    var entityAspect = original[0].entityAspect;

                    if (!entityAspect.entityState.isDetached())
                        entityAspect.setDeleted();

                    vm.areasOriginal = vm.areasOriginal.filter(function (e) { return e.areaId != a.areaId; });
                }
            }

            saveNullos();

            return datacontext.save()
                .then(function (saveResult) {
                    // Save success
                    vm.disabilityTypesSelected.length = 0;

                    for(var a of vm.disabilityTypesOriginal)
                        vm.disabilityTypesSelected.push(a.disabilityTypeId);

                    vm.areasSelected.length = 0;

                    for(var a of vm.areasOriginal)
                        vm.areasSelected.push(a.areaId);

                    if (!vm.photo && !vm.resume)
                    {
                        restoreNullos();
                        vm.isSaving = false;
                    }

                    var promises = [];

                    // Uploads
                    if (vm.photo)
                    {
                        logSuccess('Uploading File : ' + vm.photo.name + '...');

                        var p = fileUpload.upload(vm.photo, vm.photoUrl, vm.entity.photo, true).then(function (result)
                        {
                            vm.photo = null;
                            vm.entity.photo = result.data;
                            logSuccess('Uploaded File : ' + vm.entity.photo);
                        }, queryFailed);

                        promises.push(p);
                    }

                    if(vm.resume)
                    {
                        logSuccess('Uploading File : ' + vm.resume.name);

                        var p = fileUpload.upload(vm.resume, vm.resumeUrl, vm.entity.resume).then(function (result)
                        {
                            vm.resume = null;
                            vm.entity.resume = result.data;
                            logSuccess('Uploaded File : ' + vm.entity.resume);
                        }, queryFailed);

                        promises.push(p);
                    }

                    $q.all(promises).then(function () { datacontext.save(true).then(function () { restoreNullos(); vm.isSaving = false; }); });

                    //helper.replaceLocationUrlGuidWithId(vm.entity.documentId);
                },
                function (error) {
                    // Save error
                    restoreNullos();
                    vm.isSaving = false;
                });
        }

        function saveNullos() {
            if (vm.entity.organization && vm.entity.organization.organizationId === 0)
                vm.entity.organization = null;
        }

        function restoreNullos() {
            if (vm.entity && !vm.entity.organization) 
                vm.entity.organization = allOrganizations[0];
        }

        function cancel() {
            datacontext.cancel();

            vm.photo = null;
            vm.resume = null;

            $('input[type=file]').val('');
            
            if (!vm.entity.district)
                createEntity()
            else
            {
                vm.province = $.grep(vm.provinces, function (o) { return o.provinceId === vm.entity.district.provinceId; })[0];

                initOrganizations();
                initLocations();
                restoreNullos();

                vm.disabilityTypesSelected.length = 0;

                for(var a of vm.disabilityTypesOriginal)
                    vm.disabilityTypesSelected.push(a.disabilityTypeId);

                vm.areasSelected.length = 0;

                for(var a of vm.areasOriginal)
                    vm.areasSelected.push(a.areaId);

                vm.hasChanges = false;
            }

            //helper.replaceLocationUrlGuidWithId(vm.entity.documentId);

            if (vm.entity.entityAspect.entityState.isDetached()) {
                goToIndex();
            }
        }

        function goBack()
        {
            $window.history.back();
        }

        function goToIndex()
        {
            $location.path('/resourcePersons');
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
