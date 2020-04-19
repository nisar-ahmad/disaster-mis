(function ()
{
    'use strict';

    var app = angular.module('app');

    // Collect the routes
    app.constant('routes', getRoutes());

    // Configure the routes and route resolvers
    app.config(['$routeProvider', '$locationProvider', 'routes', routeConfigurator]);

    function routeConfigurator($routeProvider, $locationProvider, routes)
    {
        routes.forEach(function (r)
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
                    title: 'Submit Your Training',
                    templateUrl: 'app/trainingActivity/login.html'
                }
            },
            {
                url: '/4wTrainings/map/:public',
                config: {
                    title: 'Mapping DRM Trainings',
                    templateUrl: 'app/trainingActivity/map.html'
                }
            },
            {
                url: '/4wTrainings/:orgId/:public',
                config: {
                    title: '4W Training Activities',
                    templateUrl: 'app/trainingActivity/index.html'
                }
            },
            {
                url: '/4wTraining/:id/:orgId/details/:public',
                config: {
                    title: '4W Training Activity',
                    templateUrl: 'app/trainingActivity/details.html'
                }
            },
            {
                url: '/4wTraining/:id/:orgId/:public',
                config: {
                    title: '4W Training Activity',
                    templateUrl: 'app/trainingActivity/edit.html'
                }
            },
            {
                url: '/documents/:public',
                config: {
                    title: 'DIRC Library',
                    templateUrl: 'app/document/index.html'
                }
            },
            {
                url: '/document/:id/details/:public',
                config: {
                    title: 'Document Details',
                    templateUrl: 'app/document/details.html',
                    settings: {}
                }
            },
            {
                url: '/galleries/:public',
                config: {
                    title: 'Photo / Video Galleries',
                    templateUrl: 'app/gallery/index.html'
                }
            },
            {
                url: '/gallery/:id/details/:public',
                config: {
                    title: 'Gallery',
                    templateUrl: 'app/gallery/details.html'

                }
            },
            {
                url: '/album/:id/details/:public',
                config: {
                    title: 'Album',
                    templateUrl: 'app/album/details.html'

                }
            },
            {
                url: '/organization/:id/:category/:public',
                config: {
                    title: 'Organization',
                    templateUrl: 'app/organization/edit.html'
                }
            },
            {
                url: '/participant/:id/:public',
                config: {
                    title: 'Participant Registration',
                    templateUrl: 'app/participant/edit.html'
                }
            },
            {
                url: '/respondent/:id/:surveyId/:public',
                config: {
                    title: 'Respondent',
                    templateUrl: 'app/respondent/edit.html'
                }
            },
            {
                url: '/survey/:surveyId/response/:respondentId',
                config: {
                    title: 'Survey Response',
                    templateUrl: 'app/survey/response.html'
                }
            },
            {
                url: '/surveys/:public',
                config: {
                    title: 'Surveys',
                    templateUrl: 'app/survey/index.html'
                }
            },
            {
                url: '/training/:id/details/:public',
                config: {
                    title: 'Training Details',
                    templateUrl: 'app/training/details.html'
                }
            },
            {
                url: '/trainings/map/:public',
                config: {
                    title: 'Training Map',
                    templateUrl: 'app/training/map.html'
                }
            },
            {
                url: '/trainings/schedule/:public',
                config: {
                    title: 'Training Calendar',
                    templateUrl: 'app/training/schedule.html'
                }
            },
            {
                url: '/training/evaluation/:trainingId/:participantId',
                config: {
                    title: 'Training Evaluation',
                    templateUrl: 'app/training/evaluation.html'
                }
            },
            {
                url: '/thanks',
                config: {
                    title: 'Thank You!',
                    templateUrl: 'app/common/thanks.html'
                }
            },
            {
                url: '/trainings/calendar/:public',
                config: {
                    title: 'Training Calendar',
                    templateUrl: 'app/training/schedule.html'
                }
            }
        ];
    }
})();