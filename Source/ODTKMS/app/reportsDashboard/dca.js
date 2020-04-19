(function () {
    'use strict';
    var controllerId = 'dcaDashboard';
    angular.module('app').controller(controllerId, ['common', dcaDashboard]);

    function dcaDashboard(common, datacontext)
    {
        var getLogFn = common.logger.getLogFn;
        var log = getLogFn(controllerId);

        var vm = this;
        vm.title = 'Donors & Collaborating Agencies Dashboard';

        activate();

        function activate()
        {
            common.activateController([], controllerId);
        }
    }
})();