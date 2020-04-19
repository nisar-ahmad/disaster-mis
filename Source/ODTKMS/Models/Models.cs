using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel;

namespace ODTKMS.Models
{
    #region DROPDOWN LISTS

    public static class Lists
    {
        public static string[] Titles = { "Mr", "Ms", "Mrs", "Dr", "Engr" };
    }

    #endregion

    #region ENUMS

    public enum AccessType { Public, Private }
    public enum AccountType { Current, Saving }
    public enum AlbumType { Training, Project, Activity, Training4W, TNA, General, System }
    public enum ApprovalType { Pending, Accepted, Rejected }      

    //public enum BroaderTrainingArea { Mitigation, Preparedness, Response, Recovery, Other }    
    public enum CollaboratingOrganization { NIDM, NDMA, Other, None }

    public enum DeliveryStatus { Pending, Delivered, NotDelivered }
    
    public enum FileType { Unknown, Image, Video, Pdf, Word }
    public enum FundingType { Cash, InKind, Expertise }

    public enum GeographicalArea { Nationwide, Punjab, Sindh, KPK, Balochistan, GB, AJK, FATA }
    public enum GenderType { Male, Female }
    public enum GroupType { Email, SMS }

    public enum OrganizationCategory { Default, FourW }
    public enum QuestionType { YesNo, AgreementScale, SatisfactionScale, InterestScale, Text, CheckBoxes, Percentages, TextBoxes }

    public enum RelationshipType { None, Donor, CollaboratinAgency, Both }

    public enum TrainingType { Practioner, TrainingOfTrainers, Other }
    public enum TrainingStatus { Draft, Planned, Scheduled, InProgress, Completed, Rescheduled, Postponed, Cancelled }
    public enum TrainingLevel { International, National, Province, Division, District, Local }

    public enum ContentType { MainSlider, News, Event, StakeholderActivity, ProminentStakeholder, GuestBook, PictureSlider, Partner}

    #endregion

    #region MODULE 1: COURSE MANAGEMENT

    public class Training
    {
        public Training()
        {
            StartDate = EndDate = DateTime.Now;
            ProvinceId = 4;
            CityId = DistrictId = 55;
        }

        [Key]
        public int TrainingId { get; set; }

        [Display(Name = "Status")]
        public TrainingStatus Status { get; set; }

        [Required]
        [Display(Name = "Title")]
        public string Name { get; set; }

        public string Objective { get; set; }

        [DataType(DataType.MultilineText)]
        [Display(Name = "Agenda / Description")]
        public string Description { get; set; }

        [Display(Name = "Training Type")]
        public TrainingType TrainingType { get; set; }

        [Display(Name = "Training Level")]
        public TrainingLevel TrainingLevel { get; set; }

        [Display(Name = "Broader Training Area")]
        [ForeignKey("BroaderTrainingArea")]
        public int BroaderTrainingAreaId { get; set; }

        [Display(Name = "Start Date")]
        [DisplayFormat(DataFormatString = "{0:dd MMM yyyy}")]
        public DateTime StartDate { get; set; }

        [Display(Name = "End Date")]
        [DisplayFormat(DataFormatString = "{0:dd MMM yyyy}")]
        public DateTime EndDate { get; set; }

        [Display(Name = "Training Fee")]
        public int Fee { get; set; }

        [Display(Name = "Province/Region")]
        [ForeignKey("Province")]
        public int ProvinceId { get; set; }

        [Display(Name = "District")]
        [ForeignKey("District")]
        public int DistrictId { get; set; }

        [Display(Name = "City")]
        [ForeignKey("City")]
        public int CityId { get; set; }

        [Display(Name = "Logistic Note")]
        public string LogisticNote { get; set; }

        [Display(Name = "Reference Material")]
        public string ReferenceMaterial { get; set; }

        [Display(Name = "Fee Voucher")]
        public string FeeVoucher { get; set; }

        [ForeignKey("Survey")]
        [Display(Name = "Evaluation Survey")]
        public int SurveyId { get; set; }

        public string Location { get; set; }

        [DisplayFormat(DataFormatString = "{0:dd MMM yyyy}")]
        public DateTime DateCreated { get; set; }

        [DisplayFormat(DataFormatString = "{0:dd MMM yyyy}")]
        public DateTime DateModified { get; set; }

        public virtual BroaderTrainingArea BroaderTrainingArea { get; set; }
        public virtual Province Province { get; set; }
        public virtual District District { get; set; }
        public virtual City City { get; set; }
        public virtual Survey Survey { get; set; }

        public virtual ICollection<TrainingSession> TrainingSessions { get; set; }
        public virtual ICollection<TrainingOrganization> TrainingOrganizations { get; set; }
        public virtual ICollection<TrainingCost> TrainingCosts { get; set; }
        public virtual ICollection<TrainingEvaluation> TrainingEvaluations { get; set; }
        public virtual ICollection<Participant> Participants { get; set; }

    }

    public class TrainingSession
    {
        public TrainingSession()
        {
            DateOfSession = DateTime.Now;
            //StartTime = DateTime.Now.Date.AddHours(9);
            //EndTime = StartTime.AddHours(8);
        }

        [Key]
        public int TrainingSessionId { get; set; }

        [ForeignKey("Training")]
        [Display(Name = "Training")]
        public int TrainingId { get; set; }

        [Required]
        [Display(Name = "Title")]
        public string Name { get; set; }

        public string Module { get; set; }        

        [Display(Name= "Date of Session")]
        public DateTime DateOfSession { get; set; }

        [Display(Name = "Start Time")]
        [DisplayFormat(DataFormatString = "{0:hh:mm tt}")]
        public DateTime StartTime { get; set; }

        [Display(Name = "End Time")]
        [DisplayFormat(DataFormatString = "{0:hh:mm tt}")]
        public DateTime EndTime { get; set; }

        [Display(Name = "Agenda / Description")]
        [DataType(DataType.MultilineText)]
        public string Agenda { get; set; }

        [DataType(DataType.MultilineText)]
        public string LogisticNote { get; set; }

        public virtual Training Training { get; set; }

        [Display(Name = "Resource Persons")]
        public virtual ICollection<ResourcePersonTraining> ResourcePersonTrainings { get; set; }

        [Display(Name = "Participants")]
        public virtual ICollection<TrainingSessionParticipant> TrainingSessionParticipants { get; set; }
    }

    public class TrainingEvaluation
    {
        [Key, Column(Order = 0)]
        [ForeignKey("Training")]
        public int TrainingId { get; set; }

        [Key, Column(Order = 1)]
        [ForeignKey("Survey")]
        public int SurveyId { get; set; }

        [Key, Column(Order = 2)]
        [ForeignKey("Question")]
        public int QuestionId { get; set; }

