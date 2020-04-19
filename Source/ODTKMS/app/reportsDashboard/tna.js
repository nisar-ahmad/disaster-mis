(function () {
    'use strict';
    var controllerId = 'tnaDashboard';
    angular.module('app').controller(controllerId, ['common', tnaDashboard]);

    function tnaDashboard(common, datacontext)
    {
        var getLogFn = common.logger.getLogFn;
        var log = getLogFn(controllerId);

        var vm = this;
        vm.title = 'TNA Dashboard';

        activate();

        function activate()
        {
            common.activateController([], controllerId);
        }
    }
})();