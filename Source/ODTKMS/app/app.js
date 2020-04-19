(function()
{
    'use strict';

    var app = angular.module('app', [
        // Angular modules 
        'ngAnimate',        // animations
        'ngRoute',          // routing
        'ngSanitize',       // sanitizes html bindings (ex: sidebar.js)

        // Custom modules 
        'common',           // common functions, logger, spinner
        'common.bootstrap', // bootstrap dialog wrapper functions

        // 3rd Party Modules
        'checklist-model',
        'breeze.angular',    // configures breeze for an angular app
        'breeze.directives', // contains the breeze validation directive (zValidate)
        //'ngzWip',          // Angular-Breeze LocalStorage features
        'ui.bootstrap',      // ui-bootstrap (ex: carousel, pagination, dialog)
        'ui.grid',           // ui-grid
        'ui.grid.pagination',// ui-grid-pagination
        'ui.grid.selection', // ui-grid-selection
        'ui.grid.resizeColumns',
        'ui.grid.moveColumns',
        'ui.grid.exporter',
        'ui.grid.grouping',
        'ui.calendar',
        'uiGmapgoogle-maps',
        'schemaForm',
        'chart.js',
        'wysiwyg.module'
    ]);

    // Handle routing errors and success events
    // Trigger breeze configuration
    app.run(['$route', 'breeze', 'datacontext', 'routeMediator',
        function($route, breeze, datacontext, routeMediator)
    {
        // Include $route to kick start the router.        
        datacontext.prime();

        routeMediator.setRoutingHandlers();
    }]);
})();