        [Key, Column(Order = 3)]
        [ForeignKey("Participant")]
        public int ParticipantId { get; set; }

        public string Response { get; set; }
        public string Reason { get; set; }
        public DateTime ResponseDate { get; set; }

        public virtual Training Training { get; set; }
        public virtual Survey Survey { get; set; }
        public virtual Participant Participant { get; set; }
        public virtual Question Question { get; set; }
    }

    public class TrainingOrganization
    {
        [Key, Column(Order = 0)]
        [ForeignKey("Training")]
        public int TrainingId { get; set; }

        [Key, Column(Order = 1)]
        [ForeignKey("Organization")]
        public int OrganizationId { get; set; }

        public virtual Training Training { get; set; }
        public virtual Organization Organization { get; set; }
    }

    public class TrainingCost
    {
        [Key]
        public int TrainingCostId { get; set; }

        [ForeignKey("Training")]
        [Display(Name = "Training")]
        public int TrainingId { get; set; }

        [ForeignKey("Funding")]
        [Display(Name = "Funding")]
        public int FundingId { get; set; }

        [Range(1, 10000000)]
        public int Cost { get; set; }

        public virtual Training Training { get; set; }
        public virtual Funding Funding { get; set; }
    }

    #endregion

    #region MODUEL 2: PARTICIPANTS

    public class Participant
    {
        public Participant()
        {
            IsActive = true;
        }

        [Key]
        public int ParticipantId { get; set; }

        [ForeignKey("Training")]
        [Display(Name = "Training")]
        public int TrainingId { get; set; }

        [Required]
        public string Title { get; set; }

        [Required]
        [Display(Name = "Full Name")]
        public string Name { get; set; }

        [RegularExpression("^$|[0-9+]{5}-[0-9+]{7}-[0-9]{1}", ErrorMessage = "Use CNIC Format: 11111-2222222-3")]
        public string CNIC { get; set; }

        [Required]
        public GenderType Gender { get; set; }

        [Display(Name = "Date Of Birth")]
        [DisplayFormat(DataFormatString = "{0:dd MMM yyyy}")]
        public DateTime? DateOfBirth { get; set; }

        [Display(Name = "Special Ability")]
        public bool HasSpecialAbility { get; set; }

        [Display(Name = "Organization Type")]
        [ForeignKey("OrganizationType")]
        public int OrganizationTypeId { get; set; }

        [Display(Name = "Organization / Department")]
        [ForeignKey("Organization")]
        public int? OrganizationId { get; set; }

        [Display(Name = "Other Organization / Department")]
        public string OtherOrganization { get; set; }

        ////////////////////////////////////
        // Designation / Position
        ////////////////////////////////////

        public string Designation { get; set; }

        [Range(1, 22)]
        [Display(Name = "BPS Grade")]
        public int? BPSNo { get; set; }

        [Range(0, 70)]
        [Display(Name = "Years of Professional Experience")]
        public int YearsOfExperience { get; set; }

        [Display(Name = "Academic Qualification")]
        [ForeignKey("AcademicQualification")]
        public int AcademicQualificationId { get; set; }

        [Display(Name = "District of Posting")]
        [ForeignKey("District")]
        public int DistrictId { get; set; }

        [Display(Name = "Official Address")]
        [DataType(DataType.MultilineText)]
        public string OfficialAddress { get; set; }

        [Display(Name = "Residential Address")]
        [DataType(DataType.MultilineText)]
        public string ResidentialAddress { get; set; }

        ////////////////////////////////////
        //Contact Details
        ////////////////////////////////////

        [Display(Name = "Phone with Ext.")]
        public string PhoneWithExt { get; set; }

        [Display(Name = "Fax")]
        public string Fax { get; set; }

        public string Cell { get; set; }

        [Required]
        [DataType(DataType.EmailAddress)]
        [EmailAddress]
        public string Email { get; set; }

        public string Skype { get; set; }

        [Display(Name = "Any Previous DRM Training Attended?")]
        public bool AnyPreviousTrainingAttended { get; set; }

        [Display(Name = "Previous DRM Trainings")]
        public string PreviousTrainings { get; set; }

        [Display(Name = "Fee Paid?")]
        public bool IsFeePaid { get; set; }

        [Display(Name = "Amount Paid")]
        public int AmountPaid { get; set; }

        [Display(Name = "Proof of Payment")]
        public string PaymentProofDocument { get; set; }

        [Display(Name = "Status")]
        public ApprovalType ApprovalStatus { get; set; }

        [Display(Name = "Active")]
        public bool IsActive { get; set; }

        [Display(Name = "Organization Type")]
        public virtual OrganizationType OrganizationType { get; set; }

        [Display(Name = "Organization")]
        public virtual Organization Organization { get; set; }

        [Display(Name = "Academic Qualification")]
        public virtual AcademicQualification AcademicQualification { get; set; }
        
        [Display(Name = "District")]
        public virtual District District { get; set; }

        [Display(Name = "Registered for Training")]
        public virtual Training Training { get; set; }

        [Display(Name = "Special Abilities")]
        public virtual ICollection<ParticipantDisabilityType> ParticipantDisabilityTypes { get; set; }

        [Display(Name = "Sessions Attended")]
        public virtual ICollection<TrainingSessionParticipant> TrainingSessionParticipants { get; set; }

        public virtual ICollection<TrainingEvaluation> TrainingEvaluations { get; set; }
    }

    public class ParticipantDisabilityType
    {
        [Key, Column(Order = 0)]
        [ForeignKey("Participant")]
        public int ParticipantId { get; set; }

        [Key, Column(Order = 1)]
        [ForeignKey("DisabilityType")]
        [Display(Name = "Special Ability")]
        public int DisabilityTypeId { get; set; }

        [Display(Name = "Participant")]
        public virtual Participant Participant { get; set; }

        [Display(Name = "Special Ability")]
        public virtual DisabilityType DisabilityType { get; set; }
    }

    public class TrainingSessionParticipant
    {
        [Key, Column(Order = 0)]
        [ForeignKey("TrainingSession")]
        [Display(Name = "Training Session")]
        public int TrainingSessionId { get; set; }

        [Key, Column(Order = 1)]
        [ForeignKey("Participant")]
        [Display(Name = "Participant")]
        public int ParticipantId { get; set; }

        [Display(Name = "Training Session")]
        public virtual TrainingSession TrainingSession { get; set; }

        public virtual Participant Participant { get; set; }
    }

    #endregion

    #region MODULE 3: DONORS & COLLABORATING AGENCIES

    public class Organization
    {
        public Organization()
        {
            IsActive = true;
        }

        [Key]
        public int OrganizationId { get; set; }

        [Required]
        [Display(Name = "Organization")]
        public string Name { get; set; }

        [Display(Name = "Organization Type")]
        [ForeignKey("OrganizationType")]
        public int OrganizationTypeId { get; set; }

