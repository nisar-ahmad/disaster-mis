(function () {
    'use strict';
    var controllerId = 'trainingDashboard';
    angular.module('app').controller(controllerId, ['common', trainingDashboard]);

    function trainingDashboard(common, datacontext)
    {
        var getLogFn = common.logger.getLogFn;
        var log = getLogFn(controllerId);

        var vm = this;
        vm.title = 'Training Dashboard';

        activate();

        function activate()
        {
            common.activateController([], controllerId);
        }
    }
})();