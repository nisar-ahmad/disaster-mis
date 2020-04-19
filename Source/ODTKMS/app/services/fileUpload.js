(function () {
    'use strict';

    angular
        .module('app')
        .factory('fileUpload', fileUpload);

    fileUpload.$inject = ['$http'];

    function fileUpload($http)
    {
        var service = {
            upload: upload
        };

        return service;

        function upload(file, savePath, oldFileName, generateThumbnail, thumbnailSize)
        {
            var fd = new FormData();
            fd.append('file', file);

            var url = 'api/File/SaveFile?savePath=' + encodeURIComponent(savePath);

            if (oldFileName)
                url += '&oldFileName=' + oldFileName;

            if (generateThumbnail)
                url += '&generateThumbnail=true';

            if (thumbnailSize)
                url += '&thumbnailSize=' + thumbnailSize;

            return $http.post(url, fd, {
                transformRequest: angular.identity,
                headers: { 'Content-Type': undefined }
            });
        }
    }
})();