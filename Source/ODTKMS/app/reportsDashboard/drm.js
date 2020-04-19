(function () {
    'use strict';
    var controllerId = 'drmDashboard';
    angular.module('app').controller(controllerId, ['common', drmDashboard]);

    function drmDashboard(common, datacontext)
    {
        var getLogFn = common.logger.getLogFn;
        var log = getLogFn(controllerId);

        var vm = this;
        vm.title = '4ws Dashboard';

        activate();

        function activate()
        {
            common.activateController([], controllerId);
        }
    }
})();