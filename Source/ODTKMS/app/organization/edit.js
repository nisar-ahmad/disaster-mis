(function()
{
    'use strict';

    var controllerId = 'organization';

    angular.module('app').controller(controllerId,
        ['$scope', '$location', '$filter', '$window', '$routeParams', '$q', 'common', 'config', 'datacontext',
            'model', 'helper', 'fileUpload', organization]);

    function organization($scope, $location, $filter, $window, $routeParams, $q, common, config, datacontext,
        model, helper, fileUpload)
    {
        var vm = this;

        var entityName = model.entityNames.participant;
        var logError = common.logger.getLogFn(controllerId, 'error');
        var logSuccess = common.logger.getLogFn(controllerId, 'success');

        // Bindable properties and functions are placed on vm.
        vm.entity = undefined;
        vm.id = $routeParams.id;
        vm.category = $routeParams.category;
        vm.public = $routeParams.public;

        var entity = vm.category === '4w' ? 'Stakeholder Organization' : 'Donor / Collaborating Agency';
        var action = 'Register ';

        if(vm.id != 'new')
            action = vm.category === '4w' ? 'Approve ' : 'Edit ';

        vm.title = action + entity;

        vm.goBack = goBack;
        vm.cancel = cancel;

        vm.hasChanges = false;
        vm.isSaving = false;
        vm.save = save;

        vm.organizationTypes = [];
        vm.districts = [];
        vm.approvalTypes = [];

        vm.logo = undefined;
        vm.profile = undefined;
        vm.registrationCertificate = undefined;
        vm.headPhoto = undefined;
        
        vm.headPhotoUrl = vm.category === '4w' ? 'Files/Galleries/4W/Heads/' : 'Files/Galleries/Donors/Heads/';
        vm.logoUrl = vm.category === '4w' ? 'Files/Galleries/4W/Logos/' : 'Files/Galleries/Donors/Logos/';
        vm.profileUrl = vm.category === '4w' ? 'Files/Documents/4W/Profiles/' : 'Files/Documents/Donors/Profiles/';
        vm.registrationCertificateUrl = 'Files/Documents/4W/RegistrationCertificates/';
        
        vm.getFileIcon = common.getFileIcon;
        vm.activate = activate;

        vm.fileNameChanged = function () { vm.hasChanges = true; }

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

            var p0 = datacontext.organizationType.getAll(true);
            var p1 = datacontext.district.getAll(true);

            common.activateController([p0, p1], controllerId).then(init, queryFailed);
        }

        function init(results)
        {
            vm.approvalTypes = datacontext.enum.types.approvalTypes;
            vm.relationshipTypes = datacontext.enum.types.relationshipTypes;
            vm.geographicalAreas = datacontext.enum.types.geographicalAreas;
            vm.organizationTypes = results[0];
            vm.districts = results[1];

            getEntity(true);
        }

        function initDropDowns(entity)
        {
            entity.approvalStatus = vm.approvalTypes[0];
            entity.relationshipType = vm.relationshipTypes[0];
            entity.geographicalArea = vm.geographicalAreas[0];

            if(vm.category === '4w')
            {
                entity.category = 'FourW';
            }
            else
            {
                entity.category = 'Default';
                entity.approvalStatus = 'Accepted';
            }

            if (!vm.entity.organizationType)
                vm.entity.organizationType = vm.organizationTypes[0];

            if (!vm.entity.district)
                vm.entity.district = vm.districts[0];
        }
        
        function createEntity()
        {
            vm.entity = datacontext.organization.create();
            vm.entity.organizationType = $.grep(vm.organizationTypes, function (o) { return o.name === 'Government'; })[0];
            vm.entity.district = $.grep(vm.districts, function (o) { return o.name === 'Islamabad'; })[0];

            initDropDowns(vm.entity);

            return vm.entity;
        }

        function getEntity(forceRemote)
        {
            if (vm.id === 'new')
                return createEntity();

            return datacontext.organization.getById(vm.id, forceRemote)
                    .then(querySucceeded, queryFailed);

            function querySucceeded(data) {
                vm.entity = data.entity || data;

                if (!vm.entity.organizationType)
                    vm.entity.organizationType = $.grep(vm.organizationTypes, function (o) { return o.organizationTypeId === vm.entity.organizationTypeId; })[0];

                if (!vm.entity.district)
                    vm.entity.district = $.grep(vm.districts, function (o) { return o.districtId === vm.entity.districtId; })[0];
            }
        }

        function save() {
            if (!canSave()) {
                return common.$q.when(null);

            } // Must return a promise

            if(vm.public)
            {
                if (!vm.entity.username || !vm.entity.passwordHash)
                 {
                    logError("Please provide user name and password");
                    return;
                }
                else if (vm.confirmPassword != vm.entity.passwordHash)
                {
                    logError("Password and confirm password don't match");
                    return;
                }
            }

            vm.isSaving = true;

            return datacontext.save()
                .then(function (saveResult) {
                    // Save success                                       

                    var promises = [];

                    // Uploads
                    if (vm.logo)
                    {
                        logSuccess('Uploading File : ' + vm.logo.name + '...');

                        var p = fileUpload.upload(vm.logo, vm.logoUrl, vm.entity.logo, true).then(function (result)
                        {
                            vm.logo = null;
                            vm.entity.logo = result.data;
                            logSuccess('Uploaded File : ' + vm.entity.logo);
                            //datacontext.save(true);
                        }, queryFailed);

                        promises.push(p);
                    }

                    if (vm.profile)
                    {
                        logSuccess('Uploading File : ' + vm.profile.name);

                        var p = fileUpload.upload(vm.profile, vm.profileUrl, vm.entity.profile).then(function (result)
                        {
                            vm.resume = null;
                            vm.entity.profile = result.data;
                            logSuccess('Uploaded File : ' + vm.entity.profile);
                            //datacontext.save(true);

                        }, queryFailed);

                        promises.push(p);
                    }

                    if (vm.headPhoto)
                    {
                        logSuccess('Uploading File : ' + vm.headPhoto.name + '...');

                        var p = fileUpload.upload(vm.headPhoto, vm.headPhotoUrl, vm.entity.headPhoto, true).then(function (result)
                        {
                            vm.headPhoto = null;
                            vm.entity.headPhoto = result.data;
                            logSuccess('Uploaded File : ' + vm.entity.headPhoto);
                            //datacontext.save(true);
                        }, queryFailed);

                        promises.push(p);
                    }

                    if (vm.registrationCertificate)
                    {
                        logSuccess('Uploading File : ' + vm.registrationCertificate.name);

                        var p = fileUpload.upload(vm.registrationCertificate, vm.registrationCertificateUrl, vm.entity.registrationCertificate).then(function (result)
                        {
                            vm.resume = null;
                            vm.entity.registrationCertificate = result.data;
                            logSuccess('Uploaded File : ' + vm.entity.registrationCertificate);
                            //datacontext.save(true);

                        }, queryFailed);

                        promises.push(p);
                    }

                    $q.all(promises).then(function () {
                        datacontext.save();

                        if (vm.public) {
                            common.setData('thanksUrl', null);
                            common.setData('thanksMessage', 'Thank you for registration. We will contact you by email with further details.');
                            $location.path('/thanks');
                        }                        
                    });

                    vm.isSaving = false;
                    //helper.replaceLocationUrlGuidWithId(vm.entity.documentId);
                },
                function (error) {
                    // Save error
                    vm.isSaving = false;
                });
        }

        function cancel()
        {
            datacontext.cancel();
            vm.hasChanges = false;

            vm.logo = null;
            vm.profile = null;
            vm.registrationCertificate = null;
            vm.headPhoto = null;

            $('input[type=file]').val('');
            //helper.replaceLocationUrlGuidWithId(vm.entity.documentId);

            if (vm.entity.entityAspect.entityState.isDetached())
            {
                goToIndex();
            }
        }

        function goToIndex()
        {
            $location.path('/organizations/' + vm.category);
        }

        function goBack() {
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
