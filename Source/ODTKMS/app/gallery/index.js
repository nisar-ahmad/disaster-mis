(function()
{
    'use strict';

    // Controller name is handy for logging
    var controllerId = 'galleries';

    // Define the controller on the module.
    // Inject the dependencies. 
    // Point to the controller definition function.
    angular.module('app').controller(controllerId,
        [ '$window', '$routeParams', 'common', 'config', 'datacontext', galleries]);

    function galleries($window, $routeParams, common, config, datacontext)
    {
        // Using 'Controller As' syntax, so we assign this to the vm variable (for viewmodel).
        var vm = this;
        var getLogFn = common.logger.getLogFn;
        var log = getLogFn(controllerId);
        var chunkSize = 6;

        // Bindable properties and functions are placed on vm.
        vm.title = 'Galleries';
        vm.public = $routeParams.public;
        vm.galleries = [];

        vm.refresh = refresh;
        vm.goBack = goBack;

        activate();

        function activate()
        {
            common.activateController([getAll(true)], controllerId);
        }

        function getAll(forceRefresh)
        {
            return datacontext.gallery.getAll(forceRefresh, null)
                .then(function(data)
                {
                    vm.galleries = common.getChunks(data, chunkSize);
                    return data;
                }
            );
        }

        function refresh()
        {
            activate()
        }

        function goBack()
        {
            $window.history.back();
        }
    }
})();
