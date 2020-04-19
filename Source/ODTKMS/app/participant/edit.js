(function()
{
    'use strict';

    var controllerId = 'participant';

    angular.module('app').controller(controllerId,
        ['$scope', '$location', '$filter', '$window', '$routeParams', 'common', 'config', 'datacontext',
            'model', '$http', 'fileUpload', 'notify', participant]);

    function participant($scope, $location, $filter, $window, $routeParams, common, config, datacontext, 
                        model, $http, fileUpload, notify)
    {
        var entity = 'Participant';

        var vm = this;
        vm.title = entity + ' Registration';

        var entityName = model.entityNames.participant;
        var logError = common.logger.getLogFn(controllerId, 'error');
        var logSuccess = common.logger.getLogFn(controllerId, 'success');

        // Bindable properties and functions are placed on vm.                
        vm.entity = undefined;
        vm.id = $routeParams.id;
        vm.public = $routeParams.public;
        vm.trainingId = common.getData('trainingId');

        if (vm.public && !vm.trainingId)
            return queryFailed('Invalid request!');

        vm.goBack = goBack;
        vm.cancel = cancel;

        vm.hasChanges = false;
        vm.isSaving = false;
        vm.save = save;
        
        vm.salutations = config.salutations;

        vm.provinces = [];
        vm.districts = [];

        vm.disabilityTypes = [];
        vm.disabilityTypesOriginal = [];
        vm.disabilityTypesSelected = [];

        vm.academicQualifications = [];
        vm.organizations = [];
        vm.trainings = [];

        vm.genderTypes = [];
        vm.approvalTypes = [];

        var allOrganizations = [];
        var allDistricts = [];

        vm.province = undefined;
        vm.organizationTypes = [];

        vm.paymentProofDocument = undefined;
        vm.paymentProofDocumentUrl = 'Files/Documents/Participants/PaymentProofDocuments/';

        vm.getFileIcon = common.getFileIcon;

        vm.orgTypeChanged = orgTypeChanged;
        vm.provinceChanged = provinceChanged;
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
            goBack();
        }
    
        function activate()
        {
            onDestroy();
            onHasChanges();

            var trainingNotNull = breeze.Predicate.create('trainingId', '!=', 0);

            var p0 = datacontext.disabilityType.getAll(true);
            var p1 = datacontext.district.getAll(true);
            var p2 = datacontext.organization.getAll(true);
            var p3 = datacontext.academicQualification.getAll(true);
            var p4 = datacontext.training.getAll(true, null, trainingNotNull);
            var p5 = datacontext.province.getAll(true);
            var p6 = datacontext.organizationType.getAll(true);

            common.activateController([p0, p1, p2, p3, p4, p5, p6], controllerId).then(init, queryFailed);
        }

        function init(results)
        {
            vm.genderTypes = datacontext.enum.types.genderTypes;
            vm.approvalTypes = datacontext.enum.types.approvalTypes;

            vm.disabilityTypes = results[0];
            allDistricts = results[1];
            allOrganizations = results[2];
            vm.academicQualifications = results[3];
            vm.trainings = results[4];
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

            if (vm.trainingId)
                entity.training = $.grep(vm.trainings, function (o) { return o.trainingId == vm.trainingId; })[0];
            else
                entity.training = vm.trainings[0];

            if (!vm.entity.organizationType)
                vm.entity.organizationType = vm.organizationTypes[0];

            if (!vm.entity.district)
                vm.entity.district = allDistricts[0];

            if (!vm.entity.organization)
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
            vm.organizations = allOrganizations.filter(function (o) { return o.organizationId === 0 || o.organizationTypeId === vm.entity.organizationType.organizationTypeId; });
            vm.entity.organization = vm.organizations[0];
        }       

        function createEntity()
        {
            vm.entity = datacontext.participant.create();

            vm.entity.district = $.grep(allDistricts, function (o) { return o.name === 'Islamabad'; })[0];
            vm.entity.organizationType = $.grep(vm.organizationTypes, function (o) { return o.name === 'Government'; })[0];

            initDropDowns(vm.entity);

            return vm.entity;
        }

        function getEntity(forceRemote)
        {
            var val = $routeParams.id;

            if (val === 'new')
                return createEntity();

            vm.title = 'Approve ' + entity;

            return datacontext.participant.getById(val, forceRemote)
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

                vm.entity.entityAspect.loadNavigationProperty("participantDisabilityTypes")
                    .then(successDisability, queryFailed);

                function successDisability(data) {
                    vm.disabilityTypesOriginal = data.results || data;

                    for (var a of vm.disabilityTypesOriginal)
                        vm.disabilityTypesSelected.push(a.disabilityTypeId);
                }
            }
        }

        function save() {
            if (!canSave()) {
                return common.$q.when(null);

            } // Must return a promise

            vm.isSaving = true;      

            // Save Special Abilities
            for (var a of vm.disabilityTypes)
            {
                var selected = $.grep(vm.disabilityTypesSelected, function (e) { return e == a.disabilityTypeId; }).length;
                var original = $.grep(vm.disabilityTypesOriginal, function (e) { return e.disabilityTypeId == a.disabilityTypeId; });
                var exists = original.length;

                if (selected && !exists) {
                    // add
                    var obj = { participant: vm.entity, disabilityType: a };
                    var newEntity = datacontext.participantDisabilityType.create(obj);

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

            saveNullos();

            return datacontext.save()
                .then(function (saveResult) {
                    // Save success

                    vm.disabilityTypesSelected.length = 0;

                    for(var a of vm.disabilityTypesOriginal)
                        vm.disabilityTypesSelected.push(a.disabilityTypeId);

                    if (vm.paymentProofDocument)
                    {
                        logSuccess('Uploading File : ' + vm.paymentProofDocument.name);

                        fileUpload.upload(vm.paymentProofDocument, vm.paymentProofDocumentUrl, vm.entity.paymentProofDocument).then(function (result)
                        {
                            vm.resume = null;
                            vm.entity.paymentProofDocument = result.data;
                            logSuccess('Uploaded File : ' + vm.entity.paymentProofDocument);
                            datacontext.save(true).then(function () { restoreNullos(); vm.isSaving = false; });

                        }, queryFailed);
                    }
                    else
                    {
                        restoreNullos();
                        vm.isSaving = false;
                    }

                    if (vm.id === 'new' && vm.entity.email)
                    {
                        var message = {};
                        message.id = vm.trainingId;
                        message.to = vm.entity.email;
                        message.subject = 'NIDM Training Registration';
                        message.body = "Dear " + vm.entity.name + ",<br /><br />Thank you for registering yourself for this NIDM training. "
                                       + "We will inform you by email when your application is approved.<br /><br />"
                                       + "<strong>Training Details:</strong> <br /> <a href='[training-link]'>[training-link]</a><br /><br />Regards,<br />NIDM Admin";

                        notify.email(message);
                    }

                    goToIndex();
                },
                function (error) {
                    // Save error
                    restoreNullos();
                    vm.isSaving = false;
                });
        }

        function saveNullos() {
            if (vm.entity.organization.organizationId === 0)
                vm.entity.organization = null;
        }

        function restoreNullos() {
            if (vm.entity) {
                if (!vm.entity.organization)
                    vm.entity.organization = allOrganizations[0];
            }
        }

        function cancel()
        {
            datacontext.cancel();

            $('input[type=file]').val('');
            vm.files = [];

            if (!vm.entity.district)
                createEntity();
            else {
                vm.province = $.grep(vm.provinces, function (o) { return o.provinceId === vm.entity.district.provinceId; })[0];

                initOrganizations();
                initLocations();
                restoreNullos();

                vm.disabilityTypesSelected.length = 0;

                for(var a of vm.disabilityTypesOriginal)
                    vm.disabilityTypesSelected.push(a.disabilityTypeId);

                vm.hasChanges = false;
            }

            //helper.replaceLocationUrlGuidWithId(vm.entity.documentId);

            if (vm.entity.entityAspect.entityState.isDetached())
            {
                goToIndex();
            }
        }

        function goToIndex()
        {
            var path = '/participants';

            if(vm.trainingId)
                path = '/trainings/calendar';

            if (vm.public)
            {
                common.setData('thanksMessage', 'Thank you for registration. We will contact you by email with further details.');
                //common.setData('thanksUrl', path + '/public');

                path = '/thanks';
            }

            $location.path(path);
        }

        function goBack()
        {
            $window.history.back();
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
