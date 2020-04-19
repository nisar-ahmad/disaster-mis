(function()
{
    'use strict';

    // Controller name is handy for logging
    var controllerId = 'trainingActivities';

    // Define the controller on the module.
    // Inject the dependencies. 
    // Point to the controller definition function.
    angular.module('app').controller(controllerId,
        ['$modal', '$routeParams', '$location', 'common', 'config', 'datacontext', trainingActivities]);

    function trainingActivities($modal, $routeParams, $location, common, config, datacontext)
    {
        // Using 'Controller As' syntax, so we assign this to the vm variable (for viewmodel).
        var vm = this;
        var getLogFn = common.logger.getLogFn;
        var log = getLogFn(controllerId);
        var logError = common.logger.getLogFn(controllerId, 'error');
        var keyCodes = config.keyCodes;

        vm.orgId = $routeParams.orgId;
        vm.public = $routeParams.public;

        var orgId = common.getData('4wOrgId');

        //alert('orgId ' + orgId + ' vm.orgId ' + vm.orgId);

        if (vm.public && orgId != vm.orgId) {
            logError('Invalid Url');
            $location.path('/');
            return;
        }

        vm.addLink = '#/4wTraining/new';

        var cellTemplate = 'app/trainingActivity/edit-button.html';

        if (vm.public)
        {
            vm.addLink += vm.orgId + '/public';
            cellTemplate = 'app/trainingActivity/edit-button-public.html';
        }

        // Bindable properties and functions are placed on vm.
        vm.title = '4W Training Activities';
        vm.gridOptions = config.gridOptions;

        vm.gridOptions.columnDefs = [
            { field: 'trainingActivityId', name: ' ', cellTemplate: cellTemplate, width: 45, enableFiltering: false, enableSorting: false },
            { field: 'titleOfTraining' , name: 'Title'},
            { field: 'organization.name', name: 'Organization' },
            { field: 'trainingType', name: 'Type', filter: config.filters['trainingType'] },
            { field: 'trainingLevel', name:'Level', filter: config.filters['trainingLevel'] },
            { field: 'broaderTrainingArea.name', name: 'Area', filter: config.filters['broaderTrainingArea'] },
            { field: 'startDate', cellFilter: 'date:\'dd MMM yyyy\'' },
            { field: 'endDate', cellFilter: 'date:\'dd MMM yyyy\'' },
            { field: 'year'},
            { field: 'noOfParticipants'},
            //{ field: 'trainingLocation', name:'Location'},
            { field: 'district.name', name: 'District' }
            //{ field: 'approvalStatus', filter: config.filters['approvalType'] }
        ];

        //vm.gridOptions.onRegisterApi = function (grid) {
        //    getAll(true);
        //}

        vm.refresh = refresh;
        vm.logOut = logOut;

        activate();

        function activate()
        {
            common.activateController([getAll(true)], controllerId);
                //.then(function() { log('Activated ' + vm.title); });
        }

        function getAll(forceRefresh) {

            var select = 'trainingActivityId, titleOfTraining, organization, organization.name, trainingType,' +
                         'trainingLevel, broaderTrainingArea, broaderTrainingArea.name, startDate, durationOfTraining, noOfParticipants,' +
                         'trainingLocation, district, district.name, approvalStatus';

            var where = null;

            if(vm.orgId)
                where = breeze.Predicate.create('organizationId', '==', vm.orgId);

            return datacontext.trainingActivity.getAll(forceRefresh, select, where)
                .then(function (data) {
                    vm.gridOptions.data = data;
                    return data;
                }
            );
        }

        function refresh()
        {
            activate();
        }

        function logOut() {
            common.setData('4wOrgId', 0);
            $location.path('/');
        }
    }
})();
