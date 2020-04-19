(function () {
    'use strict';
    var controllerId = 'reportsDashboard';
    angular.module('app').controller(controllerId, ['common', reportsDashboard]);

    function reportsDashboard(common, datacontext)
    {
        var getLogFn = common.logger.getLogFn;
        var log = getLogFn(controllerId);

        var vm = this;
        vm.title = 'Reports Dashboard';

        activate();

        function activate()
        {
            common.activateController([], controllerId);
        }
    }
})();