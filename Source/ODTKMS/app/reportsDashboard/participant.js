(function () {
    'use strict';
    var controllerId = 'participantDashboard';
    angular.module('app').controller(controllerId, ['common', participantDashboard]);

    function participantDashboard(common, datacontext)
    {
        var getLogFn = common.logger.getLogFn;
        var log = getLogFn(controllerId);

        var vm = this;
        vm.title = 'Participant Dashboard';

        activate();

        function activate()
        {
            common.activateController([], controllerId);
        }
    }
})();