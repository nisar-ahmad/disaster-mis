(function()
{
    'use strict';

    var app = angular.module('app');

    // Collect the routes
    app.constant('routes', getRoutes());

    // Configure the routes and route resolvers
    app.config(['$routeProvider','$locationProvider', 'routes', routeConfigurator]);

    function routeConfigurator($routeProvider, $locationProvider, routes)
    {
        routes.forEach(function(r)
        {
            setRoute(r.url, r.config);
        });

        $routeProvider.otherwise({ redirectTo: '/' });

        function setRoute(url, definition)
        {
            definition.resolve = angular.extend(definition.resolve || {}, {
                prime: prime
            });

            $routeProvider.when(url, definition);
        }

        //$locationProvider.html5Mode(false).hashPrefix('!');
    }

    prime.$inject = ['datacontext'];

    function prime(dc) { return dc.prime(); }

    // Define the routes 
    function getRoutes()
    {
        return [
            {
                url: '/',
                config: {
                    templateUrl: 'app/home/home.html',
                    title: 'Home Page'
                }
            },
            {
                url: '/home',
                config: {
                    templateUrl: 'app/home/home.html',
                    title: 'Home Page'
                }
            },
            {
                url: '/academicQualification/:id',
                config: {
                    title: 'Academic Qualification',
                    templateUrl: 'app/academicQualification/edit.html',
                    settings: {}
                }
            },
            {
                url: '/academicQualifications',
                config: {
                    title: 'Academic Qualifications',
                    templateUrl: 'app/academicQualification/index.html',
                    settings: {}
                }
            },
            {
                url: '/activities',
                config: {
                    title: 'Activities',
                    templateUrl: 'app/activity/index.html',
                    settings: {}
                }
            },
            {
                url: '/activity/:id',
                config: {
                    title: 'Activity',
                    templateUrl: 'app/activity/edit.html',
                    settings: {}
                }
            },
            {
                url: '/activity/:id/details',
                config: {
                    title: 'Activity Details',
                    templateUrl: 'app/activity/details.html',
                    settings: {}
                }
            },
             {
                 url: '/activityCosts',
                 config: {
                     title: 'Activity Costs',
                     templateUrl: 'app/activityCost/index.html',
                     settings: {}
                 }
             },
            {
                url: '/activityCost/:id',
                config: {
                    title: 'Activity Cost',
                    templateUrl: 'app/activityCost/edit.html',
                    settings: {}
                }
            },
            {
                url: '/activityCost/:id/details',
                config: {
                    title: 'Activity Cost Details',
                    templateUrl: 'app/activityCost/details.html',
                    settings: {}
                }
            },
            {
                url: '/activityType/:id',
                config: {
                    title: 'Activity Type',
                    templateUrl: 'app/activityType/edit.html',
                    settings: {}
                }
            },
            {
                url: '/activityTypes',
                config: {
                    title: 'Activity Types',
                    templateUrl: 'app/activityType/index.html',
                    settings: {}
                }
            },
            {
                url: '/approvedHead/:id',
                config: {
                    title: 'Approved Head',
                    templateUrl: 'app/approvedActivity/edit.html',
                    settings: {}
                }
            },
            {
                url: '/approvedHeads',
                config: {
                    title: 'Approved Heads',
                    templateUrl: 'app/approvedActivity/index.html',
                    settings: {}
                }
            },
            {
                url: '/albums',
                config: {
                    title: 'Albums',
                    templateUrl: 'app/album/index.html',
                    settings: {}
                }
            },
            {
                url: '/album/:id/details',
                config: {
                    title: 'View Album',
                    templateUrl: 'app/album/details.html',
                    settings: {}
                }
            },
            {
                url: '/album/:id',
                config: {
                    title: 'Edit Album',
                    templateUrl: 'app/album/edit.html',
                    settings: {}
                }
            },
            {
                url: '/area/:id',
                config: {
                    title: 'Area',
                    templateUrl: 'app/area/edit.html',
                    settings: {}
                }
            },
            {
                url: '/areas',
                config: {
                    title: 'Areas',
                    templateUrl: 'app/area/index.html',
                    settings: {}
                }
            },
            {
                url: '/city/:id',
                config: {
                    title: 'City',
                    templateUrl: 'app/city/edit.html',
                    settings: {}
                }
            },
            {
                url: '/cities',
                config: {
                    title: 'Cites',
                    templateUrl: 'app/city/index.html',
                    settings: {}
                }
            },
            {
                url: '/contents',
                config: {
                    title: 'Contents',
                    templateUrl: 'app/content/index.html',
                    settings: {}
                }
            },
            {
                url: '/content/:id',
                config: {
                    title: 'Edit Content',
                    templateUrl: 'app/content/edit.html',
                    settings: {}
                }
            },
            {
                url: '/documents',
                config: {
                    title: 'Documents',
                    templateUrl: 'app/document/index.html',
                    settings: {}
                }
            },
            {
                url: '/document/:id',
                config: {
                    title: 'Document',
                    templateUrl: 'app/document/edit.html',
                    settings: {}
                }
            },
            {
                url: '/document/:id/details/:public?',
                config: {
                    title: 'Document Details',
                    templateUrl: 'app/document/details.html',
                    settings: {}
                }
            },
            {
                url: '/disabilityType/:id',
                config: {
                    title: 'Disability Type',
                    templateUrl: 'app/disabilityType/edit.html',
                    settings: {}
                }
            },
            {
                url: '/disabilityTypes',
                config: {
                    title: 'Disability Types',
                    templateUrl: 'app/disabilityType/index.html',
                    settings: {}
                }
            },
            {
                 url: '/district/:id',
                 config: {
                     title: 'district',
                     templateUrl: 'app/district/edit.html',
                     settings: {}
                 }
             },
            {
                url: '/districts',
                config: {
                    title: 'Districts',
                    templateUrl: 'app/district/index.html',
                    settings: {}
                }
            },
            {
                url: '/documentCategory/:id',
                config: {
                    title: 'Document Category',
                    templateUrl: 'app/documentCategory/edit.html',
                    settings: {}
                }
            },
            {
                url: '/documentCategories',
                config: {
                    title: 'Document Categories',
                    templateUrl: 'app/documentCategory/index.html',
                    settings: {}
                }
            },
           {
                url: '/fundings',
                config: {
                    title: 'Funding',
                    templateUrl: 'app/funding/index.html',
                    settings: {}
                }
            },
            {
                url: '/funding/:id',
                config: {
                    title: 'Funding',
                    templateUrl: 'app/funding/edit.html',
                    settings: {}
                }
            },
            {
                url: '/funding/:id/details',
                config: {
                    title: 'Funding Details',
                    templateUrl: 'app/funding/details.html',
                    settings: {}
                }
            },
            {
                url: '/galleries/:public?',
                config: {
                    title: 'Galleries',
                    templateUrl: 'app/gallery/index.html',
                    settings: {}
                }
            },
            {
                url: '/gallery/:id/details/:public?',
                config: {
                    title: 'Gallery',
                    templateUrl: 'app/gallery/details.html'
                }
            },
            {
                url: '/groups',
                config: {
                    title: 'Groups',
                    templateUrl: 'app/group/index.html'
                }
            },
            {
                url: '/group/:id',
                config: {
                    title: 'Group',
                    templateUrl: 'app/group/edit.html'
                }
            },
            {
                url: '/messageLogs',
                config: {
                    title: 'Email / SMS Logs',
                    templateUrl: 'app/messageLog/index.html'
               }
            },
            {
                url: '/messageLog/:id/details',
                config: {
                    title: 'Message Details',
                    templateUrl: 'app/messageLog/details.html'
                }
            },
            {
                url: '/organizations/:category?',
                config: {
                    title: 'Organizations',
                    templateUrl: 'app/organization/index.html'
                }
            },
            {
                url: '/organization/:id/details/:category?',
                config: {
                    title: 'Organization Details',
                    templateUrl: 'app/organization/details.html'
                }
            },
            {
                url: '/organization/:id/:category?',
                config: {
                    title: 'Organization',
                    templateUrl: 'app/organization/edit.html'
                }
            },
            {
                url: '/4wTrainings',
                config: {
                    title: '4W Training Activities',
                    templateUrl: 'app/trainingActivity/index.html',
                    settings: {}
                }
            },
            {
                url: '/4wTraining/:id/details',
                config: {
                    title: '4W Training Activity',
                    templateUrl: 'app/trainingActivity/details.html',
                    settings: {}
                }
            },
            {
                url: '/4wTraining/:id',
                config: {
                    title: '4W Training Activity',
                    templateUrl: 'app/trainingActivity/edit.html',
                    settings: {}
                }
            },
            {
                url: '/4wTrainings/map/:public?',
                config: {
                    title: 'Mapping DRM Trainings',
                    templateUrl: 'app/trainingActivity/map.html',
                    settings: {}
                }
            },
            {
                url: '/organizationTypes',
                config: {
                    title: 'Organization Types',
                    templateUrl: 'app/organizationType/index.html',
                    settings: {}
                }
            },
            {
                url: '/organizationType/:id',
                config: {
                    title: 'Organization Type',
                    templateUrl: 'app/organizationType/edit.html',
                    settings: {}
                }
            },
            {
                url: '/participants',
                config: {
                    title: 'Participants',
                    templateUrl: 'app/participant/index.html',
                    settings: {}
                }
            },
            {
                url: '/participant/:id/details',
                config: {
                    title: 'Participants Details',
                    templateUrl: 'app/participant/details.html',
                    settings: {}
                }
            },
            {
                url: '/participant/email',
                config: {
                    title: 'Email Participants',
                    templateUrl: 'app/participant/email.html',
                    settings: {}
                }
            },
            {
                url: '/participant/sms',
                config: {
                    title: 'SMS Participants',
                    templateUrl: 'app/participant/sms.html',
                    settings: {}
                }
            },
            {
                url: '/participant/:id/:public?',
                config: {
                    title: 'Participant',
                    templateUrl: 'app/participant/edit.html',
                    settings: {}
                }
            },
            {
                url: '/projects',
                config: {
                    title: 'Projects',
                    templateUrl: 'app/project/index.html',
                    settings: {}
                }
            },
            {
                url: '/project/:id',
                config: {
                    title: 'Edit Project',
                    templateUrl: 'app/project/edit.html',
                    settings: {}
                }
            },
            {
                url: '/project/:id/details',
                config: {
                    title: 'Project Details',
                    templateUrl: 'app/project/details.html',
                    settings: {}
                }
            },
            {
                url: '/provinces',
                config: {
                    title: 'Provinces',
                    templateUrl: 'app/province/index.html',
                    settings: {}
                }
            },
            {
                url: '/province/:id',
                config: {
                    title: 'Province',
                    templateUrl: 'app/province/edit.html',
                    settings: {}
                }
            },
            {
                url: '/questions',
                config: {
                    title: 'Questions',
                    templateUrl: 'app/question/index.html',
                    settings: {}
                }
            },
            {
                url: '/report/:id',
                config: {
                    title: 'Report',
                    templateUrl: 'app/reports/report.html',
                    settings: {}
                }
            },
            {
                url: '/question/:id',
                config: {
                    title: 'Question',
                    templateUrl: 'app/question/edit.html',
                    settings: {}
                }
            },
            {
                url: '/question/:id/details',
                config: {
                    title: 'Question Details',
                    templateUrl: 'app/question/details.html',
                    settings: {}
                }
            },
            {
                url: '/resourcePersons',
                config: {
                    title: 'Resource Persons',
                    templateUrl: 'app/resourcePerson/index.html',
                    settings: {}
                }
            },
            {
                url: '/resourcePerson/:id',
                config: {
                    title: 'Resource Person',
                    templateUrl: 'app/resourcePerson/edit.html',
                    settings: {}
                }
            },
            {
                url: '/resourcePerson/:id/details',
                config: {
                    title: 'Resource Person Details',
                    templateUrl: 'app/resourcePerson/details.html',
                    settings: {}
                }
            },
            {
                url: '/resourcePersonTrainings',
                config: {
                    title: 'Resource Persons Trainings',
                    templateUrl: 'app/resourcePersonTraining/index.html',
                    settings: {}
                }
            },
            {
                url: '/resourcePersonTraining/:id',
                config: {
                    title: 'Resource Person Training',
                    templateUrl: 'app/resourcePersonTraining/edit.html',
                    settings: {}
                }
            },
            {
                url: '/resourcePersonTraining/:id/details',
                config: {
                    title: 'Resource Person Training Details',
                    templateUrl: 'app/resourcePersonTraining/details.html',
                    settings: {}
                }
            },
            {
                url: '/respondents',
                config: {
                    title: 'Respondents',
                    templateUrl: 'app/respondent/index.html',
                    settings: {}
                }
            },
            {
                url: '/respondent/:id/details',
                config: {
                    title: 'Respondent Details',
                    templateUrl: 'app/respondent/details.html',
                    settings: {}
                }
            },
            {
                url: '/respondent/:id/:public?',
                config: {
                    title: 'Respondent',
                    templateUrl: 'app/respondent/edit.html',
                    settings: {}
                }
            },         
            {
                url: '/surveys/:public?',
                config: {
                    title: 'Surveys',
                    templateUrl: 'app/survey/index.html',
                    settings: {}
                }
            },
            {
                url: '/survey/response',
                config: {
                    title: 'Survey Response',
                    templateUrl: 'app/survey/response.html',
                    settings: {}
                }
            },
            {
                url: '/survey/:id',
                config: {
                    title: 'Survey',
                    templateUrl: 'app/survey/edit.html',
                    settings: {}
                }
            },
            {
                url: '/survey/:id/details',
                config: {
                    title: 'Survey Details',
                    templateUrl: 'app/survey/details.html',
                    settings: {}
                }
            },
            {
                url: '/thematicAreas',
                config: {
                    title: 'Thematic Areas',
                    templateUrl: 'app/thematicArea/index.html',
                    settings: {}
                }
            },
            {
                url: '/thematicArea/:id',
                config: {
                    title: 'Thematic Area',
                    templateUrl: 'app/thematicArea/edit.html',
                    settings: {}
                }
            },
            {
                url: '/trainings',
                config: {
                    title: 'Trainings',
                    templateUrl: 'app/training/index.html',
                    settings: {}
                }
            },
            {
                url: '/training/attendance',
                config: {
                    title: 'Training Attendance',
                    templateUrl: 'app/training/attendance.html',
                    settings: {}
                }
            },
            {
                url: '/training/evaluation/:trainingId/:participantId',
                config: {
                    title: 'Training Evaluation',
                    templateUrl: 'app/training/evaluation.html',
                    settings: {}
                }
            },
            {
                url: '/thanks',
                config: {
                    title: 'Thank You!',
                    templateUrl: 'app/common/thanks.html',
                    settings: {}
                }
            },
            {
                url: '/training/evaluation',
                config: {
                    title: 'Training Evaluation',
                    templateUrl: 'app/training/evaluation.html',
                    settings: {}
                }
            },
            {
                url: '/training/:id/details/:public?',
                config: {
                    title: 'Training Details',
                    templateUrl: 'app/training/details.html',
                    settings: {}
                }
            },
            {
                url: '/trainings/schedule/:public?',
                config: {
                    title: 'Training Calendar',
                    templateUrl: 'app/training/schedule.html',
                    settings: {}
                }
            },
            {
                url: '/training/:id',
                config: {
                    title: 'Training',
                    templateUrl: 'app/training/edit.html',
                    settings: {}
                }
            },
            {
                url: '/trainings/map/:public?',
                config: {
                    title: 'Training Map',
                    templateUrl: 'app/training/map.html'
                }
            },
            {
                url: '/trainings/calendar/:public?',
                config: {
                    title: 'Training Calendar',
                    templateUrl: 'app/training/schedule.html',
                    settings: {}
                }
            },

            {
                url: '/trainingCosts',
                config: {
                    title: 'Training Costs',
                    templateUrl: 'app/trainingCost/index.html',
                    settings: {}
                }
            },
            {
                url: '/trainingCost/:id',
                config: {
                    title: 'Training Cost',
                    templateUrl: 'app/trainingCost/edit.html',
                    settings: {}
                }
            },
            {
                url: '/trainingCost/:id/details',
                config: {
                    title: 'Training Cost Details',
                    templateUrl: 'app/trainingCost/details.html',
                    settings: {}
                }
            },
            {
                url: '/trainingSessions',
                config: {
                    title: 'Training Sessions',
                    templateUrl: 'app/trainingSession/index.html',
                    settings: {}
                }
            },
            {
                url: '/trainingSession/:id',
                config: {
                    title: 'Training Session',
                    templateUrl: 'app/trainingSession/edit.html',
                    settings: {}
                }
            },
            {
                url: '/trainingSession/:id/details',
                config: {
                    title: 'Training Session Details',
                    templateUrl: 'app/trainingSession/details.html',
                    settings: {}
                }
            },
            {
                url: '/trainingSession/attendance',
                config: {
                    title: 'Training Session Attendance',
                    templateUrl: 'app/trainingSession/attendance.html',
                    settings: {}
                }
            },
            {
                url: '/reportsDashboard',
                config: {
                    templateUrl: 'app/reportsDashboard/dashboard.html',
                    title: 'Reports Dashboard'
                }
            },
            {
                url: '/trainingDashboard',
                config: {
                    templateUrl: 'app/reportsDashboard/training.html',
                    title: 'Training Reports'
                }
            },
            {
                url: '/participantDashboard',
                config: {
                    templateUrl: 'app/reportsDashboard/participant.html',
                    title: 'Participant Reports'
                }
            },
            {
                url: '/dcaDashboard',
                config: {
                    templateUrl: 'app/reportsDashboard/dca.html',
                    title: 'Donors & Collaborating Agencies Reports'
                }
            },
            {
                url: '/resourceDashboard',
                config: {
                    templateUrl: 'app/reportsDashboard/resource.html',
                    title: 'Resource Persons Reports'
                }
            },
            {
                url: '/drmDashboard',
                config: {
                    templateUrl: 'app/reportsDashboard/drm.html',
                    title: '4Ws Reports'
                }
            },
            {
                url: '/tnaDashboard',
                config: {
                    templateUrl: 'app/reportsDashboard/tna.html',
                    title: 'TNA Reports'
                }
            },
            {
                url: '/smsemailDashboard',
                config: {
                    templateUrl: 'app/reportsDashboard/smsemail.html',
                    title: 'SMS & Email Reports'
                }
            },
        ];
    }
})();