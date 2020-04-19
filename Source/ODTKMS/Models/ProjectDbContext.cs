using System.Data.Entity;
using System.Data.Entity.ModelConfiguration.Conventions;

namespace ODTKMS.Models
{
    public partial class ProjectDbContext : DbContext
    {
        public ProjectDbContext(): base("DefaultConnection")
        {
        }

        protected override void OnModelCreating(DbModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);

            modelBuilder.Conventions.Remove<OneToManyCascadeDeleteConvention>();
            modelBuilder.Conventions.Remove<PluralizingTableNameConvention>();

            // Disable proxy creation and lazy loading; not wanted in this service context.
            Configuration.ProxyCreationEnabled = false;
            Configuration.LazyLoadingEnabled = false;
        }

        public DbSet<Activity> Activities { get; set; }
        public DbSet<ActivityCost> ActivityCosts { get; set; }
        public DbSet<Album> Albums { get; set; }

        public DbSet<Organization> Organizations { get; set; }
        public DbSet<OrganizationArea> OrganizationAreas { get; set; }
        public DbSet<Project> Projects { get; set; }
        public DbSet<ApprovedActivity> ApprovedActivities { get; set; }
        public DbSet<Funding> Fundings { get; set; }
        

        public DbSet<Training> Trainings { get; set; }
        public DbSet<TrainingOrganization> TrainingOrganizations { get; set; }
        public DbSet<TrainingSession> TrainingSessions { get; set; }
        public DbSet<TrainingCost> TrainingCosts { get; set; }
        public DbSet<TrainingEvaluation> TrainingEvaluations { get; set; }

        public DbSet<Participant> Participants { get; set; }

        public DbSet<Document> Documents { get; set; }
        public DbSet<Gallery> Galleries { get; set; }
        public DbSet<Group> Groups { get; set; }
        
        public DbSet<MediaFile> MediaFiles { get; set; }
        public DbSet<MessageLog> MessageLogs { get; set; }

        public DbSet<OrganizationType> OrganizationTypes { get; set; }
        public DbSet<Area> Areas { get; set; }
        public DbSet<ThematicArea> ThematicAreas { get; set; }
        public DbSet<BroaderTrainingArea> BroaderTrainingAreas { get; set; }
        public DbSet<AcademicQualification> AcademicQualifications { get; set; }
        public DbSet<DocumentCategory> DocumentCategories { get; set; }
        public DbSet<DisabilityType> DisabilityTypes { get; set; }
        public DbSet<Province> Provinces { get; set; }
        public DbSet<District> Districts { get; set; }
        public DbSet<City> Cities { get; set; }
        public DbSet<ActivityType> ActivityTypes { get; set; }
        public DbSet<AgeGroup> AgeGroups { get; set; }

        public DbSet<ResourcePerson> ResourcePersons { get; set; }
        public DbSet<ResourcePersonTraining> ResourcePersonTrainings { get; set; }
        public DbSet<ResourcePersonArea> ResourcePersonAreas { get; set; }
        public DbSet<ResourcePersonDisabilityType> ResourcePersonDisabilityTypes { get; set; }

        public DbSet<ParticipantDisabilityType> ParticipantDisabilityTypes { get; set; }
        public DbSet<TrainingSessionParticipant> TrainingSessionParticipants { get; set; }

        public DbSet<TrainingActivity> TrainingActivities { get; set; }
        public DbSet<PotentialResourcePerson> PotentialResourcePersons { get; set; }

        public DbSet<Question> Questions { get; set; }
        public DbSet<Survey> Surveys { get; set; }
        public DbSet<SurveyQuestion> SurveyQuestions { get; set; }
        public DbSet<SurveyQuestionResponse> SurveyQuestionResponses { get; set; }

        public DbSet<Respondent> Respondents { get; set; }
        public DbSet<RespondentDisabilityType> RespondentDisabilityTypes { get; set; }

        public DbSet<Content> Contents { get; set; }

    }
}