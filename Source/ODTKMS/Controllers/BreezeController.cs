using System.Linq;
using System.Web.Http;
using Newtonsoft.Json.Linq;
using Breeze.ContextProvider;
using Breeze.WebApi2;
using ODTKMS.Models;
using System;

namespace ODTKMS.Controllers
{
    [BreezeController(MaxExpansionDepth = 3)]
    //[Authorize]
    public class BreezeController : ApiController
    {
        // Todo: inject via an interface rather than "new" the concrete class
        readonly ProjectRepository _repository = new ProjectRepository();

        [HttpGet] public string Metadata(){ return _repository.Metadata;  }
        
        [HttpGet] public IQueryable<Training> Trainings() { return _repository.Trainings; }
        [HttpGet] public IQueryable<TrainingSession> TrainingSessions() {  return _repository.TrainingSessions; }
        [HttpGet] public IQueryable<TrainingCost> TrainingCosts() { return _repository.TrainingCosts; }
        [HttpGet] public IQueryable<TrainingEvaluation> TrainingEvaluations() { return _repository.TrainingEvaluations; }
        [HttpGet] public IQueryable<TrainingOrganization> TrainingOrganizations() { return _repository.TrainingOrganizations; }

        [HttpGet] public IQueryable<Participant> Participants() {  return _repository.Participants; }
        [HttpGet] public IQueryable<ParticipantDisabilityType> ParticipantDisabilityTypes() { return _repository.ParticipantDisabilityTypes; }
        [HttpGet] public IQueryable<TrainingSessionParticipant> TrainingSessionParticipants() { return _repository.TrainingSessionParticipants; }

        [HttpGet] public IQueryable<Organization> Organizations() { return _repository.Organizations; }
        [HttpGet] public IQueryable<OrganizationArea> OrganizationAreas() { return _repository.OrganizationAreas; }
        [HttpGet] public IQueryable<Project> Projects() { return _repository.Projects; }
        [HttpGet] public IQueryable<ApprovedActivity> ApprovedActivities() { return _repository.ApprovedActivities; }
        [HttpGet] public IQueryable<Funding> Fundings() { return _repository.Fundings; }
        [HttpGet] public IQueryable<Activity> Activities() { return _repository.Activities; }
        [HttpGet] public IQueryable<ActivityCost> ActivityCosts() { return _repository.ActivityCosts; }

        [HttpGet] public IQueryable<ResourcePerson> ResourcePersons() { return _repository.ResourcePersons; }
        [HttpGet] public IQueryable<ResourcePersonTraining> ResourcePersonTrainings(){ return _repository.ResourcePersonTrainings; }
        [HttpGet] public IQueryable<ResourcePersonArea> ResourcePersonAreas() { return _repository.ResourcePersonAreas; }
        [HttpGet] public IQueryable<ResourcePersonDisabilityType> ResourcePersonDisabilityTypes() { return _repository.ResourcePersonDisabilityTypes; }

        [HttpGet] public IQueryable<TrainingActivity> TrainingActivities() { return _repository.TrainingActivities; }
        [HttpGet] public IQueryable<PotentialResourcePerson> PotentialResourcePersons() { return _repository.PotentialResourcePersons; }

        [HttpGet] public IQueryable<Question> Questions() {  return _repository.Questions; }
        [HttpGet] public IQueryable<Survey> Surveys() {  return _repository.Surveys; }
        [HttpGet] public IQueryable<SurveyQuestion> SurveyQuestions() { return _repository.SurveyQuestions; }
        [HttpGet] public IQueryable<SurveyQuestionResponse> SurveyQuestionResponses() {  return _repository.SurveyQuestionResponses;  }
        [HttpGet] public IQueryable<Respondent> Respondents() { return _repository.Respondents;  }
        [HttpGet] public IQueryable<RespondentDisabilityType> RespondentDisabilityTypes() { return _repository.RespondentDisabilityTypes;  }

        [HttpGet] public IQueryable<Document> Documents() { return _repository.Documents; }

