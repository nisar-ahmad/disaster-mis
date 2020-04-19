(function()
{
    'use strict';

    var controllerId = 'project';

    angular.module('app').controller(controllerId,
        ['$scope', '$location', '$filter', '$window', '$routeParams', '$q', 'common', 'config', 'datacontext',
          'model', 'helper', 'fileUpload',  project]);

    function project($scope, $location, $filter, $window, $routeParams, $q, common, config, datacontext,
           model, helper, fileUpload)
    {
        var vm = this;

        var entity = 'Project';
        var entityName = model.entityNames.project;
        var logError = common.logger.getLogFn(controllerId, 'error');
        var logSuccess = common.logger.getLogFn(controllerId, 'success');
        
        // Bindable properties and functions are placed on vm.        
        vm.id = $routeParams.id;

        var action = vm.id === 'new' ? 'Add ' : 'Edit ';

        vm.title = action + entity;

        vm.goBack = goBack;
        vm.cancel = cancel;

        vm.hasChanges = false;
        vm.isSaving = false;
        vm.save = save;

        var allOrganizations = [];

        vm.organizationTypes = [];
        vm.organizations = [];

        vm.organizationType = undefined;
        vm.orgTypeChanged = orgTypeChanged;

        vm.proposal = undefined;
        vm.loa = undefined;
        vm.workplan = undefined;
        vm.otherDocuments = undefined;

        vm.logoUrl = 'Files/Galleries/Donors/Logos/';

        vm.proposalUrl = 'Files/Documents/Projects/Proposals/';
        vm.loaUrl = 'Files/Documents/Projects/LOAs/';
        vm.workplanUrl = 'Files/Documents/Projects/Workplans/';
        vm.otherDocumentsUrl = 'Files/Documents/Projects/OtherDocuments/';

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

            var select = 'organizationId, name, organizationTypeId, category, logo';
            var filter = breeze.Predicate.create('organizationId', '!=', 0)
                                            .and('category', '==', 'Default');

            var p0 = datacontext.organizationType.getAll(true);
            var p1 = datacontext.organization.getAll(true, select, filter);

            common.activateController([p0, p1], controllerId).then(init, queryFailed);
        }

        function init(results)
        {
            vm.organizationTypes = results[0];
            allOrganizations = results[1];
            getEntity(true);
        }

        function initOrganizationType()
        {
            vm.entity.organization = $.grep(allOrganizations, function (o) { return o.organizationId === vm.entity.organizationId; })[0];
            vm.organizationType = $.grep(vm.organizationTypes, function (o) { return o.organizationTypeId === vm.entity.organization.organizationTypeId; })[0];

            initOrganizations();
        }

        function initOrganizations() {
            vm.organizations = allOrganizations.filter(function (o) { return o.organizationId === 0 || o.organizationTypeId === vm.organizationType.organizationTypeId; });
        }

        function orgTypeChanged() {
            initDropDowns();
        }

        function initDropDowns(entity)
        {
            initOrganizations();
            vm.entity.organization = vm.organizations[0];
        }
        
        function createEntity()
        {
            vm.entity = datacontext.project.create();
            vm.organizationType = $.grep(vm.organizationTypes, function (o) { return o.name === 'Government'; })[0];

            initDropDowns(vm.entity);            

            return vm.entity;
        }

        function getEntity(forceRemote)
        {
            if (vm.id === 'new')
                return createEntity();

            return datacontext.project.getById(vm.id, forceRemote)
                    .then(querySucceeded, queryFailed);

            function querySucceeded(data) {
                vm.entity = data.entity || data;

                initOrganizationType();
            }
        }

        function save() {
            if (!canSave()) {
                return common.$q.when(null);

            } // Must return a promise

            vm.isSaving = true;

            return datacontext.save()
                .then(function (saveResult) {
                    // Save success

                    var promises = [];

                    // Uploads
                    if (vm.proposal)
                    {
                        logSuccess('Uploading File : ' + vm.proposal.name + '...');

                        var p = fileUpload.upload(vm.proposal, vm.proposalUrl, vm.entity.proposal).then(function (result)
                        {
                            vm.proposal = null;
                            vm.entity.proposal = result.data;
                            logSuccess('Uploaded File : ' + vm.entity.proposal);
                        }, queryFailed);

                        promises.push(p);
                    }

                    if (vm.loa)
                    {
                        logSuccess('Uploading File : ' + vm.loa.name);

                        var p = fileUpload.upload(vm.loa, vm.loaUrl, vm.entity.lOA).then(function (result)
                        {
                            vm.loa = null;
                            vm.entity.lOA = result.data;
                            logSuccess('Uploaded File : ' + vm.entity.lOA);
                        }, queryFailed);

                        promises.push(p);
                    }

                    if (vm.workplan)
                    {
                        logSuccess('Uploading File : ' + vm.workplan.name);

                        var p = fileUpload.upload(vm.workplan, vm.workplanUrl, vm.entity.workplan).then(function (result)
                        {
                            vm.workplan = null;
                            vm.entity.workplan = result.data;
                            logSuccess('Uploaded File : ' + vm.entity.workplan);
                        }, queryFailed);

                        promises.push(p);
                    }

                    if (vm.otherDocuments)
                    {
                        logSuccess('Uploading File : ' + vm.otherDocuments.name);

                        var p = fileUpload.upload(vm.otherDocuments, vm.otherDocumentsUrl, vm.entity.otherDocuments).then(function (result)
                        {
                            vm.otherDocuments = null;
                            vm.entity.otherDocuments = result.data;
                            logSuccess('Uploaded File : ' + vm.entity.otherDocuments);
                        }, queryFailed);

                        promises.push(p);
                    }

                    $q.all(promises).then(function () { datacontext.save(true).then(function () {vm.isSaving = false; }); });
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

            vm.proposal = null;
            vm.loa = null;
            vm.workplan = null;
            vm.otherDocuments = null;

            $('input[type=file]').val('');

            if (!vm.entity.organization)
                createEntity();
            else
                initOrganizationType();

            vm.hasChanges = false;
            //helper.replaceLocationUrlGuidWithId(vm.entity.documentId);

            if (vm.entity.entityAspect.entityState.isDetached())
            {
                goToIndex();
            }
        }

        function goToIndex()
        {
            $location.path('/projects');
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
