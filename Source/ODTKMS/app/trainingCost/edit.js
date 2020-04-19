/// <reference path="edit.js" />
(function()
{
    'use strict';

    var controllerId = 'trainingCost';

    angular.module('app').controller(controllerId,
        ['$scope', '$location', '$window', '$routeParams', 'common', 'config', 'datacontext', 'model', 'helper',
            trainingCost]);

    function trainingCost($scope, $location, $window, $routeParams, common, config, datacontext, model, helper)
    {
        var entity = 'Training Costs';

        var vm = this;
        vm.title = 'Edit '+ entity;

        var logError = common.logger.getLogFn(controllerId, 'error');

        // Bindable properties and functions are placed on vm.
        vm.entity = undefined;
        vm.id = $routeParams.id;

        vm.goBack = goBack;
        vm.cancel = cancel;

        vm.hasChanges = false;
        vm.isSaving = false;
        vm.save = save;
        
        vm.trainings = [];
        vm.fundings = [];
        vm.projects = [];

        vm.project = null;
        vm.training = null;
        vm.projectChanged = projectChanged;

        vm.activate = activate;
 
        // vm.canSave Property
        Object.defineProperty(vm, 'canSave', {
            get: canSave
        });

        Object.defineProperty(vm, 'totalCost', {
            get: function()
            {
                var totalCost = 0;

                for(var f of vm.fundings)
                    totalCost += f.cost ? parseInt(f.cost) : 0;

                return totalCost;

            }
        });

        function canSave()
        {
            return !vm.isSaving;
        }

        function queryFailed(error) {
            logError(error);
            goToIndex();
        }
        
        activate();

        function activate()
        {
            onDestroy();
            onHasChanges();
            
            var trainingFilter = breeze.Predicate.create('trainingId', '!=', 0);

            var p0 = datacontext.training.getAll(true, 'trainingId, name', trainingFilter);
            var p1 = datacontext.project.getAll(true, 'projectId, name');            

            common.activateController([p0, p1], controllerId).then(init, queryFailed);
        }

        function init(results)
        {
            vm.trainings = results[0];
            vm.projects = results[1];

            getEntity(true);
        }

        function getEntity(forceRemote)
        {
            if (vm.id === 'new')
            {
                vm.title = 'Add ' + entity;
                vm.training = vm.trainings[0];
                vm.project = vm.projects[0];
                projectChanged();

                return;
            }

            return datacontext.trainingCost.getById(vm.id, forceRemote, 'funding, funding.project')
                    .then(querySucceeded, queryFailed);

            function querySucceeded(data) {
                var c = data.entity || data;

                vm.training = $.grep(vm.trainings, function (o) { return o.trainingId == c.trainingId; })[0];
                vm.project = $.grep(vm.projects, function (o) { return o.projectId == c.funding.project.projectId; })[0];

                projectChanged();
            }
        }

        function projectChanged()
        {
            var select = 'fundingId, projectId, approvedActivity, approvedActivity.name, project, project.name, cashAmount';
            var filter = breeze.Predicate.create('projectId', '==', vm.project.projectId);
            
            datacontext.funding.getAll(true, select, filter).then(function (data)
            {                
                vm.fundings = data;

                filter = breeze.Predicate.create('trainingId', '==', vm.training.trainingId);

                datacontext.trainingCost.getAll(true, null, filter).then(function (data)
                {
                    vm.trainingCosts = data;

                    for(var f of vm.fundings)
                    {
                        var costs = $.grep(vm.trainingCosts, function (o) { return o.fundingId === f.fundingId; });

                        if(costs.length && costs[0].cost)
                            f.cost = costs[0].cost;
                        else
                            f.cost = null;
                    }

                    vm.hasChanges = true;

                }, logError);

            }, logError);
        }

        function goBack()
        {
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
            $location.path('/trainingCosts');
        }

        function save()
        {
            if(!canSave())
            {
                return common.$q.when(null);

            } // Must return a promise

            vm.isSaving = true;

            for (var f of vm.fundings)
            {
                var original = $.grep(vm.trainingCosts, function (e) { return e.fundingId == f.fundingId; });
                var exists = original.length;

                if (!exists)
                {                    
                    // add
                    var obj = {
                        trainingId: vm.training.trainingId,
                        fundingId: f.fundingId,
                        cost: f.cost
                    };

                    var newEntity = datacontext.trainingCost.create(obj);
                    vm.trainingCosts.push(newEntity);
                }
                else if (exists)
                {
                    // update
                    var entity = original[0];
                    entity.cost = f.cost;
                }                             
            }

            return datacontext.save()
                .then(function(saveResult)
                {
                    // Save success
                    vm.isSaving = false;
                },
                function(error)
                {
                    // Save error
                    vm.isSaving = false;
                });
        }

        function onDestroy()
        {
            $scope.$on('$destroy', function()
            {
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
