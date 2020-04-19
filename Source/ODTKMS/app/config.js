(function ()
{
    'use strict';

    var app = angular.module('app');

    // Configure Toastr
    toastr.options.timeOut = 4000;
    toastr.options.positionClass = 'toast-bottom-right';

    // ui-grid default options
    var gridOptions = {
        enableFiltering: true,
        enableColumnMenus: true,
        enableColumnResizing: true,
        enableColumnMoving: true,
        paginationPageSizes: [25, 50, 100, 200, 500, 1000],
        paginationPageSize: 100,
        enableHorizontalScrollbar: 0,
        showGroupPanel: true,
        enableGridMenu: true,
        showFilter: true
    };

    var filters = {        
        'accessType': { condition: equalsFilter },
        'albumType': { condition: equalsFilter },
        'approvalType': { condition: equalsFilter },
        'approvedActivity': { condition: equalsFilter },
        'broaderTrainingArea': { condition: equalsFilter },
        'contentType': { condition: equalsFilter },
        'deliveryStatus': { condition: equalsFilter },
        'gallery': { condition: equalsFilter },
        'gender': { condition: equalsFilter },
        'geographicalArea': { condition: equalsFilter },
        'groupType': { condition: equalsFilter },
        'trainingType': { condition: equalsFilter },
        'trainingLevel': { condition: equalsFilter },
        'trainingStatus': { condition: equalsFilter },
        'fundingType': { condition: equalsFilter },
        'relationshipType': { condition: equalsFilter },
        'questionType': { condition: equalsFilter },
        'academicQualification': { condition: equalsFilter },
        'organizationType': { condition: equalsFilter },
        'thematicArea': { condition: equalsFilter },        
        'yesNo': { selectOptions: [{ label: 'Yes', value: 'true' }, { label: 'No', value: 'false' }] }
    };

    var participantGroups = ['Accepted', 'Rejected', 'Waiting', 'Attended', 'Absent', 'Evaluation', 'Group', 'Specific']

    function equalsFilter(searchTerm, cellValue) { return searchTerm === cellValue; }

    var keyCodes = {
        backspace: 8,
        tab: 9,
        enter: 13,
        esc: 27,
        space: 32,
        pageup: 33,
        pagedown: 34,
        end: 35,
        home: 36,
        left: 37,
        up: 38,
        right: 39,
        down: 40,
        insert: 45,
        del: 46
    };

    var salutations = ['Mr.', 'Ms.', 'Mrs.', 'Dr.', 'Engr.'];

    // For use with the HotTowel-Angular-Breeze add-on that uses Breeze
    var remoteServiceName = 'breeze/Breeze';

    var imageSettings =
    {
        imageBasePath: '../content/img/',
        unknownPersonImageSource: 'unknown_person.jpg'
    }            

    var polyOptions = {
        path: [],
        strokeColor: "#00BB00",
        strokeOpacity: 1,
        strokeWeight: 2
    }

    var events = {
        controllerActivateSuccess: 'controller.activateSuccess',
        spinnerToggle: 'spinner.toggle',
        hasChangesChanged: 'datacontext.hasChangesChanged',
        entitiesChanged: 'datacontext.entitiesChanged',
        //storage: {
        //    error: 'store.error',
        //    storeChanged: 'store.changed',
        //    wipChanged: 'wip.changed'
        //}
    };

    var config = {
        appErrorPrefix: '[Error] ', //Configure the exceptionHandler decorator
        docTitle: '',
        events: events,
        participantGroups: participantGroups,
        gridOptions: gridOptions,
        filters: filters,
        salutations: salutations,
        keyCodes: keyCodes,
        remoteServiceName: remoteServiceName,
        imageSettings: imageSettings,
        polyOptions: polyOptions,
        version: '2.1.0'
    };

    app.value('config', config);

    app.config(['uiGridConstants', function (uiGridConstants)
    {
        for (var key in filters)
            filters[key].type = uiGridConstants.filter.SELECT;

    }]);

    app.config(['$logProvider', function ($logProvider)
    {
        // turn debugging off/on (no info or warn)
        if ($logProvider.debugEnabled)
        {
            $logProvider.debugEnabled(true);
        }
    }]);

    //#region Configure the common services via commonConfig
    app.config(['commonConfigProvider', function (cfg)
    {
        cfg.config.controllerActivateSuccessEvent = config.events.controllerActivateSuccess;
        cfg.config.spinnerToggleEvent = config.events.spinnerToggle;
    }]);

    //#endregion

    app.config(['uiGmapGoogleMapApiProvider', function (uiGmapGoogleMapApiProvider)
    {
        uiGmapGoogleMapApiProvider.configure({
            key: 'AIzaSyBI_cUVZYejBbwyxda_tpAEue3OZ6-MD5w',
            v: '3.17',
            libraries: 'weather,geometry,visualization'
        });
    }]);


    //#region Configure Breeze Validation Directive
    app.config(['zDirectivesConfigProvider', function (cfg)
    {
        //cfg.zValidateTemplate = '<span class="invalid"><i class="fa fa-warning"></i>%error%</span>';
        //cfg.zRequiredTemplate = '<i class="icon-asterisk icon-asterisk-invalid z-required" title="Required"></i>';
    }]);

    app.filter('yesNo', function ()
    {
        return function (input)
        {
            return input ? 'Yes' : 'No';
        }
    });

    app.filter('successDanger', function ()
    {
        return function (input)
        {
            return input ? 'success' : 'danger';
        }
    });

    // Learning Point:
    // Can configure during config or app.run phase
    //app.run(['zDirectivesConfig', function(cfg) {
    //    cfg.zValidateTemplate =
    //                 '<span class="invalid"><i class="icon-warning-sign"></i>' +
    //                 'Inconceivable! %error%</span>';
    //}]);

    //#endregion
})();