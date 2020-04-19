(function () {
    'use strict';
    var controllerId = 'home';
    angular.module('app').controller(controllerId, ['common', home]);

    function home(common, datacontext)
    {
        var getLogFn = common.logger.getLogFn;
        var log = getLogFn(controllerId);

        var vm = this;
        vm.title = 'Home Page';

        activate();

        function activate()
        {
            common.activateController([], controllerId);
        }
    }
})();