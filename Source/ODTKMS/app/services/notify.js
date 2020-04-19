(function () {
    'use strict';

    angular
        .module('app')
        .factory('notify', notify);

    notify.$inject = ['$http', 'datacontext'];

    function notify($http, datacontext)
    {
        var service = {
            email: email,
            sms: sms
        };

        return service;

        function sms(message)
        {
            return $http.post('api/Alert/SMS', JSON.stringify(message), {
                transformRequest: angular.identity,
                headers: { 'Content-Type': 'application/json' }
            }).then(function(){

                var obj = { type: 'SMS',
                            timeStamp: moment(),
                            subject: message.subject,
                            message: message.body,
                            group: message.group,
                            members: message.to,
                            userName: 'admin',
                            deliveryStatus: 'Delivered'}

                datacontext.messageLog.create(obj);
                datacontext.save();
            });
        }

        function email(message)
        {
            return $http.post('api/Alert/Email', JSON.stringify(message), {
                transformRequest: angular.identity,
                headers: { 'Content-Type': 'application/json' }
            }).then(function(){

                if (!message.group)
                    message.group = 'Specific';

                var obj = { type: 'Email',
                            timeStamp: moment(),
                            subject: message.subject, 
                            message: message.body,
                            group: message.group,
                            members: message.to,
                            userName: 'admin',
                            deliveryStatus: 'Delivered'}

                datacontext.messageLog.create(obj);
                datacontext.save();
            });
        }
    }
})();