        [Display(Name = "Relationship Type")]
        public RelationshipType RelationshipType { get; set; }

        [Display(Name = "Geographical Area")]
        public GeographicalArea GeographicalArea { get; set; }

        [Display(Name = "Established Since")]
        [DisplayFormat(DataFormatString = "{0:dd MMM yyyy}")]
        public DateTime? DateEstablished { get; set; }

        [Display(Name = "MoU/NOC/Registering Department/Authority")]
        public string RegisteringAuthority { get; set; }

        [Display(Name = "MoU/NOC/Registeraion No.")]
        public string RegistrationNumber { get; set; }

        [Display(Name = "MoU/NOC/Registeration Certificate")]
        public string RegistrationCertificate { get; set; }

        // Contact Details

        [Display(Name = "Head Office Address")]
        public string Address { get; set; }

        [Display(Name = "Head Office District")]
        [ForeignKey("District")]
        public int DistrictId { get; set; }

        [Display(Name = "Head Office Email")]
        public string Email { get; set; }

        [Display(Name = "Head Office Landline")]
        public string Landline { get; set; }

        [Display(Name = "Head Office Fax")]
        public string Fax { get; set; }

        [Display(Name = "Website")]
        [DataType(DataType.Url)]
        public string Website { get; set; }

        [Display(Name = "Skype")]
        public string Skype { get; set; }

        // Head of Organization

        [Display(Name = "Title")]
        public string HeadTitle { get; set; }

        [Display(Name = "Name")]
        public string HeadName { get; set; }

        [Display(Name = "Designation")]
        public string HeadDesignation { get; set; }

        [Display(Name = "Landline")]
        public string HeadLandline { get; set; }

        [Display(Name = "Fax")]
        public string HeadFax { get; set; }

        [Display(Name = "Mobile")]
        public string HeadMobile { get; set; }

        [Display(Name = "Email")]
        [DataType(DataType.EmailAddress)]
        public string HeadEmail { get; set; }

        [Display(Name = "Photo")]
        public string HeadPhoto { get; set; }

        // Contact Person

        [Display(Name = "Title")]
        public string ContactPersonTitle { get; set; }

        [Display(Name = "Name")]
        public string ContactPersonName { get; set; }

        [Display(Name = "Designation")]
        public string ContactPersonDesignation { get; set; }

        [Display(Name = "Landline")]
        public string ContactPersonLandline { get; set; }

        [Display(Name = "Fax")]
        public string ContactPersonFax { get; set; }

        [Display(Name = "Mobile")]
        public string ContactPersonMobile { get; set; }

        [Display(Name = "Email")]
        public string ContactPersonEmail { get; set; }

        [Display(Name = "Logo")]
        [DataType(DataType.ImageUrl)]
        public string Logo { get; set; }

        [Display(Name = "Profile")]
        [DataType(DataType.Url)]
        public string Profile { get; set; }

        public OrganizationCategory Category { get; set; }

        public ApprovalType ApprovalStatus { get; set; }

        //[Index("UserNameIndex", IsUnique = true)]
        //[MaxLength(10)]
        public string Username { get; set; }
        public string PasswordHash { get; set; }

        [Display(Name = "Active")]
        public bool IsActive { get; set; }

        [Display(Name = "Organization Type")]
        public virtual OrganizationType OrganizationType { get; set; }

        [Display(Name = "Head Office District")]
        public virtual District District { get; set; }

        [Display(Name = "Organization Trainings")]
        public virtual ICollection<TrainingOrganization> TrainingOrganizations { get; set; }

        [Display(Name = "Areas of Intervention")]
        public virtual ICollection<OrganizationArea> OrganizationAreas { get; set; }
    }

    public class OrganizationArea
    {
        [Key, Column(Order = 0)]
        [ForeignKey("Organization")]
        public int OrganizationId { get; set; }

        [Key, Column(Order = 1)]
        [ForeignKey("Area")]
        [Display(Name = "Area of Specialty")]
        public int AreaId { get; set; }

        public virtual Organization Organization { get; set; }

        [Display(Name = "Area of Intervention")]
        public virtual Area Area { get; set; }
    }

    public class Project
    {
        public Project()
        {
            IsActive = true;
        }

        [Key]
        public int ProjectId { get; set; }

        [ForeignKey("Organization")]
        [Display(Name = "Donor")]
        public int OrganizationId { get; set; }

        [Display(Name = "Project Title")]
        public string Name { get; set; }

        [Display(Name = "Project Description")]
        public string Description { get; set; }

        [Display(Name = "Project Number")]
        public string ProjectNumber { get; set; }

        [Display(Name = "Start Date")]
        [DisplayFormat(DataFormatString = "{0:dd MMM yyyy}")]
        public DateTime StartDate { get; set; }

        [Display(Name = "End Date")]
        [DisplayFormat(DataFormatString = "{0:dd MMM yyyy}")]
        public DateTime EndDate { get; set; }

        [Display(Name = "Proposal")]
        public string Proposal { get; set; }

        [Display(Name = "Workplan")]
        public string Workplan { get; set; }

        [Display(Name = "LOA")]
        public string LOA { get; set; }

        [Display(Name = "Other Documents")]
        public string OtherDocuments { get; set; }

        [Display(Name = "Active")]
        public bool IsActive { get; set; }

        [Display(Name = "Donor")]
        public virtual Organization Organization { get; set; }

        [Display(Name = "Funding")]
        public virtual ICollection<Funding> Fundings { get; set; }

        [Display(Name = "Activities")]
        public virtual ICollection<Activity> Activities { get; set; }
    }

    public class ApprovedActivity
    {
        [Key]
        public int ApprovedActivityId { get; set; }

        [Required]
        public string Name { get; set; }

        [DataType(DataType.MultilineText)]
        public string Description { get; set; }

        public virtual ICollection<Funding> Fundings { get; set; }
    }

    public class Funding
    {
        public Funding()
        {
            StartDate = EndDate = DateTime.Now;
        }

        [Key]
        public int FundingId { get; set; }

        [ForeignKey("Project")]
        public int ProjectId { get; set; }

        [ForeignKey("ApprovedActivity")]
        public int ApprovedActivityId { get; set; }

        public FundingType FundingType { get; set; }

        public int CashAmount { get; set; }

        [Display(Name = "Start Date")]
        [DisplayFormat(DataFormatString = "{0:dd MMM yyyy}")]
        public DateTime StartDate { get; set; }

        [Display(Name = "End Date")]
        [DisplayFormat(DataFormatString = "{0:dd MMM yyyy}")]
        public DateTime EndDate { get; set; }

        public virtual Project Project { get; set; }

        [Display(Name = "Approved Activity")]
        public virtual ApprovedActivity ApprovedActivity { get; set; }
    }

