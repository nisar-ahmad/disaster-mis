(function()
{
    'use strict';

    // Controller name is handy for logging
    var controllerId = 'thanks';

    // Define the controller on the module.
    // Inject the dependencies. 
    // Point to the controller definition function.
    angular.module('app').controller(controllerId, ['common', thanks]);

    function thanks(common)
    {
        var vm = this;
        vm.title = 'Thank You!';
        vm.thanksMessage = common.getData('thanksMessage');
        vm.thanksUrl = common.getData('thanksUrl');

        if (!vm.thanksMessage)
            vm.thanksMessage = 'Thank You for providing your valuable feedback!';

        //if (!vm.thanksUrl)
        //    vm.thanksUrl = '/trainings/calendar/public';

        // Using 'Controller As' syntax, so we assign this to the vm variable (for viewmodel).
        common.activateController([], controllerId);
    }
})();
