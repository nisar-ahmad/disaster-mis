using System.Linq;
using Breeze.ContextProvider;
using Breeze.ContextProvider.EF6;
using Newtonsoft.Json.Linq;

namespace ODTKMS.Models
{
    /// <summary>
    /// Repository (a "Unit of Work" really) of models.
    /// </summary>
    public class ProjectRepository
    {
        private readonly EFContextProvider<ProjectDbContext>
            _contextProvider = new EFContextProvider<ProjectDbContext>();

        private ProjectDbContext Context { get { return _contextProvider.Context; } }

        public string Metadata { get { return _contextProvider.Metadata(); }}

        public SaveResult SaveChanges(JObject saveBundle)
        {
            return _contextProvider.SaveChanges(saveBundle);
        }

        public IQueryable<Training> Trainings { get { return Context.Trainings; } }
        public IQueryable<TrainingSession> TrainingSessions { get { return Context.TrainingSessions; } }
        public IQueryable<TrainingCost> TrainingCosts { get { return Context.TrainingCosts; } }
        public IQueryable<TrainingOrganization> TrainingOrganizations { get { return Context.TrainingOrganizations; } }
        public IQueryable<TrainingEvaluation> TrainingEvaluations { get { return Context.TrainingEvaluations; } }

        public IQueryable<Participant> Participants { get { return Context.Participants; } }
        public IQueryable<ParticipantDisabilityType> ParticipantDisabilityTypes { get { return Context.ParticipantDisabilityTypes; } }
        public IQueryable<TrainingSessionParticipant> TrainingSessionParticipants { get { return Context.TrainingSessionParticipants; } }

        public IQueryable<Organization> Organizations { get { return Context.Organizations; } }
        public IQueryable<OrganizationArea> OrganizationAreas { get { return Context.OrganizationAreas; } }
        public IQueryable<Project> Projects { get { return Context.Projects; } }
        public IQueryable<ApprovedActivity> ApprovedActivities { get { return Context.ApprovedActivities; } }
        public IQueryable<Funding> Fundings { get { return Context.Fundings; } }
        public IQueryable<Activity> Activities { get { return Context.Activities; } }
        public IQueryable<ActivityCost> ActivityCosts { get { return Context.ActivityCosts; } }

        public IQueryable<ResourcePerson> ResourcePersons { get { return Context.ResourcePersons; } }
        public IQueryable<ResourcePersonTraining> ResourcePersonTrainings { get { return Context.ResourcePersonTrainings; } }
        public IQueryable<ResourcePersonArea> ResourcePersonAreas { get { return Context.ResourcePersonAreas; } }
        public IQueryable<ResourcePersonDisabilityType> ResourcePersonDisabilityTypes { get { return Context.ResourcePersonDisabilityTypes; } }

        public IQueryable<TrainingActivity> TrainingActivities { get { return Context.TrainingActivities; } }
        public IQueryable<PotentialResourcePerson> PotentialResourcePersons { get { return Context.PotentialResourcePersons; } }

        public IQueryable<Question> Questions { get { return Context.Questions; } }
        public IQueryable<Survey> Surveys { get { return Context.Surveys; } }
        public IQueryable<SurveyQuestion> SurveyQuestions { get { return Context.SurveyQuestions; } }
        public IQueryable<SurveyQuestionResponse> SurveyQuestionResponses { get { return Context.SurveyQuestionResponses; } }
        public IQueryable<Respondent> Respondents { get { return Context.Respondents; } }
        public IQueryable<RespondentDisabilityType> RespondentDisabilityTypes { get { return Context.RespondentDisabilityTypes; } }

        public IQueryable<Document> Documents { get { return Context.Documents; } }

        public IQueryable<Gallery> Galleries { get { return Context.Galleries; } }
        public IQueryable<Group> Groups { get { return Context.Groups; } }
        public IQueryable<Album> Albums { get { return Context.Albums; } }
        public IQueryable<MediaFile> MediaFiles { get { return Context.MediaFiles; } }
        public IQueryable<MessageLog> MessageLogs { get { return Context.MessageLogs; } }

        public IQueryable<AcademicQualification> AcademicQualifications { get { return Context.AcademicQualifications; } }
        public IQueryable<ActivityType> ActivityTypes { get { return Context.ActivityTypes; } }
        public IQueryable<Area> Areas { get { return Context.Areas; } }
        public IQueryable<ThematicArea> ThematicAreas { get { return Context.ThematicAreas; } }
        public IQueryable<BroaderTrainingArea> BroaderTrainingAreas { get { return Context.BroaderTrainingAreas; } }
        public IQueryable<DisabilityType> DisabilityTypes { get { return Context.DisabilityTypes; } }
        public IQueryable<DocumentCategory> DocumentCategories { get { return Context.DocumentCategories; } }
        public IQueryable<OrganizationType> OrganizationTypes { get { return Context.OrganizationTypes; } }
        public IQueryable<AgeGroup> AgeGroups { get { return Context.AgeGroups; } }

        public IQueryable<Province> Provinces { get { return Context.Provinces; } }
        public IQueryable<District> Districts { get { return Context.Districts; } }
        public IQueryable<City> Cities { get { return Context.Cities; } }

        public IQueryable<Content> Contents { get { return Context.Contents; } }
    }
}