    public class Activity
    {
        public Activity()
        {
            DateOfActivity = DateTime.Now;
        }

        [Key]
        public int ActivityId { get; set; }

        [ForeignKey("Project")]
        public int ProjectId { get; set; }

        [ForeignKey("ActivityType")]
        public int ActivityTypeId { get; set; }

        [Required]
        [Display(Name = "Activity Title")]
        public string Name { get; set; }

        [Display(Name = "Activity Description")]
        public string Description { get; set; }

        [Display(Name = "Activity Date")]
        [DisplayFormat(DataFormatString = "{0:dd MMM yyyy}")]
        public DateTime DateOfActivity { get; set; }

        [ForeignKey("City")]
        [Display(Name = "Activity Location")]
        public int CityId { get; set; }

        [Display(Name = "Activity Location")]
        public virtual City City { get; set; }

        public virtual Project Project { get; set; }
        public virtual ActivityType ActivityType { get; set; }

        [Display(Name = "Activity Costs")]
        public virtual ICollection<ActivityCost> ActivityCosts { get; set; }
    }

    public class ActivityCost
    {
        [Key]
        public int ActivityCostId { get; set; }

        [ForeignKey("Activity")]
        public int ActivityId { get; set; }

        [ForeignKey("Funding")]
        public int FundingId { get; set; }

        [Range(1, 10000000)]
        public int Cost { get; set; }

        public string Description { get; set; }

        public virtual Activity Activity { get; set; }
        public virtual Funding Funding { get; set; }
    }

    #endregion

    #region MODULE 4: RESOURSE PERSONS

    public class ResourcePerson
    {
        public ResourcePerson()
        {
            IsActive = true;
        }

        [Key]
        public int ResourcePersonId { get; set; }

        [Required]
        public string Title { get; set; }

        [Required]
        [Display(Name = "Full Name")]
        public string Name { get; set; }

        [RegularExpression("^$|[0-9+]{5}-[0-9+]{7}-[0-9]{1}", ErrorMessage = "Use CNIC Format: 11111-2222222-3")]
        public string CNIC { get; set; }

        [Required]
        public GenderType Gender { get; set; }

        [Display(Name = "Date Of Birth")]
        [DisplayFormat(DataFormatString = "{0:dd MMM yyyy}")]
        public DateTime? DateOfBirth { get; set; }

        [Display(Name = "Special Ability")]
        public bool HasSpecialAbility { get; set; }

        [Display(Name = "Organization Type")]
        [ForeignKey("OrganizationType")]
        public int OrganizationTypeId { get; set; }

        [Display(Name = "Organization / Department")]
        [ForeignKey("Organization")]
        public int? OrganizationId { get; set; }

        [Display(Name = "Other Organization / Department")]
        public string OtherOrganization { get; set; }

        ////////////////////////////////////
        // Designation / Position
        ////////////////////////////////////

        public string Designation { get; set; }

        [Range(1, 22)]
        [Display(Name = "BPS Grade")]
        public int? BPSNo { get; set; }

        [Range(0, 70)]
        [Display(Name = "Years of Professional Experience")]
        public int YearsOfExperience { get; set; }

        [Display(Name = "Academic Qualification")]
        [ForeignKey("AcademicQualification")]
        public int AcademicQualificationId { get; set; }

        [Display(Name = "District of Posting")]
        [ForeignKey("District")]
        public int DistrictId { get; set; }

        [Display(Name = "Official Address")]
        [DataType(DataType.MultilineText)]
        public string OfficialAddress { get; set; }

        [Display(Name = "Residential Address")]
        [DataType(DataType.MultilineText)]
        public string ResidentialAddress { get; set; }


        ////////////////////////////////////
        //Contact Details
        ////////////////////////////////////

        [Display(Name = "Phone with Ext.")]
        public string PhoneWithExt { get; set; }

        [Display(Name = "Fax")]
        public string Fax { get; set; }

        public string Cell { get; set; }

        [DataType(DataType.EmailAddress)]
        [EmailAddress]
        public string Email { get; set; }


        public string Skype { get; set; }

        ////////////////////////////////////
        //  Banking Details 
        ////////////////////////////////////

        [Display(Name = "Bank Name")]

        public string BankName { get; set; }

        [Display(Name = "Branch Name")]

        public string BranchName { get; set; }

        [Display(Name = "Branch Code")]

        public string BranchCode { get; set; }

        [Display(Name = "Account Title")]

        public string AccountTitle { get; set; }

        [Display(Name = "Account No.")]
        public string AccountNo { get; set; }

        [Display(Name = "Account Type")]
        public AccountType AccountType { get; set; }

        [Display(Name = "IBAN")]
        public string IBAN { get; set; }

        [Display(Name = "Status")]
        public ApprovalType ApprovalStatus { get; set; }

        [Display(Name = "CV with Profile")]
        public string Resume { get; set; }

        public string Photo { get; set; }

        [Display(Name = "Active")]
        public bool IsActive { get; set; }

        [Display(Name = "Organization Type")]
        public virtual OrganizationType OrganizationType { get; set; }

        [Display(Name = "Organization")]
        public virtual Organization Organization { get; set; }

        [Display(Name = "Academic Qualification")]
        public virtual AcademicQualification AcademicQualification { get; set; }        

        [Display(Name = "District")]
        public virtual District District { get; set; }

        [Display(Name = "Training Sessions")]
        public virtual ICollection<ResourcePersonTraining> ResourcePersonTrainings { get; set; }

        [Display(Name = "Special Abilities")]
        public virtual ICollection<ResourcePersonDisabilityType> ResourcePersonDisabilityTypes { get; set; }

        [Display(Name = "Areas of Specialty")]
        public virtual ICollection<ResourcePersonArea> ResourcePersonAreas { get; set; }
    }

    public class ResourcePersonDisabilityType
    {
        [Key, Column(Order = 0)]
        [ForeignKey("ResourcePerson")]
        [Display(Name = "Resource Person")]
        public int ResourcePersonId { get; set; }

        [Key, Column(Order = 1)]
        [ForeignKey("DisabilityType")]
        [Display(Name = "Special Ability")]
        public int DisabilityTypeId { get; set; }

        [Display(Name = "Resource Person")]
        public virtual ResourcePerson ResourcePerson { get; set; }

        [Display(Name = "Special Ability")]
        public virtual DisabilityType DisabilityType { get; set; }
    }

    public class ResourcePersonArea
    {
        [Key, Column(Order = 0)]
        [ForeignKey("ResourcePerson")]
        [Display(Name = "Resource Person")]
        public int ResourcePersonId { get; set; }

        [Key, Column(Order = 1)]
        [ForeignKey("Area")]
        [Display(Name = "Area of Interest")]
        public int AreaId { get; set; }

        [Display(Name = "Resource Person")]
        public virtual ResourcePerson ResourcePerson { get; set; }

