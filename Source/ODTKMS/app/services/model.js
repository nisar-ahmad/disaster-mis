(function()
{
    'use strict';

    var serviceId = 'model';

    angular.module('app').factory(serviceId, ['model.validation', model]);

    function model(modelValidation)
    {
        var entityNames = {
            academicQualification: 'AcademicQualification',
            activity: 'Activity',
            activityCost: 'ActivityCost',
            activityType: 'ActivityType',
            area: 'Area',
            album: 'Album',
            approvedActivity: 'ApprovedActivity',
            broaderTrainingArea: 'BroaderTrainingArea',
            city: 'City',
            content: 'Content',
            disabilityType: 'DisabilityType',
            document: 'Document',
            documentCategory: 'DocumentCategory',
            district: 'District',                      
            funding: 'Funding',
            gallery: 'Gallery',
            group: 'Group',
            mediaFile: 'MediaFile',
            messageLog: 'MessageLog',
            organization: 'Organization',
            organizationType: 'OrganizationType',
            participant: 'Participant',
            participantDisabilityType: 'ParticipantDisabilityType',            
            potentialResourcePerson: 'PotentialResourcePerson',
            project: 'Project',
            province: 'Province',
            question: 'Question',
            resourcePerson: 'ResourcePerson',
            resourcePersonArea: 'ResourcePersonArea',
            resourcePersonDisabilityType: 'ResourcePersonDisabilityType',
            resourcePersonTraining: 'ResourcePersonTraining',
            respondent: 'Respondent',
            respondentDisabilityType: 'RespondentDisabilityType',
            survey: 'Survey',
            surveyQuestion: 'SurveyQuestion',
            surveyQuestionResponse: 'SurveyQuestionResponse',
            thematicArea: 'ThematicArea',
            training: 'Training',
            trainingActivity: 'TrainingActivity',
            trainingCost: 'TrainingCost',
            trainingEvaluation: 'TrainingEvaluation',
            trainingOrganization: 'TrainingOrganization',
            trainingSession: 'TrainingSession',
            trainingSessionParticipant: 'TrainingSessionParticipant'         
        }

        var choiceMap = {
            'YesNo': ['Yes', 'No'],
            'AgreementScale': ['Strongly Agree', 'Agree Somewhat', 'Neutral', 'Disagree Somewhat', 'Strongly Disagree'],
            'SatisfactionScale': ['Highly Satisfied', 'Satisfied', 'Neutral', 'Dissatisfied', 'Highly Dissatisfied'],
            'InterestScale': ['Very Interested', 'Interested', 'Neutral', 'Not Very Interested', 'Not At All Interested']
        }

        var nulloDate = new Date(1900, 0, 1);

        // Define the functions and properties to reveal.
        var service = {
            configureMetadataStore: configureMetadataStore,
            entityNames: entityNames,
            createNullos: createNullos,
            choiceMap : choiceMap,
            extendMetadata: extendMetadata
        };

        return service;

        function configureMetadataStore(metadataStore)
        {
            registerDocument(metadataStore);
            registerTraining(metadataStore);
            registerTrainingActivity(metadataStore);
            registerParticipant(metadataStore);
            registerRespondent(metadataStore);
            registerResourcePerson(metadataStore);
            registerQuestion(metadataStore);
            registerProject(metadataStore);

            modelValidation.createAndRegister(entityNames);
        }

        function extendMetadata(metadataStore)
        {
            modelValidation.applyValidators(metadataStore);
        }

        function createNullos(manager)
        {
            var unchanged = breeze.EntityState.Unchanged;

            //createNullo(entityNames.document);
            createNullo(entityNames.training);
            //(entityNames.trainingSession, { name: ' [-- Select Training Session --]' });
            //createNullo(entityNames.trainingCost, { name: ' [-- Select Training Cost --]' });
            //createNullo(entityNames.participant, { name: ' [-- Select Participant --]' });
            //createNullo(entityNames.resourcePerson, { name: ' [-- Select Resource Person --]' });
            //createNullo(entityNames.resourcePersonTraining, { name: ' [-- Select Resource Person Training --]' });
            createNullo(entityNames.organization, { name: ' [-- Other Organization --]' });
            //createNullo(entityNames.project, { name: ' [-- Select Project --]' });
            //createNullo(entityNames.funding, { name: ' [-- Select Funding --]' });
            //createNullo(entityNames.activity, { name: ' [-- Select Activity --]' });
            //createNullo(entityNames.expenseItem, { name: ' [-- Select Expense Item --]' });
            //createNullo(entityNames.activity, { name: ' [-- Select Activity --]' });
            //createNullo(entityNames.trainingActivity, { name: ' [-- Select Training Activity --]' });
            //createNullo(entityNames.potentialResourcePerson, { name: ' [-- Select Potential Resource Person --]' });
            //createNullo(entityNames.album, { name: ' [-- Select Album --]' });
            //createNullo(entityNames.academicQualification, { name: ' [-- Select Academic Qualification --]' });
            //createNullo(entityNames.area, { name: ' [-- Select Area --]' });
            //createNullo(entityNames.thematicArea, { name: ' [-- Select Thematic Area --]' });
            //createNullo(entityNames.disabilityType, { name: ' [-- Select Disability Type --]' });
            createNullo(entityNames.documentCategory, { name: ' [-- Select Document Category --]' });
            //createNullo(entityNames.organizationType, { name: ' [-- Select Organization Type --]' });
            //createNullo(entityNames.province, { name: ' [-- Select Province --]' });
            //createNullo(entityNames.district, { name: ' [-- Select District --]' });
            //createNullo(entityNames.city, { name: ' [-- Select City --]' });

            function createNullo(entityName, values)
            {
                var initialValues = values || { name: ' [-- Select ' + entityName + ' --]' };

                return manager.createEntity(entityName, initialValues, unchanged);
            }
        }

        //#region Internal Methods   
        
        function registerEntity(entityName, metadataStore)
        {
            metadataStore.registerEntityTypeCtor(entityName, Entity);

            function Entity() {
                this.isPartial = false;
            }
        }

        function registerQuestion(metadataStore)
        {
            metadataStore.registerEntityTypeCtor('Question', Question);

            function Question()
            {
                this.isPartial = false;
                this.responseArray = [];

                Object.defineProperty(this, 'hasChoices', {
                    get: function ()
                    {
                        var hasChoices = false;

                        switch (this.type)
                        {
                            case 'CheckBoxes':
                            case 'Percentages':
                            case 'TextBoxes':
                                hasChoices = true;
                                break;
                        }

                        return hasChoices;
                    }
                });

                Object.defineProperty(this, 'choiceArray', {
                    get: function ()
                    {
                        if (this.hasChoices)
                            return this.choices.split(',');

                        return choiceMap[this.type];                        
                    }
                });

                Object.defineProperty(this, 'isScaleType', {
                    get: function ()
                    {
                        var isScaleType = false;

                        switch (this.type)
                        {
                            case 'AgreementScale':
                            case 'SatisfactionScale':
                            case 'InterestScale':
                                isScaleType = true;
                                break;
                        }

                        return isScaleType;
                    }
                });                
            };
        }

        function registerDocument(metadataStore) {
            metadataStore.registerEntityTypeCtor('Document', Document);

            function Document() {
                this.isPartial = false;
                this.yearOfPublication = moment().valueOf();
                this.accessType = 'Public';
            };
        }

        function registerTraining(metadataStore) {
            metadataStore.registerEntityTypeCtor('Training', Training);

            function Training() {
                this.isPartial = false;

                Object.defineProperty(this, 'duration', {
                    get: function ()
                    {
                        var start = moment(this.startDate);
                        var end = moment(this.endDate);

                        return end.from(start, true);
                    }
                });

                Object.defineProperty(this, 'year', {
                    get: function ()
                    {
                        return moment(this.startDate).year();
                    }
                });

                Object.defineProperty(this, 'isUpdatedRecently', {
                    get: function ()
                    {
                        var months = moment().diff(moment(this.dateModified), 'months');
                        //var days = moment().diff(this.dateModified, 'days');

                        if (months < 1)
                            return true;

                        return false;
                    }
                });
            };
        }

        function registerParticipant(metadataStore) {
            metadataStore.registerEntityTypeCtor('Participant', Participant);

            function Participant() {
                this.isPartial = false;

                Object.defineProperty(this, 'age', {
                    get: function () {

                        if (!this.dateOfBirth)
                            return null;

                        return moment().diff(this.dateOfBirth, 'years');
                    }
                });
            };
        }

        function registerTrainingActivity(metadataStore)
        {
            metadataStore.registerEntityTypeCtor('TrainingActivity', TrainingActivity);

            function TrainingActivity()
            {
                this.isPartial = false;

                Object.defineProperty(this, 'duration', {
                    get: function ()
                    {
                        var start = moment(this.startDate);
                        var end = moment(this.endDate);

                        return end.from(start, true);
                    }
                });

                Object.defineProperty(this, 'year', {
                    get: function ()
                    {
                        return moment(this.startDate).year();
                    }
                });
            };
        }

        function registerRespondent(metadataStore)
        {
            metadataStore.registerEntityTypeCtor('Respondent', Respondent);

            function Respondent()
            {
                this.isPartial = false;

                Object.defineProperty(this, 'age', {
                    get: function ()
                    {
                        if (!this.dateOfBirth)
                            return null;

                        return moment().diff(this.dateOfBirth, 'years');
                    }
                });
            };
        }

        
        function registerResourcePerson(metadataStore) {
            metadataStore.registerEntityTypeCtor('ResourcePerson', ResourcePerson);

            function ResourcePerson() {
                this.isPartial = false;

                Object.defineProperty(this, 'age', {
                    get: function ()
                    {
                        if (!this.dateOfBirth)
                            return null;

                        return moment().diff(this.dateOfBirth, 'years');
                    }
                });
            };
        }

        function registerProject(metadataStore)
        {
            metadataStore.registerEntityTypeCtor('Project', Project);

            function Project()
            {
                this.isPartial = false;

                Object.defineProperty(this, 'duration', {
                    get: function ()
                    {
                        var start = moment(this.startDate);
                        var end = moment(this.endDate);

                        return end.from(start, true);
                    }
                });
            };
        }

        //#endregion
    }
})();