        [HttpGet] public IQueryable<Gallery> Galleries() { return _repository.Galleries; }
        [HttpGet] public IQueryable<Group> Groups() { return _repository.Groups; }
        [HttpGet] public IQueryable<Album> Albums() { return _repository.Albums; }
        [HttpGet] public IQueryable<MediaFile> MediaFiles(){ return _repository.MediaFiles; }
        [HttpGet] public IQueryable<MessageLog> MessageLogs() { return _repository.MessageLogs; }

        [HttpGet] public IQueryable<AcademicQualification> AcademicQualifications() { return _repository.AcademicQualifications; }
        [HttpGet] public IQueryable<ActivityType> ActivityTypes() { return _repository.ActivityTypes; }
        [HttpGet] public IQueryable<Area> Areas() {return _repository.Areas; }
        [HttpGet] public IQueryable<ThematicArea> ThematicAreas() { return _repository.ThematicAreas; }
        [HttpGet] public IQueryable<BroaderTrainingArea> BroaderTrainingAreas() { return _repository.BroaderTrainingAreas; }
        [HttpGet] public IQueryable<DisabilityType> DisabilityTypes() { return _repository.DisabilityTypes; }
        [HttpGet] public IQueryable<DocumentCategory> DocumentCategories() { return _repository.DocumentCategories; }
        [HttpGet] public IQueryable<OrganizationType> OrganizationTypes() { return _repository.OrganizationTypes; }
        [HttpGet] public IQueryable<Province> Provinces() { return _repository.Provinces; }
        [HttpGet] public IQueryable<District> Districts() { return _repository.Districts; }
        [HttpGet] public IQueryable<City> Cities() { return _repository.Cities; }
        [HttpGet] public IQueryable<AgeGroup> AgeGroups() { return _repository.AgeGroups; }
        [HttpGet] public IQueryable<Content> Contents() { return _repository.Contents; }
        

        [HttpGet]
        public object Enums()
        {
            var accessTypes = Enum.GetNames(typeof(AccessType));
            var albumTypes = Enum.GetNames(typeof(AlbumType));
            var fileTypes = Enum.GetNames(typeof(FileType));
            var deliveryStatuses = Enum.GetNames(typeof(DeliveryStatus));
            var organizationCategories = Enum.GetNames(typeof(OrganizationCategory));
            var relationshipTypes = Enum.GetNames(typeof(RelationshipType));
            var fundingTypes = Enum.GetNames(typeof(FundingType));
            var geographicalAreas = Enum.GetNames(typeof(GeographicalArea));
            var genderTypes = Enum.GetNames(typeof(GenderType));
            var groupTypes = Enum.GetNames(typeof(GroupType));
            var accountTypes = Enum.GetNames(typeof(AccountType));
            var approvalTypes = Enum.GetNames(typeof(ApprovalType));
            var collaboratingOrganizations = Enum.GetNames(typeof(CollaboratingOrganization));
            var trainingTypes = Enum.GetNames(typeof(TrainingType));
            var trainingStatuses = Enum.GetNames(typeof(TrainingStatus));
            var trainingLevels = Enum.GetNames(typeof(TrainingLevel));
            //var broaderTrainingAreas = Enum.GetNames(typeof(BroaderTrainingArea));
            var questionTypes = Enum.GetNames(typeof(QuestionType));
            var contentTypes = Enum.GetNames(typeof(ContentType));

            return new {accessTypes,
                        albumTypes,
                        fileTypes,
                        deliveryStatuses,
                        organizationCategories,
                        relationshipTypes,
                        fundingTypes,
                        geographicalAreas,
                        genderTypes,
                        groupTypes,
                        accountTypes,
                        approvalTypes,
                        collaboratingOrganizations,
                        trainingTypes,
                        trainingStatuses,
                        trainingLevels,
                        //broaderTrainingAreas,
                        questionTypes,
                        contentTypes
            };
        }

        [HttpPost]
        public SaveResult SaveChanges(JObject saveBundle)
        {
            return _repository.SaveChanges(saveBundle);
        }


        // Diagnostic
        [HttpGet]
        public string Ping()
        {
            return "pong";
        }
    }
}