        [Display(Name = "Area of Interest")]
        public virtual Area Area { get; set; }
    }

    public class ResourcePersonTraining
    {
        [Key, Column(Order = 0)]
        [ForeignKey("ResourcePerson")]
        [Display(Name = "Resource Person")]
        public int ResourcePersonId { get; set; }

        [Key, Column(Order = 1)]
        [ForeignKey("TrainingSession")]
        [Display(Name = "Training Session")]
        public int TrainingSessionId { get; set; }

        [Display(Name = "Paid?")]
        public bool IsPaid { get; set; }

        [Range(0, 1000000)]
        [Display(Name = "Amount Paid")]
        public int AmountPaid { get; set; }

        [Display(Name = "Resource Person")]
        public virtual ResourcePerson ResourcePerson { get; set; }

        [Display(Name = "Training Session")]
        public virtual TrainingSession TrainingSession { get; set; }
    }

    #endregion
   
    #region MODULE 5: 4W TRAINING ACTIVITIES

    public class TrainingActivity
    {
        public TrainingActivity()
        {
            StartDate = DateTime.Now;
            EndDate = DateTime.Now;
        }

        [Key]
        public int TrainingActivityId { get; set; }

        [Display(Name = "Organization")]
        [ForeignKey("Organization")]
        public int OrganizationId { get; set; }

        /////////////////////////////////////////////////////////////////////
        // Training Details
        /////////////////////////////////////////////////////////////////////
        [Display(Name = "Collaborating Organization")]
        public CollaboratingOrganization CollaboratingOrganization { get; set; }

        [Required]
        [Display(Name = "Title Of Training")]
        public string TitleOfTraining { get; set; }

        [Display(Name = "Training Type")]
        public TrainingType TrainingType { get; set; }

        [Display(Name = "Training Level")]
        public TrainingLevel TrainingLevel { get; set; }

        [Display(Name = "Broader Training Area")]
        [ForeignKey("BroaderTrainingArea")]
        public int BroaderTrainingAreaId { get; set; }

        [Display(Name = "Start Date")]
        [DisplayFormat(DataFormatString = "{0:dd MMM yyyy}")]
        public DateTime StartDate { get; set; }

        [Display(Name = "End Date")]
        [DisplayFormat(DataFormatString = "{0:dd MMM yyyy}")]
        public DateTime EndDate { get; set; }

        [Display(Name = "Duration Of Training")]
        [Range(0, int.MaxValue)]
        public int? DurationOfTraining { get; set; }

        [Display(Name = "No of Participants")]
        [Range(1, int.MaxValue)]
        public int NoOfParticipants { get; set; }

        [Display(Name = "Gender Representation (Male)")]
        [Range(0, int.MaxValue)]
        public int GenderRepresentationMale { get; set; }


        [Display(Name = "Gender Representation (Female)")]
        [Range(0, int.MaxValue)]
        public int GenderRepresentationFemale { get; set; }


        [Display(Name = "Vulnerable Groups")]
        [Range(0, int.MaxValue)]
        public int? VulnerableGroups { get; set; }

        /////////////////////////////////////////////////////////////////////
        // Sectoral Representation
        /////////////////////////////////////////////////////////////////////

        [Display(Name = "Own Staff")]
        [Range(0, int.MaxValue)]
        public int? OwnStaff { get; set; }


        [Display(Name = "Government")]
        [Range(0, int.MaxValue)]
        public int? Government { get; set; }


        [Display(Name = "Armed Forces")]
        [Range(0, int.MaxValue)]
        public int? ArmedForces { get; set; }


        [Display(Name = "Police")]
        [Range(0, int.MaxValue)]
        public int? Police { get; set; }



        [Display(Name = "UN Agencies")]
        [Range(0, int.MaxValue)]
        public int? UNAgencies { get; set; }


        [Display(Name = "INGOs")]
        [Range(0, int.MaxValue)]
        public int? INGOs { get; set; }


        [Display(Name = "NGOs")]
        [Range(0, int.MaxValue)]
        public int? NGOs { get; set; }


        [Display(Name = "CBOs")]
        [Range(0, int.MaxValue)]
        public int? CBOs { get; set; }


        [Display(Name = "Students")]
        [Range(0, int.MaxValue)]
        public int? Students { get; set; }


        [Display(Name = "Teachers")]
        [Range(0, int.MaxValue)]
        public int? Teachers { get; set; }


        [Display(Name = "Educational Management")]
        [Range(0, int.MaxValue)]
        public int? EducationalManagement { get; set; }


        [Display(Name = "Religious Leader")]
        [Range(0, int.MaxValue)]
        public int? ReligiousLeader { get; set; }


        [Display(Name = "Private Commercial Org")]
        [Range(0, int.MaxValue)]
        public int? PrivateCommercialOrg { get; set; }


        [Display(Name = "Community")]
        [Range(0, int.MaxValue)]
        public int? Community { get; set; }


        [Display(Name = "Media")]
        [Range(0, int.MaxValue)]
        public int? Media { get; set; }


        [Display(Name = "Others Title")]
        public string OthersTitle { get; set; }


        [Display(Name = "Others No")]
        [Range(0, int.MaxValue)]
        public int? OthersNo { get; set; }

        /////////////////////////////////////////////////////////////////////
        // Provincial/Regional Representation
        /////////////////////////////////////////////////////////////////////

        [Range(0, int.MaxValue)]
        public int? Punjab { get; set; }


        [Range(0, int.MaxValue)]
        public int? Sindh { get; set; }


        [Range(0, int.MaxValue)]
        public int? Balochistan { get; set; }

        [Display(Name = "Khyber Pakhtunkhawa")]
        [Range(0, int.MaxValue)]
        public int? KhyberPakhtunkhawa { get; set; }


        [Range(0, int.MaxValue)]
        public int? FATA { get; set; }


        [Display(Name = "Gilgit Baltistan")]
        [Range(0, int.MaxValue)]
        public int? GilgitBaltistan { get; set; }


        [Range(0, int.MaxValue)]
        public int? AJK { get; set; }
        /////////////////////////////////////////////////////////////////////
        // Venue/LocationInfo 
        /////////////////////////////////////////////////////////////////////

        [Display(Name = "Training Location")]
        public string TrainingLocation { get; set; }


        [Display(Name = "Province/Region")]
        [ForeignKey("Province")]
        public int ProvinceId { get; set; }

        [Display(Name = "District")]
        [ForeignKey("District")]
        public int DistrictId { get; set; }


        /////////////////////////////////////////////////////////////////////
        //  Training Management
        /////////////////////////////////////////////////////////////////////

        // TrainingCoordinator
        [Display(Name = "Coordinator Name")]
        public string Name { get; set; }

