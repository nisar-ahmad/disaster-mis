(function()
{
    'use strict';

    // Define the common module 
    // Contains services:
    //  - common
    //  - logger
    //  - spinner
    var commonModule = angular.module('common', []);

    // Must configure the common service and set its 
    // events via the commonConfigProvider
    commonModule.provider('commonConfig', function()
    {
        this.config = {
            // These are the properties we need to set
            //controllerActivateSuccessEvent: '',
            //spinnerToggleEvent: ''
        };

        this.$get = function()
        {
            return {
                config: this.config
            };
        };
    });

    commonModule.factory('common',
        ['$q', '$http', '$rootScope', '$timeout', 'commonConfig', 'logger', 'uiGridConstants', common]);

    function common($q, $http, $rootScope, $timeout, commonConfig, logger, uiGridConstants)
    {
        var throttles = {};

        var data = {
                    participantId: null,
                    respondentId: null,
                    surveyId: null,
                    trainingId: null,
                    thanksMessage: null,
                    thanksUrl: null
                };

        var service = {
            // common angular dependencies
            $broadcast: $broadcast,
            $q: $q,
            $timeout: $timeout,
            $http: $http,
            // data
            getData: getData,
            setData: setData,
            // methods
            activateController: activateController,
            createSearchThrottle: createSearchThrottle,
            debouncedThrottle: debouncedThrottle,
            isNumber: isNumber,
            logger: logger, // for accessibility
            textContains: textContains,
            getFileExtension: getFileExtension,
            getFileName: getFileName,
            getFileIcon: getFileIcon,
            getChunks: getChunks,
            getSelectOptions: getSelectOptions,
            getBetweenFilter: getBetweenFilter
        };

        return service;

        function setData(key, value)
        {
            data[key] = value;
        }

        function getData(key)
        {
            var value = data[key];
            //data[key] = null;
            return value;
        }

        function getBetweenFilter()
        {
            return [
                    {
                        condition: uiGridConstants.filter.GREATER_THAN_OR_EQUAL,
                        placeholder: 'from'
                    },
                    {
                        condition: uiGridConstants.filter.LESS_THAN_OR_EQUAL,
                        placeholder: 'to'
                    }
            ];
        }

        function getSelectOptions(array)
        {
            var selectOptions = [];

            for(var a of array){
                selectOptions.push({value: a, label: a});
            }

            return selectOptions;
        }

        function getChunks(arr, size)
        {
            var newArr = [];
            for (var i = 0; i < arr.length; i += size)
            {
                newArr.push(arr.slice(i, i + size));
            }
            return newArr;
        }
        
        function getFileIcon(fileName)
        {
                var icon = 'Content/img/icon-file.png';

                if (fileName)
                {
                    var ext = getFileExtension(fileName);
                    icon = 'Content/img/icon-' + ext + '.png';
                }

                return icon;
        }

        function getFileExtension(fileName)
        { 
            return fileName.split(".").pop();
        }

        function getFileName(fileUrl)
        {
            var fileName = fileUrl.substring(fileUrl.lastIndexOf('/') + 1);

            if (fileName.length === 0)
                return fileUrl;
            
            return fileName;
        }

        function activateController(promises, controllerId)
        {
            return $q.all(promises).then(function(eventArgs)
            {
                var data = { controllerId: controllerId };
                $broadcast(commonConfig.config.controllerActivateSuccessEvent, data);
                return eventArgs;
            });
        }

        function $broadcast()
        {
            return $rootScope.$broadcast.apply($rootScope, arguments);
        }

        function createSearchThrottle(viewmodel, list, filteredList, filter, delay)
        {
            // After a delay, search a viewmodel's list using 
            // a filter function, and return a filteredList.

            // custom delay or use default
            delay = +delay || 300;

            // if only vm and list parameters were passed, set others by naming convention 
            if(!filteredList)
            {
                // assuming list is named sessions, filteredList is filteredSessions
                filteredList = 'filtered' + list[0].toUpperCase() + list.substr(1).toLowerCase(); // string

                // filter function is named sessionsFilter
                filter = list + 'Filter'; // function in string form
            }

            // create the filtering function we will call from here
            var filterFn = function()
            {
                // translates to ...
                // vm.filteredSessions = vm.sessions.filter(function(item( { returns vm.sessionFilter (item) } );
                viewmodel[filteredList] = viewmodel[list].filter(function(item)
                {
                    return viewmodel[filter](item);
                });
            };

            return (function()
            {
                // Wrapped in outer IFFE so we can use closure 
                // over filterInputTimeout which references the timeout
                var filterInputTimeout;

                // return what becomes the 'applyFilter' function in the controller
                return function(searchNow)
                {
                    if(filterInputTimeout)
                    {
                        $timeout.cancel(filterInputTimeout);
                        filterInputTimeout = null;
                    }

                    if(searchNow || !delay)
                    {
                        filterFn();
                    }
                    else
                    {
                        filterInputTimeout = $timeout(filterFn, delay);
                    }
                };
            })();
        }

        function debouncedThrottle(key, callback, delay, immediate)
        {
            // Perform some action (callback) after a delay. 
            // Track the callback by key, so if the same callback 
            // is issued again, restart the delay.

            var defaultDelay = 1000;
            delay = delay || defaultDelay;
            if(throttles[key])
            {
                $timeout.cancel(throttles[key]);
                throttles[key] = undefined;
            }
            if(immediate)
            {
                callback();
            } else
            {
                throttles[key] = $timeout(callback, delay);
            }
        }

        function isNumber(val)
        {
            // negative or positive
            return /^[-]?\d+$/.test(val);
        }

        function textContains(text, searchText)
        {
            return text && -1 !== text.toLowerCase().indexOf(searchText.toLowerCase());
        }
    }
})();