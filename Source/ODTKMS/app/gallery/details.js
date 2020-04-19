(function()
{
    'use strict';

    // Controller name is handy for logging
    var controllerId = 'galleryDetails';

    // Define the controller on the module.
    // Inject the dependencies. 
    // Point to the controller definition function.
    angular.module('app').controller(controllerId,
        ['$window', '$routeParams', 'common', 'config', 'datacontext', galleryDetails]);

    function galleryDetails($window, $routeParams, common, config, datacontext)
    {
        // Using 'Controller As' syntax, so we assign this to the vm variable (for viewmodel).
        var vm = this;
        var getLogFn = common.logger.getLogFn;
        var log = getLogFn(controllerId);
        var chunkSize = 6;

        // Bindable properties and functions are placed on vm.
        vm.title = 'Albums in Gallery';
        vm.albums = [];
        vm.refresh = refresh;
        vm.goBack = goBack;
        vm.id = $routeParams.id;
        vm.public = $routeParams.public;

        activate();

        function activate()
        {
            common.activateController([getAll(true)], controllerId);                
        }

        function getAll(forceRefresh)
        {
            var filter = breeze.Predicate.create('galleryId', '==', vm.id);

            if (vm.public)
                filter = filter.and('accessType', '==', 'Public');

            return datacontext.album.getAll(forceRefresh, null, filter)
                .then(function(data)
                {
                    vm.albums = common.getChunks(data, chunkSize);
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