        [Display(Name = "Coordinator Phone No")]
        public string ContactNoTel { get; set; }

        [Display(Name = "Coordinator Mobile No")]
        public string ContactNoMob { get; set; }

        [Display(Name = "Coordinator Email")]
        [DataType(DataType.EmailAddress)]
        public string EmailAddress { get; set; }

        [Display(Name = "Guest of Honor")]
        public string GuestofHonour { get; set; }

        [Display(Name = "Any Additional Information")]
        [DataType(DataType.MultilineText)]
        public string AnyAdditionalInformation { get; set; }

        /////////////////////////////////////////////////////////////////////
        //  Attachments 
        /////////////////////////////////////////////////////////////////////
        [Display(Name = "List of Participants")]
        public string ListOfParticipants { get; set; }

        [Display(Name = "Training Agenda")]
        public string TrainingAgenda { get; set; }

        [Display(Name = "Picture 1")]
        public string Picture1 { get; set; }

        [Display(Name = "Picture 2")]
        public string Picture2 { get; set; }

        [Display(Name = "Picture 3")]
        public string Picture3 { get; set; }

        [Display(Name = "Picture 4")]
        public string Picture4 { get; set; }

        [Display(Name = "Picture 5")]
        public string Picture5 { get; set; }

        [Display(Name = "Approval Status")]
        public ApprovalType ApprovalStatus { get; set; }

        [Display(Name = "Organization")]
        public virtual Organization Organization { get; set; }

        [Display(Name = "Province")]
        public virtual Province Province { get; set; }

        [Display(Name = "District")]
        public virtual District District { get; set; }

        [Display(Name = "Broader Training Area")]
        public virtual BroaderTrainingArea BroaderTrainingArea { get; set; }

        public string Location { get; set; }

        [Display(Name = "Resource Person")]
        public virtual ICollection<PotentialResourcePerson> PotentialResourcePerson { get; set; }
    }

    public class PotentialResourcePerson
    {
        /////////////////////////////////////////////////////////////////////
        // ResourcePersons 
        /////////////////////////////////////////////////////////////////////
        [Key]
        public int PotentialResourcePersonId { get; set; }

        [Display(Name = "Resource Person Name")]
        public string Name { get; set; }

        public string CNIC { get; set; }

        [DisplayName("Dept / Org / Designation")]
        public string DeptOrgDesignation { get; set; }

        [DisplayName("Contact No. (Tel)")]
        public string ContactNoTel { get; set; }

        [DisplayName("Contact No. (Mob)")]
        public string ContactNoMob { get; set; }

        [DisplayName("Contact No. (Fax)")]
        public string ContactNoFax { get; set; }

        [Display(Name = "Email Address")]
        [DataType(DataType.EmailAddress)]
        public string EmailAddress { get; set; }

        [Display(Name = "Postal Address")]
        [DataType(DataType.MultilineText)]
        public string PostalAddress { get; set; }


        /////////////////////////////////////////////////////////////////////
        // Parent 
        /////////////////////////////////////////////////////////////////////

        [Display(Name = "Training Activity")]
        [ForeignKey("TrainingActivity")]
        public int TrainingActivityId { get; set; }

        public virtual TrainingActivity TrainingActivity { get; set; }
    } 

    #endregion

    #region MODULE 6: DOCUMENT LIBRARY

    public class DocumentCategory
    {
        public DocumentCategory()
        {
            Level = 1;
        }

        [Key]
        public int DocumentCategoryId { get; set; }

        [Required]
        public string Name { get; set; }

        [Required]
        [Range(1, 3)]
        public int Level { get; set; }

        [Display(Name = "Parent Category")]
        [ForeignKey("ParentDocumentCategory")]
        public int? ParentDocumentCategoryId { get; set; }

        [DataType(DataType.MultilineText)]
        public string Description { get; set; }

        public virtual DocumentCategory ParentDocumentCategory { get; set; }
    }

    public class Document
    {
        public Document()
        {
            DateUploaded = DateTime.Now;
            YearOfPublication = DateTime.Now;
        }

        [Key]
        public int DocumentId { get; set; }

        [Required]
        [Display(Name = "Title")]
        public string Name { get; set; }

        [Display(Name = "Training")]
        [ForeignKey("Training")]
        public int? TrainingId { get; set; }

        [Display(Name = "Category Level 1")]
        [ForeignKey("DocumentCategory1")]
        public int DocumentCategoryId1 { get; set; }

        [Display(Name = "Category Level 2")]
        [ForeignKey("DocumentCategory2")]
        public int? DocumentCategoryId2 { get; set; }

        [Display(Name = "Category Level 3")]
        [ForeignKey("DocumentCategory3")]
        public int? DocumentCategoryId3 { get; set; }

        [Display(Name = "Thematic Area")]
        [ForeignKey("ThematicArea")]
        public int ThematicAreaId { get; set; }

        public string Edition { get; set; }

        [Display(Name = "Year of Publication")]
        [DisplayFormat(DataFormatString = "{0:dd MMM yyyy}")]
        public DateTime YearOfPublication { get; set; }

        [Display(Name = "Author(s)")]
        public string Authors { get; set; }

        [Display(Name = "Compiling Agency/Org.")]
        public string CompilingAgency { get; set; }

        [Display(Name = "Name")]
        public string PublisherName { get; set; }

        [Display(Name = "Address")]
        public string PublisherAddress { get; set; }

        [Display(Name = "Email")]
        [EmailAddress]
        public string PublisherEmail { get; set; }

        [Display(Name = "Phone No.")]
        public string PublisherPhone { get; set; }

        [Range(1, 10000)]
        public int? Price { get; set; }

        [Display(Name = "Physical Library Location")]
        public string PhysicalLocation { get; set; }

        [Display(Name = "Visibility")]
        public AccessType AccessType { get; set; }

        [Display(Name = "File")]
        public string FileName { get; set; }

        public DateTime DateUploaded { get; set; }

        public virtual Training Training { get; set; }

        [Display(Name = "Category Level 1")]
        public virtual DocumentCategory DocumentCategory1 { get; set; }

        [Display(Name = "Category Level 2")]
        public virtual DocumentCategory DocumentCategory2 { get; set; }

        [Display(Name = "Category Level 3")]
        public virtual DocumentCategory DocumentCategory3 { get; set; }

        [Display(Name = "Thematic Area")]
        public virtual ThematicArea ThematicArea { get; set; }

    }

    #endregion

    #region MODULE 7: EMAIL / SMS

    public class Group
    {
        [Key]
        public int GroupId { get; set; }

        [Required]
        public string Name { get; set; }

        public GroupType GroupType { get; set; }

        public string Description { get; set; }

        [Required]
        public string Members { get; set; }

    }

    public class MessageLog
    {
        [Key]
        public int MessageLogId { get; set; }

