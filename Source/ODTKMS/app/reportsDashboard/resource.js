(function () {
    'use strict';
    var controllerId = 'resourceDashboard';
    angular.module('app').controller(controllerId, ['common', resourceDashboard]);

    function resourceDashboard(common, datacontext)
    {
        var getLogFn = common.logger.getLogFn;
        var log = getLogFn(controllerId);

        var vm = this;
        vm.title = 'Resource Persons Dashboard';

        activate();

        function activate()
        {
            common.activateController([], controllerId);
        }
    }
})();