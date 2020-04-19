/// <reference path="edit.js" />
(function()
{
    'use strict';

    var controllerId = 'training';

    angular.module('app').controller(controllerId,
        ['$scope', '$location', '$filter', '$window', '$routeParams', 'common', 'config',
         'datacontext', 'model', 'helper', 'uiGmapIsReady', training]);

    function training($scope, $location, $filter, $window, $routeParams, common, config,
        datacontext, model, helper, uiGmapIsReady)
    {
        var entity = 'Training';

        var vm = this;
        vm.title = 'Edit '+ entity;

        var entityName = model.entityNames.training;
        var logError = common.logger.getLogFn(controllerId, 'error');

        // Bindable properties and functions are placed on vm.
        vm.entity = undefined;
        vm.id = $routeParams.id;

        vm.goBack = goBack;
        vm.cancel = cancel;

        vm.hasChanges = false;
        vm.isSaving = false;
        vm.save = save;
        
        var allDistricts = [];
        var allCities = [];

        vm.provinces = [];
        vm.districts = [];
        vm.cities = [];
        vm.surveys = [];

        vm.trainingStatuses = [];
        vm.trainingTypes = [];
        vm.trainingLevels = [];
        vm.broaderTrainingAreas = [];

        vm.organizations = [];
        vm.trainingOrganizationsOriginal = [];

        vm.provinceChanged = provinceChanged;
        vm.districtChanged = districtChanged;

        vm.activate = activate;
        vm.placeMarker = placeMarker;

        var isReady = false;
        var marker = undefined;
        var gMap = null;

        vm.map = {  center: { latitude: 31, longitude: 71 }, 
            zoom: 5,
            markers:[{
                id: 0,
                latitude: 31,
                longitude: 71,
                options: {
                    //labelContent: 'Training Location',
                    //labelAnchor: "50 5"
                    //labelClass: "marker-labels"
                },
                control: {}
            }],
            control: {},
            events: { click: mapClicked }
        };

        vm.gridOptions = config.gridOptions;

        vm.gridOptions.columnDefs = [
            { field: 'organizationId', name: ' ', cellTemplate: 'app/organization/edit-button.html', width: 45, visible:false, enableFiltering: false, enableSorting: false },
            { field: 'name' },
            { field: 'organizationType.name', name: 'Organization Type', filter: config.filters['organizationType'] },
            { field: 'relationshipType', filter: config.filters['relationshipType'] },
            { field: 'headName' }
        ];

        vm.gridApi = null;
        vm.gridOptions.onRegisterApi = onRegisterApi;

        function onRegisterApi(gridApi)
        {
            vm.gridApi = gridApi;

            if (vm.gridApi.selection)
            {
                vm.gridApi.selection.on.rowSelectionChanged($scope, function (row)
                {
                    vm.hasChanges = true;
                });

                vm.gridApi.selection.on.rowSelectionChangedBatch($scope, function (rows)
                {
                    vm.hasChanges = true;
                });
            }
        }
 
        // vm.canSave Property
        Object.defineProperty(vm, 'canSave', {
            get: canSave
        });

        function canSave()
        {
            return vm.hasChanges && !vm.isSaving;
        }

        uiGmapIsReady.promise().then(function (maps) {
            isReady = true;
            gMap = vm.map.control.getGMap();

            if(config.polyOptions.path.length == 0)
                config.polyOptions.path = [
                    new google.maps.LatLng(25.264568, 61.622314),
                    new google.maps.LatLng(25.363882, 61.644287),
                    new google.maps.LatLng(25.720735, 61.699219),
                    new google.maps.LatLng(25.740529, 61.721191),
                    new google.maps.LatLng(25.720735, 61.776123),
                    new google.maps.LatLng(25.740529, 61.809082),
                    new google.maps.LatLng(25.780107, 61.820068),
                    new google.maps.LatLng(25.819672, 61.831055),
                    new google.maps.LatLng(25.849337, 61.831055),
                    new google.maps.LatLng(25.878994, 61.853027),
                    new google.maps.LatLng(25.888879, 61.875000),
                    new google.maps.LatLng(25.918526, 61.853027),
                    new google.maps.LatLng(25.918526, 61.820068),
                    new google.maps.LatLng(25.948166, 61.820068),
                    new google.maps.LatLng(25.997550, 61.831055),
                    new google.maps.LatLng(26.066652, 61.853027),
                    new google.maps.LatLng(26.145576, 61.853027),
                    new google.maps.LatLng(26.204734, 61.875000),
                    new google.maps.LatLng(26.254010, 61.896973),
                    new google.maps.LatLng(26.283565, 61.929932),
                    new google.maps.LatLng(26.273714, 61.951904),
                    new google.maps.LatLng(26.293415, 61.973877),
                    new google.maps.LatLng(26.313113, 61.984863),
                    new google.maps.LatLng(26.322960, 62.028809),
                    new google.maps.LatLng(26.342653, 62.050781),
                    new google.maps.LatLng(26.313113, 62.072754),
                    new google.maps.LatLng(26.263862, 62.116699),
                    new google.maps.LatLng(26.263862, 62.160645),
                    new google.maps.LatLng(26.263862, 62.193604),
                    new google.maps.LatLng(26.313113, 62.204590),
                    new google.maps.LatLng(26.322960, 62.226563),
                    new google.maps.LatLng(26.332807, 62.248535),
                    new google.maps.LatLng(26.352498, 62.237549),
                    new google.maps.LatLng(26.362342, 62.259521),
                    new google.maps.LatLng(26.391870, 62.270508),
                    new google.maps.LatLng(26.441066, 62.248535),
                    new google.maps.LatLng(26.450902, 62.281494),
                    new google.maps.LatLng(26.519735, 62.314453),
                    new google.maps.LatLng(26.529565, 62.391357),
                    new google.maps.LatLng(26.559050, 62.435303),
                    new google.maps.LatLng(26.568877, 62.589111),
                    new google.maps.LatLng(26.617997, 62.644043),
                    new google.maps.LatLng(26.608174, 62.731934),
                    new google.maps.LatLng(26.657278, 62.764893),
                    new google.maps.LatLng(26.637639, 62.918701),
                    new google.maps.LatLng(26.627818, 63.006592),
                    new google.maps.LatLng(26.647459, 63.094482),
                    new google.maps.LatLng(26.647459, 63.149414),
                    new google.maps.LatLng(26.647459, 63.193359),
                    new google.maps.LatLng(26.725987, 63.171387),
                    new google.maps.LatLng(26.765231, 63.193359),
                    new google.maps.LatLng(26.824071, 63.171387),
                    new google.maps.LatLng(26.843677, 63.226318),
                    new google.maps.LatLng(27.088473, 63.237305),
                    new google.maps.LatLng(27.137368, 63.325195),
                    new google.maps.LatLng(27.225326, 63.259277),
                    new google.maps.LatLng(27.244863, 63.215332),
                    new google.maps.LatLng(27.274161, 63.160400),
                    new google.maps.LatLng(27.225326, 63.094482),
                    new google.maps.LatLng(27.225326, 63.039551),
                    new google.maps.LatLng(27.205786, 62.962646),
                    new google.maps.LatLng(27.196014, 62.918701),
                    new google.maps.LatLng(27.225326, 62.885742),
                    new google.maps.LatLng(27.225326, 62.819824),
                    new google.maps.LatLng(27.264396, 62.786865),
                    new google.maps.LatLng(27.313214, 62.797852),
                    new google.maps.LatLng(27.352253, 62.786865),
                    new google.maps.LatLng(27.469287, 62.830811),
                    new google.maps.LatLng(27.800210, 62.808838),
                    new google.maps.LatLng(28.023500, 62.753906),
                    new google.maps.LatLng(28.294707, 62.797852),
                    new google.maps.LatLng(28.256006, 62.611084),
                    new google.maps.LatLng(28.372069, 62.479248),
                    new google.maps.LatLng(28.439714, 62.380371),
                    new google.maps.LatLng(28.545926, 61.918945),
                    new google.maps.LatLng(28.738764, 61.732178),
                    new google.maps.LatLng(28.806174, 61.633301),
                    new google.maps.LatLng(28.921631, 61.567383),
                    new google.maps.LatLng(29.017748, 61.501465),
                    new google.maps.LatLng(29.113775, 61.424561),
                    new google.maps.LatLng(29.276816, 61.347656),
                    new google.maps.LatLng(29.391748, 61.369629),
                    new google.maps.LatLng(29.420460, 61.281738),
                    new google.maps.LatLng(29.859701, 60.875244),
                    new google.maps.LatLng(29.401320, 62.446289),
                    new google.maps.LatLng(29.458731, 63.193359),
                    new google.maps.LatLng(29.449165, 63.303223),
                    new google.maps.LatLng(29.477861, 63.457031),
                    new google.maps.LatLng(29.506549, 63.588867),
                    new google.maps.LatLng(29.391748, 64.116211),
                    new google.maps.LatLng(29.439598, 64.171143),
                    new google.maps.LatLng(29.468297, 64.160156),
                    new google.maps.LatLng(29.496988, 64.193115),
                    new google.maps.LatLng(29.496988, 64.237061),
                    new google.maps.LatLng(29.516110, 64.281006),
                    new google.maps.LatLng(29.516110, 64.335938),
                    new google.maps.LatLng(29.535230, 64.368896),
                    new google.maps.LatLng(29.554345, 64.423828),
                    new google.maps.LatLng(29.563902, 64.478760),
                    new google.maps.LatLng(29.573457, 64.544678),
                    new google.maps.LatLng(29.583012, 64.610596),
                    new google.maps.LatLng(29.535230, 65.050049),
                    new google.maps.LatLng(29.859701, 66.247559),
                    new google.maps.LatLng(29.945415, 66.346436),
                    new google.maps.LatLng(30.078601, 66.236572),
                    new google.maps.LatLng(30.363396, 66.324463),
                    new google.maps.LatLng(30.420256, 66.357422),
                    new google.maps.LatLng(30.477083, 66.346436),
                    new google.maps.LatLng(30.524413, 66.291504),
                    new google.maps.LatLng(30.600094, 66.258545),
                    new google.maps.LatLng(30.939924, 66.379395),
                    new google.maps.LatLng(30.987028, 66.577148),
                    new google.maps.LatLng(31.071756, 66.643066),
                    new google.maps.LatLng(31.128199, 66.708984),
                    new google.maps.LatLng(31.212801, 66.719971),
                    new google.maps.LatLng(31.231592, 66.774902),
                    new google.maps.LatLng(31.259770, 66.807861),
                    new google.maps.LatLng(31.278551, 66.862793),
                    new google.maps.LatLng(31.306715, 66.972656),
                    new google.maps.LatLng(31.316101, 67.038574),
                    new google.maps.LatLng(31.259770, 67.027588),
                    new google.maps.LatLng(31.222197, 67.082520),
                    new google.maps.LatLng(31.250378, 67.159424),
                    new google.maps.LatLng(31.212801, 67.280273),
                    new google.maps.LatLng(31.222197, 67.401123),
                    new google.maps.LatLng(31.231592, 67.467041),
                    new google.maps.LatLng(31.269161, 67.631836),
                    new google.maps.LatLng(31.334871, 67.697754),
                    new google.maps.LatLng(31.334871, 67.785645),
                    new google.maps.LatLng(31.409912, 67.763672),
                    new google.maps.LatLng(31.428663, 67.730713),
                    new google.maps.LatLng(31.400535, 67.631836),
                    new google.maps.LatLng(31.428663, 67.598877),
                    new google.maps.LatLng(31.531726, 67.565918),
                    new google.maps.LatLng(31.503629, 67.697754),
                    new google.maps.LatLng(31.597253, 67.818604),
                    new google.maps.LatLng(31.653381, 67.972412),
                    new google.maps.LatLng(31.690782, 68.060303),
                    new google.maps.LatLng(31.830899, 68.159180),
                    new google.maps.LatLng(31.793555, 68.247070),
                    new google.maps.LatLng(31.774878, 68.269043),
                    new google.maps.LatLng(31.756196, 68.422852),
                    new google.maps.LatLng(31.821565, 68.565674),
                    new google.maps.LatLng(31.765537, 68.631592),
                    new google.maps.LatLng(31.765537, 68.686523),
                    new google.maps.LatLng(31.700130, 68.719482),
                    new google.maps.LatLng(31.653381, 68.774414),
                    new google.maps.LatLng(31.606610, 68.829346),
                    new google.maps.LatLng(31.615966, 68.873291),
                    new google.maps.LatLng(31.597253, 68.906250),
                    new google.maps.LatLng(31.644029, 68.950195),
                    new google.maps.LatLng(31.615966, 68.994141),
                    new google.maps.LatLng(31.681433, 69.104004),
                    new google.maps.LatLng(31.746854, 69.125977),
                    new google.maps.LatLng(31.765537, 69.169922),
                    new google.maps.LatLng(31.849565, 69.191895),
                    new google.maps.LatLng(31.924193, 69.290771),
                    new google.maps.LatLng(31.933517, 69.323730),
                    new google.maps.LatLng(32.119801, 69.279785),
                    new google.maps.LatLng(32.352123, 69.279785),
                    new google.maps.LatLng(32.463426, 69.235840),
                    new google.maps.LatLng(32.537552, 69.279785),
                    new google.maps.LatLng(32.565333, 69.378662),
                    new google.maps.LatLng(32.657876, 69.444580),
                    new google.maps.LatLng(32.722599, 69.433594),
                    new google.maps.LatLng(32.778038, 69.389648),
                    new google.maps.LatLng(32.814978, 69.433594),
                    new google.maps.LatLng(32.861132, 69.455566),
                    new google.maps.LatLng(32.870360, 69.521484),
                    new google.maps.LatLng(32.916485, 69.477539),
                    new google.maps.LatLng(33.036298, 69.488525),
                    new google.maps.LatLng(33.091542, 69.565430),
                    new google.maps.LatLng(33.100745, 69.708252),
                    new google.maps.LatLng(33.128351, 69.796143),
                    new google.maps.LatLng(33.109948, 69.927979),
                    new google.maps.LatLng(33.137551, 69.938965),
                    new google.maps.LatLng(33.137551, 70.004883),
                    new google.maps.LatLng(33.220308, 70.048828),
                    new google.maps.LatLng(33.201924, 70.136719),
                    new google.maps.LatLng(33.330528, 70.290527),
                    new google.maps.LatLng(33.330528, 70.334473),
                    new google.maps.LatLng(33.367237, 70.312500),
                    new google.maps.LatLng(33.394759, 70.323486),
                    new google.maps.LatLng(33.431441, 70.290527),
                    new google.maps.LatLng(33.440609, 70.257568),
                    new google.maps.LatLng(33.468108, 70.235596),
                    new google.maps.LatLng(33.477272, 70.202637),
                    new google.maps.LatLng(33.504759, 70.191650),
                    new google.maps.LatLng(33.513919, 70.169678),
                    new google.maps.LatLng(33.642063, 70.202637),
                    new google.maps.LatLng(33.660353, 70.125732),
                    new google.maps.LatLng(33.724340, 70.136719),
                    new google.maps.LatLng(33.733477, 70.004883),
                    new google.maps.LatLng(33.824794, 69.938965),
                    new google.maps.LatLng(33.888658, 69.916992),
                    new google.maps.LatLng(33.934245, 69.840088),
                    new google.maps.LatLng(33.970698, 69.862061),
                    new google.maps.LatLng(33.998027, 69.873047),
                    new google.maps.LatLng(34.034453, 69.895020),
                    new google.maps.LatLng(34.034453, 69.960938),
                    new google.maps.LatLng(34.016242, 70.059814),
                    new google.maps.LatLng(34.025348, 70.147705),
                    new google.maps.LatLng(33.998027, 70.191650),
                    new google.maps.LatLng(33.998027, 70.268555),
                    new google.maps.LatLng(33.961586, 70.356445),
                    new google.maps.LatLng(33.961586, 70.422363),
                    new google.maps.LatLng(33.925130, 70.477295),
                    new google.maps.LatLng(33.952474, 70.488281),
                    new google.maps.LatLng(33.952474, 70.532227),
                    new google.maps.LatLng(33.934245, 70.532227),
                    new google.maps.LatLng(33.970698, 70.576172),
                    new google.maps.LatLng(33.970698, 70.773926),
                    new google.maps.LatLng(33.988918, 70.828857),
                    new google.maps.LatLng(33.979809, 70.872803),
                    new google.maps.LatLng(34.007135, 70.916748),
                    new google.maps.LatLng(34.043557, 70.960693),
                    new google.maps.LatLng(34.007135, 70.982666),
                    new google.maps.LatLng(34.043557, 71.015625),
                    new google.maps.LatLng(34.043557, 71.070557),
                    new google.maps.LatLng(34.116352, 71.070557),
                    new google.maps.LatLng(34.152727, 71.114502),
                    new google.maps.LatLng(34.234512, 71.114502),
                    new google.maps.LatLng(34.261757, 71.114502),
                    new google.maps.LatLng(34.343436, 71.158447),
                    new google.maps.LatLng(34.379713, 71.158447),
                    new google.maps.LatLng(34.379713, 71.114502),
                    new google.maps.LatLng(34.434098, 71.114502),
                    new google.maps.LatLng(34.443159, 71.048584),
                    new google.maps.LatLng(34.524661, 70.993652),
                    new google.maps.LatLng(34.560859, 71.004639),
                    new google.maps.LatLng(34.578952, 71.059570),
                    new google.maps.LatLng(34.615127, 71.092529),
                    new google.maps.LatLng(34.669359, 71.092529),
                    new google.maps.LatLng(34.705493, 71.092529),
                    new google.maps.LatLng(34.723555, 71.136475),
                    new google.maps.LatLng(34.750640, 71.169434),
                    new google.maps.LatLng(34.768691, 71.224365),
                    new google.maps.LatLng(34.804783, 71.268311),
                    new google.maps.LatLng(34.894942, 71.301270),
                    new google.maps.LatLng(34.930979, 71.367188),
                    new google.maps.LatLng(34.957995, 71.477051),
                    new google.maps.LatLng(34.976002, 71.510010),
                    new google.maps.LatLng(35.012002, 71.504517),
                    new google.maps.LatLng(35.034494, 71.548462),
                    new google.maps.LatLng(35.083956, 71.526489),
                    new google.maps.LatLng(35.124402, 71.559448),
                    new google.maps.LatLng(35.137879, 71.581421),
                    new google.maps.LatLng(35.151354, 71.619873),
                    new google.maps.LatLng(35.178298, 71.630859),
                    new google.maps.LatLng(35.205233, 71.674805),
                    new google.maps.LatLng(35.223185, 71.674805),
                    new google.maps.LatLng(35.232159, 71.647339),
                    new google.maps.LatLng(35.250105, 71.630859),
                    new google.maps.LatLng(35.290469, 71.548462),
                    new google.maps.LatLng(35.308401, 71.542969),
                    new google.maps.LatLng(35.402484, 71.608887),
                    new google.maps.LatLng(35.406961, 71.625366),
                    new google.maps.LatLng(35.438296, 71.647339),
                    new google.maps.LatLng(35.483038, 71.608887),
                    new google.maps.LatLng(35.496456, 71.597900),
                    new google.maps.LatLng(35.518814, 71.592407),
                    new google.maps.LatLng(35.532226, 71.592407),
                    new google.maps.LatLng(35.545636, 71.608887),
                    new google.maps.LatLng(35.567980, 71.614380),
                    new google.maps.LatLng(35.581384, 71.614380),
                    new google.maps.LatLng(35.590319, 71.592407),
                    new google.maps.LatLng(35.590319, 71.564941),
                    new google.maps.LatLng(35.608185, 71.542969),
                    new google.maps.LatLng(35.626047, 71.493530),
                    new google.maps.LatLng(35.666222, 71.499023),
                    new google.maps.LatLng(35.679610, 71.526489),
                    new google.maps.LatLng(35.692995, 71.548462),
                    new google.maps.LatLng(35.719758, 71.548462),
                    new google.maps.LatLng(35.759886, 71.488037),
                    new google.maps.LatLng(35.786627, 71.471558),
                    new google.maps.LatLng(35.799994, 71.499023),
                    new google.maps.LatLng(35.817813, 71.471558),
                    new google.maps.LatLng(35.848987, 71.449585),
                    new google.maps.LatLng(35.875698, 71.438599),
                    new google.maps.LatLng(35.889050, 71.422119),
                    new google.maps.LatLng(35.897950, 71.389160),
                    new google.maps.LatLng(35.924645, 71.367188),
                    new google.maps.LatLng(35.942436, 71.383667),
                    new google.maps.LatLng(35.955777, 71.378174),
                    new google.maps.LatLng(35.973561, 71.372681),
                    new google.maps.LatLng(35.969115, 71.317749),
                    new google.maps.LatLng(36.009117, 71.279297),
                    new google.maps.LatLng(36.026889, 71.235352),
                    new google.maps.LatLng(36.040216, 71.196899),
                    new google.maps.LatLng(36.093499, 71.207886),
                    new google.maps.LatLng(36.097938, 71.240845),
                    new google.maps.LatLng(36.111253, 71.240845),
                    new google.maps.LatLng(36.129002, 71.251831),
                    new google.maps.LatLng(36.168923, 71.317749),
                    new google.maps.LatLng(36.160053, 71.345215),
                    new google.maps.LatLng(36.204391, 71.361694),
                    new google.maps.LatLng(36.230981, 71.433105),
                    new google.maps.LatLng(36.266421, 71.438599),
                    new google.maps.LatLng(36.288563, 71.471558),
                    new google.maps.LatLng(36.310699, 71.510010),
                    new google.maps.LatLng(36.341678, 71.526489),
                    new google.maps.LatLng(36.332828, 71.575928),
                    new google.maps.LatLng(36.341678, 71.581421),
                    new google.maps.LatLng(36.350527, 71.592407),
                    new google.maps.LatLng(36.372645, 71.553955),
                    new google.maps.LatLng(36.412442, 71.625366),
                    new google.maps.LatLng(36.443380, 71.614380),
                    new google.maps.LatLng(36.447799, 71.636353),
                    new google.maps.LatLng(36.478724, 71.641846),
                    new google.maps.LatLng(36.483141, 71.663818),
                    new google.maps.LatLng(36.403600, 71.790161),
                    new google.maps.LatLng(36.430122, 71.817627),
                    new google.maps.LatLng(36.500805, 71.801147),
                    new google.maps.LatLng(36.509636, 71.806641),
                    new google.maps.LatLng(36.509636, 71.883545),
                    new google.maps.LatLng(36.514051, 71.911011),
                    new google.maps.LatLng(36.553775, 71.932983),
                    new google.maps.LatLng(36.567012, 71.998901),
                    new google.maps.LatLng(36.593479, 72.026367),
                    new google.maps.LatLng(36.593479, 72.070313),
                    new google.maps.LatLng(36.655200, 72.092285),
                    new google.maps.LatLng(36.668419, 72.152710),
                    new google.maps.LatLng(36.659606, 72.191162),
                    new google.maps.LatLng(36.708064, 72.185669),
                    new google.maps.LatLng(36.721274, 72.185669),
                    new google.maps.LatLng(36.721274, 72.213135),
                    new google.maps.LatLng(36.747688, 72.240601),
                    new google.maps.LatLng(36.734482, 72.284546),
                    new google.maps.LatLng(36.765292, 72.328491),
                    new google.maps.LatLng(36.760891, 72.366943),
                    new google.maps.LatLng(36.774092, 72.399902),
                    new google.maps.LatLng(36.774092, 72.487793),
                    new google.maps.LatLng(36.835668, 72.542725),
                    new google.maps.LatLng(36.831272, 72.586670),
                    new google.maps.LatLng(36.857648, 72.636108),
                    new google.maps.LatLng(36.844461, 72.685547),
                    new google.maps.LatLng(36.831272, 72.718506),
                    new google.maps.LatLng(36.848857, 72.740479),
                    new google.maps.LatLng(36.857648, 72.767944),
                    new google.maps.LatLng(36.853252, 72.806396),
                    new google.maps.LatLng(36.844461, 72.910767),
                    new google.maps.LatLng(36.875227, 72.954712),
                    new google.maps.LatLng(36.866438, 73.026123),
                    new google.maps.LatLng(36.870832, 73.053589),
                    new google.maps.LatLng(36.888408, 73.075562),
                    new google.maps.LatLng(36.888408, 73.119507),
                    new google.maps.LatLng(36.901587, 73.141479),
                    new google.maps.LatLng(36.884014, 73.179932),
                    new google.maps.LatLng(36.892801, 73.267822),
                    new google.maps.LatLng(36.870832, 73.289795),
                    new google.maps.LatLng(36.888408, 73.333740),
                    new google.maps.LatLng(36.888408, 73.366699),
                    new google.maps.LatLng(36.897194, 73.399658),
                    new google.maps.LatLng(36.892801, 73.449097),
                    new google.maps.LatLng(36.884014, 73.515015),
                    new google.maps.LatLng(36.862043, 73.542480),
                    new google.maps.LatLng(36.884014, 73.553467),
                    new google.maps.LatLng(36.892801, 73.575439),
                    new google.maps.LatLng(36.910372, 73.602905),
                    new google.maps.LatLng(36.897194, 73.619385),
                    new google.maps.LatLng(36.923548, 73.685303),
                    new google.maps.LatLng(36.910372, 73.751221),
                    new google.maps.LatLng(36.897194, 73.800659),
                    new google.maps.LatLng(36.932330, 73.833618),
                    new google.maps.LatLng(36.910372, 73.894043),
                    new google.maps.LatLng(36.884014, 73.888550),
                    new google.maps.LatLng(36.866438, 73.916016),
                    new google.maps.LatLng(36.870832, 73.927002),
                    new google.maps.LatLng(36.857648, 73.948975),
                    new google.maps.LatLng(36.831272, 73.965454),
                    new google.maps.LatLng(36.840065, 73.992920),
                    new google.maps.LatLng(36.822478, 74.036865),
                    new google.maps.LatLng(36.840065, 74.058838),
                    new google.maps.LatLng(36.840065, 74.124756),
                    new google.maps.LatLng(36.888408, 74.157715),
                    new google.maps.LatLng(36.914764, 74.174194),
                    new google.maps.LatLng(36.901587, 74.245605),
                    new google.maps.LatLng(36.923548, 74.306030),
                    new google.maps.LatLng(36.963060, 74.355469),
                    new google.maps.LatLng(36.963060, 74.388428),
                    new google.maps.LatLng(36.971838, 74.415894),
                    new google.maps.LatLng(37.002553, 74.421387),
                    new google.maps.LatLng(37.006939, 74.432373),
                    new google.maps.LatLng(36.971838, 74.509277),
                    new google.maps.LatLng(36.963060, 74.536743),
                    new google.maps.LatLng(37.011326, 74.520264),
                    new google.maps.LatLng(37.033255, 74.558716),
                    new google.maps.LatLng(37.037640, 74.586182),
                    new google.maps.LatLng(37.055177, 74.630127),
                    new google.maps.LatLng(37.077093, 74.668579),
                    new google.maps.LatLng(37.085858, 74.701538),
                    new google.maps.LatLng(37.042024, 74.723511),
                    new google.maps.LatLng(37.020098, 74.756470),
                    new google.maps.LatLng(37.020098, 74.789429),
                    new google.maps.LatLng(37.046409, 74.805908),
                    new google.maps.LatLng(37.059561, 74.838867),
                    new google.maps.LatLng(36.971838, 74.871826),
                    new google.maps.LatLng(36.941111, 74.888306),
                    new google.maps.LatLng(36.941111, 74.910278),
                    new google.maps.LatLng(36.971838, 74.921265),
                    new google.maps.LatLng(36.989391, 74.948730),
                    new google.maps.LatLng(36.993778, 74.987183),
                    new google.maps.LatLng(37.002553, 75.047607),
                    new google.maps.LatLng(37.006939, 75.102539),
                    new google.maps.LatLng(37.020098, 75.135498),
                    new google.maps.LatLng(36.985003, 75.190430),
                    new google.maps.LatLng(36.958671, 75.234375),
                    new google.maps.LatLng(36.958671, 75.294800),
                    new google.maps.LatLng(36.954282, 75.371704),
                    new google.maps.LatLng(36.949892, 75.393677),
                    new google.maps.LatLng(36.919156, 75.388184),
                    new google.maps.LatLng(36.879621, 75.415649),
                    new google.maps.LatLng(36.826875, 75.421143),
                    new google.maps.LatLng(36.782892, 75.421143),
                    new google.maps.LatLng(36.734482, 75.454102),
                    new google.maps.LatLng(36.712467, 75.459595),
                    new google.maps.LatLng(36.743286, 75.498047),
                    new google.maps.LatLng(36.725677, 75.525513),
                    new google.maps.LatLng(36.760891, 75.531006),
                    new google.maps.LatLng(36.769692, 75.569458),
                    new google.maps.LatLng(36.765292, 75.629883),
                    new google.maps.LatLng(36.747688, 75.745239),
                    new google.maps.LatLng(36.672825, 75.855103),
                    new google.maps.LatLng(36.615528, 75.910034),
                    new google.maps.LatLng(36.350527, 76.267090),
                    new google.maps.LatLng(36.288563, 76.409912),
                    new google.maps.LatLng(36.208823, 76.541748),
                    new google.maps.LatLng(36.137875, 76.695557),
                    new google.maps.LatLng(36.075742, 76.783447),
                    new google.maps.LatLng(36.031332, 76.788940),
                    new google.maps.LatLng(35.986896, 76.755981),
                    new google.maps.LatLng(35.942436, 76.755981),
                    new google.maps.LatLng(35.889050, 76.794434),
                    new google.maps.LatLng(35.822267, 76.876831),
                    new google.maps.LatLng(35.791083, 76.959229),
                    new google.maps.LatLng(35.768801, 77.014160),
                    new google.maps.LatLng(35.733136, 77.025146),
                    new google.maps.LatLng(35.719758, 77.069092),
                    new google.maps.LatLng(35.733136, 77.102051),
                    new google.maps.LatLng(35.715298, 77.151489),
                    new google.maps.LatLng(35.733136, 77.184448),
                    new google.maps.LatLng(35.728677, 77.228394),
                    new google.maps.LatLng(35.710838, 77.244873),
                    new google.maps.LatLng(35.706377, 77.283325),
                    new google.maps.LatLng(35.697456, 77.316284),
                    new google.maps.LatLng(35.719758, 77.343750),
                    new google.maps.LatLng(35.706377, 77.393188),
                    new google.maps.LatLng(35.675147, 77.420654),
                    new google.maps.LatLng(35.643905, 77.442627),
                    new google.maps.LatLng(35.599252, 77.442627),
                    new google.maps.LatLng(35.572449, 77.470093),
                    new google.maps.LatLng(35.545636, 77.448120),
                    new google.maps.LatLng(35.554574, 77.415161),
                    new google.maps.LatLng(35.554574, 77.387695),
                    new google.maps.LatLng(35.554574, 77.365723),
                    new google.maps.LatLng(35.532226, 77.349243),
                    new google.maps.LatLng(35.505400, 77.343750),
                    new google.maps.LatLng(35.483038, 77.382202),
                    new google.maps.LatLng(35.478565, 77.420654),
                    new google.maps.LatLng(35.465144, 77.437134),
                    new google.maps.LatLng(35.474092, 77.470093),
                    new google.maps.LatLng(35.483038, 77.514038),
                    new google.maps.LatLng(35.474092, 77.563477),
                    new google.maps.LatLng(35.465144, 77.623901),
                    new google.maps.LatLng(35.483038, 77.640381),
                    new google.maps.LatLng(35.456196, 77.695313),
                    new google.maps.LatLng(35.496456, 77.733765),
                    new google.maps.LatLng(35.518814, 77.805176),
                    new google.maps.LatLng(35.469618, 77.898560),
                    new google.maps.LatLng(35.487511, 77.915039),
                    new google.maps.LatLng(35.554574, 77.931519),
                    new google.maps.LatLng(35.567980, 77.975464),
                    new google.maps.LatLng(35.567980, 78.019409),
                    new google.maps.LatLng(35.585852, 78.041382),
                    new google.maps.LatLng(35.563512, 78.079834),
                    new google.maps.LatLng(35.550105, 78.129272),
                    new google.maps.LatLng(35.559043, 78.156738),
                    new google.maps.LatLng(35.599252, 78.162231),
                    new google.maps.LatLng(35.724218, 78.244629),
                    new google.maps.LatLng(35.733136, 78.398438),
                    new google.maps.LatLng(35.786627, 78.436890),
                    new google.maps.LatLng(35.759886, 78.469849),
                    new google.maps.LatLng(35.773258, 78.552246),
                    new google.maps.LatLng(35.822267, 78.645630),
                    new google.maps.LatLng(35.862344, 78.706055),
                    new google.maps.LatLng(35.866795, 78.766479),
                    new google.maps.LatLng(35.866795, 78.793945),
                    new google.maps.LatLng(35.973561, 78.859863),
                    new google.maps.LatLng(35.915747, 79.013672),
                    new google.maps.LatLng(35.951330, 79.255371),
                    new google.maps.LatLng(35.986896, 79.365234),
                    new google.maps.LatLng(35.951330, 79.453125),
                    new google.maps.LatLng(35.853440, 79.486084),
                    new google.maps.LatLng(35.906849, 79.573975),
                    new google.maps.LatLng(35.782171, 79.628906),
                    new google.maps.LatLng(35.666222, 79.672852),
                    new google.maps.LatLng(35.630512, 79.782715),
                    new google.maps.LatLng(35.612651, 79.848633),
                    new google.maps.LatLng(35.648369, 79.947510),
                    new google.maps.LatLng(35.433820, 80.024414),
                    new google.maps.LatLng(35.541166, 80.167236),
                    new google.maps.LatLng(35.559043, 80.321045),
                    new google.maps.LatLng(35.478565, 80.408936),
                    new google.maps.LatLng(35.389050, 80.354004),
                    new google.maps.LatLng(35.353216, 80.288086),
                    new google.maps.LatLng(35.281501, 80.277100),
                    new google.maps.LatLng(35.236646, 80.321045),
                    new google.maps.LatLng(35.200745, 80.266113),
                    new google.maps.LatLng(35.128894, 80.211182),
                    new google.maps.LatLng(35.038992, 80.222168),
                    new google.maps.LatLng(34.939985, 80.189209),
                    new google.maps.LatLng(34.876918, 80.167236),
                    new google.maps.LatLng(34.786739, 80.112305),
                    new google.maps.LatLng(34.714525, 80.057373),
                    new google.maps.LatLng(34.696461, 79.958496),
                    new google.maps.LatLng(34.642247, 79.771729),
                    new google.maps.LatLng(34.497503, 79.826660),
                    new google.maps.LatLng(34.461277, 79.650879),
                    new google.maps.LatLng(34.488448, 79.530029),
                    new google.maps.LatLng(34.434098, 79.508057),
                    new google.maps.LatLng(34.352507, 79.584961),
                    new google.maps.LatLng(34.261757, 79.584961),
                    new google.maps.LatLng(34.179998, 79.530029),
                    new google.maps.LatLng(34.098159, 79.453125),
                    new google.maps.LatLng(34.052659, 79.420166),
                    new google.maps.LatLng(33.979809, 79.343262),
                    new google.maps.LatLng(34.007135, 79.255371),
                    new google.maps.LatLng(33.979809, 79.145508),
                    new google.maps.LatLng(33.979809, 79.068604),
                    new google.maps.LatLng(34.016242, 78.936768),
                    new google.maps.LatLng(33.979809, 78.903809),
                    new google.maps.LatLng(33.870416, 78.936768),
                    new google.maps.LatLng(33.760882, 79.013672),
                    new google.maps.LatLng(33.678640, 79.068604),
                    new google.maps.LatLng(33.605470, 79.024658),
                    new google.maps.LatLng(33.632916, 78.925781),
                    new google.maps.LatLng(33.477272, 78.925781),
                    new google.maps.LatLng(33.376412, 78.936768),
                    new google.maps.LatLng(33.293804, 79.024658),
                    new google.maps.LatLng(33.183537, 79.112549),
                    new google.maps.LatLng(33.211116, 79.189453),
                    new google.maps.LatLng(33.220308, 79.288330),
                    new google.maps.LatLng(33.165145, 79.409180),
                    new google.maps.LatLng(33.045508, 79.321289),
                    new google.maps.LatLng(32.916485, 79.398193),
                    new google.maps.LatLng(32.796510, 79.519043),
                    new google.maps.LatLng(32.722599, 79.552002),
                    new google.maps.LatLng(32.620870, 79.475098),
                    new google.maps.LatLng(32.537552, 79.431152),
                    new google.maps.LatLng(32.519026, 79.354248),
                    new google.maps.LatLng(32.546813, 79.288330),
                    new google.maps.LatLng(32.546813, 79.222412),
                    new google.maps.LatLng(32.500496, 79.167480),
                    new google.maps.LatLng(32.472695, 79.101563),
                    new google.maps.LatLng(32.379961, 79.101563),
                    new google.maps.LatLng(32.379961, 79.024658),
                    new google.maps.LatLng(32.361403, 78.969727),
                    new google.maps.LatLng(32.389239, 78.892822),
                    new google.maps.LatLng(32.444885, 78.815918),
                    new google.maps.LatLng(32.602362, 78.760986),
                    new google.maps.LatLng(32.676373, 78.739014),
                    new google.maps.LatLng(32.639375, 78.651123),
                    new google.maps.LatLng(32.620870, 78.541260),
                    new google.maps.LatLng(32.593106, 78.475342),
                    new google.maps.LatLng(32.556074, 78.398438),
                    new google.maps.LatLng(32.509762, 78.343506),
                    new google.maps.LatLng(32.491230, 78.277588),
                    new google.maps.LatLng(32.556074, 78.288574),
                    new google.maps.LatLng(32.639375, 78.376465),
                    new google.maps.LatLng(32.722599, 78.365479),
                    new google.maps.LatLng(32.768800, 78.321533),
                    new google.maps.LatLng(32.713355, 78.222656),
                    new google.maps.LatLng(32.630123, 78.046875),
                    new google.maps.LatLng(32.620870, 77.980957),
                    new google.maps.LatLng(33.017876, 77.728271),
                    new google.maps.LatLng(32.888813, 77.431641),
                    new google.maps.LatLng(32.879587, 77.354736),
                    new google.maps.LatLng(33.008663, 76.992188),
                    new google.maps.LatLng(33.201924, 76.750488),
                    new google.maps.LatLng(33.247876, 76.530762),
                    new google.maps.LatLng(33.201924, 76.420898),
                    new google.maps.LatLng(33.155948, 76.300049),
                    new google.maps.LatLng(33.082337, 76.267090),
                    new google.maps.LatLng(33.008663, 76.135254),
                    new google.maps.LatLng(32.925707, 76.014404),
                    new google.maps.LatLng(32.916485, 75.926514),
                    new google.maps.LatLng(32.971804, 75.849609),
                    new google.maps.LatLng(32.907262, 75.805664),
                    new google.maps.LatLng(32.833443, 75.849609),
                    new google.maps.LatLng(32.741082, 75.893555),
                    new google.maps.LatLng(32.639375, 75.860596),
                    new google.maps.LatLng(32.574592, 75.871582),
                    new google.maps.LatLng(32.500496, 75.816650),
                    new google.maps.LatLng(32.435613, 75.728760),
                    new google.maps.LatLng(32.389239, 75.651855),
                    new google.maps.LatLng(32.342841, 75.531006),
                    new google.maps.LatLng(32.268555, 75.410156),
                    new google.maps.LatLng(32.119801, 75.278320),
                    new google.maps.LatLng(32.063956, 75.124512),
                    new google.maps.LatLng(32.008076, 74.904785),
                    new google.maps.LatLng(31.821565, 74.619141),
                    new google.maps.LatLng(31.690782, 74.553223),
                    new google.maps.LatLng(31.484893, 74.619141),
                    new google.maps.LatLng(31.128199, 74.531250),
                    new google.maps.LatLng(31.090574, 74.663086),
                    new google.maps.LatLng(31.034108, 74.575195),
                    new google.maps.LatLng(30.864510, 74.377441),
                    new google.maps.LatLng(30.637912, 74.201660),
                    new google.maps.LatLng(30.505484, 74.047852),
                    new google.maps.LatLng(30.448674, 73.916016),
                    new google.maps.LatLng(30.429730, 73.959961),
                    new google.maps.LatLng(30.358656, 73.883057),
                    new google.maps.LatLng(30.197366, 73.970947),
                    new google.maps.LatLng(30.073848, 73.817139),
                    new google.maps.LatLng(29.931135, 73.383179),
                    new google.maps.LatLng(29.602118, 73.278809),
                    new google.maps.LatLng(29.238477, 73.081055),
                    new google.maps.LatLng(29.161756, 72.993164),
                    new google.maps.LatLng(29.051368, 72.949219),
                    new google.maps.LatLng(29.032158, 72.949219),
                    new google.maps.LatLng(28.945669, 72.723999),
                    new google.maps.LatLng(28.796546, 72.454834),
                    new google.maps.LatLng(28.786918, 72.399902),
                    new google.maps.LatLng(28.676130, 72.301025),
                    new google.maps.LatLng(28.386568, 72.207642),
                    new google.maps.LatLng(28.246328, 72.031860),
                    new google.maps.LatLng(28.125283, 71.921997),
                    new google.maps.LatLng(27.960443, 71.900024),
                    new google.maps.LatLng(27.873073, 71.669312),
                    new google.maps.LatLng(27.887639, 71.378174),
                    new google.maps.LatLng(27.839076, 71.207886),
                    new google.maps.LatLng(27.707847, 70.900269),
                    new google.maps.LatLng(27.727298, 70.751953),
                    new google.maps.LatLng(27.834219, 70.686035),
                    new google.maps.LatLng(27.926474, 70.675049),
                    new google.maps.LatLng(27.994401, 70.592651),
                    new google.maps.LatLng(28.013801, 70.576172),
                    new google.maps.LatLng(28.038046, 70.510254),
                    new google.maps.LatLng(28.018651, 70.372925),
                    new google.maps.LatLng(27.931327, 70.301514),
                    new google.maps.LatLng(27.892494, 70.219116),
                    new google.maps.LatLng(27.805069, 70.136719),
                    new google.maps.LatLng(27.566721, 70.021362),
                    new google.maps.LatLng(27.508271, 69.938965),
                    new google.maps.LatLng(27.415662, 69.878540),
                    new google.maps.LatLng(27.303452, 69.719238),
                    new google.maps.LatLng(27.191128, 69.592896),
                    new google.maps.LatLng(26.990619, 69.510498),
                    new google.maps.LatLng(26.809364, 69.477539),
                    new google.maps.LatLng(26.735799, 69.494019),
                    new google.maps.LatLng(26.667096, 69.702759),
                    new google.maps.LatLng(26.593439, 69.785156),
                    new google.maps.LatLng(26.583615, 69.900513),
                    new google.maps.LatLng(26.593439, 70.032349),
                    new google.maps.LatLng(26.598351, 70.092773),
                    new google.maps.LatLng(26.549223, 70.169678),
                    new google.maps.LatLng(26.475490, 70.180664),
                    new google.maps.LatLng(26.421390, 70.180664),
                    new google.maps.LatLng(26.367264, 70.191650),
                    new google.maps.LatLng(26.303264, 70.158691),
                    new google.maps.LatLng(26.244156, 70.169678),
                    new google.maps.LatLng(26.160369, 70.142212),
                    new google.maps.LatLng(26.091322, 70.087280),
                    new google.maps.LatLng(25.923467, 70.098267),
                    new google.maps.LatLng(25.799891, 70.208130),
                    new google.maps.LatLng(25.725684, 70.263062),
                    new google.maps.LatLng(25.695988, 70.317993),
                    new google.maps.LatLng(25.676187, 70.378418),
                    new google.maps.LatLng(25.681137, 70.521240),
                    new google.maps.LatLng(25.715786, 70.603638),
                    new google.maps.LatLng(25.710837, 70.653076),
                    new google.maps.LatLng(25.671236, 70.669556),
                    new google.maps.LatLng(25.537485, 70.658569),
                    new google.maps.LatLng(25.527572, 70.675049),
                    new google.maps.LatLng(25.408547, 70.658569),
                    new google.maps.LatLng(25.324167, 70.735474),
                    new google.maps.LatLng(25.274504, 70.746460),
                    new google.maps.LatLng(25.140312, 70.894775),
                    new google.maps.LatLng(24.931276, 70.927734),
                    new google.maps.LatLng(24.716895, 71.054077),
                    new google.maps.LatLng(24.696934, 71.098022),
                    new google.maps.LatLng(24.647017, 71.054077),
                    new google.maps.LatLng(24.637031, 71.015625),
                    new google.maps.LatLng(24.597080, 70.993652),
                    new google.maps.LatLng(24.532132, 70.988159),
                    new google.maps.LatLng(24.462151, 70.999146),
                    new google.maps.LatLng(24.432147, 71.098022),
                    new google.maps.LatLng(24.412140, 71.125488),
                    new google.maps.LatLng(24.402136, 71.109009),
                    new google.maps.LatLng(24.397133, 71.087036),
                    new google.maps.LatLng(24.377121, 71.059570),
                    new google.maps.LatLng(24.352101, 71.037598),
                    new google.maps.LatLng(24.362110, 70.993652),
                    new google.maps.LatLng(24.367114, 70.960693),
                    new google.maps.LatLng(24.302047, 70.883789),
                    new google.maps.LatLng(24.261989, 70.905762),
                    new google.maps.LatLng(24.246965, 70.856323),
                    new google.maps.LatLng(24.221919, 70.823364),
                    new google.maps.LatLng(24.221919, 70.768433),
                    new google.maps.LatLng(24.211900, 70.697021),
                    new google.maps.LatLng(24.256981, 70.570679),
                    new google.maps.LatLng(24.287027, 70.576172),
                    new google.maps.LatLng(24.357105, 70.548706),
                    new google.maps.LatLng(24.412140, 70.598145),
                    new google.maps.LatLng(24.432147, 70.565186),
                    new google.maps.LatLng(24.367114, 70.394897),
                    new google.maps.LatLng(24.347097, 70.367432),
                    new google.maps.LatLng(24.332082, 70.274048),
                    new google.maps.LatLng(24.312059, 70.120239),
                    new google.maps.LatLng(24.211900, 70.065308),
                    new google.maps.LatLng(24.171814, 70.032349),
                    new google.maps.LatLng(24.176825, 69.730225),
                    new google.maps.LatLng(24.287027, 69.587402),
                    new google.maps.LatLng(24.261989, 69.499512),
                    new google.maps.LatLng(24.282020, 69.444580),
                    new google.maps.LatLng(24.272005, 69.362183),
                    new google.maps.LatLng(24.287027, 69.312744),
                    new google.maps.LatLng(24.231938, 69.213867),
                    new google.maps.LatLng(24.266997, 69.093018),
                    new google.maps.LatLng(24.221919, 69.005127),
                    new google.maps.LatLng(24.307053, 68.933716),
                    new google.maps.LatLng(24.287027, 68.895264),
                    new google.maps.LatLng(24.221919, 68.873291),
                    new google.maps.LatLng(24.221919, 68.845825),
                    new google.maps.LatLng(24.312059, 68.823853),
                    new google.maps.LatLng(24.297040, 68.768921),
                    new google.maps.LatLng(23.981234, 68.746948),
                    new google.maps.LatLng(23.976215, 68.384399),
                    new google.maps.LatLng(23.956136, 68.367920),
                    new google.maps.LatLng(23.936055, 68.351440),
                    new google.maps.LatLng(23.941076, 68.318481),
                    new google.maps.LatLng(23.915970, 68.296509),
                    new google.maps.LatLng(23.900905, 68.285522),
                    new google.maps.LatLng(23.936055, 68.280029),
                    new google.maps.LatLng(23.931034, 68.263550),
                    new google.maps.LatLng(23.900905, 68.258057),
                    new google.maps.LatLng(23.885838, 68.230591),
                    new google.maps.LatLng(23.880815, 68.214111),
                    new google.maps.LatLng(23.860722, 68.192139),
                    new google.maps.LatLng(23.825551, 68.192139),
                    new google.maps.LatLng(23.790371, 68.192139),
                    new google.maps.LatLng(23.770264, 68.170166),
                    new google.maps.LatLng(23.755182, 68.164673),
                    new google.maps.LatLng(23.719983, 68.170166),
                    new google.maps.LatLng(23.709924, 68.164673),
                    new google.maps.LatLng(23.694835, 68.137207),
                    new google.maps.LatLng(23.694835, 68.060303),
                    new google.maps.LatLng(23.725012, 68.038330),
                    new google.maps.LatLng(23.775291, 68.005371),
                    new google.maps.LatLng(23.825551, 67.950439),
                    new google.maps.LatLng(23.835601, 67.884521),
                    new google.maps.LatLng(23.895883, 67.862549),
                    new google.maps.LatLng(23.855698, 67.807617),
                    new google.maps.LatLng(23.825551, 67.818604),
                    new google.maps.LatLng(23.835601, 67.752686),
                    new google.maps.LatLng(23.825551, 67.675781),
                    new google.maps.LatLng(23.875792, 67.576904),
                    new google.maps.LatLng(23.936055, 67.467041),
                    new google.maps.LatLng(23.976215, 67.412109),
                    new google.maps.LatLng(24.076559, 67.357178),
                    new google.maps.LatLng(24.287027, 67.280273),
                    new google.maps.LatLng(24.367114, 67.302246),
                    new google.maps.LatLng(24.417142, 67.357178),
                    new google.maps.LatLng(24.467151, 67.269287),
                    new google.maps.LatLng(24.577100, 67.192383),
                    new google.maps.LatLng(24.726875, 67.104492),
                    new google.maps.LatLng(24.746831, 67.060547),
                    new google.maps.LatLng(24.806681, 66.950684),
                    new google.maps.LatLng(24.846565, 66.829834),
                    new google.maps.LatLng(24.816654, 66.665039),
                    new google.maps.LatLng(25.085599, 66.697998),
                    new google.maps.LatLng(25.175117, 66.719971),
                    new google.maps.LatLng(25.373809, 66.566162),
                    new google.maps.LatLng(25.463115, 66.258545),
                    new google.maps.LatLng(25.423431, 66.016846),
                    new google.maps.LatLng(25.423431, 65.819092),
                    new google.maps.LatLng(25.334097, 65.643311),
                    new google.maps.LatLng(25.393661, 65.412598),
                    new google.maps.LatLng(25.373809, 65.247803),
                    new google.maps.LatLng(25.304304, 65.192871),
                    new google.maps.LatLng(25.264568, 65.072021),
                    new google.maps.LatLng(25.324167, 64.764404),
                    new google.maps.LatLng(25.284438, 64.698486),
                    new google.maps.LatLng(25.204941, 64.665527),
                    new google.maps.LatLng(25.155229, 64.643555),
                    new google.maps.LatLng(25.155229, 64.588623),
                    new google.maps.LatLng(25.214881, 64.566650),
                    new google.maps.LatLng(25.264568, 64.544678),
                    new google.maps.LatLng(25.254633, 64.478760),
                    new google.maps.LatLng(25.234758, 64.423828),
                    new google.maps.LatLng(25.274504, 64.259033),
                    new google.maps.LatLng(25.304304, 64.182129),
                    new google.maps.LatLng(25.334097, 64.072266),
                    new google.maps.LatLng(25.383735, 63.720703),
                    new google.maps.LatLng(25.304304, 63.522949),
                    new google.maps.LatLng(25.274504, 63.457031),
                    new google.maps.LatLng(25.204941, 63.511963),
                    new google.maps.LatLng(25.204941, 63.468018),
                    new google.maps.LatLng(25.244696, 63.116455),
                    new google.maps.LatLng(25.204941, 63.028564),
                    new google.maps.LatLng(25.254633, 62.490234),
                    new google.maps.LatLng(25.204941, 62.413330),
                    new google.maps.LatLng(25.165173, 62.347412),
                    new google.maps.LatLng(25.115445, 62.358398),
                    new google.maps.LatLng(25.065697, 62.380371),
                    new google.maps.LatLng(25.075648, 62.325439),
                    new google.maps.LatLng(25.105497, 62.259521),
                    new google.maps.LatLng(25.155229, 62.270508),
                    new google.maps.LatLng(25.195000, 62.281494),
                    new google.maps.LatLng(25.224820, 62.182617),
                    new google.maps.LatLng(25.204941, 62.094727),
                    new google.maps.LatLng(25.175117, 62.039795),
                    new google.maps.LatLng(25.125393, 62.105713),
                    new google.maps.LatLng(25.115445, 62.061768),
                    new google.maps.LatLng(25.075648, 61.962891),
                    new google.maps.LatLng(25.095549, 61.885986),
                    new google.maps.LatLng(25.095549, 61.831055),
                    new google.maps.LatLng(25.055745, 61.831055),
                    new google.maps.LatLng(25.005973, 61.798096),
                    new google.maps.LatLng(25.015929, 61.754150),
                    new google.maps.LatLng(25.045792, 61.710205),
                    new google.maps.LatLng(25.135339, 61.666260),
                    new google.maps.LatLng(25.175117, 61.699219),
                    new google.maps.LatLng(25.224820, 61.600342),
                    new google.maps.LatLng(25.284438, 61.589355)
                ];

            var boundary = new google.maps.Polyline(config.polyOptions);
            boundary.setMap(gMap);

            vm.placeMarker();
        });

        function mapClicked(mapModel, eventName, originalEventArgs) {
            // 'this' is the directive's scope
            var e = originalEventArgs[0];
            var lat = e.latLng.lat();
            var lng = e.latLng.lng();

            vm.entity.location = lng + ' ' + lat;

            $scope.$apply();
            vm.placeMarker();
        }

        function placeMarker()
        {
            if (isReady && vm.entity && vm.entity.location)
            {
                var latlngStr = vm.entity.location.split(" ", 2);
                var lng = parseFloat(latlngStr[0]);
                var lat = parseFloat(latlngStr[1]);               

                var latLng = new google.maps.LatLng(lat, lng);

                if (!marker) {
                    marker = new google.maps.Marker({
                        position: latLng,
                        map: gMap,
                        title: 'Training Location'
                    });
                }
                
                marker.setPosition(latLng);
                gMap.panTo(latLng);
            }
        }

        activate();

        function activate()
        {
            onDestroy();
            onHasChanges();

            var filter = breeze.Predicate.create('category', '==', 'Default').and('organizationId', '!=', 0);
            var select = 'organizationId, name, organizationType, organizationType.name, headName, relationshipType, category';

            var p0 = datacontext.province.getAll(true);
            var p1 = datacontext.district.getAll(true);
            var p2 = datacontext.city.getAll(true);
            var p3 = datacontext.survey.getAll(true);
            var p4 = datacontext.organization.getAll(true, select, filter);
            var p5 = datacontext.broaderTrainingArea.getAll(true);

            common.activateController([p0, p1, p2, p3, p4, p5], controllerId).then(init, queryFailed);
        }                   

        function init(results)
        {
            vm.trainingStatuses = datacontext.enum.types.trainingStatuses;
            vm.trainingTypes = datacontext.enum.types.trainingTypes;
            vm.trainingLevels = datacontext.enum.types.trainingLevels;
                        
            vm.provinces = results[0];
            allDistricts = results[1];
            allCities = results[2];
            vm.surveys = results[3];

            vm.organizations = results[4];
            vm.broaderTrainingAreas = results[5];

            vm.gridOptions.data = vm.organizations;

            getEntity(true);
        }

        function initLocations(location)
        {
            vm.districts = allDistricts.filter(function (district) { return district.provinceId === location.province.provinceId; });
            vm.cities = allCities.filter(function (city) { return city.districtId === location.district.districtId; });
        }

        function initDropDowns(entity)
        {
            entity.status = vm.trainingStatuses[0];
            entity.trainingType = vm.trainingTypes[0];
            entity.trainingLevel = vm.trainingLevels[0];
            entity.broaderTrainingArea = vm.broaderTrainingAreas[0];
            entity.survey = vm.surveys[0];

            initLocations(entity);
        }

        function queryFailed(error) {
            logError(error);
            goToIndex();
        }

        function getEntity(forceRemote)
        {
            var val = $routeParams.id;

            if(val === 'new')
            {
                vm.title = 'Add ' + entity;
                vm.entity = datacontext.training.create();

                vm.entity.city = $.grep(allCities, function (o) { return o.name === 'Islamabad'; })[0];
                vm.entity.district = $.grep(allDistricts, function (o) { return o.districtId === vm.entity.city.districtId; })[0];
                vm.entity.province = $.grep(vm.provinces, function (o) { return o.provinceId === vm.entity.district.provinceId; })[0];
                vm.entity.location = '73.0667 33.7167' // Assume Islamabad as default location
                vm.entity.dateCreated = moment().valueOf();                

                initDropDowns(vm.entity);
                placeMarker();
                return vm.entity;
            }

            return datacontext.training.getById(val, forceRemote)
                    .then(querySucceeded, queryFailed);

            function querySucceeded(data) {
                vm.entity = data.entity || data;
                initLocations(vm.entity);
                placeMarker();

                vm.entity.entityAspect.loadNavigationProperty("trainingOrganizations").then(success, queryFailed);

                function success(data)
                {
                    vm.trainingOrganizationsOriginal = data.results || data;

                    for (var o of vm.trainingOrganizationsOriginal)
                    {
                        var row = $.grep(vm.organizations, function (e) { return e.organizationId == o.organizationId; })[0];

                        if (row)
                            vm.gridApi.selection.selectRow(row);
                    }

                    vm.hasChanges = false;
                }
            }
        }

        function goBack()
        {
            vm.gridOptions.onRegisterApi = null;
            $window.history.back();
        }

        function cancel()
        {
            datacontext.cancel();
            vm.hasChanges = false;

            //helper.replaceLocationUrlGuidWithId(vm.entity.documentId);

            if (vm.entity.entityAspect.entityState.isDetached())
            {
                goToIndex();
            }
        }

        function goToIndex()
        {
            vm.gridOptions.onRegisterApi = null;
            $location.path('/trainings');
        }

        function save()
        {
            if(!canSave())
            {
                return common.$q.when(null);

            } // Must return a promise

            vm.isSaving = true;

            if (vm.id != 'new')
            {
                var selectedOrganizations = vm.gridApi.selection.getSelectedRows();

                for(var o of vm.organizations)
                {
                    var selected = (selectedOrganizations.indexOf(o) >= 0);
                    var original = $.grep(vm.trainingOrganizationsOriginal, function (e) { return e.organizationId == o.organizationId; });
                    var exists = original.length;

                    if (selected && !exists)
                    {
                        // add
                        var obj = { trainingId: vm.entity.trainingId, organizationId: o.organizationId };
                        var newEntity = datacontext.trainingOrganization.create(obj);

                        vm.trainingOrganizationsOriginal.push(newEntity);
                    }
                    else if (!selected && exists)
                    {
                        // remove
                        var entityAspect = original[0].entityAspect;

                        if (!entityAspect.entityState.isDetached())
                            entityAspect.setDeleted();

                        vm.trainingOrganizationsOriginal = vm.trainingOrganizationsOriginal.filter(function (e) { return e.organizationId != o.organizationId; });
                    }
                }
            }

            vm.entity.dateModified = moment().valueOf();

            return datacontext.save()
                .then(function(saveResult)
                {
                    // Save success
                    vm.isSaving = false;
                    //helper.replaceLocationUrlGuidWithId(vm.entity.documentId);
                },
                function(error)
                {
                    // Save error
                    vm.isSaving = false;
                });
        }

        function provinceChanged() {

            var provinceId = vm.entity.province.provinceId;
            vm.districts = allDistricts.filter(function (e) { return e.provinceId === provinceId; });
            vm.entity.district = vm.districts[0];
            districtChanged();
        }

        function districtChanged() {
            vm.cities = allCities.filter(function (e) { return e.districtId === vm.entity.district.districtId; });
            vm.entity.city = vm.cities[0];
        }

        function onDestroy()
        {
            $scope.$on('$destroy', function()
            {
                vm.gridOptions.onRegisterApi = null;
                datacontext.cancel();
            });
        }

        function onHasChanges()
        {
            $scope.$on(config.events.hasChangesChanged,
                function(event, data)
                {
                    vm.hasChanges = data.hasChanges;
                });
        }
    }

})();