        [Required]
        public DateTime TimeStamp { get; set; }

        public GroupType Type { get; set; }

        [Required]
        public string Group { get; set; }

        public string Members { get; set; }

        public string Subject { get; set; }

        [Required]
        public string Message { get; set; }

        [Required]
        public string UserName { get; set; }

        [Required]
        public DeliveryStatus DeliveryStatus { get; set; }
    }

    #endregion

    #region MODULE 8: PHOTO / VIDEO GALLERY

    public class Gallery
    {
        [Key]
        public int GalleryId { get; set; }

        public string Name { get; set; }
        public string Description { get; set; }
        public string RelativeUrl { get; set; }

        public AlbumType AlbumType { get; set; }

        public virtual ICollection<Album> Albums { get; set; }
    }

    public class Album
    {
        public Album()
        {
            DateCreated = DateModified = DateTime.Now;
        }

        [Key]
        public int AlbumId { get; set; }

        [Required]
        public string Name { get; set; }

        [DataType(DataType.MultilineText)]
        public string Description { get; set; }

        public AlbumType AlbumType { get; set; }
        public string RelativeUrl { get; set; }

        [Display(Name = "Visibility")]
        public AccessType AccessType { get; set; }

        [ScaffoldColumn(false)]
        [DisplayFormat(DataFormatString = "{0:dd-MMM-yyyy}")]
        public DateTime DateCreated { get; set; }

        [ScaffoldColumn(false)]
        [DisplayFormat(DataFormatString = "{0:dd-MMM-yyyy}")]
        public DateTime DateModified { get; set; }

        [Display(Name = "Gallery")]
        [ForeignKey("Gallery")]
        public int GalleryId { get; set; }

        public virtual Gallery Gallery { get; set; }
        public virtual ICollection<MediaFile> MediaFiles { get; set; }
    }

    public class MediaFile
    {
        public MediaFile()
        {
            DateUploaded = DateTime.Now;
        }

        public int MediaFileId { get; set; }
        public string Name { get; set; }
        public string Description { get; set; }
        public FileType FileType { get; set; }
        public DateTime DateUploaded { get; set; }

        [Display(Name = "Album")]
        [ForeignKey("Album")]
        public int AlbumId { get; set; }

        public virtual Album Album { get; set; }
    }

    #endregion

    #region MODULE 10: TRAINING NEEDS ASSESSMENT

    public class Question
    {
        [Key]
        public int QuestionId { get; set; }

        public QuestionType Type { get; set; }

        [Display(Name = "Broader Training Area")]
        [ForeignKey("BroaderTrainingArea")]
        public int BroaderTrainingAreaId { get; set; }

        [Required]
        [DataType(DataType.MultilineText)]
        public string Statement { get; set; }

        public string Choices { get; set; }

        public bool AskReason { get; set; }

        public bool Active { get; set; }

        public DateTime DateCreated { get; set; }

        public virtual BroaderTrainingArea BroaderTrainingArea { get; set; }

        public virtual ICollection<SurveyQuestion> SurveyQuestions { get; set; }
        public virtual ICollection<SurveyQuestionResponse> SurveyQuestionResponses { get; set; }
        public virtual ICollection<TrainingEvaluation> TrainingEvalutions { get; set; }
    }

    public class Survey
    {
        [Key]
        public int SurveyId { get; set; }

        [Required]
        public string Name { get; set; }

        public string Description { get; set; }
        public string WelcomeMessage { get; set; }
        public string ExitMessage { get; set; }

        public bool Active { get; set; }

        public DateTime? StartDate { get; set; }
        public DateTime? EndDate { get; set; }

        public virtual ICollection<SurveyQuestion> SurveyQuestions { get; set; }
        public virtual ICollection<TrainingEvaluation> TrainingEvaluations { get; set; }
        public virtual ICollection<SurveyQuestionResponse> SurveyQuestionResponses { get; set; }
    }

    public class SurveyQuestion
    {
        [Key, Column(Order = 0)]
        [ForeignKey("Survey")]
        public int SurveyId { get; set; }

        [Key, Column(Order = 1)]
        [ForeignKey("Question")]
        public int QuestionId { get; set; }

        public virtual Survey Survey { get; set; }
        public virtual Question Question { get; set; }
    }

    public class SurveyQuestionResponse
    {
        [Key, Column(Order = 0)]
        [ForeignKey("Survey")]
        public int SurveyId { get; set; }

        [Key, Column(Order = 1)]
        [ForeignKey("Question")]
        public int QuestionId { get; set; }

        [Key, Column(Order = 2)]
        [ForeignKey("Respondent")]
        public int RespondentId { get; set; }

        public string Response { get; set; }
        public string Reason { get; set; }

        public DateTime ResponseDate { get; set; }

        public virtual Survey Survey { get; set; }
        public virtual Question Question { get; set; }
        public virtual Respondent Respondent { get; set; }
    }

    public class Respondent
    {
        public Respondent()
        {
            IsActive = true;
        }

        [Key]
        public int RespondentId { get; set; }

        [Required]
        public string Title { get; set; }

        [Required]
        [Display(Name = "Full Name")]
        public string Name { get; set; }

        [RegularExpression("^$|[0-9+]{5}-[0-9+]{7}-[0-9]{1}", ErrorMessage = "Use CNIC Format: 11111-2222222-3")]
        public string CNIC { get; set; }

        [Required]
        public GenderType Gender { get; set; }

        [Display(Name = "Date Of Birth")]
        [DisplayFormat(DataFormatString = "{0:dd MMM yyyy}")]
        public DateTime? DateOfBirth { get; set; }

        [Display(Name = "Special Ability")]
        public bool HasSpecialAbility { get; set; }

        [Display(Name = "Organization Type")]
        [ForeignKey("OrganizationType")]
        public int OrganizationTypeId { get; set; }

        [Display(Name = "Organization / Department")]
        [ForeignKey("Organization")]
        public int? OrganizationId { get; set; }

        [Display(Name = "Other Organization / Department")]
        public string OtherOrganization { get; set; }

        ////////////////////////////////////
        // Designation / Position
        ////////////////////////////////////

        public string Designation { get; set; }

        [Range(1, 22)]
        [Display(Name = "BPS Grade")]
        public int? BPSNo { get; set; }

        [Range(0, 70)]
        [Display(Name = "Years of Professional Experience")]
        public int YearsOfExperience { get; set; }

        [Display(Name = "Academic Qualification")]
        [ForeignKey("AcademicQualification")]
        public int AcademicQualificationId { get; set; }

        [Display(Name = "District of Posting")]
        [ForeignKey("District")]
        public int DistrictId { get; set; }

        [Display(Name = "Official Address")]
        [DataType(DataType.MultilineText)]
        public string OfficialAddress { get; set; }

