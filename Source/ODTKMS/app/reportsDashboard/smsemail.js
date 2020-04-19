(function () {
    'use strict';
    var controllerId = 'smsemailDashboard';
    angular.module('app').controller(controllerId, ['common', smsemailDashboard]);

    function smsemailDashboard(common, datacontext)
    {
        var getLogFn = common.logger.getLogFn;
        var log = getLogFn(controllerId);

        var vm = this;
        vm.title = 'SMS & Email Dashboard';

        activate();

        function activate()
        {
            common.activateController([], controllerId);
        }
    }
})();