        [Display(Name = "Residential Address")]
        [DataType(DataType.MultilineText)]
        public string ResidentialAddress { get; set; }

        ////////////////////////////////////
        //Contact Details
        ////////////////////////////////////

        public string PhoneWithExt { get; set; }

        [Display(Name = "Fax")]
        public string Fax { get; set; }

        public string Cell { get; set; }

        [DataType(DataType.EmailAddress)]
        [EmailAddress]
        public string Email { get; set; }

        public string Skype { get; set; }

        [Display(Name = "Status")]
        public ApprovalType ApprovalStatus { get; set; }

        [Display(Name = "Active")]
        public bool IsActive { get; set; }

        [Display(Name = "Organization Type")]
        public virtual OrganizationType OrganizationType { get; set; }

        [Display(Name = "Organization")]
        public virtual Organization Organization { get; set; }

        [Display(Name = "Academic Qualification")]
        public virtual AcademicQualification AcademicQualification { get; set; }

        [Display(Name = "District")]
        public virtual District District { get; set; }

        [Display(Name = "Special Abilities")]
        public virtual ICollection<RespondentDisabilityType> RespondentDisabilityTypes { get; set; }

        public virtual ICollection<SurveyQuestionResponse> SurveyQuestionResponses { get; set; }
    }

    public class RespondentDisabilityType
    {
        [Key, Column(Order = 0)]
        [ForeignKey("Respondent")]
        public int RespondentId { get; set; }

        [Key, Column(Order = 1)]
        [ForeignKey("DisabilityType")]
        [Display(Name = "Special Ability")]
        public int DisabilityTypeId { get; set; }

        [Display(Name = "Respondent")]
        public virtual Respondent Respondent { get; set; }

        [Display(Name = "Special Ability")]
        public virtual DisabilityType DisabilityType { get; set; }
    }

    #endregion

    #region SETUP / LOOKUPS TABLES

    public class Content
    {
        [Key]
        public int ContentId { get; set; }
        public ContentType ContentType { get; set; }
        public string Title { get; set; }
        public string Description { get; set; }
        public string File { get; set; }
        [DisplayFormat(DataFormatString = "{0:dd MMMM yyyy}")]
        public DateTime? Date { get; set; }
        public string Location { get; set; }
    }

    public class AgeGroup
    {
        [Key]
        public int AgeGroupId { get; set; }

        [Required]
        public string Name { get; set; }

        public string Description { get; set; }

        public int StartAge { get; set; }
        public int EndAge { get; set; }

    }

    public class OrganizationType
    {
        [Key]
        public int OrganizationTypeId { get; set; }

        [Required]
        public string Name { get; set; }

        [DataType(DataType.MultilineText)]
        public string Description { get; set; }
    }

    public class Province
    {
        [Key]
        public int ProvinceId { get; set; }

        [Required]
        public string Name { get; set; }

        [DataType(DataType.MultilineText)]
        public string Description { get; set; }
    }

    public class District
    {
        [Key]
        public int DistrictId { get; set; }

        [Required]
        [Display(Name = "Province Name")]
        public string Name { get; set; }

        [Display(Name = "Province")]
        [ForeignKey("Province")]
        public int ProvinceId { get; set; }

        public virtual Province Province { get; set; }

        public virtual ICollection<Organization> Organizations { get; set; }
    }

    public class City
    {
        [Key]
        public int CityId { get; set; }

        [Required]
        public string Name { get; set; }

        [Display(Name = "District")]
        [ForeignKey("District")]
        public int? DistrictId { get; set; }

        public virtual District District { get; set; }

    }

    public class ThematicArea
    {
        [Key]
        public int ThematicAreaId { get; set; }

        [Required]
        public string Name { get; set; }

        [DataType(DataType.MultilineText)]
        public string Description { get; set; }
    }

    public class BroaderTrainingArea
    {
        [Key]
        public int BroaderTrainingAreaId { get; set; }

        [Required]
        public string Name { get; set; }

        [DataType(DataType.MultilineText)]
        public string Description { get; set; }
    }

    public class AcademicQualification
    {
        [Key]
        public int AcademicQualificationId { get; set; }

        [Required]
        [Display(Name = "Academic Qualification")]
        public string Name { get; set; }

        [DataType(DataType.MultilineText)]
        public string Description { get; set; }
    }

    [DisplayName("Area of Intervention")]
    public class Area
    {
        [Key]
        public int AreaId { get; set; }

        [Required]
        public string Name { get; set; }

        [DataType(DataType.MultilineText)]
        public string Description { get; set; }

        [Display(Name = "Areas of Interest")]
        public virtual ICollection<ResourcePersonArea> ResourcePersonAreas { get; set; }
    }

    [DisplayName("Special Ability")]
    public class DisabilityType
    {
        [Key]
        public int DisabilityTypeId { get; set; }

        [Required]
        public string Name { get; set; }

        [DataType(DataType.MultilineText)]
        public string Description { get; set; }

        [Display(Name = "Resource Persons")]
        public virtual ICollection<ResourcePersonDisabilityType> ResourcePersonDisabilityTypes { get; set; }

        [Display(Name = "Participants")]
        public virtual ICollection<ParticipantDisabilityType> ParticipantDisabilityTypes { get; set; }
    }

    public class ActivityType
    {
        [Key]
        public int ActivityTypeId { get; set; }

        [Required]
        public string Name { get; set; }

        [DataType(DataType.MultilineText)]
        public string Description { get; set; }

        //[Display(Name = "Activities")]
        //public virtual ICollection<Activity> Activities { get; set; }
    }

    #endregion

    #region WEBSITE

    public class StatsViewModel
    {
        public int Trainings { get; set; }
        public int Male { get; set; }
        public int Female { get; set; }
        public int Participants { get { return Male + Female; } }

        public int Govt { get; set; }
        public int UN { get; set; }
        public int NGO { get; set; }
        public int Academia { get; set; }

        public int Media { get; set; }
        public int Industry { get; set; }
        public int PublicReps { get; set; }
        public int Others { get { return Participants - Govt - UN - NGO - Academia - Media - Industry - PublicReps; } }
    }

    public class HomePageViewModel
    {
        public StatsViewModel NIDMStats { get; set; }
        public StatsViewModel StakeholderStats { get; set; }

        public List<string> SliderImages { get; set; }
        public List<Content> News { get; set; }
        public List<Content> Events { get; set; }
        public List<Content> Trainings { get; set; }

        public List<Content> StakeholderActivities { get; set; }
        public Content ProminentStakeholder { get; set; }

        public List<Content> GuestBook { get; set; }

        public List<Content> PictureGallery { get; set; }
        public List<string> PartnerLogos { get; set; }
    }

    public class CalendarViewModel
    {
        public List<Content> Upcoming { get; set; }
        public List<Content> Archived { get; set; }
    } 

    #endregion
}