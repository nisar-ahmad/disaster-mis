USE [ODTKMS]
GO
ALTER DATABASE [ODTKMS] SET COMPATIBILITY_LEVEL = 110
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [ODTKMS].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [ODTKMS] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [ODTKMS] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [ODTKMS] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [ODTKMS] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [ODTKMS] SET ARITHABORT OFF 
GO
ALTER DATABASE [ODTKMS] SET AUTO_CLOSE ON 
GO
ALTER DATABASE [ODTKMS] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [ODTKMS] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [ODTKMS] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [ODTKMS] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [ODTKMS] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [ODTKMS] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [ODTKMS] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [ODTKMS] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [ODTKMS] SET  DISABLE_BROKER 
GO
ALTER DATABASE [ODTKMS] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [ODTKMS] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [ODTKMS] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [ODTKMS] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [ODTKMS] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [ODTKMS] SET READ_COMMITTED_SNAPSHOT ON 
GO
ALTER DATABASE [ODTKMS] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [ODTKMS] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [ODTKMS] SET  MULTI_USER 
GO
ALTER DATABASE [ODTKMS] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [ODTKMS] SET DB_CHAINING OFF 
GO
ALTER DATABASE [ODTKMS] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [ODTKMS] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
EXEC sys.sp_db_vardecimal_storage_format N'ODTKMS', N'ON'
GO
USE [ODTKMS]
GO
/****** Object:  Table [dbo].[__MigrationHistory]    Script Date: 21-Sep-15 1:40:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[__MigrationHistory](
	[MigrationId] [nvarchar](150) NOT NULL,
	[ContextKey] [nvarchar](300) NOT NULL,
	[Model] [varbinary](max) NOT NULL,
	[ProductVersion] [nvarchar](32) NOT NULL,
 CONSTRAINT [PK_dbo.__MigrationHistory] PRIMARY KEY CLUSTERED 
(
	[MigrationId] ASC,
	[ContextKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[AcademicQualification]    Script Date: 21-Sep-15 1:40:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AcademicQualification](
	[AcademicQualificationId] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NOT NULL,
	[Description] [nvarchar](max) NULL,
 CONSTRAINT [PK_dbo.AcademicQualification] PRIMARY KEY CLUSTERED 
(
	[AcademicQualificationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Activity]    Script Date: 21-Sep-15 1:40:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Activity](
	[ActivityId] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NOT NULL,
	[Description] [nvarchar](max) NULL,
	[ProjectId] [int] NOT NULL DEFAULT ((0)),
	[ActivityTypeId] [int] NOT NULL DEFAULT ((0)),
	[DateOfActivity] [datetime] NOT NULL DEFAULT ('1900-01-01T00:00:00.000'),
	[CityId] [int] NOT NULL DEFAULT ((0)),
 CONSTRAINT [PK_dbo.Activity] PRIMARY KEY CLUSTERED 
(
	[ActivityId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ActivityCost]    Script Date: 21-Sep-15 1:40:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ActivityCost](
	[ActivityCostId] [int] IDENTITY(1,1) NOT NULL,
	[ActivityId] [int] NOT NULL,
	[FundingId] [int] NOT NULL,
	[Cost] [int] NOT NULL,
	[Description] [nvarchar](max) NULL,
 CONSTRAINT [PK_dbo.ActivityCost] PRIMARY KEY CLUSTERED 
(
	[ActivityCostId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ActivityType]    Script Date: 21-Sep-15 1:40:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ActivityType](
	[ActivityTypeId] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NOT NULL,
	[Description] [nvarchar](max) NULL,
 CONSTRAINT [PK_dbo.ActivityType] PRIMARY KEY CLUSTERED 
(
	[ActivityTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[AgeGroup]    Script Date: 21-Sep-15 1:40:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AgeGroup](
	[AgeGroupId] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NOT NULL,
	[Description] [nvarchar](max) NULL,
	[StartAge] [int] NOT NULL,
	[EndAge] [int] NOT NULL,
 CONSTRAINT [PK_dbo.AgeGroup] PRIMARY KEY CLUSTERED 
(
	[AgeGroupId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Album]    Script Date: 21-Sep-15 1:40:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Album](
	[AlbumId] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NOT NULL CONSTRAINT [DF__Albums__Name__5AEE82B9]  DEFAULT (''),
	[Description] [nvarchar](max) NULL,
	[DateCreated] [datetime] NOT NULL CONSTRAINT [DF__Albums__DateCrea__6FE99F9F]  DEFAULT ('1900-01-01T00:00:00.000'),
	[DateModified] [datetime] NOT NULL CONSTRAINT [DF__Albums__DateModi__70DDC3D8]  DEFAULT ('1900-01-01T00:00:00.000'),
	[AccessType] [int] NOT NULL CONSTRAINT [DF__Albums__AccessTy__71D1E811]  DEFAULT ((0)),
	[RelativeUrl] [nvarchar](max) NULL,
	[AlbumType] [int] NOT NULL CONSTRAINT [DF__Album__AlbumType__666B225D]  DEFAULT ((0)),
	[GalleryId] [int] NOT NULL CONSTRAINT [DF__Album__GalleryId__675F4696]  DEFAULT ((0)),
 CONSTRAINT [PK_dbo.Album] PRIMARY KEY CLUSTERED 
(
	[AlbumId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ApprovedActivity]    Script Date: 21-Sep-15 1:40:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ApprovedActivity](
	[ApprovedActivityId] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NOT NULL,
	[Description] [nvarchar](max) NULL,
 CONSTRAINT [PK_dbo.ApprovedActivity] PRIMARY KEY CLUSTERED 
(
	[ApprovedActivityId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Area]    Script Date: 21-Sep-15 1:40:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Area](
	[AreaId] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NOT NULL,
	[Description] [nvarchar](max) NULL,
 CONSTRAINT [PK_dbo.Area] PRIMARY KEY CLUSTERED 
(
	[AreaId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[AspNetRoles]    Script Date: 21-Sep-15 1:40:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AspNetRoles](
	[Id] [nvarchar](128) NOT NULL,
	[Name] [nvarchar](256) NOT NULL,
 CONSTRAINT [PK_dbo.AspNetRoles] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[AspNetUserClaims]    Script Date: 21-Sep-15 1:40:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AspNetUserClaims](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [nvarchar](128) NOT NULL,
	[ClaimType] [nvarchar](max) NULL,
	[ClaimValue] [nvarchar](max) NULL,
 CONSTRAINT [PK_dbo.AspNetUserClaims] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[AspNetUserLogins]    Script Date: 21-Sep-15 1:40:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AspNetUserLogins](
	[LoginProvider] [nvarchar](128) NOT NULL,
	[ProviderKey] [nvarchar](128) NOT NULL,
	[UserId] [nvarchar](128) NOT NULL,
 CONSTRAINT [PK_dbo.AspNetUserLogins] PRIMARY KEY CLUSTERED 
(
	[LoginProvider] ASC,
	[ProviderKey] ASC,
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[AspNetUserRoles]    Script Date: 21-Sep-15 1:40:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AspNetUserRoles](
	[UserId] [nvarchar](128) NOT NULL,
	[RoleId] [nvarchar](128) NOT NULL,
 CONSTRAINT [PK_dbo.AspNetUserRoles] PRIMARY KEY CLUSTERED 
(
	[UserId] ASC,
	[RoleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[AspNetUsers]    Script Date: 21-Sep-15 1:40:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AspNetUsers](
	[Id] [nvarchar](128) NOT NULL,
	[Email] [nvarchar](256) NULL,
	[EmailConfirmed] [bit] NOT NULL,
	[PasswordHash] [nvarchar](max) NULL,
	[SecurityStamp] [nvarchar](max) NULL,
	[PhoneNumber] [nvarchar](max) NULL,
	[PhoneNumberConfirmed] [bit] NOT NULL,
	[TwoFactorEnabled] [bit] NOT NULL,
	[LockoutEndDateUtc] [datetime] NULL,
	[LockoutEnabled] [bit] NOT NULL,
	[AccessFailedCount] [int] NOT NULL,
	[UserName] [nvarchar](256) NOT NULL,
 CONSTRAINT [PK_dbo.AspNetUsers] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[City]    Script Date: 21-Sep-15 1:40:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[City](
	[CityId] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NOT NULL,
	[DistrictId] [int] NULL,
 CONSTRAINT [PK_dbo.City] PRIMARY KEY CLUSTERED 
(
	[CityId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[DisabilityType]    Script Date: 21-Sep-15 1:40:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DisabilityType](
	[DisabilityTypeId] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NOT NULL,
	[Description] [nvarchar](max) NULL,
 CONSTRAINT [PK_dbo.DisabilityType] PRIMARY KEY CLUSTERED 
(
	[DisabilityTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[District]    Script Date: 21-Sep-15 1:40:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[District](
	[DistrictId] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NOT NULL,
	[ProvinceId] [int] NOT NULL,
 CONSTRAINT [PK_dbo.District] PRIMARY KEY CLUSTERED 
(
	[DistrictId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Document]    Script Date: 21-Sep-15 1:40:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Document](
	[DocumentId] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NOT NULL,
	[TrainingId] [int] NULL,
	[DocumentCategoryId1] [int] NOT NULL,
	[DocumentCategoryId2] [int] NULL,
	[DocumentCategoryId3] [int] NULL,
	[ThematicAreaId] [int] NOT NULL,
	[Edition] [nvarchar](max) NULL,
	[YearOfPublication] [datetime] NOT NULL,
	[Authors] [nvarchar](max) NULL,
	[CompilingAgency] [nvarchar](max) NULL,
	[PublisherName] [nvarchar](max) NULL,
	[PublisherAddress] [nvarchar](max) NULL,
	[PublisherEmail] [nvarchar](max) NULL,
	[PublisherPhone] [nvarchar](max) NULL,
	[Price] [int] NULL,
	[PhysicalLocation] [nvarchar](max) NULL,
	[FileName] [nvarchar](max) NULL,
	[DateUploaded] [datetime] NOT NULL DEFAULT ('1900-01-01T00:00:00.000'),
	[AccessType] [int] NOT NULL DEFAULT ((0)),
 CONSTRAINT [PK_dbo.Document] PRIMARY KEY CLUSTERED 
(
	[DocumentId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[DocumentCategory]    Script Date: 21-Sep-15 1:40:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DocumentCategory](
	[DocumentCategoryId] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NOT NULL,
	[Level] [int] NOT NULL,
	[ParentDocumentCategoryId] [int] NULL,
	[Description] [nvarchar](max) NULL,
 CONSTRAINT [PK_dbo.DocumentCategory] PRIMARY KEY CLUSTERED 
(
	[DocumentCategoryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Funding]    Script Date: 21-Sep-15 1:40:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Funding](
	[FundingId] [int] IDENTITY(1,1) NOT NULL,
	[ProjectId] [int] NOT NULL,
	[FundingType] [int] NOT NULL,
	[CashAmount] [int] NOT NULL,
	[StartDate] [datetime] NOT NULL,
	[EndDate] [datetime] NOT NULL,
	[ApprovedActivityId] [int] NOT NULL DEFAULT ((0)),
 CONSTRAINT [PK_dbo.Funding] PRIMARY KEY CLUSTERED 
(
	[FundingId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Gallery]    Script Date: 21-Sep-15 1:40:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Gallery](
	[GalleryId] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NULL,
	[Description] [nvarchar](max) NULL,
	[RelativeUrl] [nvarchar](max) NULL,
	[AlbumType] [int] NOT NULL,
 CONSTRAINT [PK_dbo.Gallery] PRIMARY KEY CLUSTERED 
(
	[GalleryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[MediaFile]    Script Date: 21-Sep-15 1:40:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MediaFile](
	[MediaFileId] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NULL,
	[Description] [nvarchar](max) NULL,
	[DateUploaded] [datetime] NOT NULL,
	[FileType] [int] NOT NULL,
	[AlbumId] [int] NOT NULL,
 CONSTRAINT [PK_dbo.MediaFile] PRIMARY KEY CLUSTERED 
(
	[MediaFileId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Organization]    Script Date: 21-Sep-15 1:40:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Organization](
	[OrganizationId] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NOT NULL,
	[OrganizationTypeId] [int] NOT NULL DEFAULT ((0)),
	[RelationshipType] [int] NOT NULL DEFAULT ((0)),
	[GeographicalArea] [int] NOT NULL DEFAULT ((0)),
	[DateEstablished] [datetime] NULL,
	[RegisteringAuthority] [nvarchar](max) NULL,
	[RegistrationNumber] [nvarchar](max) NULL,
	[RegistrationCertificate] [nvarchar](max) NULL,
	[Address] [nvarchar](max) NULL,
	[Email] [nvarchar](max) NULL,
	[Landline] [nvarchar](max) NULL,
	[Fax] [nvarchar](max) NULL,
	[Website] [nvarchar](max) NULL,
	[Skype] [nvarchar](max) NULL,
	[HeadTitle] [nvarchar](max) NULL,
	[HeadName] [nvarchar](max) NULL,
	[HeadDesignation] [nvarchar](max) NULL,
	[HeadLandline] [nvarchar](max) NULL,
	[HeadFax] [nvarchar](max) NULL,
	[HeadMobile] [nvarchar](max) NULL,
	[HeadEmail] [nvarchar](max) NULL,
	[ContactPersonTitle] [nvarchar](max) NULL,
	[ContactPersonName] [nvarchar](max) NULL,
	[ContactPersonDesignation] [nvarchar](max) NULL,
	[ContactPersonLandline] [nvarchar](max) NULL,
	[ContactPersonFax] [nvarchar](max) NULL,
	[ContactPersonMobile] [nvarchar](max) NULL,
	[ContactPersonEmail] [nvarchar](max) NULL,
	[Logo] [nvarchar](max) NULL,
	[Profile] [nvarchar](max) NULL,
	[Category] [int] NOT NULL DEFAULT ((0)),
	[ApprovalStatus] [int] NOT NULL DEFAULT ((0)),
	[DistrictId] [int] NOT NULL,
	[IsActive] [bit] NOT NULL DEFAULT ((0)),
	[Username] [nvarchar](max) NULL,
	[PasswordHash] [nvarchar](max) NULL,
	[HeadPhoto] [nvarchar](max) NULL,
 CONSTRAINT [PK_dbo.Organization] PRIMARY KEY CLUSTERED 
(
	[OrganizationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[OrganizationArea]    Script Date: 21-Sep-15 1:40:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OrganizationArea](
	[OrganizationId] [int] NOT NULL,
	[AreaId] [int] NOT NULL,
 CONSTRAINT [PK_dbo.OrganizationArea] PRIMARY KEY CLUSTERED 
(
	[OrganizationId] ASC,
	[AreaId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[OrganizationType]    Script Date: 21-Sep-15 1:40:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OrganizationType](
	[OrganizationTypeId] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NOT NULL,
	[Description] [nvarchar](max) NULL,
 CONSTRAINT [PK_dbo.OrganizationType] PRIMARY KEY CLUSTERED 
(
	[OrganizationTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Participant]    Script Date: 21-Sep-15 1:40:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Participant](
	[ParticipantId] [int] IDENTITY(1,1) NOT NULL,
	[TrainingId] [int] NOT NULL,
	[Title] [nvarchar](max) NOT NULL,
	[Name] [nvarchar](max) NOT NULL,
	[CNIC] [nvarchar](max) NULL,
	[Gender] [int] NOT NULL,
	[DateOfBirth] [datetime] NULL,
	[HasSpecialAbility] [bit] NOT NULL,
	[OrganizationId] [int] NULL,
	[Designation] [nvarchar](max) NULL,
	[BPSNo] [int] NULL,
	[YearsOfExperience] [int] NOT NULL,
	[AcademicQualificationId] [int] NOT NULL,
	[DistrictId] [int] NOT NULL,
	[OfficialAddress] [nvarchar](max) NULL,
	[ResidentialAddress] [nvarchar](max) NULL,
	[PhoneWithExt] [nvarchar](max) NULL,
	[Fax] [nvarchar](max) NULL,
	[Cell] [nvarchar](max) NULL,
	[Email] [nvarchar](max) NOT NULL,
	[Skype] [nvarchar](max) NULL,
	[AnyPreviousTrainingAttended] [bit] NOT NULL,
	[PreviousTrainings] [nvarchar](max) NULL,
	[IsFeePaid] [bit] NOT NULL,
	[AmountPaid] [int] NOT NULL,
	[PaymentProofDocument] [nvarchar](max) NULL,
	[ApprovalStatus] [int] NOT NULL,
	[IsActive] [bit] NOT NULL DEFAULT ((0)),
	[OtherOrganization] [nvarchar](max) NULL,
	[OrganizationTypeId] [int] NOT NULL,
 CONSTRAINT [PK_dbo.Participant] PRIMARY KEY CLUSTERED 
(
	[ParticipantId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ParticipantDisabilityType]    Script Date: 21-Sep-15 1:40:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ParticipantDisabilityType](
	[ParticipantId] [int] NOT NULL,
	[DisabilityTypeId] [int] NOT NULL,
 CONSTRAINT [PK_dbo.ParticipantDisabilityType] PRIMARY KEY CLUSTERED 
(
	[ParticipantId] ASC,
	[DisabilityTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[PotentialResourcePerson]    Script Date: 21-Sep-15 1:40:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PotentialResourcePerson](
	[PotentialResourcePersonId] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NULL,
	[DeptOrgDesignation] [nvarchar](max) NULL,
	[ContactNoTel] [nvarchar](max) NULL,
	[ContactNoMob] [nvarchar](max) NULL,
	[ContactNoFax] [nvarchar](max) NULL,
	[EmailAddress] [nvarchar](max) NULL,
	[PostalAddress] [nvarchar](max) NULL,
	[TrainingActivityId] [int] NOT NULL,
	[CNIC] [nvarchar](max) NULL,
 CONSTRAINT [PK_dbo.PotentialResourcePerson] PRIMARY KEY CLUSTERED 
(
	[PotentialResourcePersonId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Project]    Script Date: 21-Sep-15 1:40:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Project](
	[ProjectId] [int] IDENTITY(1,1) NOT NULL,
	[OrganizationId] [int] NOT NULL,
	[Name] [nvarchar](max) NULL,
	[Description] [nvarchar](max) NULL,
	[ProjectNumber] [nvarchar](max) NULL,
	[Proposal] [nvarchar](max) NULL,
	[Workplan] [nvarchar](max) NULL,
	[LOA] [nvarchar](max) NULL,
	[OtherDocuments] [nvarchar](max) NULL,
	[IsActive] [bit] NOT NULL DEFAULT ((0)),
	[StartDate] [datetime] NOT NULL,
	[EndDate] [datetime] NOT NULL,
 CONSTRAINT [PK_dbo.Project] PRIMARY KEY CLUSTERED 
(
	[ProjectId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Province]    Script Date: 21-Sep-15 1:40:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Province](
	[ProvinceId] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NOT NULL,
	[Description] [nvarchar](max) NULL,
 CONSTRAINT [PK_dbo.Province] PRIMARY KEY CLUSTERED 
(
	[ProvinceId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Question]    Script Date: 21-Sep-15 1:40:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Question](
	[QuestionId] [int] IDENTITY(1,1) NOT NULL,
	[Type] [int] NOT NULL,
	[BroaderTrainingArea] [int] NOT NULL CONSTRAINT [DF__Question__Broade__25918339]  DEFAULT ((0)),
	[Statement] [nvarchar](max) NOT NULL CONSTRAINT [DF__Question__Statem__2685A772]  DEFAULT (''),
	[Choices] [nvarchar](max) NULL,
	[AskReason] [bit] NOT NULL CONSTRAINT [DF__Question__AskRea__2779CBAB]  DEFAULT ((0)),
	[Active] [bit] NOT NULL CONSTRAINT [DF__Questions__Activ__24B26D99]  DEFAULT ((0)),
	[DateCreated] [datetime] NOT NULL CONSTRAINT [DF__Question__DateCr__286DEFE4]  DEFAULT ('1900-01-01T00:00:00.000'),
 CONSTRAINT [PK_dbo.Question] PRIMARY KEY CLUSTERED 
(
	[QuestionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ResourcePerson]    Script Date: 21-Sep-15 1:40:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ResourcePerson](
	[ResourcePersonId] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](max) NOT NULL,
	[Name] [nvarchar](max) NOT NULL,
	[Gender] [int] NOT NULL,
	[DateOfBirth] [datetime] NULL,
	[HasSpecialAbility] [bit] NOT NULL,
	[OrganizationId] [int] NULL,
	[BPSNo] [int] NULL,
	[YearsOfExperience] [int] NOT NULL,
	[AcademicQualificationId] [int] NOT NULL,
	[DistrictId] [int] NOT NULL,
	[OfficialAddress] [nvarchar](max) NULL,
	[ResidentialAddress] [nvarchar](max) NULL,
	[PhoneWithExt] [nvarchar](max) NULL,
	[Fax] [nvarchar](max) NULL,
	[Cell] [nvarchar](max) NULL,
	[Email] [nvarchar](max) NULL,
	[Skype] [nvarchar](max) NULL,
	[BankName] [nvarchar](max) NULL,
	[BranchName] [nvarchar](max) NULL,
	[BranchCode] [nvarchar](max) NULL,
	[AccountTitle] [nvarchar](max) NULL,
	[AccountNo] [nvarchar](max) NULL,
	[AccountType] [int] NOT NULL,
	[IBAN] [nvarchar](max) NULL,
	[ApprovalStatus] [int] NOT NULL,
	[Resume] [nvarchar](max) NULL,
	[Photo] [nvarchar](max) NULL,
	[CNIC] [nvarchar](max) NULL,
	[Designation] [nvarchar](max) NULL,
	[IsActive] [bit] NOT NULL DEFAULT ((0)),
	[OtherOrganization] [nvarchar](max) NULL,
	[OrganizationTypeId] [int] NOT NULL,
 CONSTRAINT [PK_dbo.ResourcePerson] PRIMARY KEY CLUSTERED 
(
	[ResourcePersonId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ResourcePersonArea]    Script Date: 21-Sep-15 1:40:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ResourcePersonArea](
	[ResourcePersonId] [int] NOT NULL,
	[AreaId] [int] NOT NULL,
 CONSTRAINT [PK_dbo.ResourcePersonArea] PRIMARY KEY CLUSTERED 
(
	[ResourcePersonId] ASC,
	[AreaId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ResourcePersonDisabilityType]    Script Date: 21-Sep-15 1:40:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ResourcePersonDisabilityType](
	[ResourcePersonId] [int] NOT NULL,
	[DisabilityTypeId] [int] NOT NULL,
 CONSTRAINT [PK_dbo.ResourcePersonDisabilityType] PRIMARY KEY CLUSTERED 
(
	[ResourcePersonId] ASC,
	[DisabilityTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ResourcePersonTraining]    Script Date: 21-Sep-15 1:40:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ResourcePersonTraining](
	[ResourcePersonId] [int] NOT NULL,
	[TrainingSessionId] [int] NOT NULL,
	[IsPaid] [bit] NOT NULL,
	[AmountPaid] [int] NOT NULL,
 CONSTRAINT [PK_dbo.ResourcePersonTraining] PRIMARY KEY CLUSTERED 
(
	[ResourcePersonId] ASC,
	[TrainingSessionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Respondent]    Script Date: 21-Sep-15 1:40:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Respondent](
	[RespondentId] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](max) NOT NULL,
	[Name] [nvarchar](max) NOT NULL,
	[CNIC] [nvarchar](max) NULL,
	[Gender] [int] NOT NULL,
	[DateOfBirth] [datetime] NULL,
	[HasSpecialAbility] [bit] NOT NULL,
	[OrganizationTypeId] [int] NOT NULL,
	[OrganizationId] [int] NULL,
	[OtherOrganization] [nvarchar](max) NULL,
	[Designation] [nvarchar](max) NULL,
	[BPSNo] [int] NULL,
	[YearsOfExperience] [int] NOT NULL,
	[AcademicQualificationId] [int] NOT NULL,
	[DistrictId] [int] NOT NULL,
	[OfficialAddress] [nvarchar](max) NULL,
	[ResidentialAddress] [nvarchar](max) NULL,
	[PhoneWithExt] [nvarchar](max) NULL,
	[Fax] [nvarchar](max) NULL,
	[Cell] [nvarchar](max) NULL,
	[Email] [nvarchar](max) NULL,
	[Skype] [nvarchar](max) NULL,
	[ApprovalStatus] [int] NOT NULL,
	[IsActive] [bit] NOT NULL,
 CONSTRAINT [PK_dbo.Respondent] PRIMARY KEY CLUSTERED 
(
	[RespondentId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[RespondentDisabilityType]    Script Date: 21-Sep-15 1:40:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RespondentDisabilityType](
	[RespondentId] [int] NOT NULL,
	[DisabilityTypeId] [int] NOT NULL,
 CONSTRAINT [PK_dbo.RespondentDisabilityType] PRIMARY KEY CLUSTERED 
(
	[RespondentId] ASC,
	[DisabilityTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Survey]    Script Date: 21-Sep-15 1:40:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Survey](
	[SurveyId] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NOT NULL,
	[Description] [nvarchar](max) NULL,
	[WelcomeMessage] [nvarchar](max) NULL,
	[ExitMessage] [nvarchar](max) NULL,
	[Active] [bit] NOT NULL,
	[StartDate] [datetime] NULL,
	[EndDate] [datetime] NULL,
 CONSTRAINT [PK_dbo.Survey] PRIMARY KEY CLUSTERED 
(
	[SurveyId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[SurveyQuestion]    Script Date: 21-Sep-15 1:40:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SurveyQuestion](
	[SurveyId] [int] NOT NULL,
	[QuestionId] [int] NOT NULL,
 CONSTRAINT [PK_dbo.SurveyQuestion] PRIMARY KEY CLUSTERED 
(
	[SurveyId] ASC,
	[QuestionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[SurveyQuestionResponse]    Script Date: 21-Sep-15 1:40:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SurveyQuestionResponse](
	[SurveyId] [int] NOT NULL,
	[QuestionId] [int] NOT NULL,
	[RespondentId] [int] NOT NULL,
	[Response] [nvarchar](max) NULL,
	[Reason] [nvarchar](max) NULL,
	[ResponseDate] [datetime] NOT NULL,
 CONSTRAINT [PK_dbo.SurveyQuestionResponse] PRIMARY KEY CLUSTERED 
(
	[SurveyId] ASC,
	[QuestionId] ASC,
	[RespondentId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ThematicArea]    Script Date: 21-Sep-15 1:40:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ThematicArea](
	[ThematicAreaId] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NOT NULL,
	[Description] [nvarchar](max) NULL,
 CONSTRAINT [PK_dbo.ThematicArea] PRIMARY KEY CLUSTERED 
(
	[ThematicAreaId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Training]    Script Date: 21-Sep-15 1:40:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Training](
	[TrainingId] [int] IDENTITY(1,1) NOT NULL,
	[Description] [nvarchar](max) NULL,
	[Name] [nvarchar](max) NOT NULL DEFAULT (''),
	[Status] [int] NOT NULL DEFAULT ((0)),
	[TrainingType] [int] NOT NULL DEFAULT ((0)),
	[TrainingLevel] [int] NOT NULL DEFAULT ((0)),
	[BroaderTrainingArea] [int] NOT NULL DEFAULT ((0)),
	[StartDate] [datetime] NOT NULL DEFAULT ('1900-01-01T00:00:00.000'),
	[EndDate] [datetime] NOT NULL DEFAULT ('1900-01-01T00:00:00.000'),
	[Fee] [int] NOT NULL DEFAULT ((0)),
	[ProvinceId] [int] NOT NULL,
	[DistrictId] [int] NOT NULL,
	[CityId] [int] NOT NULL,
	[LogisticNote] [nvarchar](max) NULL,
	[ReferenceMaterial] [nvarchar](max) NULL,
	[Location] [nvarchar](max) NULL,
	[Objective] [nvarchar](max) NULL,
	[FeeVoucher] [nvarchar](max) NULL,
	[SurveyId] [int] NOT NULL DEFAULT ((0)),
	[DateCreated] [datetime] NOT NULL,
	[DateModified] [datetime] NOT NULL,
 CONSTRAINT [PK_dbo.Training] PRIMARY KEY CLUSTERED 
(
	[TrainingId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[TrainingActivity]    Script Date: 21-Sep-15 1:40:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TrainingActivity](
	[TrainingActivityId] [int] IDENTITY(1,1) NOT NULL,
	[OrganizationId] [int] NOT NULL,
	[CollaboratingOrganization] [int] NOT NULL,
	[TitleOfTraining] [nvarchar](max) NOT NULL,
	[TrainingType] [int] NOT NULL,
	[TrainingLevel] [int] NOT NULL,
	[BroaderTrainingArea] [int] NOT NULL,
	[DurationOfTraining] [int] NULL,
	[NoOfParticipants] [int] NULL,
	[GenderRepresentationMale] [nvarchar](max) NULL,
	[GenderRepresentationFemale] [nvarchar](max) NULL,
	[VulnerableGroups] [int] NULL,
	[OwnStaff] [int] NULL,
	[Government] [int] NULL,
	[ArmedForces] [int] NULL,
	[Police] [int] NULL,
	[UNAgencies] [int] NULL,
	[INGOs] [int] NULL,
	[NGOs] [int] NULL,
	[CBOs] [int] NULL,
	[Students] [int] NULL,
	[Teachers] [int] NULL,
	[EducationalManagement] [int] NULL,
	[ReligiousLeader] [int] NULL,
	[PrivateCommercialOrg] [int] NULL,
	[Community] [int] NULL,
	[Media] [int] NULL,
	[OthersTitle] [nvarchar](max) NULL,
	[OthersNo] [int] NULL,
	[Punjab] [int] NULL,
	[Sindh] [int] NULL,
	[Balochistan] [int] NULL,
	[KhyberPakhtunkhawa] [int] NULL,
	[FATA] [int] NULL,
	[GilgitBaltistan] [int] NULL,
	[AJK] [int] NULL,
	[TrainingLocation] [nvarchar](max) NULL,
	[DistrictId] [int] NOT NULL,
	[Name] [nvarchar](max) NULL,
	[ContactNoTel] [nvarchar](max) NULL,
	[ContactNoMob] [nvarchar](max) NULL,
	[EmailAddress] [nvarchar](max) NULL,
	[GuestofHonour] [nvarchar](max) NULL,
	[AnyAdditionalInformation] [nvarchar](max) NULL,
	[ListOfParticipants] [nvarchar](max) NULL,
	[TrainingAgenda] [nvarchar](max) NULL,
	[Picture1] [nvarchar](max) NULL,
	[Picture2] [nvarchar](max) NULL,
	[Picture3] [nvarchar](max) NULL,
	[Picture4] [nvarchar](max) NULL,
	[Picture5] [nvarchar](max) NULL,
	[ApprovalStatus] [int] NOT NULL,
	[StartDate] [datetime] NOT NULL DEFAULT ('1900-01-01T00:00:00.000'),
	[EndDate] [datetime] NOT NULL DEFAULT ('1900-01-01T00:00:00.000'),
	[ProvinceId] [int] NOT NULL,
	[Location] [nvarchar](max) NULL,
 CONSTRAINT [PK_dbo.TrainingActivity] PRIMARY KEY CLUSTERED 
(
	[TrainingActivityId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[TrainingCost]    Script Date: 21-Sep-15 1:40:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TrainingCost](
	[TrainingId] [int] NOT NULL,
	[FundingId] [int] NOT NULL,
	[Cost] [int] NOT NULL,
	[TrainingCostId] [int] IDENTITY(1,1) NOT NULL,
	[Description] [nvarchar](max) NULL,
	[DateOfActivity] [datetime] NOT NULL,
 CONSTRAINT [PK_dbo.TrainingCost] PRIMARY KEY CLUSTERED 
(
	[TrainingCostId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[TrainingEvaluation]    Script Date: 21-Sep-15 1:40:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TrainingEvaluation](
	[TrainingId] [int] NOT NULL,
	[SurveyId] [int] NOT NULL,
	[QuestionId] [int] NOT NULL,
	[ParticipantId] [int] NOT NULL,
	[Response] [nvarchar](max) NULL,
	[Reason] [nvarchar](max) NULL,
	[ResponseDate] [datetime] NOT NULL,
 CONSTRAINT [PK_dbo.TrainingEvaluation] PRIMARY KEY CLUSTERED 
(
	[TrainingId] ASC,
	[SurveyId] ASC,
	[QuestionId] ASC,
	[ParticipantId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[TrainingOrganization]    Script Date: 21-Sep-15 1:40:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TrainingOrganization](
	[TrainingId] [int] NOT NULL,
	[OrganizationId] [int] NOT NULL,
 CONSTRAINT [PK_dbo.TrainingOrganization] PRIMARY KEY CLUSTERED 
(
	[TrainingId] ASC,
	[OrganizationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[TrainingSession]    Script Date: 21-Sep-15 1:40:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TrainingSession](
	[TrainingSessionId] [int] IDENTITY(1,1) NOT NULL,
	[TrainingId] [int] NOT NULL,
	[Name] [nvarchar](max) NOT NULL DEFAULT (''),
	[Module] [nvarchar](max) NULL,
	[DateOfSession] [datetime] NOT NULL DEFAULT ('1900-01-01T00:00:00.000'),
	[StartTime] [datetime] NOT NULL DEFAULT ('1900-01-01T00:00:00.000'),
	[EndTime] [datetime] NOT NULL DEFAULT ('1900-01-01T00:00:00.000'),
	[Agenda] [nvarchar](max) NULL,
	[LogisticNote] [nvarchar](max) NULL,
 CONSTRAINT [PK_dbo.TrainingSession] PRIMARY KEY CLUSTERED 
(
	[TrainingSessionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[TrainingSessionParticipant]    Script Date: 21-Sep-15 1:40:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TrainingSessionParticipant](
	[TrainingSessionId] [int] NOT NULL,
	[ParticipantId] [int] NOT NULL,
 CONSTRAINT [PK_dbo.TrainingSessionParticipant] PRIMARY KEY CLUSTERED 
(
	[TrainingSessionId] ASC,
	[ParticipantId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
INSERT [dbo].[__MigrationHistory] ([MigrationId], [ContextKey], [Model], [ProductVersion]) VALUES (N'201509210757452_AutomaticMigration', N'ODTKMS.Migrations.Configuration', 0x1F8B0800000000000400ED7D5B731CB992DEBB23FC1F147CB237CE8A23728EED9D9076836A5D4667C4CB11A519EF13A3D80DB2EBA8BAAB5D55CD11EDF02FF3837F92FF8251F7029000129742554B0C4528D8052091487C00128904F2FFFD9FFFFBF2DFBE6D92670F24CBE374FBEAE8C5F39F8E9E91ED325DC5DBFB5747FBE2EE9FFFDBD1BFFDEB7FFC0F2FDFAE36DF9EFDDEE63B2DF3D192DBFCD5D1BA2876BF1C1FE7CB35D944F9F34DBCCCD23CBD2B9E2FD3CD71B44A8F4F7EFAE95F8E5FBC382694C411A5F5ECD9CB4FFB6D116F48F583FE5CA4DB25D915FB28394F5724C99BEF34E5BAA2FAEC22DA907C172DC9ABA3CB379F7F3BBF7E5E673C7A7696C41165E29A247747CFA2ED362DA282B2F8CB979C5C1759BABDBFDED10F51F2F9714768BEBB28C949C3FA2F7D766C2B7E3A295B71DC176C492DF779916E0C09BE386DC472CC17B712EE5127362AB8B754C0C563D9EA4A78AF8ECE96D18AD0F27FA7528EEFE265530F5FF32F8B242B4B71827E0E16FFCBB33AD35F3A64500095FFFEF26CB14F8A7D465E6DC9BEC8A2E42FCFAEF6B749BCFC8D3C7E4EBF92EDABED3E49860C5396691AF3817EBACAD21DC98AC74FE44ED58C0FABA367C72CB1639E5A474B47A86EFD876D717A72F4EC82B219DD26A443CE4052D7459A91F7644BB2A820ABABA82848463BFEC38A54B21758E21828FF6F6BA350A503EEE8D979F4ED23D9DE17EB5747F4CFA367EFE26F64D57E6938F8B28DE9F8A4858A6C4F000ED5B5BE21F9328B7775E73B573EACEBE5718F390D128BF8A112101E7C758949F056576D07B1BE6C2854D19FFF20CB425FA59A4CCB7A49C395D6F70674A02EDA5597773DAEEBEACAAF9FE38D39EB0B1466381A17D1437C5F4148D2958B342FE882F9892455AE7C1DEFEA75F3F930C74DDF8A7759BAF994261C892EC3CDE728BB2705653355E5BA4EF7D9D282DDB2F14A6E6FD89C22B74C868E0F9E5B3657DB262CB78B4A522A2E171259560972AE16430963B96906BF9AA12E13C053932667ABCD007166BC009440315F04CA52132E0465F52E8B415B3ED482805F84D474DEEDB7E5A6C0954CDDE72E14469DD8B5D392CF095436CAE06916CB69D3517A46BB8C123E9B74359B6D26A709A1E3043B17340526980606C3C07406408FA0F96983BB5D963E9095E7B9A45EB89B215CC293F96E3AB144F9FA6C93EEB78ED3CB75116545A9BA39AB716FB72B3B3AF24988EB07708CB72352CCDC8F73591E61AC4B33FA544DDA4A00CD844B92F2E7472F112486D64DB89253E827C01835D6518CC7F99339C4469968500BEFC69CC62FBF27D30E74AB81D20D54ECF8680A4C302C062BA0E968402F9EFE06C165761F6DE3FF89B445061950F3B1B234FD71B1DFDC926CF4DA66A00788EDDFA579948CDEF43FD2ECEB2E89C6EFD18F9767A3D77159AC49F6265DEE377408E6A357F721AFA6D8AEB75FA7741E2E45E96ABF8B89DA7887B2EBC84C76827EE5752543E875B275CB96AFE1440AF2D6126633F60C42E982F609667252415976B0CBEBB0D4046B2CBF6A992EB466ABDEA1AB9CC3D6FA385E19825BD8518B8986D4DF93F43E8B76EB78192567198918EA62A2A9FA4DFBED6D5ED01271BE262B7189D435FD3ECE699FD39E3BDB17EB341B9CBE8C36C3D79566955803E922C32A17F47B7D5E3DBE7677B65A65241F7FD17C53B62E76B753BDDD44F1F8EAD1C768BB4AE2EDF8E27F5752195BD723B7791C004AD75F8753D358B5FC4AA2D5E7B848C2D41464875556447759F1FD360AB2CB2AEB0B86F0B2B210282FEB394F6FE340C008330F95355DADD3221DBDA645BA2DA2657145154AAAB304195F4C9541061A5363C811C7541C6CE831B58618834C85810623536720ED20BD1F7F40D29F7741E447B5CCFB347B64B4FEE106A6CF6075A41825D7742BB7CF19FA6D92D57EE54B4EB78021A68BAB28CFFF4CB3D5AF51BE3E40AB52AB7283C611C69ED1E7ECAD236006C13C02E7323D391C52293799B0AD89CF2535EC28330A7628756E17AB94D4BF8DA9412C21E9043EA3BA3384DCA69DF2398BE22DC5FA9010DC31504E69E768330B1DA42FE174D2D5831F6B8B6B4B4C60871B6EA34D6D70F82DF8A1DBDFE8CF8778BB34B7BBA186B57E7632985055B39138ED1AB86254020039EDA8F6B97A2E8544619611733899C37B260C4E9AAB12D31C3577C0B2386B4682F2D087DF0C2EA0F08BBADD414B597276872DB06B10E574FC73198DBEDFF0E0E94E43D56B1835B0CEA950FFAAFF54CA529FCB45731D5369D572EFEF7CD26CB84C34446CF18EC3E8D3046CE3F2F689E4154A6B538C7C1F27E61386B0248BA02DC9F2396D0844A2F8E120969D6070B04C8CBC8288951DC01AE200417E26D641D56EF460B9E64B29F9673F615AC295705A577856ED86D40C8793FF31E26FFDF175927310F78117171F16A3DB69695FAC06FE20B58F4CF9C9CA965D5F2B7E1D67456761C67AC6FC1AE5D73BB28CA3E4EC364E066E3168CBF1C85E4BCABD05C2A393D594C7F7720E761AF8FAEAFA223592C7BF9328CB2FEFDE7EA31F6352594B9C5659BB8731C278F85CDE518E4A5407F24CA293735CCDA6E1AABC5AA75BF2475CACDF7E2B46AF2CC8C12F49C63F760D73B81BC68BE975B4FD1AC4E5E175166D97EB80552D68FEF1BD1697CBF21A68183F95A6B28BF1CFFCDB66F12EBECC77C3E9F4C3EBB38BF1191FE9A89FCECDFB1007FD415CACC6B837023EF8A5DD3ADE480ACA768F707ECD065252C8745FACF462E06A848EDD245974CC7BF165C0F02CB3072BB2E978D7DA829D1D181415F22E0C9AAC266DB1726370B04ABA185710964A8939C6AE6114AF51BD0D2CA58469225B02DD5865314DB3D565DD04D07A89609ADEE645375A5240D35C592927EBB438D66C4E36CBF4894F365B1383CB9125CE4CF1749CE37C9EAE1AC7B6A65C96CA0C0DBB320FAC01D7D39F9888FCF8393BE1FBD8743DE1CB23D713EEA75A3B50971DFD04669415D4A8C53ECF676C07F5E4C3D87D449A8EA1A705C5C63FE02ACA8A7819EFA26D81D156A5D915530BB68CA0B8A10B4EACA5FB99558DB4748400F0CE9E32311B787FCA484CE10EDAF3124C7BE0EA3C50D561D4C12DBCE1613A2B58CC6886AD644A629A38483168DFB0949B97F6905F8BA13AB7C1E9799C7974D8686C06AE63FBC9F1E3C9F103CBCB93E3C793E3C793E3C793E3C7F7EEF861FA4C74104F90B3EDE355461EE2749FB76BFF19D519E8C2B2729DD779BA219E467C47C855143BB35E3FF33DA46437A75C458FE5A390F46B7AD7BE1079B0DE10533A100C77125AEF016D66D5162684DFC0B03AC869004A57F23C9EBBC0B016E94B96923C4A96C7F71290D5A6D8D8EBFD0394991D36F06E2649A7FD3CDE180959014CDF73D076559F11EEA2EE585BD5355D26DB6727DED25972AFB86F2FE69375823AA7F4B90949765BB15F53FDB24CED49A9DB25E6D7B54F5D42DA4E4D31277B6F0F25ACCDA82D3181C168687A31B516E1CD36FE4C45807AD1F569937410D69BCBDBF285E5815EF35D3C65DF76C5E747CE99974D3035EB35853F92079280649B1443BAAFB3342A4D59ED0E847F06184C3FBCB03BFC0E9938DA53AE6C1F9A19C98462155692A3F1312D5F228E971769803763E9EC4BB2D2AE751E958F3C07887C40FBFCF774BF5C87882FB1CF1E8887FE68375863CF8EB40B16746017D02BDD16E66DBAA2D3ED9B0D31F3589C9DBAC9C7E26412048D954DF5BAC5EC4843FB4B2151CE99F5CE52AB695AE9FC8ABD8AB83140B3AA7AAEAAA37A053C572524CA0579A57AAE4AC55D3D8CD5BCB57900CEEA24395F4DBAED3E491EF3779803EC603083749FC0E6B2DD06596CEB54AC03D9301B3AE766583E8AA86A0A9811F718A273739A3D206A47AA6C049F47B7EB54B38EDE672E8C42F92DA609DFD72A67A67B4B9C5277F03E893215D8CB6A5CADEFD04ACC240893349BEAE441D3AE105890D6F9278069AFB59A0215ABEF1E3C54039A11FE20C932DD90733A5D46F7E3EFC7DE7E8B8B5075591E66E1AD0A96460433BDF0EF7B9297899F48BEA3538EE4E400CE0BA88DCA8CC26AAACE6DAA0DB0D4300DD13600C7B82DC30E4AA55C61173261144A45030C5708BE334D570CBEFC8C56103073CB2F327BDDAC727918738552CF1C43965DE8B06D71A79487B0D745798055AF6D8FE7E0EA6DC7994CD17D19ED24DD4F679C1AA9CB6F7153AD018E494B86A5B46DE933635B3328E1D1C2E269E144B641618B414FE33D60B013775B6282A95A3EFBEA2753FC34E8D13D9E3F4D6B99B03A4D0B74EA55104F6E67A6A741EB345E92F1BDFECEF2AFECBA60EDF5E76547E0748E31A6B66FB39420357E61E91951E7D73703CBBE3DDB8C0A6EA4F843DC2BB261947F652B2CD57F5BB5FF70D5FDD96BEF3ED44AA3C1A3565AECD547B4BA85DEDE6B38F5A15689E3CEDCA9AC2F3B2BF7B2E09B68C7AB91BEEE28CE6B37EEF162F5D376DCD443615C175FD9D9BBC623D8CBFCEF410541B03FC65AE068354570EDE8FA309603018273A57BBBC9AB5A9D45C6E00DADA6CC342F6639585F4DEC9D4F21109E6EC26B8B3EDD847FBA09FF7413FEE926BCD6E7FBE926FCFC42207C8FB7A40767609827D69579A19720D5057C3FADDED62679569D4F56313CEA73EA6D258AA7D4A12C2A7E833CA10E55C6DF8D5664C3F26F7533BAA7857CB310CC2D3973466487DE28D496713BFCB03AD3B13D54479EEB681A67B1D37478BB19A430B35D2858C0CB9BCD9E5C75A67DAF191E42CA57453145145391F7379A559E2F23CC43E89669FC5F8C0F3ACAFB36E6471C65A9090F37CAEA5D8E14DAF2C18C439E8E32DEEDB72B0F646A5B48A5BF0EAC19D6B7306B08393134C94BD18D34F5B7DABA8C924B6D4DBAD4A2CB641AC50C6D78F94EC9A81FA3337483CC7C9E19969EFF612A6F879BEAC453690FB45EFAB57B24F0D2A06CB7A4CD2C05A9BCC42843CBF16625AA157E875C73E9D17CB43505271C680D072E836740E2D096F7690E732808F601E25BD64A47874D479DA3BA8F559774A4F476BBF242E7EC9E6C57D1E8621CF7DD9431A3A009D393360C9A708B1B17078D2FE6F5093BA76BEAB2C5407A9FDDF286BDCBF36F8A6EC2973279060ED35D9611C4FACEB18B1DD6963F94A8611E9651BF61C38C1765DDA1CBA4AFFEFA8BE9D50D74D7D090EA385EB2528ED34BD8591FD944D90CE44395B68A4B22A73147057B4C0F5E4FA3DFC575D6D93BD4FB43A91A5D40F7BEAACFA13BBA3660D056AFC3B835719A9D410D4B4D305487D5DB8C3ABE7CA85DF034BBD71944ADA53BBFF759BADF1920AC293105BA9AAAAD903528FB842A6F7E50A529E3AC7F09C76E717CBB5D19D2C0E33BB9DD6F0CC05D669F02D965BD56B06E0B3E61DA9BD75D29D2CF8FDC2DFAC157E3AB4EA5D2F240BE64E3FB259E2D9754F710991F7C0E79551CA065FFE42DEF621F2509C9CCEFC649B5CD8620A86556BD7FD3E5E815492641D015D95453F5F79CACE2E85D9C48DCADBAE49B6692EBB9E292048B169FEE64B6EAA4829D649B02134CB303CC984EB468B8CD6EAA9DCFCC1A7426749DC5E5BECE250D784822A7097E38C29388D560EC46367E3876452618905DDD36439229FC34286D6F7E50010AE3A4FF68B1C47FD925E5A340EE4B3C52B9351AB8AE4B29BFC4CB965AABD1DBC6DF5B5089DDA7266B2A5F7282B1CCB36033A4211A0736B24D63570CC3D458DB964B5F5B9DE8E6E8C608B30E8E513ED38DAC6C3F76914584318D2DE765AC9B8FF109C7B6CB98FEFEC7B2D4974A33F48491FBC2D125592078E2C8D0A951F9CF6BB2A1DDB82C5F03743D387BBB8A83A841E5E5E9CBBB7AB83017BCEDB5977DB14EB3F1EF092FD2CD2E4E28EDD28B6BF9387A7D958CF235C982A8C25D6DC1AE5DB71586B949DC55575DF71EBFBA2C16DE05D05D437FCCE990488205D9F26FC32CD5F330FB36A7DD8FFCE21A371FBF502A483740765127127349D52020ABF13D6A8EC289590B4E502D38C1B7E0C4B905A7662D3845B5E014DF8253736F8AC1AAAC669ECD09F03DCC206799C9E5F57E435F05E0C12A242A38F47377811117DAC56A506A0AA72A4E4733F68F32D2F10E5DB39F81A7C6555AD4EFCFF06E9758C049084C803D0927363054903A30446A94FC10AF96BD21BBE232BB0FF9CAD522DD16D1B2B8483F93F175EDAEB2F3F4365C65219E56AAF62AC17648695E847B06AB5DA35BD7407FE7013C6538042C3CC1DC8885076161916504C5045DD08B8378CFBAA95B785B724267F0211C6C7DBBF190F2B75A38DD6F16A698327B4A19112EAB0F36CE8A5CA6F6CDF29DD0CBBB5EE99ECAC02A1807D8044BAACC510C43B6499967EC14596C3F73274C2F74DEECB30A5D224E50E6A68BF4F28EBD026850B87E63F513D9D195890EC78A8FF328C00561A8E277748314A0EADFF7493917D10EAAFC9BCD0476F9E79622E8EECE4CCAE9039DF286017B50C5CEB20D59BD4BB341BC1D9C01324D4C6D965F2E2A5B786C58D3878BF79766258C0B2C5E1B16B82EF6E5CA6256E83389966B9299157ABBDAD716DE28398FB6D13D31EE61AA3EC5F771BACF3F9268F0FC31AE97B3F8A174354D371B92952FBBD295CA4CB2B4E47E3B78130855AA72DF301B32E5ABC3B9AF27B33175193E037CB5DFFE23BA350359BC5DAD8D4ABC8E9274B98EE946606B54EEB7F5E32DC9AEA2AFEB62BFFDBA8EFE3413FEBBB3CF676673559CDCC705E5B630E7F5EC6FBF998DBA565B087552427F3EC4DBA5F31BDCBE1E650E6309F96E2D064137F1EFCB7734D3BB5FD32DDD688E7FA6B77DA40D8BEBD5E5C3F62ECD366186C8470A6D58A11CDF6011E651952B3A70E946FB45A88A4E4255741AAAA29F4355F4D7F1C7D9482F868FB7A4D93DBD2D18C4A007B8A599A477BAC59CDE1FE316AAD23D320766D4B7C0E97139E959536803297F53C2D8B28A6E71A34AE1FAACCFADE8AF3693BEAFBA9C6666DDFA264BAB19D74F74D6A3FB43FE2E89EEF36E0862EDBB0322AEA65D3AECE91630796CC8B52A25DB1DE764437703ADAE15E5740FF27B94ECE98F9F84AE63F27ED8FE46B72C5DEE17EADC554414BA0128CD014D891351C8B53815221E22C34DCE3CA5F0C2BEA89CCD70C27E4375C40C2BEBA1B5B975488465CE977C9D167DFF9F5AF4CF7B92DE67D16E5D7AABD5C654DBFEE1294DD03F157F7FC62B742FB5DB7E5C37353B7E5CCFFC76F59BAC63844E1CDA059A223FAB8BBC7FDDE5FCAB3A67B5216FB2FE1775D6DA50D0E4FDAF16601AAE9FFDDD025B4041D4C283EA0DB98B28652CA2DED175EB0F19A0504264754E5BE10DA98417DA15691ED0C609AD7453DD5597E57103F113F907590EF3DBAC4CC3D872F6735E4B23BC8CEB331A242A9B631517582E97E52B7A8EA8EC894CA02BEDB3ACB2CEE364764DD5DE01846D64D6BD6DD5EC2C6DC5C6D299600ECCA23BB4DCAE12DA20FC58BE5EAE49F91EB174308B6A2C55FDEF6B7B1F6E7D2D2F7B2464385F685657BA5112B8D22CB3A57FCF2E1DB65BB3D82E22BA79498635D8ACB8EC19BE2BBE2652AB3FBC39C782EBE2CDF9191659D5411016558C6E6FA348736E0FAE5D519109DF173403C9B6CD8926BA53F8FC9A8EE92D01B8BE794377FCF56384B8F1DEDBB570C3BD34D425B2818EEA7CD02BC5160200B109B48BB8688C3EE8793F23BB2823ABED7066D62A726D447B1C123E9165E947F18845023B05FC6CD1B36DE834B7097648257C5FFE3BA98EC391BA385D5A2B2F86EBA542651495A522CEEFA265D948B6A07635A7130E150E5B48D3AD9FC937F4E05EACC9F2EBEBF4DBC08EA55BCA49B62CFD91EE0745348B79C9105B87CD623E7868C75AC16E49844759EFB9869D2FD272178745586F12C701AB65E7E73FD0A8BA38C382AA766595AE19C2E878CC0BB2918109BBFDEA6E723AECBE1A1A1358042A2A786C548E4D4E9BAFFE391E6BCB7E4321BCB4BE6CBF6ED33FD14BEF874D748F9EAA7F8F5724C58EA2ABD51D76F8FC9166D20D16AAC3143ED7B63D2825F9B4CB41EE72CEF23C5DC695CCB889B88A1DD7CDCA6CA56FB7AB67CD336D50EEFE746F70D43EC878F4EC9C7642BCA362A75F5E1DFD93D02A5D05DD19A858014F5C94EF277247B2FAC87441B5D3A25C490A264B75D84FB730F12E4A307C708507BE02E233E0E053FDC75D757CCA1BB2235578508CC0DDF9E8AA634576AC93D9CBE30192D4006B0327D6266CB2D2624C5600825917DA118F30297908643CCFE3804DC712AA9FB9B28EB8D375823F960240B07365E94C153270083921D0F506093CEA44C200DC7A4BCA283093F280E9CCA1A3AD03AEA40276E7210090188FA20E06B23E0773438062B5233CA8E00A0060C910EB09584A3E301D3BF4BE76009752E0EE7C040018EBD355BD1A52591F650890E48740266635819AAC2268D104487B029A860BD4A2043EF66104338DD0DDB8080E32AA55462BB289977FDF47497CD73EFD8603025C580F3F7BE8496A04770850BB420053CD234E6B07087885ADBAE73CF3181ED4DAC559927F54E84EB8446B3809B8486B047F80CB34EBBF8EC402ECCA3E02E8402F78A4F2F9D3F3E7E3E00F620AD3F3FCD311FE7008F5871F8EA6C5636533B7804A592E182EABCA34D8AC8DFF2126471967A67028CB8E07D26107F9E32C0058073711E9441EDDC64973B5E386FD29452D9600045F69591324A31980D77945AD9E006DCA2072D11D9474C4B56917FA62302CBC0DB756DA921A405B42789E3B2A3483536DA7D0BD75787BA961D3B41B2928F348409D70FFA46223E0E64925EC83D8390D1B80DA36C90A8C04B179EC96741C05DE2AE9FAE060F649B28660D54DD40EC9330A27DE1B61D89A606384E99483DA152D98271C6420617241E05B005E0A2AD4B1040DD6557F931DC842C0351594E9412CA6DDDBFD0B953F0D930BC24CEFEA8BC70D4B14C00D04444F8001EBC674D8C2DD2F0614A65BDD2181A29D60849CDE0133A1122FE521E06C2315F061CD385A4F2A21A777204DE84925E501D3899E3CA9A40276E7210090AEF7D903796C2F52DDB47F48E124C90F818ACD6A022D592500C064E43D014CC309A68BDB328E30D308DE9D93F060AB7F62A156FF1C15684D1500CC1A5683808CE502D3B17509BF0063C5EDCA45C025F1ED4394EC6BB3C8D002A05BC6E062AAC5B22F61B36C4AEA83D650B91DC3F332AAE609B59EF5C53C2DABEA7EF1C2D334E0D42EB58A32416039E1B28BE026E0D28BE88883587E8176689660698920009C6839D672126C49D68AFF3097E56EB76980856E971502785D6500F4645BE5F1C0C77383E9F4B68C7F00F21DE1CE4DF08D47FB3C8AE96E5728A7DF8CF42FB1D86E4AC44AA7DE054B399A6C372CED988358966BEECB3ACCAF80280B4ADC469B32862EA3EA9AA6BFF681E20F838791AE7CA07ACA337F61C18BB9EAC1E71D05A2D35EEF907111F06C4321E88338DD18F08FBDD201E51F055CF3704CD23084E965BF573854F2F7C3CD74B8D35DDD9095191D7FD35FD7D07165DAF57EAE6AE83AC41F57414169774B03595E0D56FB3B1AD8EAA7BAA261C81F72FDF47743C3B0FB7CF13725B00773A431AA06A33F34A007550360964FFC630359E40B0392BED4580016BBCA075FD3599310B0D5960C6A519A18B068AE82C215DD45870D5623DF0BAE545090CEC22743C24DB0832054771CD06110F6DC1171DA68E5B238F1C9E2D4E789870B9CEAF9CDF6B1495D370F33AB2064FA362A481FC092E4514CCF6082B8C0F46853C413A420593B73111A58E8836926F768D09AC13134C807A65F3D1F40830277E72320C018C328CAAAAD2DA9029EED5396FA4A0D6DDE9E01A9E52BB0E91BDD49076304075B849E19C152C1803A831953C9CF0433A7B2430E620665DF5EEA9AC03D80A530D7E94BEB1FD8B2D96EE0AA864D2F8AB7BD46796C4BC31DD2D83128E9F5C12D4DB7F9E26E3A30B77F5C933CD79C74238A0785335FB762EA6D5B1714D012FE4CA6BEA6E8389096F49D37FE02AA0C9D88B1DA025F40A52848C083D111846AA6530F64AC4CA019C8847F104A01D788E1D520935B5FEAE208385A3E3283AC7FD2DB6038DE3068F17F2B0CD76F5E789B16CC58C5004F621250CF464930E731BCA260DE9787A42C40CD41BDF9A552123CBCF535A172A06223A062A012F6412805F2D76C313A01AAF4046F194FAE1018B116561F30EAB3435107D88DA2B5D7279686DE5AE0E42C876663420F50531E3148F2ED056ADA9DBE789C1AF056765E258DC9003F4BCB2F8AC789EDBFA8EE3C582B7015B4CC0AE640C92021E7660964056713C357D14D0704DAE149A23E2222985B1774D3149A70256163212A79C074AF8748884A61BBF13005B050EE31CA52A3036D062E31289E309DEFD11D06D5297E780A1D66187D2354596AB4B0C333BA178AE2CB14041E3651A88EF1C75708835796FE832CB1113C80CCA039ABCE6764BC82484F332BAA58093C19AA047E307360EBD3DDA24206012E1F042C893FBC0A583C55F8896908AE9EE0246100654AAC8B388248225767060240E76C59C40FB433509736A0CC108886F94C9004D20F7E6943C505A64BFD5CDA50C9DA998B80C0BA69FF50EA63606E15B46C60C512079FC31AB03A2EB8405E50BBC041394F100385EE8797904053067661727907D604815DC0BA319DE621B00B284CB7BA430245A726F119BDC365324D49C64138554926DB83D09592DBFDE6E67D94242453CC34C35C2074CA0C46B8612802A069591A093450F598FE6A8AB8220692A773F501E0724E5671F42E4EC84DDDE3B2EEE5F24190E9B298C086A70B293C10143DC146523D4AAF280B38C2462255C7EA03C0E64DBADC6F28A9455490FB9442FE2A2A29F39FA5704296876026D46180366CB5900789A65A7F4F321A3289010B5FD611B686BD875A36410A93E3FB86E7E88516D26211158A6DD00BD4600158CF689533352140E57D61C79420B3A9E178620EC793D1E178328FF953CED79C1079E286C893B921F2D41C91A7A323F274A6883C9D23224FDD10793A35223FAFC986262C955E45606EEF38648843D74186AC8EBC3E43BC607A7858CE17E420A1FBE12528D074978E849CFE016671D76884796DC2BB465219BBF310F0C266677144C7F3164AA8AE63DA1882E5154D17E75BCA0B6AA9F21BEF5BDA01EEBC4C013CA397C4C052A30370064E41289E300018E1E53065A7F8E1690A605E6103D30B254607241F2C7E8280F5525E504637BF81EBA51DE0CE4B0817C8B4A809F1373F78C4C8E0812500BA4AC2658D5C27B1D52B5445D9A8F0E55269C8A2890AD7967575B534EC447F2C7A87F85B5AA674CDDA16B404C9D8F3E937B76502F94671B0DCE745BA89B6DBB4A868FCF225278B242BE191BF3A2AB2BD38F59684AF49D1F92C0081E4F2A367753EC61F018CE427409A275F892D2630C916B1382A95AB9A8A50ED0EA821D6F8AD41743AB73F1D3FBB1D9DF1C84ADD3A3693BE954DEF42B43AA70D0D89A11600D161B52C0DB156CF8508F57B067DA3AAA541D2AA6699356856693ED035AD36C9E83A5142085558BCDA079182AE5C1A11D61335925D352D686457BB261A71C95ECCD5F3CC5FACD6E35043DE90A0F4BD0810A4F2773DF0D568086B49B5AB1044A7371569882C6433D502333BD56FFF43C5DB680928027CF80A3941318C88A682B60044B28F8D6CC4A59E3B74D7F5D1B3559D388C5EAE1F834D5819C988EB02F7A009A106B2247616520CB2257C988E26A65BEEA07C68E2CD13592ABADD2B6546D3A56A30CB1E6835E35933F3A81E7A436A62327CB00EEE3A62F7E47D96EE7720A1264D4FA4F4A50229D4AE679AE2B50F1F3C2F765E8F1A1A9D27184464E059A75BE7D8E3389827F1E0134955454C8FAFC1D90D8828E62C4CB72EC2DB34708D946DAD91E341A9A08B1B678EEA606F06EF456EFAA283BCC0A6E4063640303600307F676FE85A28EC8684DDA88E646B4310495672E28470CC4A0121A1F62E91B801128524CD2B6F94AC0824AA7EAFA790929420242860E7E72CB0EE10A2DF1089921233C95B24E4856433D8DE2984239202A432D8E4390B833180F7DB4C51207046794BC0FC906038AD42211C98242020A9AC2D0404BC2A534FBBA2886459E52D929480C4046E8115C2929186461944CC5954371213964E6E9272D896C2C5F5123591A6A40E70A687ED7DBE65AD1AB9B2ACE8D6AA46AF8310A719C1ECE9AD5E5CF2C35E55DBC0C35E3F62038F76B1F3A95FF1D5DB0E23118AB786B16D656E10FB172573875822CE661BE62C52F90BAAFC365F942DBAAC5C0A581290B455C63C85E0D155C27381AA1E37F9E357297D2154F3F1EB136B56C00977062BD3901BD5B204E6C33552B52059492DD45234AC53B70E49F3E29AA45B81ACE4147AED91D58D981C4D561D55B151641772B1A9EEF4AB06229B41DE18261F249605B84357D01879B4756EAE0B893984CD20E79AC907B57C606356349E2503341E16A04BCB55FD2E6642B0AEEA7F4329048781CADE236642B44065EF311446287B0F7B9C76D39FAB8922916595B7465202128F70F0A710928C2C202A29417751B5E7AE5A413519D1ED6103C37B12121BED5E24EA7360F5A7A84CCC0FC5289394D08F13B8A06AFC3107C1889128A9011A960A2DC08F3455A35395DDA895AA51EA4188A1462B50B57CC4CA331BB54D3E723D086EA211DC1F82A3C4065FECD2B54DB8E4E55774C2552FCCBAECBC42B49E33068BAA58043BC10B25F5EBC7C00708BD8E88D58C3C8C7B8F17A3F3037519A5415059546270EC3D81D4C64635EDC0E7052D339AB302211BAA859A33025381053C1B68AB449C0B805951ED419C07988A68827300A86AC5198034BB71FB14B67F17B18534C3C85CF910267F6C514CFB8D0DFE0A774594C06760EE973233F4DA3410FBA098850406581C5FDC83CA00512B868F3F6D482D647D216355452D608F3AD10C848B354AF0058CDB8A3552380934E49607B13BC4EF09113B41A41D30A4089837E2157290BF250FB6017C4D1E9088DEA112A4088846E677E82A1BCC5E98CD886C0B66FF6B289E507B5EC8C95FAB3BEB0BE95B292DAB1222DEB9505F4D001D1B64028342B880616B31A87414682894C2173BF8808F5AD7255941AC8791A4BCDE8D09B76AE02A83751395CF943F810B5777D012E74B1A4B812330B2CCF9DA14F8EE6F3A799B2FBA5A11538590573F84F922AA0942D63A1CE1408B9778150B7B72A529896EB2840042B268E713648DE14EB6004610F38341692B5920E689117A609AF902E240E747859827A0ECDEFCA642CD0D721755CDD4802B886AACBC7C105FDCB0D382EA95029C55145D1CBB9CDB5847552F33A0F588795849E50C992ACEEAE296523155A2BD75C7F40A3514AE1E7703CD52F4AA28F77E6FA54D215C38ACBAE6D623E6429F3A02BBC472A0179B3AE6FA0857F9D4E1C13182425A777011C5FD092EB445471DCE5A77CFD6E0E41417011BDB5203D2A1EE4C416197216D4C1B9E99558654019A591FDCE6B5309566A50AC93C22C8F878C18A9BFF60AC3CA611B2A0C2087BBB920EECD80C0AD5420460DC5BDD3311FA330D65845CC66FC7EA918830671A70E856857014315EC1B6C0515E45F1E86E87A803BB02E2F635B9B031475592D1DC1481C3923A4862F4AB2242144D55EBF5B38734D6A6830C02CD204C3448480AF270912CDF60C0C861FB9B3794546D0743440E680C1E52726E391FD81068BB32F621C3B92CFAE180F7E1034E0A19C8E21D6A2569F3260C32481FF4528C4D7C3FA6A1A611FE866600E0112BD5F3328641FD8C6A72103B103B4E21695DA439B0C98A5873402B71625444979B4C722746923BB191DCC908923B995E72A746923BB591DCE908923B0D2F39F6FD3985D0E4F1A5E0B68111A6EC4505C6941A1E1FB0EFEC791490E26C45131349D212C5A98AA950029FB58AF17A14877C9AE03EE0E99A3CBC0FD032A4EE29A71DE8B2321C6C06233943B72A757C1A8F129CCA974A8C8E8291A2C135707930158FD20B753F1C1DDA0332BD598505612D68A681418662903E74AA32D999860231EA534507BC3CAE29754127BAB497C7D7CB72616A3EBC3CA659966457ECA3E43C5D91246F13CEA3DDAE9CACFB92CD9767D7BB68491BB7F8E7EBA367DF36C9367F75B42E8ADD2FC7C779453A7FBE8997599AA777C5F365BA398E56E9F1C94F3FFDCBF18B17C79B9AC6F1321FF6D34B8EDBAEA622CDA27BC2A5D2AA29A7EFE22C2FDE4445741B95EF892F561B219B106283155F27ECB63A65140DB1978BC646D4162FFF6EECF26F3EFF767EFDBC16A824DA0647AF97EF3BDAE4722DAD5A4F18CB068A0EA574BD8C92286B03A0A8DA55864059A4C97EB3D564E2512EAFA7FC9F255A7FC1537843F26516EFEA456948884910E9BD3CE644C8F7D9B1D069DC80E22181044C37425D40024F5F285CC88ACAA1D007C0617B5F1E18474EAD19663CB1C1673CADA1ED55C65D9B76089094D2A35BA7CBBB7EBD6348726978AA0BA04F17D2FE9C76B834A719EE23A68A32603F6AE0E23A7C96A564F86CD3CC51EF673C36873B3CB1C167034455211C183C01411D54140E6C32EF4EC6EC812939F84360525A3244577B9DC6B9E7D7056003E9C600AF0F1A817643012B54F41651BE3EDBA4FB2D0FF5C1773CB5EB22CA4AC594E36DF0194F8B6E25444ADDC7D90C1AE0257D87795D133E0033B76B494C03DC1F4E35EE4E50EDE120391546A0405A32C40CC8C7F01D12D4C5F79D23803432BBD86F6E4906CAAD4D3A8C1954D1CE5D9A4789D0C4E62B9ED21F69F67597449CF8FBAF784A1F2FCF5822D507038C166B920D0CFC0C46B9343CD50F7935397222EFBFCE6672626DC2F63394CA268E98A6D4C50F6D7EE1BD3355BC996FE43F91A4EEAE75BC13D53F31154FF93D49EFB368B78E69627DF238A42CA69A6DF5DFE645749BC4F99A70E210124D64711FE705C94A1BF1BE58A7996048807398D690553285267828DD8EFA827EAFCD8D42974A3219EC4556AB8CE4DCF4D67D34E8C7E6208E47F4F0BBC1BAB489626E31693E19CCFFD17695C45B4E64FD57831D55F48DDB49951F0CD634729BC77CDF751F0D56FEAFC2A06E3EE169FC4AA2D5E7B848383A83CF66B4C439B1FF6A4689AA58F1FD3612752F21D18C2E8C0336C58CA28087EEA3199DF3F436863AA2FD6E460D183383CF66B4AED669918AB49ACF2606B26D112D8BE6C2BE083B28DD92BA084420D992B6149AF25C9635C1609564B1AC4380AF986A4919023498C1923E007128DD608D48EF3998D75F8C763E77429BBB8F2656B6D6CD95B5B1C1B14F55946A234C94D00D61B1E717762E0D4FF54B4EB2AD30C4FAAF06128BF2FCCF345BFD1AE56B4E6C4CCA77B8A7EABD95ECF75332EF2CC45E4A5E348C56E7BE7F6ADD6D002354F77D36BDDDFB0639D9F7405F289C814F52D4AF74E7678D9B81C5A4766BF56335813C780D2D273089B0D6939207E1C0A0F9369B3E74ED37CBBE32EB1F33493E8D4FE9B30E2E3D2D52B3E8770C11B985685896C78398FA9D8D54DED3D4574F3AF7E21C7A10D86A1BEFAEDDE787C5C58705B79FA9BE98D89DB72BDEAEDA7E3375277B1D6705B7E160120C2C24517EBD23CB384ACEEA976A384B89983C9713827156F6EA348CBD2C211C96B1C9466B0C6C7AB1B4B6BCBEBABEE0B6FCCD273C8D7F2751965FDEBDFDB62BAF0157D71A86F480641367B7307EC87E77769777948B12F0D069829068720A92C7ABFA9200481A4A37D84DAED32DF9232ED66FBF71BE4D6C4AB89382054978FB56F525ECC9898F7386D7D1F6ABB882F45F0D2865D176B906680DBE9B522BAF4840D4EAEF26A375593AC001CB2D9B624C919FA3069FCDB9137A934930B0B3BD3EBBE06C6CD597A96D937416D8F3E868BF19CD06FC9987F179C7C15822C567A2FCD82AA0576B0C6D15308969F4A51F7C8FCCBFE2E86B8FA57E22D478C7A523177EFFC57204E8585CEA6CFADF5F8F3BF7B16DAFBACBFE6936E88EEAA4AF1C3B1C69C888DA9C71E069C98F233B12C2B9079BF4030C7FE699692F5DECD6A9D376637BC99C2738FCFE64937BB2C93DD9E49E6C724F36B9279BDCDC6D7267DBC7AB8C3CC4E93EEFDE4F298A72EAE6B1ACCA68E2ADC3D2E08002249B585ADE117215C51CE783CF0672A96EB18AC486DF4DFCDB1E4BB5867E4DEFDA2B42BC4202E598DA8A7630B6AB1E2FF61AAAEC0138847A2A2F1A468F847ADDBCB7DD35C9CBDBF2FEA20098C1E7F1F7C53A898BA66F36C59CE247F2401298649364721691529D21EBA658E1621598C10829B3BB294AA7676E3526013C40C3685C660FCCC8A87C4CCB4B5DF1F222E5C5CDA698686C77242B95DEF3A8BCEFC65FD305928DFAF3F774BF5CF33BC2E17703C45681967919F65F4DA4B8043628FD57B39DEA828EBC02BA9DD82598D1A3AB10DD234004FB94D9ACB70BD7372BA087FB110B2D5C6CDCC1E7C1C46B35A54CD4B56D6073FBBE85E3B4237A575670FCA9C1431F7B5657FE20C932DD9073BA578EEE857BA26C9AC192FD2D2E40924C82891944D4F6E49B83392A25938EB2BFEF495E02E313C977E936779A51618AD6A3504F68FC51D9F2C0D31A7E373252D196946628E0587790624A3117DD4C9AAF2694A29C9F38DA6FE6FC8803804D99CD28683BD205F72D0D0BA4CB8B864124B0153575A91B7FBB5810D15A35F86CB0155AA771F52A36A38EB51F0DD69CFC2B345C069F43AF5FB6DB8159AC3DFED61CE7B5E670D69889CD9C6F1FA264EFFC0C9348CDC1F4A92212C8083A53BD630C378427CD834F37776A6C543E4717C6868A9DC3A2B470381DF6C905E5C905E5C905E5C9054521D7271794271794315D507E6CD7857EE1F67AB502A4E9A4A5385CA9F0ACB31CAC2F75BBB1718DE431A4E3B067338BE4312C25DBB19947F2F0BB07F419DE61A488333F5A7C90B6237D3D1E0DD1731803768F49FB45AD9BAE3D71BF5E5355CA539736A41C7A534A41D7914D41597F0E92A79ADADC37D954DA7B7EAFDF7E339D165B4103B36297647800FC39E61B38F86C74002C52EA3E1AA8A5F764BBE24E53DA6F213CB76671DBD7875F2D4CD1F986AFB9CFED886F2B8D388B7CC82197F630FEECF3585A3CDD409453755F70ACEE278E891A97438789C31CBA6E7E87741CC21C9A6D72BFB7309C5361E09EBCCFD2FDCEA9FF1B1A367D2F2DAAD012AA12429F0FBE1F427F2B35B333DE5BB0FF6AA4970974DA6FF3C15F72BBDF3881AF2460833CB89C147665760173EDC743065CD508E079AAFEB3C9994019DEE8817CC984EB0D8304931397255D8BC1B7B3BAEF877889407AA61A2509C904978AC1E7D90CDC9A27B73B094DBB2C46AFB4A44FC91ECE18F63EEE2CE6848970784E5671F42E4E9C80D811B180A2A2ACD42ED416E1E1C8241C3220CB3688F8E9BF9A4DB25F7649E9540B4CB27D8A21B80D96F2A95E016B2EA537E167DC665A8E98CD94AB2721ED42AEA4707E08A487043F709DD8F81A31DDE39727B69A96CA737DB71BCC3E40AB3B7A1D506B8E56194A43A3D3EFA18688BD17BAC1F8C28DFE898EFE891BFD531DFD532369AFC9866A4C4B28FC029F66B0155FC5E278ED3E9A79B75DDE5DED6F9318BA590D241B2C8B55FC55DE1DA8FD6872DEBED9C50905667976B3E463A9F1890633ECBE8E409B89438A4BB2A0097AB089A9169401A72F3ECD826AE50427A1DAA41950CD62DE4FB2F964E2AFF79897A187E12BFF62EA54368052051501D47F0DA1984E75C83398BE9C8E7506746C0E7294C5C3CECBD36D9CA67A5B342D6A975C7F917B24246DDE1CC552924E423001410B97673BAC2B186FC8AEB8CCEE157EF862BAC9425E4575BD483FF3BB2336C582E2797A2BA158A5585094C5D36D520C9DB44175804D31581AD3BC90F8C87349E69B82F6A453B63918A6CF6612E29873B36CF02D75702D909318B71B64D4C7B91144A924D16D9AD1A29C3326377EA4D90CEFBA5DDE759E43E2ADB761A239FC9F9E969BDBD3726FF659851259A743E9068B6E4AB7B743E724760116524D6F337E223B3A13D339A2E2F13CE29D37E5B9DC6A7A4715584C5D6D3E7C6DBFEF932DC9A2DBA475F360EA10530D66A73FB714697777DCBCD47D359048FA40B2ADF8E8C5F0BBC17E31DB90D5BB34135EBE60124C96EF44DC1E37DFF054BE5C54168F98676AF8DDC045F1E2FD2547A8F96430960412A61416AF790AF51793196C5FDF08E726B0F6ABC1FC4DA2F29D438E52FFD5C456B7AF8D1451721E6DA37BE035164916A3F3DAF8BE7C76F92389844BD442A29125E7A1F46548371B9295F73AE9C22D1876801C46D6BDCD7E2B5CCF197C36708F2F4F3B810350A359A8BCC09C0377EA9904537AFC35E4FEAB89AD6EFB8F88DBE6B4DF0C4648BC5D7137E39B4F067A4894A4CB754CB71A9C8EC724E0E9FDB67EBC25D955F4755DECB75FD7D19F5C2742E90616BAB3CF679C75AEFA62B09EC4C97D5CD0C615409B85448395E56FBF712B4AF9C142C7046DA462AAC9B89FEF83BC1E0C25076088F06F36785FBE7D93DEFD9A6ED33DFFCC069B6480E0ED23E524AE97AE0FDBBB34DB004894E7323853A75851E9EA50BA85F903B832C4A7198C228AED7D46B803D1FEAB31A5139092D1796753E614A46474B2D994F919A4F4B305A5BF8294FE6A84C7515E22307F767A5443589B584D2D31DD6FF159BADA9B2FDDEFBCFD505AACA89A599BBCFA72D7CBF2E4A36A75BE8B96D5F4B522EFE22C2FF7FFD16D94933ACBD1B36A25A0DA24551F1EF3826C9E97199E5FFF8F6491C495F2DA66A00A6D7C47A797CFE957B27D7574F2D30B8AD7B3248E725A94247463F76D936CF35F967B3A056DA2ED36ADB7A6AF8ED645B1FBE5F838AF6ACC9F6FE26596E6E95DF17C996E8EA3557A4C699D1EBF78714C569B63BE78431645E5A77F69A9E4F92A195AEB0676C3EEF410788E8535F0BDFC8D3CF2FDDD22EA13B953111257C297C73CB5973CE665844AAE5F1DC565675416CAF7A4DC9B176475151505DD08D33D5EF59E4AA9645FEC4BEB5C42F3DF4589F8FE185F67BDE2D6156C1FA26CB98EB2FFB489BEFD67634ACCB196866091ED397AC371A4E936C8148BED2999B115D3397DD911FB83FE2C037470B5F063E2970FDB15F9F6EAE87F55A57E79F6E1BFDF7405FFF2EC32A3A3F597673F3DFBDFC6D5F3F7A3CC78604B3B3132175C02F4B8F7266A922BFAB5A8AE351BB2B710318590745DCA40C2C6E34B7C90C46C8CC1CF8FE0C7595B7EC4B12619D206407704F9E02D14B3FABB824ED5D7AF9D0C6A9EE78CDF34D6068CD2C766F43884FBE67B9BEE2B4D9AAC1C468240C1C788A8CFE8EC91B988F2757D9DDE85CAE0B8CC7192EF8ECB8CE8E0E76CAE13ACE66D000AC673B71A4E3FBCEEDA0C5A9BEE194C14A6BD02CF31BE3B83773B309B46D8D2E36B8E2845CFB3E2D8F4C3C57E735B9EDD78A038F50405B67197E6658C320FCDFB23CDBEEE92C88FF43F5E9E79A1531DF8F457577C90EC5FC2AC89DDC6BAB50A3DE3C89F54C34D3B6A6722FDDCA39815E6BB1A40AF35DB4F671E36C3F55DDD749BAFE39DAB6AF49EA4F759B45B974EF7B55B91C30680F6DCDBBC88EAEB052BD5EC8119079F48F90C17C94A137D75BB64B0BF761A6035E1DABDC8E3F43B24BBA0DF6B9B9D9FC5A73B16F2B1900D4EE7CC70DC9774C26F739BC5C72C1E6D5749BCF523E3CAFFD7C73A456EF3D853BF374F367BA0F42B89568D9383276ADE34AB9218E37AEE89A6577494047D21A4A4759EDEC61E3BC3DF982AA95DADD322F542AD3926BFAA1F06F4863F86AC372032547D239221EE159A0C655F1865887A042B43D7E34A90DEFB012CFD79E7ADADED0B080E4A157FBA6D4FE94B4E356A5F43E52ACAF33FD36CF56B94AFE7BEEB69D5169B1D8FDC9549BFDB91285AF3DDE90CBDC08CEDCF4DC9310EA15AEA96963289671BCA5406C963BE1D18C87039DCCF8AB7737D9812609B34786DD7C9EA10D616D936C0F04CA52A35CAE1AE65DFD97604D0FE1F7E2CB1578B6D7B447F41D963378A9599019A2FFF5D8D29D595743F7DE9D841BE471C6E531778F0D617E43DA8A56DA04237AB68179FD0CD220A0425C42ACB0760D60EB14CA38F74D88BCC7E8E0FBD9A139A8087202E31E58100870E9B5484AB2ACA8F0A24E384AAC9ADDD42E4442F470D62C8441F9B7A2662E28C4CEA7500450F84FC199CFC59E65F47DBAFDE4C98AFB368BB5C7B26575E16F0738CB55C965E58FEECC00DC10B3FB6BF963DC733D50FAFCF2EFCF0E3CDF647278CBD2FCB9FB7B381408E0E55773A5A285A05C9C5F40028594FBB5F66A7A28A633AE23E581796F4C076C462738CF51EA6FC18BB64F79E76EF34A59C7EF89139B871EBDE599AC056A3742F57A7E179C6B0F0773F1AA531D23CF4AE4B477937550D5EC236EB85BEA413189E6C654FB6B2275BD993ADECC9562681D393ADECD06C65B8AB73DE8C6567DBC7AB8C3C94AF9E75EFB750B560BBEAFDCD6D26789EA6AF9B1CEF08A923F8DAB3368C036C3FEB5C458FE50D15FA35BDEB429DCCCB4635A239088E488DD36EE5E153F4AAAD44E1F4ADD7BACBDE9F3679795BDE6A1B74E3AC2EDDB1AFFEDACB8B7BEAD79E10F8B2AF3DB9F95D01A433A0D3BC15D62571863A51A01741C48A3FA6E57DA67879917ABACC42E7549295EAF379545EEBF2742D9402ECF7745FBEDEEAE75C6F9F3D100B81B7E51C45BEF4B88B1A06AB751CC56C9C5A2362E8457A61F954413B404C17676060CDD8EA3BE234E46025AE516FD36BFD3833ED377084CEB8E73CAB307F9064996EC839DDC846F77E26E6B7DFE2C2273D533DDE528F41354DAFC638C3FFEFE52BABB47B3F917C976E73AB1312D9700033B71522B3D77CADC0909496C32DD482386CA959F57D49C7BBF643D9199FEA76653D3091FBD2C2A2DCD354D4F235E663466D3FDA0C2AF938D1C35E823CEF47528E1B51FFFBC782A06C43B8BDCB3A8DAB281A3E1695FC2B0B5D2B639AF3CA64AF555BAE2A13AE264F8B8393B5F1ED4394ECADDFDA51856D0EAC40381EF04F7EECFE23A1D4C4BF22A823CC8FACC4F49AA0A553A383FE2ED5609F2E823D39B73C39B7A8F878726E79726E79726EF9819D5BC25E043B08578A5E9DF0725B43AAD88005BCDCD498DE9E77083EE1EDD6CB36F0C3B0BCCBA63140E087C9F7A713077EF01DC2E430E248B47DE7FA26B2A19DC6F509E5C9C13AD16B4AC6FD7A4D9521C72E6D48B874D380C4F73C83F9DBB09FA7ABBDA7CBE1F5BCD6E2C0755AAB8EA43FC77D3B5D5CEBBCD06903577A1095A3AF97E57D5F17B75CAB9BBE1E06F6ACAEFAAA671983E1DF117062E7433E85B3BBEDCAE078EB518BA5318F5266D2E1931C2D18C7AEB3DD9EF2D10F4D3B4B113DF17B7557C3F7CD3D799FA5FB9D55BF3465ADFA6450F607E80F891A73D63BFAD9ECD0A8026344018F8AE476BFB1824459D00A0F6DC11F120C55EB5D5D90EA70340FE44BE6C7A07AB65CD2C5C995AB9978BF030789519290CCC21BA12B38C65AD910B7197B8306998E3E5816938CBF296EA3791F39E6C3190D9073B28AA3776564040B8874856D40C214FE116152B6DDC774F8659794CEA2EE5318B468624E75EB62A3BC27D55C69EE226E588094A761F5A61440636AC8E26E9EB95E64A5BBB9F24C50DD7EDCAE10A4E3E2C811684FD3DDAB77009F0BE80E066C639AAB517810D0F5C2F8085624E1760627D03B7167E9C4AF904EDD393A75E1E8F39A6C68554BBB27FFD9D26E010C57B1B7C5BD74BFBABCBBDADF26317BF7D77E75AE8265FA71045AA49B5D9C94174BEEC976E927FC66D5D67C4D326F0A5747D1AB0F544BD49FAB5047B2F2AFF243328BA51E7B384FAFC7BC8CFDEAF5E6B99F1D7CA9F6FAD3C9EDF55FFCF9C26086B13A51E0E637E3C301F9FC385F5D20D473A66951BB49BAC7679190B27AFA524E6AEACE43AD0EBE9CEBDF905D7199DD8F1472F322FD4CFC4CE01DC1F3F4D62F415F0EB2D562E575194CF3C2AF73717757B5391EB3DF05F414C67424EA1CE31C0E89876DB53DF395C8CBF7EC309B68798BB4CC9E9601D5392F3D07A5A2BAA47479D7799E78DDCFBA6A3C4FAF8AA1B5867D564141EC490B1DF822A51BB0DE1941E6798FBF25F689ECE86C49C75FC5E379E4C99F0D22FE8EAA7C9EC8FFBE4FCA4984E6AF4EC85DC470F9E79662E6EECE4592E9039DC7864F11581039CB3664F52ECD066F10D8EC91D2C46D93F5E5A2DA3EC74E5C7CB8787FE952DEB1F8E2B553F1EB625F2E482E243E93A87CE5CD85C4DBD5BEDEE646C979B48DEE8923BE3E9124BE2FDF8DFD4822F9ED50E43EFEA13CB14E371B9295B7C4E882E7D25B94CE7E3BF0E6B7A0519DBBB94C02E5F5C9DC5FACA79A9ED35DC7ABFDF61FD1AD0B8CE3ED6AED50FE7594A4CB754C556A991683A1F2DBFAF1966457D1D775B1DF7E5D477FBA74D3BBB3CF672EF3749CDCC7056D57E1DAAAB3BFFDE6323BB4BA934F43D6D50FFFFAA83F5BC1ECF7E2DEB7CEEFCBF73BD2BB5FD36DBAF7F338E9D9F6913218D72BD887ED5D9A6DFC81FD23450CAC08FBD9EEFBBBAD704571BDCFC80B9FC44E7C123BF549EC679FC4FEEA0787DE6E2A3B4CD73243CE599EA754832AA976E711B5E5A4BC99782331E7D09DE9B34F6932C8DDB2744D92BBE7FDC7F33D5DEA767447407FBD3A7A2134502434BC10C910AB135882FF24106C9E4D2ECDC474CEA3B33A1D4F85687AA2AB0D1DB509DF082E2368A5925BA74A2977A4F994376447AAEBD0507BDDEBEDC873F6329D3C5E1E0F10A00646737FF6A6C63359E9B1C16764BA5548C463A5E184A1D77D1B0721CA36CB7A8C2BE48898B685FEAA0E009A56B3EA743C295ABA0CC35EED3FE2D1D156C910EA3F8E820FB87592CE192ACA0E78E89AE45E6700200C6DD23730EBB67DA80203640AAF88B109A380C2A883869B170750C82FE85BD51B0018EC696E697DBF017C0206ABCAC03E5FAF24D5073C24C40A197250F2386B8AD04A4917C12E0E46B0001AE556737060C0CF5C29F4522837AB5782396C71A4C0D0685AAB5620B26E953D3CE60D61BED9080FB7704BD4D4389A6299B240CBCC16AA1BC553388EEAC74FCF9FCF192FC62A86FA159FB171A3AF7D5AEC547E1018FC0C1D26040CD5898733E9A82580E8CAB2D0B4609273100050D288F337CA970699E56B988D5BC498243CAAA45CB19B7A79AEB11638A94424FDAC7B3BD10867F2F6FA62252CE0E6A78A0F5FA79120ED8750C2A5AFF4B8F3101862E1D4EFE9B03385E26D8A90C9B5EE21282653B9A7C3C894CAB6295666A169CBF0328D9A3D0FE04CA560BB00685265A78C76EA7909D2CC300BFE7C74019C891EF0BA23C6ABB5AA2F40DFB72E383740885DC3FE527538EF8A5F11E93F8ED2F1E84E80A3041B7538FC5CA9717D213B3C9CCE3945E74F31EA8D40309F911FCE57610A204CE1AB600484C97D15D898923792E0927D2F761986BDD87FC4C3810B663924C7278D020DB8A5926E52C645C4434315C0D3AAE6F0000103BBF3BD0AF4E62141036AA3A47B14D135478585AADE80CB471FC9F446FE6AB6D31611B3A20CE2A9426BCB30799C55C670EFA77CEBDB6AAD914594B565601A08855B7CE6829C2916214BCC4CBE10018009B118CD052AA117254B98CC6F61920413B1DC981C02548C7620CA3055A3C3455D7B70F5B68DF93CD93E880F860D28BD7D96EF66499234F02096A53EF8E3FC7C0506E1C539AFA7EEF30FE029200BB2EECE4258780575D39D043713B9E79AA06372CBED001053BAE54E828F89DD714D70320B070109562673C39D1C3413BADFDA826752E7005950EF493D6FA591C66158FD107EB7B8E8EB0E9C4C0936D9E871995C0E0D608633081BCE7E2A60E9B8986E7F1F1A5273DBE54F0527879DFE7CC114FE4C747A004D7B466A049C9998A4839E568474B299EA64E2903ABF7A610A7CD5C6EEAD1F0C0684E7A5D88451B060F2704F93D7131AD08F4B29AB0D0D89F0875353A062CA0329342E263F8A6A19609E0F1ACFC687018B94309CE1BB33FA81CD3C18F31F08A8F033CE1C4034E50C640C9EC96722F6B5804E81558648F2F0DE02FE110710A3B22C636DA04D1F54D0858532B5CB408DF5C5C774206BFFB82679AE5AF3F87CD0C4D2A51D2ECE94E290743057663AA4A11809B810367C4CB0065AA0F43B58F96C403B17900C2F574FE8DB2E72A3C2D0F877ADA7F775079AEA8591692136F1B23757B84DBFFC39C26E2E4B2084B5F197BFE9DE849862D9B3C5C61C40C11DB94FB0E2CDF341B5E9D63BB7A7D4E6B0DCB13B877979104919536CF57E144F2279937D713335F8E663C99A17F8E665D5B2F3389A9F6DAB7AE87F3E909B2E0CC0BCE0850E0D3013500DCF1102C48EE0AB931E2C7E2771238426B9D53B0520A6392C9E0350A63C24B602CE2C0E88A59E06D3DC10993280D11C6E8938817852659BB2F60FB21CF3469AD27250D7CEBF50567FFBEEA69BB6650733CBB4C11441C6EDBA715E11134D7AA4C91B303EA2B2C600DDCF04590DE4023B6584D5F02EB0C6F155A776816D19EE62EE2AF50D2613D499A67A8651205FCF7177D1BAC5B080277C78AA372440C67D98780A20847C98D8A8E3277D98B8EBF0404AC2143D1F5E4D30EAFFC9F584E476BFB9791F2509C9E463BE4D1FF65BF7CDA0FFCBCAD8CEAFBF8CD2F360A324DDD0E475EDF9AA35CEF505E8F673B28AA37771426E009ECD7B4CD5E95D550C99C1D771567E745754391D3BBE6F8D638D2102A6A7CBFD86925A4405B94FB3C7D2EBA0BC68CE7D969F0DF31999D36121D1E8891BBE7849D388BEAFE360A53024DDCA17728DBE0EC902B5A480FD3939DE6E788E5E8C03310CBE40823F00962CEB16443A35744E269D9D9ED06354F7C9DCD073FA849EC341CFE9D4E8F9BC261B9AB0549EFB339918FF5D2661DE2B95BCA592DE1A160889127DBD4101E2D5B17B86B3C8145EDD667898DAA5BB65A033A8858FF405DAD6C4C4EFE60559A169EE754F0194695F9A981234737861C2083CB338D61700143E94DC94A09932B49CA95D7FDA10735769511362FD686FD4ADF1D5DD4AC7219833169FB23CA32A38463DCC1772753092B4D81F2BDE41F7969629FD1FB6052D41B2F644335D91777196176FA222BA8DF8E7029B52D7A4E80E21C1780B7536E69C10CC77BD2C3703AF8E56B7294550749BC8490A88E41969B10CD4DD26C1D5B5A9C81A6A3F18692D75B2AAA63A87A6B6CE8347A8A84B81EAE812758DD9EDE81C47562AB10959C04609B934357727CF42855D0A544F97A821CF2A55421D6C3254119B43535BAFF30B35F549502D7DAA5E5CCD5A0FC9AB499208AC493590586DE8504AADCEA2935C9D4B0742B836790D28AAD0D51CA10E2813542394CFA87E6DDD987A8DFAB076ED52F6619D45D787752EA3D6F237EE346DE7B3EB25C197D08F4F353F180E0CEB545CB71687B03C2F38A6E5D9F14CA9D9D056ACADAAB78D09F5F44950257DAAA68605BC602DA48BD402B330B52F070B74DB0488729B86A22DBE332DA94BCC28AF5BCCABE1A58FB826D4DE2741F5F5A946ADD5B612D33A34EA869102A5F81B66522171984F3F0F766FDC43B35E972899E3BA74743D98B9569255CD83E1D4D20A4BA217B3C92A69A3F4E236B346CF83B3A96A37D2FB846783A40C7439547577998C165BC5442BCBA85F60D193B0EA5D239D34B4EB8D2A3F729B2619146CB26A9B8602FFD93D799FA5FB1D54539704D6D2A5EA6AA85DF644F2F57790769DA421DCB9800AA4BB14887897A8213FF011142A18A441550C9275FA9D70AA2F6A78421650C71372216B56D4A8AE493FC098C367714831C9E0206272E8144499CD4E5416653941C551961939BB28EC136216D54C22B54F0CCC63B0ADE7A62F3AC80B587D6E641648D089BE6BB1DC0405961C2EB34C6970F93C669B87687A7BF55034EC88AD97E65534436278AA9BA231263194380B59454066FE3217436BA0E98F6880F68B99E4ECF2869C8A5F99914672DA3C28293520993795B9D2DED3159B0B67F4C4B8E2CC74505AA9A599371D7874A69E2DC5C6CBB22AA03E98B86B7803133153426EBAAACA238C51AE22900464D6CA0313C8999BCE140707CDBC86380750884F213AFF62530D1B59D63106CE84226087A6560C2A0F02D799608E22A9B7134662812EBE2A1F15918807DAC94C2622F9039ABCDD419415BAAC7268015693768029EC1EEC62AEB3F1D6AB3BDA5CEB2446FC9CAD2F1476C2068C06BCE03C8B4A354F83F9C698A4C3375B37374BF38E39314F2B06C41C33CD641C462CE591887234B019C61806C3639CAA14784C63DEB476CB5FBF8400348DCDE0C820E876C594929A541D9AA6EA3931D318BD17ACA9AA0DB898698C0DF8D84D658FBA6EFA332FB1C1B2AC72E6F963B88A79D9B11A53123EC6ABCA6B0EE79C45D01EAB6A05000752151A01303F9BA68B878DCC53F20AD44B4A785D5AC081201EB2324342716CEA453CAA01A2CA3EC620998948E403469ED9F7A0998928FA8919250CD9FD28DBF97F72914822AEE35715B1C8F8AB0BEF12034CB55207172B334DE3EB6064EF5497096EEBE4FC4D5A738DCC93C4494C1AFBA6906D24DB66C82623EC9960D6916D9953894061BF94660F64BB0C2812639325B6E8D8164B9DDF182734EFF64AA91C861D6520BE41318FD89895C824ABB25A60FA4263896BCA055DD26AEC36922F30EE7632AC683A13897E8B30F6C6606C5311F35CB2A29DF2679519B60D1C4CC0E60A9E3A4A4757C76663763D6CC631F73BA19A2E8DC6A01283BCD098AA9BCA71991191671717B0D518B4C005C6444D68D148C2A9F347DEBA337B59C111CEDB155440F1237DBBBD894E706847CB8E2FA9470BE77BCF0045E2503F1BF1717CA2C6A33A12BBE7A168215C7731C8E287EB85828A3C3E8A295C7EFD019299DF335C85101003D1A0F4F883710EE204E33D6B3C04461D8CC11D2414118D8DBCB1C20CC1E99DB04CA2F56A97C2C9ED43DA7BDCC09A1856A4A69A994108DBD1F5B3B988148AAC8A73779F547C619CE1E178A19AAB10E3DC05903DCB21EC3AC76ABA6E3B6D104AD3F3567A4AD1A0CE440C82448E742A12EA020D18C510D215B4D10E3D63847B66E8BA71F602DF10B2BF24D751145BAC0CE167CBAAAD7DD2A289600C3ADD0DC8F18CAAA1AE3FC271D614ED560464031B208C6BD57D739002EAEEA84BD3657EB38A10630CA3E67EB3C19AA618B0EA785A5E46ECE8CD64E241416D94078C6218E5DE06A8F8945CFC671B387CACA06E1DF8168179D3F8984740E39461916CD864CA08EF1954E5E44F15585C3946C6F6812E22DB8405627791929714EA7DA4E6750425A53A0C90013507D101616A14D2D205B5195940208531857162248C93EF5B18A746C238FDBE84C13E0DA290832AAAC4D0C609BC5552DB39156F904CD4748565571315C2935977ECA6F24F9EA02E0B69821FF01647C74B43A022A47DAAC58328B03E028827FE47F20F984C34987B569A87EB7925D9F1BE552851A05F5B870C1B562FB5FB6B2E2B72F5234E750F205F64928BF1E5714DAE7B3BBC4B7B795C3FC1D47CA03F8B348BEEC979BA22495E7D7D79FC694F4B6F48FDEB0DC9E3FB9EC44B4A734B7751F1E0ADF22ECF87ED5DDA3E9FCE71D4666993BB4D4311ADA2223ACB8AF82E5A163479599E1C9613F4EF51B2A759DE6E6EC9EAC3F6725FECF6056D32D9DC268C90CBA7D755F5BF3C16787E79B92B7FE53E9A40D98C6913C8E5F6F53E4E561DDFEFA284770F949128DF747F4FE8F7BA2F8BAC54451E3B4A17E91649A8115FF714FD67B2D92594587EB9BD8E1E880D6F5F72F291DC47CBC76A6258914C4E44DF11ACD85FBE89A3FB2CDAE40D8DBE3CFD4931BCDA7CFBD7FF0FFA11E36C89790400, N'6.1.3-40302')
SET IDENTITY_INSERT [dbo].[AcademicQualification] ON 

INSERT [dbo].[AcademicQualification] ([AcademicQualificationId], [Name], [Description]) VALUES (1, N'Matric', N'Matric')
INSERT [dbo].[AcademicQualification] ([AcademicQualificationId], [Name], [Description]) VALUES (2, N'Inter', NULL)
INSERT [dbo].[AcademicQualification] ([AcademicQualificationId], [Name], [Description]) VALUES (3, N'Graduation', NULL)
INSERT [dbo].[AcademicQualification] ([AcademicQualificationId], [Name], [Description]) VALUES (4, N'Master', NULL)
INSERT [dbo].[AcademicQualification] ([AcademicQualificationId], [Name], [Description]) VALUES (5, N'MS', NULL)
INSERT [dbo].[AcademicQualification] ([AcademicQualificationId], [Name], [Description]) VALUES (6, N'PhD', NULL)
INSERT [dbo].[AcademicQualification] ([AcademicQualificationId], [Name], [Description]) VALUES (7, N'Professional (Dr) ', NULL)
INSERT [dbo].[AcademicQualification] ([AcademicQualificationId], [Name], [Description]) VALUES (8, N'Professional (Engineer)', NULL)
INSERT [dbo].[AcademicQualification] ([AcademicQualificationId], [Name], [Description]) VALUES (9, N'None', NULL)
SET IDENTITY_INSERT [dbo].[AcademicQualification] OFF
SET IDENTITY_INSERT [dbo].[Activity] ON 

INSERT [dbo].[Activity] ([ActivityId], [Name], [Description], [ProjectId], [ActivityTypeId], [DateOfActivity], [CityId]) VALUES (1, N'Event 1', NULL, 1, 1, CAST(N'2015-09-19 19:00:00.000' AS DateTime), 1)
INSERT [dbo].[Activity] ([ActivityId], [Name], [Description], [ProjectId], [ActivityTypeId], [DateOfActivity], [CityId]) VALUES (2, N'Workshop 1', NULL, 1, 2, CAST(N'2015-09-08 19:00:00.000' AS DateTime), 2)
INSERT [dbo].[Activity] ([ActivityId], [Name], [Description], [ProjectId], [ActivityTypeId], [DateOfActivity], [CityId]) VALUES (3, N'Workshop 2', NULL, 2, 2, CAST(N'2015-08-30 00:00:00.000' AS DateTime), 1)
INSERT [dbo].[Activity] ([ActivityId], [Name], [Description], [ProjectId], [ActivityTypeId], [DateOfActivity], [CityId]) VALUES (4, N'Event 2', N'Event 1 Description', 1, 1, CAST(N'2015-09-20 16:51:32.790' AS DateTime), 67)
SET IDENTITY_INSERT [dbo].[Activity] OFF
SET IDENTITY_INSERT [dbo].[ActivityCost] ON 

INSERT [dbo].[ActivityCost] ([ActivityCostId], [ActivityId], [FundingId], [Cost], [Description]) VALUES (1, 2, 2, 2000, N'Venue')
INSERT [dbo].[ActivityCost] ([ActivityCostId], [ActivityId], [FundingId], [Cost], [Description]) VALUES (2, 2, 3, 1000, N'Refreshment')
SET IDENTITY_INSERT [dbo].[ActivityCost] OFF
SET IDENTITY_INSERT [dbo].[ActivityType] ON 

INSERT [dbo].[ActivityType] ([ActivityTypeId], [Name], [Description]) VALUES (1, N'Event', N'Event')
INSERT [dbo].[ActivityType] ([ActivityTypeId], [Name], [Description]) VALUES (2, N'Workshop', NULL)
SET IDENTITY_INSERT [dbo].[ActivityType] OFF
SET IDENTITY_INSERT [dbo].[AgeGroup] ON 

INSERT [dbo].[AgeGroup] ([AgeGroupId], [Name], [Description], [StartAge], [EndAge]) VALUES (1, N'Under 20 Years', N'Under 20 Years', 0, 19)
INSERT [dbo].[AgeGroup] ([AgeGroupId], [Name], [Description], [StartAge], [EndAge]) VALUES (2, N'20 - 29 Years', N'Between 20 and 29 Years', 20, 29)
INSERT [dbo].[AgeGroup] ([AgeGroupId], [Name], [Description], [StartAge], [EndAge]) VALUES (3, N'30 - 39 Years', N'Between 30 and 39 Years', 30, 39)
INSERT [dbo].[AgeGroup] ([AgeGroupId], [Name], [Description], [StartAge], [EndAge]) VALUES (4, N'40 - 49 Years', N'Between 40 and 49 Years', 40, 49)
INSERT [dbo].[AgeGroup] ([AgeGroupId], [Name], [Description], [StartAge], [EndAge]) VALUES (5, N'50 - 59 Years', N'Between 50 and 59 Years', 50, 59)
INSERT [dbo].[AgeGroup] ([AgeGroupId], [Name], [Description], [StartAge], [EndAge]) VALUES (6, N'Above 50 Years', N'Above 60 Years', 60, 100)
SET IDENTITY_INSERT [dbo].[AgeGroup] OFF
SET IDENTITY_INSERT [dbo].[Album] ON 

INSERT [dbo].[Album] ([AlbumId], [Name], [Description], [DateCreated], [DateModified], [AccessType], [RelativeUrl], [AlbumType], [GalleryId]) VALUES (1, N'Resource Person Photos', NULL, CAST(N'2015-07-23 02:43:59.293' AS DateTime), CAST(N'2015-07-23 02:43:59.293' AS DateTime), 0, N'Photos/', 6, 7)
INSERT [dbo].[Album] ([AlbumId], [Name], [Description], [DateCreated], [DateModified], [AccessType], [RelativeUrl], [AlbumType], [GalleryId]) VALUES (2, N'Logos of Donors & Collaborating Agencies', NULL, CAST(N'2015-07-21 22:21:44.433' AS DateTime), CAST(N'2015-07-21 22:21:44.433' AS DateTime), 0, N'Logos/', 6, 8)
INSERT [dbo].[Album] ([AlbumId], [Name], [Description], [DateCreated], [DateModified], [AccessType], [RelativeUrl], [AlbumType], [GalleryId]) VALUES (3, N'General 3', NULL, CAST(N'2015-08-30 14:29:18.023' AS DateTime), CAST(N'2015-08-30 14:29:18.023' AS DateTime), 0, N'3/', 5, 6)
INSERT [dbo].[Album] ([AlbumId], [Name], [Description], [DateCreated], [DateModified], [AccessType], [RelativeUrl], [AlbumType], [GalleryId]) VALUES (5, N'General Album 5', N'Description', CAST(N'2015-08-30 14:28:32.143' AS DateTime), CAST(N'2015-08-30 14:28:32.143' AS DateTime), 0, N'5/', 5, 6)
INSERT [dbo].[Album] ([AlbumId], [Name], [Description], [DateCreated], [DateModified], [AccessType], [RelativeUrl], [AlbumType], [GalleryId]) VALUES (6, N'Earthquake Preparedness Album', N'Earthquake Preparedness Album', CAST(N'2015-08-30 17:42:13.380' AS DateTime), CAST(N'2015-08-30 17:42:13.380' AS DateTime), 0, N'5/', 0, 1)
INSERT [dbo].[Album] ([AlbumId], [Name], [Description], [DateCreated], [DateModified], [AccessType], [RelativeUrl], [AlbumType], [GalleryId]) VALUES (7, N'USAID Project 2', NULL, CAST(N'2015-08-30 17:34:21.453' AS DateTime), CAST(N'2015-08-30 17:34:21.453' AS DateTime), 0, N'2/', 1, 2)
INSERT [dbo].[Album] ([AlbumId], [Name], [Description], [DateCreated], [DateModified], [AccessType], [RelativeUrl], [AlbumType], [GalleryId]) VALUES (8, N'DFID Project 1 Album', N'DFID Project 1 Album', CAST(N'2015-08-30 19:37:52.700' AS DateTime), CAST(N'2015-08-30 19:37:52.700' AS DateTime), 0, N'1/', 1, 2)
INSERT [dbo].[Album] ([AlbumId], [Name], [Description], [DateCreated], [DateModified], [AccessType], [RelativeUrl], [AlbumType], [GalleryId]) VALUES (9, N'Event 2', N'Event 2 Album', CAST(N'2015-08-30 19:42:37.630' AS DateTime), CAST(N'2015-08-30 19:42:37.630' AS DateTime), 0, N'9/', 2, 3)
INSERT [dbo].[Album] ([AlbumId], [Name], [Description], [DateCreated], [DateModified], [AccessType], [RelativeUrl], [AlbumType], [GalleryId]) VALUES (10, N'TNA Workshop', NULL, CAST(N'2015-08-30 19:43:14.523' AS DateTime), CAST(N'2015-08-30 19:43:14.523' AS DateTime), 0, N'1/', 4, 5)
INSERT [dbo].[Album] ([AlbumId], [Name], [Description], [DateCreated], [DateModified], [AccessType], [RelativeUrl], [AlbumType], [GalleryId]) VALUES (11, N'General 10', NULL, CAST(N'2015-09-20 20:05:11.270' AS DateTime), CAST(N'2015-09-20 20:05:11.270' AS DateTime), 1, N'11/', 5, 6)
INSERT [dbo].[Album] ([AlbumId], [Name], [Description], [DateCreated], [DateModified], [AccessType], [RelativeUrl], [AlbumType], [GalleryId]) VALUES (12, N'Drought Preparedness 4W Training', N'Drought Preparedness 4W Training', CAST(N'2015-09-12 21:26:08.133' AS DateTime), CAST(N'2015-09-12 21:26:08.133' AS DateTime), 0, N'1/', 3, 4)
INSERT [dbo].[Album] ([AlbumId], [Name], [Description], [DateCreated], [DateModified], [AccessType], [RelativeUrl], [AlbumType], [GalleryId]) VALUES (13, N'Event 1', N'Event 1 Album', CAST(N'2015-09-20 17:35:40.640' AS DateTime), CAST(N'2015-09-20 17:35:40.640' AS DateTime), 0, N'4/', 2, 3)
SET IDENTITY_INSERT [dbo].[Album] OFF
SET IDENTITY_INSERT [dbo].[ApprovedActivity] ON 

INSERT [dbo].[ApprovedActivity] ([ApprovedActivityId], [Name], [Description]) VALUES (1, N'Venue Charges', NULL)
INSERT [dbo].[ApprovedActivity] ([ApprovedActivityId], [Name], [Description]) VALUES (2, N'Refreshment', NULL)
INSERT [dbo].[ApprovedActivity] ([ApprovedActivityId], [Name], [Description]) VALUES (3, N'Honorarium', N'Honorarium')
INSERT [dbo].[ApprovedActivity] ([ApprovedActivityId], [Name], [Description]) VALUES (4, N'Stationery & Printing', NULL)
INSERT [dbo].[ApprovedActivity] ([ApprovedActivityId], [Name], [Description]) VALUES (5, N'Travelling & Boarding/Lodging', NULL)
INSERT [dbo].[ApprovedActivity] ([ApprovedActivityId], [Name], [Description]) VALUES (6, N'Misc', NULL)
SET IDENTITY_INSERT [dbo].[ApprovedActivity] OFF
SET IDENTITY_INSERT [dbo].[Area] ON 

INSERT [dbo].[Area] ([AreaId], [Name], [Description]) VALUES (1, N'Mitigation', N'Mitigation')
INSERT [dbo].[Area] ([AreaId], [Name], [Description]) VALUES (2, N'Preparedness', NULL)
INSERT [dbo].[Area] ([AreaId], [Name], [Description]) VALUES (3, N'Response', NULL)
INSERT [dbo].[Area] ([AreaId], [Name], [Description]) VALUES (4, N'Recovery', NULL)
INSERT [dbo].[Area] ([AreaId], [Name], [Description]) VALUES (5, N'Other', NULL)
SET IDENTITY_INSERT [dbo].[Area] OFF
INSERT [dbo].[AspNetUsers] ([Id], [Email], [EmailConfirmed], [PasswordHash], [SecurityStamp], [PhoneNumber], [PhoneNumberConfirmed], [TwoFactorEnabled], [LockoutEndDateUtc], [LockoutEnabled], [AccessFailedCount], [UserName]) VALUES (N'7cbefc0f-8007-4798-972d-7b98417cacb6', N'admin@nidm.gov.pk', 0, N'ANlLTjqIzV3uFpxFnxWh+AkwPW6+BE+tIVmNMP8Wp0CT10yVtTGCMquCGPidYNVz9g==', N'431ee130-d72d-43ba-bd19-49fa7f54fcbe', NULL, 0, 0, NULL, 1, 0, N'admin@nidm.gov.pk')
SET IDENTITY_INSERT [dbo].[City] ON 

INSERT [dbo].[City] ([CityId], [Name], [DistrictId]) VALUES (1, N'Bagh', 1)
INSERT [dbo].[City] ([CityId], [Name], [DistrictId]) VALUES (2, N'Bhimber', 2)
INSERT [dbo].[City] ([CityId], [Name], [DistrictId]) VALUES (3, N'Hattian', 3)
INSERT [dbo].[City] ([CityId], [Name], [DistrictId]) VALUES (4, N'Haveli', 4)
INSERT [dbo].[City] ([CityId], [Name], [DistrictId]) VALUES (5, N'Kotli', 5)
INSERT [dbo].[City] ([CityId], [Name], [DistrictId]) VALUES (6, N'Mirpur', 6)
INSERT [dbo].[City] ([CityId], [Name], [DistrictId]) VALUES (7, N'Muzaffarabad', 7)
INSERT [dbo].[City] ([CityId], [Name], [DistrictId]) VALUES (8, N'Neelum', 8)
INSERT [dbo].[City] ([CityId], [Name], [DistrictId]) VALUES (9, N'Poonch', 9)
INSERT [dbo].[City] ([CityId], [Name], [DistrictId]) VALUES (10, N'Sudhnoti', 10)
INSERT [dbo].[City] ([CityId], [Name], [DistrictId]) VALUES (11, N'Awaran', 11)
INSERT [dbo].[City] ([CityId], [Name], [DistrictId]) VALUES (12, N'Barkhan', 12)
INSERT [dbo].[City] ([CityId], [Name], [DistrictId]) VALUES (13, N'Chagai', 13)
INSERT [dbo].[City] ([CityId], [Name], [DistrictId]) VALUES (14, N'Dera Bugti', 14)
INSERT [dbo].[City] ([CityId], [Name], [DistrictId]) VALUES (15, N'Gwadar', 15)
INSERT [dbo].[City] ([CityId], [Name], [DistrictId]) VALUES (16, N'Harnai', 16)
INSERT [dbo].[City] ([CityId], [Name], [DistrictId]) VALUES (17, N'Jaffarabad', 17)
INSERT [dbo].[City] ([CityId], [Name], [DistrictId]) VALUES (18, N'Jhal Magsi', 18)
INSERT [dbo].[City] ([CityId], [Name], [DistrictId]) VALUES (19, N'Kachhi', 19)
INSERT [dbo].[City] ([CityId], [Name], [DistrictId]) VALUES (20, N'Kalat', 20)
INSERT [dbo].[City] ([CityId], [Name], [DistrictId]) VALUES (21, N'Kech', 21)
INSERT [dbo].[City] ([CityId], [Name], [DistrictId]) VALUES (22, N'Kharan', 22)
INSERT [dbo].[City] ([CityId], [Name], [DistrictId]) VALUES (23, N'Khuzdar', 23)
INSERT [dbo].[City] ([CityId], [Name], [DistrictId]) VALUES (24, N'Killa Abdullah', 24)
INSERT [dbo].[City] ([CityId], [Name], [DistrictId]) VALUES (25, N'Killa Saifullah', 25)
INSERT [dbo].[City] ([CityId], [Name], [DistrictId]) VALUES (26, N'Kohlu', 26)
INSERT [dbo].[City] ([CityId], [Name], [DistrictId]) VALUES (27, N'Las Bela', 27)
INSERT [dbo].[City] ([CityId], [Name], [DistrictId]) VALUES (28, N'Loralai', 28)
INSERT [dbo].[City] ([CityId], [Name], [DistrictId]) VALUES (29, N'Mastung', 29)
INSERT [dbo].[City] ([CityId], [Name], [DistrictId]) VALUES (30, N'Musakhel', 30)
INSERT [dbo].[City] ([CityId], [Name], [DistrictId]) VALUES (31, N'Nasirabad', 31)
INSERT [dbo].[City] ([CityId], [Name], [DistrictId]) VALUES (32, N'Nushki', 32)
INSERT [dbo].[City] ([CityId], [Name], [DistrictId]) VALUES (33, N'Panjgur', 33)
INSERT [dbo].[City] ([CityId], [Name], [DistrictId]) VALUES (34, N'Panjpai', 34)
INSERT [dbo].[City] ([CityId], [Name], [DistrictId]) VALUES (35, N'Pishin', 35)
INSERT [dbo].[City] ([CityId], [Name], [DistrictId]) VALUES (36, N'Quetta', 36)
INSERT [dbo].[City] ([CityId], [Name], [DistrictId]) VALUES (37, N'Sheerani', 37)
INSERT [dbo].[City] ([CityId], [Name], [DistrictId]) VALUES (38, N'Sibi', 38)
INSERT [dbo].[City] ([CityId], [Name], [DistrictId]) VALUES (39, N'Washuk', 39)
INSERT [dbo].[City] ([CityId], [Name], [DistrictId]) VALUES (40, N'Zhob', 40)
INSERT [dbo].[City] ([CityId], [Name], [DistrictId]) VALUES (41, N'Ziarat', 41)
INSERT [dbo].[City] ([CityId], [Name], [DistrictId]) VALUES (42, N'Bajaur Agency', 42)
INSERT [dbo].[City] ([CityId], [Name], [DistrictId]) VALUES (43, N'FR Bannu', 43)
INSERT [dbo].[City] ([CityId], [Name], [DistrictId]) VALUES (44, N'FR D.I. Khan', 44)
INSERT [dbo].[City] ([CityId], [Name], [DistrictId]) VALUES (45, N'FR Kohat', 45)
INSERT [dbo].[City] ([CityId], [Name], [DistrictId]) VALUES (46, N'FR Lakki Marwat', 46)
INSERT [dbo].[City] ([CityId], [Name], [DistrictId]) VALUES (47, N'FR Peshawar', 47)
INSERT [dbo].[City] ([CityId], [Name], [DistrictId]) VALUES (48, N'FR Tank', 48)
INSERT [dbo].[City] ([CityId], [Name], [DistrictId]) VALUES (49, N'Khyber Agency', 49)
INSERT [dbo].[City] ([CityId], [Name], [DistrictId]) VALUES (50, N'Kurram Agency', 50)
INSERT [dbo].[City] ([CityId], [Name], [DistrictId]) VALUES (51, N'Mohmand Agency', 51)
INSERT [dbo].[City] ([CityId], [Name], [DistrictId]) VALUES (52, N'North Waziristan Agency', 52)
INSERT [dbo].[City] ([CityId], [Name], [DistrictId]) VALUES (53, N'Orakzai Agency', 53)
INSERT [dbo].[City] ([CityId], [Name], [DistrictId]) VALUES (54, N'South Waziristan Agency', 54)
INSERT [dbo].[City] ([CityId], [Name], [DistrictId]) VALUES (55, N'Islamabad', 55)
INSERT [dbo].[City] ([CityId], [Name], [DistrictId]) VALUES (56, N'Astore', 56)
INSERT [dbo].[City] ([CityId], [Name], [DistrictId]) VALUES (57, N'Diamir', 57)
INSERT [dbo].[City] ([CityId], [Name], [DistrictId]) VALUES (58, N'Ghanche', 58)
INSERT [dbo].[City] ([CityId], [Name], [DistrictId]) VALUES (59, N'Ghizer', 59)
INSERT [dbo].[City] ([CityId], [Name], [DistrictId]) VALUES (60, N'Gilgit', 60)
INSERT [dbo].[City] ([CityId], [Name], [DistrictId]) VALUES (61, N'Hunza Nagar', 61)
INSERT [dbo].[City] ([CityId], [Name], [DistrictId]) VALUES (62, N'Skardu', 62)
INSERT [dbo].[City] ([CityId], [Name], [DistrictId]) VALUES (63, N'Abbottabad', 63)
INSERT [dbo].[City] ([CityId], [Name], [DistrictId]) VALUES (64, N'Bannu', 64)
INSERT [dbo].[City] ([CityId], [Name], [DistrictId]) VALUES (65, N'Batagram', 65)
INSERT [dbo].[City] ([CityId], [Name], [DistrictId]) VALUES (66, N'Buner', 66)
INSERT [dbo].[City] ([CityId], [Name], [DistrictId]) VALUES (67, N'Charsadda', 67)
INSERT [dbo].[City] ([CityId], [Name], [DistrictId]) VALUES (68, N'Chitral', 68)
INSERT [dbo].[City] ([CityId], [Name], [DistrictId]) VALUES (69, N'Dera Ismail Khan', 69)
INSERT [dbo].[City] ([CityId], [Name], [DistrictId]) VALUES (70, N'Hangu', 70)
INSERT [dbo].[City] ([CityId], [Name], [DistrictId]) VALUES (71, N'Haripur', 71)
INSERT [dbo].[City] ([CityId], [Name], [DistrictId]) VALUES (72, N'Karak', 72)
INSERT [dbo].[City] ([CityId], [Name], [DistrictId]) VALUES (73, N'Kohat', 73)
INSERT [dbo].[City] ([CityId], [Name], [DistrictId]) VALUES (74, N'Kohistan', 74)
INSERT [dbo].[City] ([CityId], [Name], [DistrictId]) VALUES (75, N'Lakki Marwat', 75)
INSERT [dbo].[City] ([CityId], [Name], [DistrictId]) VALUES (76, N'Lower Dir', 76)
INSERT [dbo].[City] ([CityId], [Name], [DistrictId]) VALUES (77, N'Malakand P.a.', 77)
INSERT [dbo].[City] ([CityId], [Name], [DistrictId]) VALUES (78, N'Mansehra', 78)
INSERT [dbo].[City] ([CityId], [Name], [DistrictId]) VALUES (79, N'Mardan', 79)
INSERT [dbo].[City] ([CityId], [Name], [DistrictId]) VALUES (80, N'Nowshera', 80)
INSERT [dbo].[City] ([CityId], [Name], [DistrictId]) VALUES (81, N'Peshawar', 81)
INSERT [dbo].[City] ([CityId], [Name], [DistrictId]) VALUES (82, N'Shangla', 82)
INSERT [dbo].[City] ([CityId], [Name], [DistrictId]) VALUES (83, N'Swabi', 83)
INSERT [dbo].[City] ([CityId], [Name], [DistrictId]) VALUES (84, N'Swat', 84)
INSERT [dbo].[City] ([CityId], [Name], [DistrictId]) VALUES (85, N'Tank', 85)
INSERT [dbo].[City] ([CityId], [Name], [DistrictId]) VALUES (86, N'Upper Dir', 86)
INSERT [dbo].[City] ([CityId], [Name], [DistrictId]) VALUES (87, N'Attock', 87)
INSERT [dbo].[City] ([CityId], [Name], [DistrictId]) VALUES (88, N'Bahawalnagar', 88)
INSERT [dbo].[City] ([CityId], [Name], [DistrictId]) VALUES (89, N'Bahawalpur', 89)
INSERT [dbo].[City] ([CityId], [Name], [DistrictId]) VALUES (90, N'Bhakkar', 90)
INSERT [dbo].[City] ([CityId], [Name], [DistrictId]) VALUES (91, N'Chakwal', 91)
INSERT [dbo].[City] ([CityId], [Name], [DistrictId]) VALUES (92, N'Chiniot', 92)
INSERT [dbo].[City] ([CityId], [Name], [DistrictId]) VALUES (93, N'Dera Ghazi Khan', 93)
INSERT [dbo].[City] ([CityId], [Name], [DistrictId]) VALUES (94, N'Faisalabad', 94)
INSERT [dbo].[City] ([CityId], [Name], [DistrictId]) VALUES (95, N'Gujranwala', 95)
INSERT [dbo].[City] ([CityId], [Name], [DistrictId]) VALUES (96, N'Gujrat', 96)
INSERT [dbo].[City] ([CityId], [Name], [DistrictId]) VALUES (97, N'Hafizabad', 97)
INSERT [dbo].[City] ([CityId], [Name], [DistrictId]) VALUES (98, N'Jhang', 98)
INSERT [dbo].[City] ([CityId], [Name], [DistrictId]) VALUES (99, N'Jhelum', 99)
GO
INSERT [dbo].[City] ([CityId], [Name], [DistrictId]) VALUES (100, N'Kasur', 100)
INSERT [dbo].[City] ([CityId], [Name], [DistrictId]) VALUES (101, N'Khanewal', 101)
INSERT [dbo].[City] ([CityId], [Name], [DistrictId]) VALUES (102, N'Khushab', 102)
INSERT [dbo].[City] ([CityId], [Name], [DistrictId]) VALUES (103, N'Lahore', 103)
INSERT [dbo].[City] ([CityId], [Name], [DistrictId]) VALUES (104, N'Layyah', 104)
INSERT [dbo].[City] ([CityId], [Name], [DistrictId]) VALUES (105, N'Lodhran', 105)
INSERT [dbo].[City] ([CityId], [Name], [DistrictId]) VALUES (106, N'Mandi Bahauddin', 106)
INSERT [dbo].[City] ([CityId], [Name], [DistrictId]) VALUES (107, N'Mianwali', 107)
INSERT [dbo].[City] ([CityId], [Name], [DistrictId]) VALUES (108, N'Multan', 108)
INSERT [dbo].[City] ([CityId], [Name], [DistrictId]) VALUES (109, N'Muzaffargarh', 109)
INSERT [dbo].[City] ([CityId], [Name], [DistrictId]) VALUES (110, N'Nankana Sahib', 110)
INSERT [dbo].[City] ([CityId], [Name], [DistrictId]) VALUES (111, N'Narowal', 111)
INSERT [dbo].[City] ([CityId], [Name], [DistrictId]) VALUES (112, N'Okara', 112)
INSERT [dbo].[City] ([CityId], [Name], [DistrictId]) VALUES (113, N'Pakpattan', 113)
INSERT [dbo].[City] ([CityId], [Name], [DistrictId]) VALUES (114, N'Rahim Yar Khan', 114)
INSERT [dbo].[City] ([CityId], [Name], [DistrictId]) VALUES (115, N'Rajanpur', 115)
INSERT [dbo].[City] ([CityId], [Name], [DistrictId]) VALUES (116, N'Rawalpindi', 116)
INSERT [dbo].[City] ([CityId], [Name], [DistrictId]) VALUES (117, N'Sahiwal', 117)
INSERT [dbo].[City] ([CityId], [Name], [DistrictId]) VALUES (118, N'Sargodha', 118)
INSERT [dbo].[City] ([CityId], [Name], [DistrictId]) VALUES (119, N'Sheikhupura', 119)
INSERT [dbo].[City] ([CityId], [Name], [DistrictId]) VALUES (120, N'Sialkot', 120)
INSERT [dbo].[City] ([CityId], [Name], [DistrictId]) VALUES (121, N'Toba Tek Singh', 121)
INSERT [dbo].[City] ([CityId], [Name], [DistrictId]) VALUES (122, N'Vehari', 122)
INSERT [dbo].[City] ([CityId], [Name], [DistrictId]) VALUES (123, N'Badin', 123)
INSERT [dbo].[City] ([CityId], [Name], [DistrictId]) VALUES (124, N'Dadu', 124)
INSERT [dbo].[City] ([CityId], [Name], [DistrictId]) VALUES (125, N'Ghotki', 125)
INSERT [dbo].[City] ([CityId], [Name], [DistrictId]) VALUES (126, N'Hyderabad', 126)
INSERT [dbo].[City] ([CityId], [Name], [DistrictId]) VALUES (127, N'Jacobabad', 127)
INSERT [dbo].[City] ([CityId], [Name], [DistrictId]) VALUES (128, N'Jamshoro', 128)
INSERT [dbo].[City] ([CityId], [Name], [DistrictId]) VALUES (129, N'Karachi City', 129)
INSERT [dbo].[City] ([CityId], [Name], [DistrictId]) VALUES (130, N'Kashmore', 130)
INSERT [dbo].[City] ([CityId], [Name], [DistrictId]) VALUES (131, N'Khairpur', 131)
INSERT [dbo].[City] ([CityId], [Name], [DistrictId]) VALUES (132, N'Larkana', 132)
INSERT [dbo].[City] ([CityId], [Name], [DistrictId]) VALUES (133, N'Matiari', 133)
INSERT [dbo].[City] ([CityId], [Name], [DistrictId]) VALUES (134, N'Mirpur Khas', 134)
INSERT [dbo].[City] ([CityId], [Name], [DistrictId]) VALUES (135, N'Naushahro Feroze', 135)
INSERT [dbo].[City] ([CityId], [Name], [DistrictId]) VALUES (136, N'Qambar Shahdadkot', 136)
INSERT [dbo].[City] ([CityId], [Name], [DistrictId]) VALUES (137, N'Sanghar', 137)
INSERT [dbo].[City] ([CityId], [Name], [DistrictId]) VALUES (138, N'Shaheed Benazirabad', 138)
INSERT [dbo].[City] ([CityId], [Name], [DistrictId]) VALUES (139, N'Shikarpur', 139)
INSERT [dbo].[City] ([CityId], [Name], [DistrictId]) VALUES (140, N'Sukkur', 140)
INSERT [dbo].[City] ([CityId], [Name], [DistrictId]) VALUES (141, N'Tando Allah Yar', 141)
INSERT [dbo].[City] ([CityId], [Name], [DistrictId]) VALUES (142, N'Tando Muhammad Khan', 142)
INSERT [dbo].[City] ([CityId], [Name], [DistrictId]) VALUES (143, N'Tharparkar', 143)
INSERT [dbo].[City] ([CityId], [Name], [DistrictId]) VALUES (144, N'Thatta', 144)
INSERT [dbo].[City] ([CityId], [Name], [DistrictId]) VALUES (145, N'Umerkot', 145)
SET IDENTITY_INSERT [dbo].[City] OFF
SET IDENTITY_INSERT [dbo].[DisabilityType] ON 

INSERT [dbo].[DisabilityType] ([DisabilityTypeId], [Name], [Description]) VALUES (1, N'Vision', N'Vision')
INSERT [dbo].[DisabilityType] ([DisabilityTypeId], [Name], [Description]) VALUES (2, N'Hearing', NULL)
INSERT [dbo].[DisabilityType] ([DisabilityTypeId], [Name], [Description]) VALUES (3, N'Speech', NULL)
INSERT [dbo].[DisabilityType] ([DisabilityTypeId], [Name], [Description]) VALUES (4, N'Physical', NULL)
INSERT [dbo].[DisabilityType] ([DisabilityTypeId], [Name], [Description]) VALUES (5, N'Mental', NULL)
INSERT [dbo].[DisabilityType] ([DisabilityTypeId], [Name], [Description]) VALUES (6, N'Other', NULL)
SET IDENTITY_INSERT [dbo].[DisabilityType] OFF
SET IDENTITY_INSERT [dbo].[District] ON 

INSERT [dbo].[District] ([DistrictId], [Name], [ProvinceId]) VALUES (1, N'Bagh', 1)
INSERT [dbo].[District] ([DistrictId], [Name], [ProvinceId]) VALUES (2, N'Bhimber', 1)
INSERT [dbo].[District] ([DistrictId], [Name], [ProvinceId]) VALUES (3, N'Hattian', 1)
INSERT [dbo].[District] ([DistrictId], [Name], [ProvinceId]) VALUES (4, N'Haveli', 1)
INSERT [dbo].[District] ([DistrictId], [Name], [ProvinceId]) VALUES (5, N'Kotli', 1)
INSERT [dbo].[District] ([DistrictId], [Name], [ProvinceId]) VALUES (6, N'Mirpur', 1)
INSERT [dbo].[District] ([DistrictId], [Name], [ProvinceId]) VALUES (7, N'Muzaffarabad', 1)
INSERT [dbo].[District] ([DistrictId], [Name], [ProvinceId]) VALUES (8, N'Neelum', 1)
INSERT [dbo].[District] ([DistrictId], [Name], [ProvinceId]) VALUES (9, N'Poonch', 1)
INSERT [dbo].[District] ([DistrictId], [Name], [ProvinceId]) VALUES (10, N'Sudhnoti', 1)
INSERT [dbo].[District] ([DistrictId], [Name], [ProvinceId]) VALUES (11, N'Awaran', 2)
INSERT [dbo].[District] ([DistrictId], [Name], [ProvinceId]) VALUES (12, N'Barkhan', 2)
INSERT [dbo].[District] ([DistrictId], [Name], [ProvinceId]) VALUES (13, N'Chagai', 2)
INSERT [dbo].[District] ([DistrictId], [Name], [ProvinceId]) VALUES (14, N'Dera Bugti', 2)
INSERT [dbo].[District] ([DistrictId], [Name], [ProvinceId]) VALUES (15, N'Gwadar', 2)
INSERT [dbo].[District] ([DistrictId], [Name], [ProvinceId]) VALUES (16, N'Harnai', 2)
INSERT [dbo].[District] ([DistrictId], [Name], [ProvinceId]) VALUES (17, N'Jaffarabad', 2)
INSERT [dbo].[District] ([DistrictId], [Name], [ProvinceId]) VALUES (18, N'Jhal Magsi', 2)
INSERT [dbo].[District] ([DistrictId], [Name], [ProvinceId]) VALUES (19, N'Kachhi', 2)
INSERT [dbo].[District] ([DistrictId], [Name], [ProvinceId]) VALUES (20, N'Kalat', 2)
INSERT [dbo].[District] ([DistrictId], [Name], [ProvinceId]) VALUES (21, N'Kech', 2)
INSERT [dbo].[District] ([DistrictId], [Name], [ProvinceId]) VALUES (22, N'Kharan', 2)
INSERT [dbo].[District] ([DistrictId], [Name], [ProvinceId]) VALUES (23, N'Khuzdar', 2)
INSERT [dbo].[District] ([DistrictId], [Name], [ProvinceId]) VALUES (24, N'Killa Abdullah', 2)
INSERT [dbo].[District] ([DistrictId], [Name], [ProvinceId]) VALUES (25, N'Killa Saifullah', 2)
INSERT [dbo].[District] ([DistrictId], [Name], [ProvinceId]) VALUES (26, N'Kohlu', 2)
INSERT [dbo].[District] ([DistrictId], [Name], [ProvinceId]) VALUES (27, N'Las Bela', 2)
INSERT [dbo].[District] ([DistrictId], [Name], [ProvinceId]) VALUES (28, N'Loralai', 2)
INSERT [dbo].[District] ([DistrictId], [Name], [ProvinceId]) VALUES (29, N'Mastung', 2)
INSERT [dbo].[District] ([DistrictId], [Name], [ProvinceId]) VALUES (30, N'Musakhel', 2)
INSERT [dbo].[District] ([DistrictId], [Name], [ProvinceId]) VALUES (31, N'Nasirabad', 2)
INSERT [dbo].[District] ([DistrictId], [Name], [ProvinceId]) VALUES (32, N'Nushki', 2)
INSERT [dbo].[District] ([DistrictId], [Name], [ProvinceId]) VALUES (33, N'Panjgur', 2)
INSERT [dbo].[District] ([DistrictId], [Name], [ProvinceId]) VALUES (34, N'Panjpai', 2)
INSERT [dbo].[District] ([DistrictId], [Name], [ProvinceId]) VALUES (35, N'Pishin', 2)
INSERT [dbo].[District] ([DistrictId], [Name], [ProvinceId]) VALUES (36, N'Quetta', 2)
INSERT [dbo].[District] ([DistrictId], [Name], [ProvinceId]) VALUES (37, N'Sheerani', 2)
INSERT [dbo].[District] ([DistrictId], [Name], [ProvinceId]) VALUES (38, N'Sibi', 2)
INSERT [dbo].[District] ([DistrictId], [Name], [ProvinceId]) VALUES (39, N'Washuk', 2)
INSERT [dbo].[District] ([DistrictId], [Name], [ProvinceId]) VALUES (40, N'Zhob', 2)
INSERT [dbo].[District] ([DistrictId], [Name], [ProvinceId]) VALUES (41, N'Ziarat', 2)
INSERT [dbo].[District] ([DistrictId], [Name], [ProvinceId]) VALUES (42, N'Bajaur Agency', 3)
INSERT [dbo].[District] ([DistrictId], [Name], [ProvinceId]) VALUES (43, N'FR Bannu', 3)
INSERT [dbo].[District] ([DistrictId], [Name], [ProvinceId]) VALUES (44, N'FR D.I. Khan', 3)
INSERT [dbo].[District] ([DistrictId], [Name], [ProvinceId]) VALUES (45, N'FR Kohat', 3)
INSERT [dbo].[District] ([DistrictId], [Name], [ProvinceId]) VALUES (46, N'FR Lakki Marwat', 3)
INSERT [dbo].[District] ([DistrictId], [Name], [ProvinceId]) VALUES (47, N'FR Peshawar', 3)
INSERT [dbo].[District] ([DistrictId], [Name], [ProvinceId]) VALUES (48, N'FR Tank', 3)
INSERT [dbo].[District] ([DistrictId], [Name], [ProvinceId]) VALUES (49, N'Khyber Agency', 3)
INSERT [dbo].[District] ([DistrictId], [Name], [ProvinceId]) VALUES (50, N'Kurram Agency', 3)
INSERT [dbo].[District] ([DistrictId], [Name], [ProvinceId]) VALUES (51, N'Mohmand Agency', 3)
INSERT [dbo].[District] ([DistrictId], [Name], [ProvinceId]) VALUES (52, N'North Waziristan Agency', 3)
INSERT [dbo].[District] ([DistrictId], [Name], [ProvinceId]) VALUES (53, N'Orakzai Agency', 3)
INSERT [dbo].[District] ([DistrictId], [Name], [ProvinceId]) VALUES (54, N'South Waziristan Agency', 3)
INSERT [dbo].[District] ([DistrictId], [Name], [ProvinceId]) VALUES (55, N'Islamabad', 4)
INSERT [dbo].[District] ([DistrictId], [Name], [ProvinceId]) VALUES (56, N'Astore', 5)
INSERT [dbo].[District] ([DistrictId], [Name], [ProvinceId]) VALUES (57, N'Diamir', 5)
INSERT [dbo].[District] ([DistrictId], [Name], [ProvinceId]) VALUES (58, N'Ghanche', 5)
INSERT [dbo].[District] ([DistrictId], [Name], [ProvinceId]) VALUES (59, N'Ghizer', 5)
INSERT [dbo].[District] ([DistrictId], [Name], [ProvinceId]) VALUES (60, N'Gilgit', 5)
INSERT [dbo].[District] ([DistrictId], [Name], [ProvinceId]) VALUES (61, N'Hunza Nagar', 5)
INSERT [dbo].[District] ([DistrictId], [Name], [ProvinceId]) VALUES (62, N'Skardu', 5)
INSERT [dbo].[District] ([DistrictId], [Name], [ProvinceId]) VALUES (63, N'Abbottabad', 6)
INSERT [dbo].[District] ([DistrictId], [Name], [ProvinceId]) VALUES (64, N'Bannu', 6)
INSERT [dbo].[District] ([DistrictId], [Name], [ProvinceId]) VALUES (65, N'Batagram', 6)
INSERT [dbo].[District] ([DistrictId], [Name], [ProvinceId]) VALUES (66, N'Buner', 6)
INSERT [dbo].[District] ([DistrictId], [Name], [ProvinceId]) VALUES (67, N'Charsadda', 6)
INSERT [dbo].[District] ([DistrictId], [Name], [ProvinceId]) VALUES (68, N'Chitral', 6)
INSERT [dbo].[District] ([DistrictId], [Name], [ProvinceId]) VALUES (69, N'Dera Ismail Khan', 6)
INSERT [dbo].[District] ([DistrictId], [Name], [ProvinceId]) VALUES (70, N'Hangu', 6)
INSERT [dbo].[District] ([DistrictId], [Name], [ProvinceId]) VALUES (71, N'Haripur', 6)
INSERT [dbo].[District] ([DistrictId], [Name], [ProvinceId]) VALUES (72, N'Karak', 6)
INSERT [dbo].[District] ([DistrictId], [Name], [ProvinceId]) VALUES (73, N'Kohat', 6)
INSERT [dbo].[District] ([DistrictId], [Name], [ProvinceId]) VALUES (74, N'Kohistan', 6)
INSERT [dbo].[District] ([DistrictId], [Name], [ProvinceId]) VALUES (75, N'Lakki Marwat', 6)
INSERT [dbo].[District] ([DistrictId], [Name], [ProvinceId]) VALUES (76, N'Lower Dir', 6)
INSERT [dbo].[District] ([DistrictId], [Name], [ProvinceId]) VALUES (77, N'Malakand P.a.', 6)
INSERT [dbo].[District] ([DistrictId], [Name], [ProvinceId]) VALUES (78, N'Mansehra', 6)
INSERT [dbo].[District] ([DistrictId], [Name], [ProvinceId]) VALUES (79, N'Mardan', 6)
INSERT [dbo].[District] ([DistrictId], [Name], [ProvinceId]) VALUES (80, N'Nowshera', 6)
INSERT [dbo].[District] ([DistrictId], [Name], [ProvinceId]) VALUES (81, N'Peshawar', 6)
INSERT [dbo].[District] ([DistrictId], [Name], [ProvinceId]) VALUES (82, N'Shangla', 6)
INSERT [dbo].[District] ([DistrictId], [Name], [ProvinceId]) VALUES (83, N'Swabi', 6)
INSERT [dbo].[District] ([DistrictId], [Name], [ProvinceId]) VALUES (84, N'Swat', 6)
INSERT [dbo].[District] ([DistrictId], [Name], [ProvinceId]) VALUES (85, N'Tank', 6)
INSERT [dbo].[District] ([DistrictId], [Name], [ProvinceId]) VALUES (86, N'Upper Dir', 6)
INSERT [dbo].[District] ([DistrictId], [Name], [ProvinceId]) VALUES (87, N'Attock', 7)
INSERT [dbo].[District] ([DistrictId], [Name], [ProvinceId]) VALUES (88, N'Bahawalnagar', 7)
INSERT [dbo].[District] ([DistrictId], [Name], [ProvinceId]) VALUES (89, N'Bahawalpur', 7)
INSERT [dbo].[District] ([DistrictId], [Name], [ProvinceId]) VALUES (90, N'Bhakkar', 7)
INSERT [dbo].[District] ([DistrictId], [Name], [ProvinceId]) VALUES (91, N'Chakwal', 7)
INSERT [dbo].[District] ([DistrictId], [Name], [ProvinceId]) VALUES (92, N'Chiniot', 7)
INSERT [dbo].[District] ([DistrictId], [Name], [ProvinceId]) VALUES (93, N'Dera Ghazi Khan', 7)
INSERT [dbo].[District] ([DistrictId], [Name], [ProvinceId]) VALUES (94, N'Faisalabad', 7)
INSERT [dbo].[District] ([DistrictId], [Name], [ProvinceId]) VALUES (95, N'Gujranwala', 7)
INSERT [dbo].[District] ([DistrictId], [Name], [ProvinceId]) VALUES (96, N'Gujrat', 7)
INSERT [dbo].[District] ([DistrictId], [Name], [ProvinceId]) VALUES (97, N'Hafizabad', 7)
INSERT [dbo].[District] ([DistrictId], [Name], [ProvinceId]) VALUES (98, N'Jhang', 7)
INSERT [dbo].[District] ([DistrictId], [Name], [ProvinceId]) VALUES (99, N'Jhelum', 7)
GO
INSERT [dbo].[District] ([DistrictId], [Name], [ProvinceId]) VALUES (100, N'Kasur', 7)
INSERT [dbo].[District] ([DistrictId], [Name], [ProvinceId]) VALUES (101, N'Khanewal', 7)
INSERT [dbo].[District] ([DistrictId], [Name], [ProvinceId]) VALUES (102, N'Khushab', 7)
INSERT [dbo].[District] ([DistrictId], [Name], [ProvinceId]) VALUES (103, N'Lahore', 7)
INSERT [dbo].[District] ([DistrictId], [Name], [ProvinceId]) VALUES (104, N'Layyah', 7)
INSERT [dbo].[District] ([DistrictId], [Name], [ProvinceId]) VALUES (105, N'Lodhran', 7)
INSERT [dbo].[District] ([DistrictId], [Name], [ProvinceId]) VALUES (106, N'Mandi Bahauddin', 7)
INSERT [dbo].[District] ([DistrictId], [Name], [ProvinceId]) VALUES (107, N'Mianwali', 7)
INSERT [dbo].[District] ([DistrictId], [Name], [ProvinceId]) VALUES (108, N'Multan', 7)
INSERT [dbo].[District] ([DistrictId], [Name], [ProvinceId]) VALUES (109, N'Muzaffargarh', 7)
INSERT [dbo].[District] ([DistrictId], [Name], [ProvinceId]) VALUES (110, N'Nankana Sahib', 7)
INSERT [dbo].[District] ([DistrictId], [Name], [ProvinceId]) VALUES (111, N'Narowal', 7)
INSERT [dbo].[District] ([DistrictId], [Name], [ProvinceId]) VALUES (112, N'Okara', 7)
INSERT [dbo].[District] ([DistrictId], [Name], [ProvinceId]) VALUES (113, N'Pakpattan', 7)
INSERT [dbo].[District] ([DistrictId], [Name], [ProvinceId]) VALUES (114, N'Rahim Yar Khan', 7)
INSERT [dbo].[District] ([DistrictId], [Name], [ProvinceId]) VALUES (115, N'Rajanpur', 7)
INSERT [dbo].[District] ([DistrictId], [Name], [ProvinceId]) VALUES (116, N'Rawalpindi', 7)
INSERT [dbo].[District] ([DistrictId], [Name], [ProvinceId]) VALUES (117, N'Sahiwal', 7)
INSERT [dbo].[District] ([DistrictId], [Name], [ProvinceId]) VALUES (118, N'Sargodha', 7)
INSERT [dbo].[District] ([DistrictId], [Name], [ProvinceId]) VALUES (119, N'Sheikhupura', 7)
INSERT [dbo].[District] ([DistrictId], [Name], [ProvinceId]) VALUES (120, N'Sialkot', 7)
INSERT [dbo].[District] ([DistrictId], [Name], [ProvinceId]) VALUES (121, N'Toba Tek Singh', 7)
INSERT [dbo].[District] ([DistrictId], [Name], [ProvinceId]) VALUES (122, N'Vehari', 7)
INSERT [dbo].[District] ([DistrictId], [Name], [ProvinceId]) VALUES (123, N'Badin', 8)
INSERT [dbo].[District] ([DistrictId], [Name], [ProvinceId]) VALUES (124, N'Dadu', 8)
INSERT [dbo].[District] ([DistrictId], [Name], [ProvinceId]) VALUES (125, N'Ghotki', 8)
INSERT [dbo].[District] ([DistrictId], [Name], [ProvinceId]) VALUES (126, N'Hyderabad', 8)
INSERT [dbo].[District] ([DistrictId], [Name], [ProvinceId]) VALUES (127, N'Jacobabad', 8)
INSERT [dbo].[District] ([DistrictId], [Name], [ProvinceId]) VALUES (128, N'Jamshoro', 8)
INSERT [dbo].[District] ([DistrictId], [Name], [ProvinceId]) VALUES (129, N'Karachi City', 8)
INSERT [dbo].[District] ([DistrictId], [Name], [ProvinceId]) VALUES (130, N'Kashmore', 8)
INSERT [dbo].[District] ([DistrictId], [Name], [ProvinceId]) VALUES (131, N'Khairpur', 8)
INSERT [dbo].[District] ([DistrictId], [Name], [ProvinceId]) VALUES (132, N'Larkana', 8)
INSERT [dbo].[District] ([DistrictId], [Name], [ProvinceId]) VALUES (133, N'Matiari', 8)
INSERT [dbo].[District] ([DistrictId], [Name], [ProvinceId]) VALUES (134, N'Mirpur Khas', 8)
INSERT [dbo].[District] ([DistrictId], [Name], [ProvinceId]) VALUES (135, N'Naushahro Feroze', 8)
INSERT [dbo].[District] ([DistrictId], [Name], [ProvinceId]) VALUES (136, N'Qambar Shahdadkot', 8)
INSERT [dbo].[District] ([DistrictId], [Name], [ProvinceId]) VALUES (137, N'Sanghar', 8)
INSERT [dbo].[District] ([DistrictId], [Name], [ProvinceId]) VALUES (138, N'Shaheed Benazirabad', 8)
INSERT [dbo].[District] ([DistrictId], [Name], [ProvinceId]) VALUES (139, N'Shikarpur', 8)
INSERT [dbo].[District] ([DistrictId], [Name], [ProvinceId]) VALUES (140, N'Sukkur', 8)
INSERT [dbo].[District] ([DistrictId], [Name], [ProvinceId]) VALUES (141, N'Tando Allah Yar', 8)
INSERT [dbo].[District] ([DistrictId], [Name], [ProvinceId]) VALUES (142, N'Tando Muhammad Khan', 8)
INSERT [dbo].[District] ([DistrictId], [Name], [ProvinceId]) VALUES (143, N'Tharparkar', 8)
INSERT [dbo].[District] ([DistrictId], [Name], [ProvinceId]) VALUES (144, N'Thatta', 8)
INSERT [dbo].[District] ([DistrictId], [Name], [ProvinceId]) VALUES (145, N'Umerkot', 8)
SET IDENTITY_INSERT [dbo].[District] OFF
SET IDENTITY_INSERT [dbo].[Document] ON 

INSERT [dbo].[Document] ([DocumentId], [Name], [TrainingId], [DocumentCategoryId1], [DocumentCategoryId2], [DocumentCategoryId3], [ThematicAreaId], [Edition], [YearOfPublication], [Authors], [CompilingAgency], [PublisherName], [PublisherAddress], [PublisherEmail], [PublisherPhone], [Price], [PhysicalLocation], [FileName], [DateUploaded], [AccessType]) VALUES (1, N'Training Manual 2015', 3, 16, 18, NULL, 4, N'22', CAST(N'2015-09-03 00:00:00.000' AS DateTime), NULL, N'NIDM', N'NIDM', NULL, NULL, NULL, 5000, NULL, N'NDMA_Annual_Report_2011.pdf', CAST(N'2015-07-22 23:58:10.067' AS DateTime), 1)
INSERT [dbo].[Document] ([DocumentId], [Name], [TrainingId], [DocumentCategoryId1], [DocumentCategoryId2], [DocumentCategoryId3], [ThematicAreaId], [Edition], [YearOfPublication], [Authors], [CompilingAgency], [PublisherName], [PublisherAddress], [PublisherEmail], [PublisherPhone], [Price], [PhysicalLocation], [FileName], [DateUploaded], [AccessType]) VALUES (2, N'Annual Report 2014', 3, 2, 7, 21, 1, N'656', CAST(N'2015-08-19 00:00:00.000' AS DateTime), N'5656', N'NIDM', N'NIDM', NULL, NULL, NULL, 5000, NULL, N'NDMA_Annual_Report_2012 (1).pdf', CAST(N'2015-07-23 00:23:30.827' AS DateTime), 0)
INSERT [dbo].[Document] ([DocumentId], [Name], [TrainingId], [DocumentCategoryId1], [DocumentCategoryId2], [DocumentCategoryId3], [ThematicAreaId], [Edition], [YearOfPublication], [Authors], [CompilingAgency], [PublisherName], [PublisherAddress], [PublisherEmail], [PublisherPhone], [Price], [PhysicalLocation], [FileName], [DateUploaded], [AccessType]) VALUES (5, N'Skills Trainers Manual', 2, 2, 10, NULL, 5, N'10', CAST(N'2015-08-23 20:12:53.843' AS DateTime), N'Nisar, Awb', N'NIDM', N'WFP', N'Diplomatic', N'wfp@un.org', N'0345 354343', 2000, N'Desk', NULL, CAST(N'1899-12-31 19:00:00.000' AS DateTime), 0)
INSERT [dbo].[Document] ([DocumentId], [Name], [TrainingId], [DocumentCategoryId1], [DocumentCategoryId2], [DocumentCategoryId3], [ThematicAreaId], [Edition], [YearOfPublication], [Authors], [CompilingAgency], [PublisherName], [PublisherAddress], [PublisherEmail], [PublisherPhone], [Price], [PhysicalLocation], [FileName], [DateUploaded], [AccessType]) VALUES (8, N'Best', 3, 16, 17, NULL, 4, NULL, CAST(N'2015-08-24 21:03:27.180' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'elijah_manor.jpg', CAST(N'1899-12-31 19:00:00.000' AS DateTime), 0)
INSERT [dbo].[Document] ([DocumentId], [Name], [TrainingId], [DocumentCategoryId1], [DocumentCategoryId2], [DocumentCategoryId3], [ThematicAreaId], [Edition], [YearOfPublication], [Authors], [CompilingAgency], [PublisherName], [PublisherAddress], [PublisherEmail], [PublisherPhone], [Price], [PhysicalLocation], [FileName], [DateUploaded], [AccessType]) VALUES (10, N'DRR', NULL, 2, 7, 21, 1, NULL, CAST(N'2015-08-24 21:07:18.537' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'NDMA_Annual_Report_2012.pdf', CAST(N'1899-12-31 19:00:00.000' AS DateTime), 0)
INSERT [dbo].[Document] ([DocumentId], [Name], [TrainingId], [DocumentCategoryId1], [DocumentCategoryId2], [DocumentCategoryId3], [ThematicAreaId], [Edition], [YearOfPublication], [Authors], [CompilingAgency], [PublisherName], [PublisherAddress], [PublisherEmail], [PublisherPhone], [Price], [PhysicalLocation], [FileName], [DateUploaded], [AccessType]) VALUES (11, N'Disability', NULL, 2, 7, 21, 4, NULL, CAST(N'2015-08-25 00:15:13.697' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'script.sql', CAST(N'1899-12-31 19:00:00.000' AS DateTime), 0)
INSERT [dbo].[Document] ([DocumentId], [Name], [TrainingId], [DocumentCategoryId1], [DocumentCategoryId2], [DocumentCategoryId3], [ThematicAreaId], [Edition], [YearOfPublication], [Authors], [CompilingAgency], [PublisherName], [PublisherAddress], [PublisherEmail], [PublisherPhone], [Price], [PhysicalLocation], [FileName], [DateUploaded], [AccessType]) VALUES (12, N'New Upload', 7, 11, NULL, NULL, 3, NULL, CAST(N'2015-08-29 12:27:31.683' AS DateTime), N'Nisar', NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'NRTD – WFP – ODTKMS – SRS v6 _Module 10_ 4.8.15.pdf', CAST(N'1899-12-31 19:00:00.000' AS DateTime), 0)
INSERT [dbo].[Document] ([DocumentId], [Name], [TrainingId], [DocumentCategoryId1], [DocumentCategoryId2], [DocumentCategoryId3], [ThematicAreaId], [Edition], [YearOfPublication], [Authors], [CompilingAgency], [PublisherName], [PublisherAddress], [PublisherEmail], [PublisherPhone], [Price], [PhysicalLocation], [FileName], [DateUploaded], [AccessType]) VALUES (13, N'Document 5', NULL, 3, NULL, NULL, 4, NULL, CAST(N'2015-08-29 13:50:24.360' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'NDMA_Annual_Report_2011.pdf', CAST(N'1899-12-31 19:00:00.000' AS DateTime), 0)
INSERT [dbo].[Document] ([DocumentId], [Name], [TrainingId], [DocumentCategoryId1], [DocumentCategoryId2], [DocumentCategoryId3], [ThematicAreaId], [Edition], [YearOfPublication], [Authors], [CompilingAgency], [PublisherName], [PublisherAddress], [PublisherEmail], [PublisherPhone], [Price], [PhysicalLocation], [FileName], [DateUploaded], [AccessType]) VALUES (14, N'Pre Training Material', 7, 16, 17, NULL, 4, NULL, CAST(N'2015-08-30 23:09:10.910' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'NRTD – WFP – ODTKMS – SRS v6 _Module 10_ 4.8.15.pdf', CAST(N'1899-12-31 19:00:00.000' AS DateTime), 0)
SET IDENTITY_INSERT [dbo].[Document] OFF
SET IDENTITY_INSERT [dbo].[DocumentCategory] ON 

INSERT [dbo].[DocumentCategory] ([DocumentCategoryId], [Name], [Level], [ParentDocumentCategoryId], [Description]) VALUES (1, N'Presentations', 1, NULL, NULL)
INSERT [dbo].[DocumentCategory] ([DocumentCategoryId], [Name], [Level], [ParentDocumentCategoryId], [Description]) VALUES (2, N'Publications', 1, NULL, NULL)
INSERT [dbo].[DocumentCategory] ([DocumentCategoryId], [Name], [Level], [ParentDocumentCategoryId], [Description]) VALUES (3, N'Audio', 1, NULL, NULL)
INSERT [dbo].[DocumentCategory] ([DocumentCategoryId], [Name], [Level], [ParentDocumentCategoryId], [Description]) VALUES (4, N'Video', 1, NULL, NULL)
INSERT [dbo].[DocumentCategory] ([DocumentCategoryId], [Name], [Level], [ParentDocumentCategoryId], [Description]) VALUES (5, N'Poster', 1, NULL, NULL)
INSERT [dbo].[DocumentCategory] ([DocumentCategoryId], [Name], [Level], [ParentDocumentCategoryId], [Description]) VALUES (6, N'Book', 1, NULL, NULL)
INSERT [dbo].[DocumentCategory] ([DocumentCategoryId], [Name], [Level], [ParentDocumentCategoryId], [Description]) VALUES (7, N'Thematic Report', 2, 2, NULL)
INSERT [dbo].[DocumentCategory] ([DocumentCategoryId], [Name], [Level], [ParentDocumentCategoryId], [Description]) VALUES (8, N'Annual Report', 2, 2, NULL)
INSERT [dbo].[DocumentCategory] ([DocumentCategoryId], [Name], [Level], [ParentDocumentCategoryId], [Description]) VALUES (9, N'Participant Training Manual', 2, 2, NULL)
INSERT [dbo].[DocumentCategory] ([DocumentCategoryId], [Name], [Level], [ParentDocumentCategoryId], [Description]) VALUES (10, N'Trainers'' Manual', 2, 2, NULL)
INSERT [dbo].[DocumentCategory] ([DocumentCategoryId], [Name], [Level], [ParentDocumentCategoryId], [Description]) VALUES (11, N'PhD Theses', 1, NULL, NULL)
INSERT [dbo].[DocumentCategory] ([DocumentCategoryId], [Name], [Level], [ParentDocumentCategoryId], [Description]) VALUES (12, N'MS Theses', 1, NULL, NULL)
INSERT [dbo].[DocumentCategory] ([DocumentCategoryId], [Name], [Level], [ParentDocumentCategoryId], [Description]) VALUES (13, N'Research paper', 1, NULL, NULL)
INSERT [dbo].[DocumentCategory] ([DocumentCategoryId], [Name], [Level], [ParentDocumentCategoryId], [Description]) VALUES (14, N'Article', 1, NULL, NULL)
INSERT [dbo].[DocumentCategory] ([DocumentCategoryId], [Name], [Level], [ParentDocumentCategoryId], [Description]) VALUES (15, N'Newspaper Cutting', 1, NULL, NULL)
INSERT [dbo].[DocumentCategory] ([DocumentCategoryId], [Name], [Level], [ParentDocumentCategoryId], [Description]) VALUES (16, N'Reference Material', 1, NULL, NULL)
INSERT [dbo].[DocumentCategory] ([DocumentCategoryId], [Name], [Level], [ParentDocumentCategoryId], [Description]) VALUES (17, N'Pre–Training Reference Material', 3, 16, NULL)
INSERT [dbo].[DocumentCategory] ([DocumentCategoryId], [Name], [Level], [ParentDocumentCategoryId], [Description]) VALUES (18, N'Post–Training Reference Material', 3, 16, NULL)
INSERT [dbo].[DocumentCategory] ([DocumentCategoryId], [Name], [Level], [ParentDocumentCategoryId], [Description]) VALUES (19, N'Policies', 1, NULL, NULL)
INSERT [dbo].[DocumentCategory] ([DocumentCategoryId], [Name], [Level], [ParentDocumentCategoryId], [Description]) VALUES (20, N'Plans', 1, NULL, NULL)
INSERT [dbo].[DocumentCategory] ([DocumentCategoryId], [Name], [Level], [ParentDocumentCategoryId], [Description]) VALUES (21, N'DRM Reports', 3, 7, NULL)
SET IDENTITY_INSERT [dbo].[DocumentCategory] OFF
SET IDENTITY_INSERT [dbo].[Funding] ON 

INSERT [dbo].[Funding] ([FundingId], [ProjectId], [FundingType], [CashAmount], [StartDate], [EndDate], [ApprovedActivityId]) VALUES (1, 1, 1, 10000, CAST(N'2015-01-01 00:00:00.000' AS DateTime), CAST(N'2015-12-31 00:00:00.000' AS DateTime), 5)
INSERT [dbo].[Funding] ([FundingId], [ProjectId], [FundingType], [CashAmount], [StartDate], [EndDate], [ApprovedActivityId]) VALUES (2, 1, 0, 5000, CAST(N'2015-08-26 19:00:00.000' AS DateTime), CAST(N'2016-08-26 19:00:00.000' AS DateTime), 1)
INSERT [dbo].[Funding] ([FundingId], [ProjectId], [FundingType], [CashAmount], [StartDate], [EndDate], [ApprovedActivityId]) VALUES (3, 2, 0, 5000, CAST(N'2015-08-30 00:13:25.850' AS DateTime), CAST(N'2016-02-29 00:13:25.850' AS DateTime), 2)
SET IDENTITY_INSERT [dbo].[Funding] OFF
SET IDENTITY_INSERT [dbo].[Gallery] ON 

INSERT [dbo].[Gallery] ([GalleryId], [Name], [Description], [RelativeUrl], [AlbumType]) VALUES (1, N'Trainings', N'Trainings', N'Files/Galleries/Trainings/', 0)
INSERT [dbo].[Gallery] ([GalleryId], [Name], [Description], [RelativeUrl], [AlbumType]) VALUES (2, N'Projects', N'Projects', N'Files/Galleries/Projects/', 1)
INSERT [dbo].[Gallery] ([GalleryId], [Name], [Description], [RelativeUrl], [AlbumType]) VALUES (3, N'Activities', N'Activities', N'Files/Galleries/Activities/', 2)
INSERT [dbo].[Gallery] ([GalleryId], [Name], [Description], [RelativeUrl], [AlbumType]) VALUES (4, N'4W Trainings', N'4W Trainings', N'Files/Galleries/4W/Trainings/', 3)
INSERT [dbo].[Gallery] ([GalleryId], [Name], [Description], [RelativeUrl], [AlbumType]) VALUES (5, N'TNA', N'Training Needs Assessments', N'Files/Galleries/TNA/', 4)
INSERT [dbo].[Gallery] ([GalleryId], [Name], [Description], [RelativeUrl], [AlbumType]) VALUES (6, N'General', N'General', N'Files/Galleries/General/', 5)
INSERT [dbo].[Gallery] ([GalleryId], [Name], [Description], [RelativeUrl], [AlbumType]) VALUES (7, N'Resource Persons', N'Resource Persons', N'Files/Galleries/ResourcePersons/', 6)
INSERT [dbo].[Gallery] ([GalleryId], [Name], [Description], [RelativeUrl], [AlbumType]) VALUES (8, N'Donors & Collaborating Agencies', N'Donors & Collaborating Agencies', N'Files/Galleries/Donors/', 6)
SET IDENTITY_INSERT [dbo].[Gallery] OFF
SET IDENTITY_INSERT [dbo].[MediaFile] ON 

INSERT [dbo].[MediaFile] ([MediaFileId], [Name], [Description], [DateUploaded], [FileType], [AlbumId]) VALUES (1, N'img_26.jpg', N'Training Session 1', CAST(N'2015-07-21 23:34:23.450' AS DateTime), 1, 3)
INSERT [dbo].[MediaFile] ([MediaFileId], [Name], [Description], [DateUploaded], [FileType], [AlbumId]) VALUES (2, N'img_25.jpg', N'Training 2 - A glance at NIDM Workshop', CAST(N'2015-07-21 23:53:14.577' AS DateTime), 1, 3)
INSERT [dbo].[MediaFile] ([MediaFileId], [Name], [Description], [DateUploaded], [FileType], [AlbumId]) VALUES (3, N'img_7.jpg', N'At a glance', CAST(N'2015-07-21 23:54:23.607' AS DateTime), 1, 3)
INSERT [dbo].[MediaFile] ([MediaFileId], [Name], [Description], [DateUploaded], [FileType], [AlbumId]) VALUES (4, N'img_16.jpg', N'Great Workshop', CAST(N'2015-07-21 23:54:47.400' AS DateTime), 1, 3)
INSERT [dbo].[MediaFile] ([MediaFileId], [Name], [Description], [DateUploaded], [FileType], [AlbumId]) VALUES (5, N'img_7.jpg', N'Need Assessment', CAST(N'2015-07-21 23:55:30.763' AS DateTime), 1, 3)
INSERT [dbo].[MediaFile] ([MediaFileId], [Name], [Description], [DateUploaded], [FileType], [AlbumId]) VALUES (6, N'small.mp4', N'Test Video', CAST(N'2015-07-22 01:09:29.687' AS DateTime), 2, 2)
INSERT [dbo].[MediaFile] ([MediaFileId], [Name], [Description], [DateUploaded], [FileType], [AlbumId]) VALUES (7, N'img_16.jpg', N'Workshop', CAST(N'2015-07-23 02:23:05.807' AS DateTime), 1, 2)
INSERT [dbo].[MediaFile] ([MediaFileId], [Name], [Description], [DateUploaded], [FileType], [AlbumId]) VALUES (8, N'img_25.jpg', N'Training Session 1', CAST(N'2015-07-23 02:24:57.623' AS DateTime), 1, 2)
INSERT [dbo].[MediaFile] ([MediaFileId], [Name], [Description], [DateUploaded], [FileType], [AlbumId]) VALUES (24, N'img_25 (1).jpg', N'E1', CAST(N'2015-08-30 19:23:38.180' AS DateTime), 1, 6)
INSERT [dbo].[MediaFile] ([MediaFileId], [Name], [Description], [DateUploaded], [FileType], [AlbumId]) VALUES (25, N'img_26.jpg', N'E2', CAST(N'2015-08-30 19:25:31.183' AS DateTime), 1, 6)
INSERT [dbo].[MediaFile] ([MediaFileId], [Name], [Description], [DateUploaded], [FileType], [AlbumId]) VALUES (26, N'img_16.jpg', N'E3', CAST(N'2015-08-30 19:27:18.900' AS DateTime), 1, 6)
INSERT [dbo].[MediaFile] ([MediaFileId], [Name], [Description], [DateUploaded], [FileType], [AlbumId]) VALUES (27, N'small.mp4', N'E4', CAST(N'2015-08-30 19:29:02.110' AS DateTime), 2, 6)
INSERT [dbo].[MediaFile] ([MediaFileId], [Name], [Description], [DateUploaded], [FileType], [AlbumId]) VALUES (28, N'img_7.jpg', N'Image 7', CAST(N'2015-08-30 19:29:21.507' AS DateTime), 1, 6)
INSERT [dbo].[MediaFile] ([MediaFileId], [Name], [Description], [DateUploaded], [FileType], [AlbumId]) VALUES (29, N'img_25 (2).jpg', N'E6', CAST(N'2015-08-30 19:31:12.153' AS DateTime), 1, 6)
INSERT [dbo].[MediaFile] ([MediaFileId], [Name], [Description], [DateUploaded], [FileType], [AlbumId]) VALUES (30, N'img_26 (1).jpg', N'E7', CAST(N'2015-08-30 19:31:23.060' AS DateTime), 1, 6)
INSERT [dbo].[MediaFile] ([MediaFileId], [Name], [Description], [DateUploaded], [FileType], [AlbumId]) VALUES (31, N'img_26.jpg', N'Project 1', CAST(N'2015-08-30 19:38:07.160' AS DateTime), 1, 8)
INSERT [dbo].[MediaFile] ([MediaFileId], [Name], [Description], [DateUploaded], [FileType], [AlbumId]) VALUES (32, N'img_16.jpg', N'Aaron', CAST(N'2015-08-30 19:38:25.573' AS DateTime), 1, 8)
INSERT [dbo].[MediaFile] ([MediaFileId], [Name], [Description], [DateUploaded], [FileType], [AlbumId]) VALUES (33, N'img_7.jpg', N'Session 2', CAST(N'2015-08-30 19:42:09.953' AS DateTime), 1, 8)
INSERT [dbo].[MediaFile] ([MediaFileId], [Name], [Description], [DateUploaded], [FileType], [AlbumId]) VALUES (34, N'img_7.jpg', N'Event 1', CAST(N'2015-08-30 19:42:44.460' AS DateTime), 1, 10)
INSERT [dbo].[MediaFile] ([MediaFileId], [Name], [Description], [DateUploaded], [FileType], [AlbumId]) VALUES (35, N'img_26.jpg', N'TNA', CAST(N'2015-08-30 19:43:20.793' AS DateTime), 1, 10)
INSERT [dbo].[MediaFile] ([MediaFileId], [Name], [Description], [DateUploaded], [FileType], [AlbumId]) VALUES (36, N'img_16.jpg', N'General', CAST(N'2015-08-30 19:43:48.180' AS DateTime), 1, 11)
INSERT [dbo].[MediaFile] ([MediaFileId], [Name], [Description], [DateUploaded], [FileType], [AlbumId]) VALUES (37, N'small.mp4', N'Elijah', CAST(N'2015-08-30 19:44:04.340' AS DateTime), 2, 11)
INSERT [dbo].[MediaFile] ([MediaFileId], [Name], [Description], [DateUploaded], [FileType], [AlbumId]) VALUES (38, N'big.mp4', N'Big', CAST(N'2015-08-30 19:44:10.480' AS DateTime), 2, 11)
INSERT [dbo].[MediaFile] ([MediaFileId], [Name], [Description], [DateUploaded], [FileType], [AlbumId]) VALUES (39, N'img_7.jpg', N'Drought 4W 1', CAST(N'2015-09-12 21:26:37.223' AS DateTime), 1, 12)
INSERT [dbo].[MediaFile] ([MediaFileId], [Name], [Description], [DateUploaded], [FileType], [AlbumId]) VALUES (40, N'img_26.jpg', N'Drought 4W 2', CAST(N'2015-09-12 21:26:53.253' AS DateTime), 1, 12)
INSERT [dbo].[MediaFile] ([MediaFileId], [Name], [Description], [DateUploaded], [FileType], [AlbumId]) VALUES (41, N'img_16.jpg', N'Event 1', CAST(N'2015-09-20 17:36:01.310' AS DateTime), 1, 13)
SET IDENTITY_INSERT [dbo].[MediaFile] OFF
SET IDENTITY_INSERT [dbo].[Organization] ON 

INSERT [dbo].[Organization] ([OrganizationId], [Name], [OrganizationTypeId], [RelationshipType], [GeographicalArea], [DateEstablished], [RegisteringAuthority], [RegistrationNumber], [RegistrationCertificate], [Address], [Email], [Landline], [Fax], [Website], [Skype], [HeadTitle], [HeadName], [HeadDesignation], [HeadLandline], [HeadFax], [HeadMobile], [HeadEmail], [ContactPersonTitle], [ContactPersonName], [ContactPersonDesignation], [ContactPersonLandline], [ContactPersonFax], [ContactPersonMobile], [ContactPersonEmail], [Logo], [Profile], [Category], [ApprovalStatus], [DistrictId], [IsActive], [Username], [PasswordHash], [HeadPhoto]) VALUES (1, N'NDMA', 1, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'', N'ndma-logo.jpg', N'NDMA_Annual_Report_2011.pdf', 0, 1, 55, 1, NULL, NULL, NULL)
INSERT [dbo].[Organization] ([OrganizationId], [Name], [OrganizationTypeId], [RelationshipType], [GeographicalArea], [DateEstablished], [RegisteringAuthority], [RegistrationNumber], [RegistrationCertificate], [Address], [Email], [Landline], [Fax], [Website], [Skype], [HeadTitle], [HeadName], [HeadDesignation], [HeadLandline], [HeadFax], [HeadMobile], [HeadEmail], [ContactPersonTitle], [ContactPersonName], [ContactPersonDesignation], [ContactPersonLandline], [ContactPersonFax], [ContactPersonMobile], [ContactPersonEmail], [Logo], [Profile], [Category], [ApprovalStatus], [DistrictId], [IsActive], [Username], [PasswordHash], [HeadPhoto]) VALUES (2, N'WFP', 2, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'WFP-logo.jpg', NULL, 0, 1, 55, 1, NULL, NULL, NULL)
INSERT [dbo].[Organization] ([OrganizationId], [Name], [OrganizationTypeId], [RelationshipType], [GeographicalArea], [DateEstablished], [RegisteringAuthority], [RegistrationNumber], [RegistrationCertificate], [Address], [Email], [Landline], [Fax], [Website], [Skype], [HeadTitle], [HeadName], [HeadDesignation], [HeadLandline], [HeadFax], [HeadMobile], [HeadEmail], [ContactPersonTitle], [ContactPersonName], [ContactPersonDesignation], [ContactPersonLandline], [ContactPersonFax], [ContactPersonMobile], [ContactPersonEmail], [Logo], [Profile], [Category], [ApprovalStatus], [DistrictId], [IsActive], [Username], [PasswordHash], [HeadPhoto]) VALUES (3, N'USAID', 1, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'', N'usaid-logo.jpg', NULL, 0, 0, 55, 1, NULL, NULL, NULL)
INSERT [dbo].[Organization] ([OrganizationId], [Name], [OrganizationTypeId], [RelationshipType], [GeographicalArea], [DateEstablished], [RegisteringAuthority], [RegistrationNumber], [RegistrationCertificate], [Address], [Email], [Landline], [Fax], [Website], [Skype], [HeadTitle], [HeadName], [HeadDesignation], [HeadLandline], [HeadFax], [HeadMobile], [HeadEmail], [ContactPersonTitle], [ContactPersonName], [ContactPersonDesignation], [ContactPersonLandline], [ContactPersonFax], [ContactPersonMobile], [ContactPersonEmail], [Logo], [Profile], [Category], [ApprovalStatus], [DistrictId], [IsActive], [Username], [PasswordHash], [HeadPhoto]) VALUES (4, N'OCHA', 2, 0, 0, CAST(N'2015-07-10 00:00:00.000' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'OCHA-logo.jpg', N'National_DRR_Policy_2013.pdf', 0, 0, 55, 1, NULL, NULL, NULL)
INSERT [dbo].[Organization] ([OrganizationId], [Name], [OrganizationTypeId], [RelationshipType], [GeographicalArea], [DateEstablished], [RegisteringAuthority], [RegistrationNumber], [RegistrationCertificate], [Address], [Email], [Landline], [Fax], [Website], [Skype], [HeadTitle], [HeadName], [HeadDesignation], [HeadLandline], [HeadFax], [HeadMobile], [HeadEmail], [ContactPersonTitle], [ContactPersonName], [ContactPersonDesignation], [ContactPersonLandline], [ContactPersonFax], [ContactPersonMobile], [ContactPersonEmail], [Logo], [Profile], [Category], [ApprovalStatus], [DistrictId], [IsActive], [Username], [PasswordHash], [HeadPhoto]) VALUES (5, N'4W Organization 1', 1, 0, 1, CAST(N'2010-08-06 00:00:00.000' AS DateTime), NULL, NULL, N'NDMA_Annual_Report_2011.pdf', N'sdfsdfs', NULL, N'sdfdsf', N'dsfsfs', N'dfds', N'fsdfsdfsd', NULL, N'sdf', N'sdfsdf', N'sdfsd', N'fdsfsd', N'fdsf', N'nisar@gnmail.com', NULL, N'fsd', N'fsd', N'fsdfsdf', N'sdfsd', N'sdfsd', N'nisar@gnmail.com', N'usaid-logo.jpg', N'NRTD – WFP – ODTKMS – SRS v6 _Module 10_ 4.8.15.pdf', 1, 1, 126, 1, NULL, NULL, NULL)
INSERT [dbo].[Organization] ([OrganizationId], [Name], [OrganizationTypeId], [RelationshipType], [GeographicalArea], [DateEstablished], [RegisteringAuthority], [RegistrationNumber], [RegistrationCertificate], [Address], [Email], [Landline], [Fax], [Website], [Skype], [HeadTitle], [HeadName], [HeadDesignation], [HeadLandline], [HeadFax], [HeadMobile], [HeadEmail], [ContactPersonTitle], [ContactPersonName], [ContactPersonDesignation], [ContactPersonLandline], [ContactPersonFax], [ContactPersonMobile], [ContactPersonEmail], [Logo], [Profile], [Category], [ApprovalStatus], [DistrictId], [IsActive], [Username], [PasswordHash], [HeadPhoto]) VALUES (6, N'4W Organization 2', 2, 0, 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, 55, 1, NULL, NULL, NULL)
INSERT [dbo].[Organization] ([OrganizationId], [Name], [OrganizationTypeId], [RelationshipType], [GeographicalArea], [DateEstablished], [RegisteringAuthority], [RegistrationNumber], [RegistrationCertificate], [Address], [Email], [Landline], [Fax], [Website], [Skype], [HeadTitle], [HeadName], [HeadDesignation], [HeadLandline], [HeadFax], [HeadMobile], [HeadEmail], [ContactPersonTitle], [ContactPersonName], [ContactPersonDesignation], [ContactPersonLandline], [ContactPersonFax], [ContactPersonMobile], [ContactPersonEmail], [Logo], [Profile], [Category], [ApprovalStatus], [DistrictId], [IsActive], [Username], [PasswordHash], [HeadPhoto]) VALUES (7, N'4W Organization 3', 1, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 55, 1, NULL, NULL, NULL)
INSERT [dbo].[Organization] ([OrganizationId], [Name], [OrganizationTypeId], [RelationshipType], [GeographicalArea], [DateEstablished], [RegisteringAuthority], [RegistrationNumber], [RegistrationCertificate], [Address], [Email], [Landline], [Fax], [Website], [Skype], [HeadTitle], [HeadName], [HeadDesignation], [HeadLandline], [HeadFax], [HeadMobile], [HeadEmail], [ContactPersonTitle], [ContactPersonName], [ContactPersonDesignation], [ContactPersonLandline], [ContactPersonFax], [ContactPersonMobile], [ContactPersonEmail], [Logo], [Profile], [Category], [ApprovalStatus], [DistrictId], [IsActive], [Username], [PasswordHash], [HeadPhoto]) VALUES (8, N'DFID', 1, 1, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'DFID Head', N'CEO', N'95459', NULL, N'34034390', N'head@email.com', NULL, NULL, NULL, NULL, NULL, NULL, N'', N'DFID-logo.jpg', N'ODTKMS27Aug2015.sql', 0, 1, 55, 1, NULL, NULL, N'waseem_ahmed.jpg')
INSERT [dbo].[Organization] ([OrganizationId], [Name], [OrganizationTypeId], [RelationshipType], [GeographicalArea], [DateEstablished], [RegisteringAuthority], [RegistrationNumber], [RegistrationCertificate], [Address], [Email], [Landline], [Fax], [Website], [Skype], [HeadTitle], [HeadName], [HeadDesignation], [HeadLandline], [HeadFax], [HeadMobile], [HeadEmail], [ContactPersonTitle], [ContactPersonName], [ContactPersonDesignation], [ContactPersonLandline], [ContactPersonFax], [ContactPersonMobile], [ContactPersonEmail], [Logo], [Profile], [Category], [ApprovalStatus], [DistrictId], [IsActive], [Username], [PasswordHash], [HeadPhoto]) VALUES (9, N'JICA', 1, 1, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'JICA-Logo.gif', NULL, 0, 1, 55, 0, NULL, NULL, NULL)
INSERT [dbo].[Organization] ([OrganizationId], [Name], [OrganizationTypeId], [RelationshipType], [GeographicalArea], [DateEstablished], [RegisteringAuthority], [RegistrationNumber], [RegistrationCertificate], [Address], [Email], [Landline], [Fax], [Website], [Skype], [HeadTitle], [HeadName], [HeadDesignation], [HeadLandline], [HeadFax], [HeadMobile], [HeadEmail], [ContactPersonTitle], [ContactPersonName], [ContactPersonDesignation], [ContactPersonLandline], [ContactPersonFax], [ContactPersonMobile], [ContactPersonEmail], [Logo], [Profile], [Category], [ApprovalStatus], [DistrictId], [IsActive], [Username], [PasswordHash], [HeadPhoto]) VALUES (10, N'4W Organization 4', 1, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, 55, 0, N'nisar', N'Admin@123', NULL)
SET IDENTITY_INSERT [dbo].[Organization] OFF
SET IDENTITY_INSERT [dbo].[OrganizationType] ON 

INSERT [dbo].[OrganizationType] ([OrganizationTypeId], [Name], [Description]) VALUES (1, N'Government', NULL)
INSERT [dbo].[OrganizationType] ([OrganizationTypeId], [Name], [Description]) VALUES (2, N'UN Agency', NULL)
INSERT [dbo].[OrganizationType] ([OrganizationTypeId], [Name], [Description]) VALUES (3, N'Academia  ', NULL)
INSERT [dbo].[OrganizationType] ([OrganizationTypeId], [Name], [Description]) VALUES (4, N'Professional Body', NULL)
INSERT [dbo].[OrganizationType] ([OrganizationTypeId], [Name], [Description]) VALUES (5, N'Media', NULL)
INSERT [dbo].[OrganizationType] ([OrganizationTypeId], [Name], [Description]) VALUES (6, N'INGO', NULL)
INSERT [dbo].[OrganizationType] ([OrganizationTypeId], [Name], [Description]) VALUES (7, N'NGO', NULL)
INSERT [dbo].[OrganizationType] ([OrganizationTypeId], [Name], [Description]) VALUES (8, N'CBO', NULL)
INSERT [dbo].[OrganizationType] ([OrganizationTypeId], [Name], [Description]) VALUES (9, N'Religious/Ethnic', NULL)
INSERT [dbo].[OrganizationType] ([OrganizationTypeId], [Name], [Description]) VALUES (10, N'Private/Commercial', NULL)
INSERT [dbo].[OrganizationType] ([OrganizationTypeId], [Name], [Description]) VALUES (11, N'Association', NULL)
INSERT [dbo].[OrganizationType] ([OrganizationTypeId], [Name], [Description]) VALUES (12, N'Other', NULL)
SET IDENTITY_INSERT [dbo].[OrganizationType] OFF
SET IDENTITY_INSERT [dbo].[Participant] ON 

INSERT [dbo].[Participant] ([ParticipantId], [TrainingId], [Title], [Name], [CNIC], [Gender], [DateOfBirth], [HasSpecialAbility], [OrganizationId], [Designation], [BPSNo], [YearsOfExperience], [AcademicQualificationId], [DistrictId], [OfficialAddress], [ResidentialAddress], [PhoneWithExt], [Fax], [Cell], [Email], [Skype], [AnyPreviousTrainingAttended], [PreviousTrainings], [IsFeePaid], [AmountPaid], [PaymentProofDocument], [ApprovalStatus], [IsActive], [OtherOrganization], [OrganizationTypeId]) VALUES (1, 5, N'Mr.', N'Syed Awab Hasan', NULL, 0, CAST(N'1985-07-17 00:00:00.000' AS DateTime), 0, 3, NULL, NULL, 10, 6, 133, NULL, NULL, NULL, NULL, NULL, N'nisar83@gmail.com', N'', 0, NULL, 1, 5000, N'NDMA_Annual_Report_2011 (1).pdf', 1, 0, N'', 6)
INSERT [dbo].[Participant] ([ParticipantId], [TrainingId], [Title], [Name], [CNIC], [Gender], [DateOfBirth], [HasSpecialAbility], [OrganizationId], [Designation], [BPSNo], [YearsOfExperience], [AcademicQualificationId], [DistrictId], [OfficialAddress], [ResidentialAddress], [PhoneWithExt], [Fax], [Cell], [Email], [Skype], [AnyPreviousTrainingAttended], [PreviousTrainings], [IsFeePaid], [AmountPaid], [PaymentProofDocument], [ApprovalStatus], [IsActive], [OtherOrganization], [OrganizationTypeId]) VALUES (2, 1, N'Mr.', N'Nisar Ahmad', N'37405-8871125-3', 0, CAST(N'1995-10-18 00:00:00.000' AS DateTime), 1, NULL, N'Accountant', 5, 10, 5, 138, N'asdas', N'asdas', N'245235', N'4545', N'retwert', N'nisar@prohelix.com', N'fghghg', 0, N'', 0, 0, N'fghfghgf', 1, 1, N'FAO', 2)
INSERT [dbo].[Participant] ([ParticipantId], [TrainingId], [Title], [Name], [CNIC], [Gender], [DateOfBirth], [HasSpecialAbility], [OrganizationId], [Designation], [BPSNo], [YearsOfExperience], [AcademicQualificationId], [DistrictId], [OfficialAddress], [ResidentialAddress], [PhoneWithExt], [Fax], [Cell], [Email], [Skype], [AnyPreviousTrainingAttended], [PreviousTrainings], [IsFeePaid], [AmountPaid], [PaymentProofDocument], [ApprovalStatus], [IsActive], [OtherOrganization], [OrganizationTypeId]) VALUES (3, 3, N'Mr.', N'Hamid', N'', 0, CAST(N'1942-06-02 19:00:00.000' AS DateTime), 0, 1, N'gfghfgh', 20, 5, 1, 55, N'fgd', N'gdfg', N'dfg', N'fdgdf', N'dfgdfg', N'nisar@prohelix.com', N'dfg', 0, N'', 0, 0, NULL, 1, 0, N'', 1)
INSERT [dbo].[Participant] ([ParticipantId], [TrainingId], [Title], [Name], [CNIC], [Gender], [DateOfBirth], [HasSpecialAbility], [OrganizationId], [Designation], [BPSNo], [YearsOfExperience], [AcademicQualificationId], [DistrictId], [OfficialAddress], [ResidentialAddress], [PhoneWithExt], [Fax], [Cell], [Email], [Skype], [AnyPreviousTrainingAttended], [PreviousTrainings], [IsFeePaid], [AmountPaid], [PaymentProofDocument], [ApprovalStatus], [IsActive], [OtherOrganization], [OrganizationTypeId]) VALUES (4, 3, N'Engr.', N'Bilal Haider', NULL, 0, CAST(N'1990-05-07 19:00:00.000' AS DateTime), 0, 2, NULL, NULL, 5, 1, 55, NULL, NULL, NULL, NULL, NULL, N'nisar83@gmail.com', N'', 0, NULL, 1, 5000, N'NRTD – WFP – ODTKMS – SRS v6 _Module 10_ 4.8.15.pdf', 1, 0, N'', 2)
INSERT [dbo].[Participant] ([ParticipantId], [TrainingId], [Title], [Name], [CNIC], [Gender], [DateOfBirth], [HasSpecialAbility], [OrganizationId], [Designation], [BPSNo], [YearsOfExperience], [AcademicQualificationId], [DistrictId], [OfficialAddress], [ResidentialAddress], [PhoneWithExt], [Fax], [Cell], [Email], [Skype], [AnyPreviousTrainingAttended], [PreviousTrainings], [IsFeePaid], [AmountPaid], [PaymentProofDocument], [ApprovalStatus], [IsActive], [OtherOrganization], [OrganizationTypeId]) VALUES (6, 3, N'Mr.', N'Nasir', N'', 0, CAST(N'1948-04-27 19:00:00.000' AS DateTime), 1, 1, NULL, NULL, 1, 1, 55, NULL, NULL, NULL, NULL, NULL, N'nisar83@gmail.com', NULL, 0, NULL, 0, 0, NULL, 1, 0, NULL, 1)
INSERT [dbo].[Participant] ([ParticipantId], [TrainingId], [Title], [Name], [CNIC], [Gender], [DateOfBirth], [HasSpecialAbility], [OrganizationId], [Designation], [BPSNo], [YearsOfExperience], [AcademicQualificationId], [DistrictId], [OfficialAddress], [ResidentialAddress], [PhoneWithExt], [Fax], [Cell], [Email], [Skype], [AnyPreviousTrainingAttended], [PreviousTrainings], [IsFeePaid], [AmountPaid], [PaymentProofDocument], [ApprovalStatus], [IsActive], [OtherOrganization], [OrganizationTypeId]) VALUES (7, 5, N'Mr.', N'Saira Khan', NULL, 1, CAST(N'1973-08-07 19:00:00.000' AS DateTime), 1, 3, NULL, 17, 5, 7, 55, NULL, NULL, NULL, NULL, NULL, N'nisar83@gmail.com', NULL, 1, N'', 0, 0, NULL, 1, 0, N'', 6)
INSERT [dbo].[Participant] ([ParticipantId], [TrainingId], [Title], [Name], [CNIC], [Gender], [DateOfBirth], [HasSpecialAbility], [OrganizationId], [Designation], [BPSNo], [YearsOfExperience], [AcademicQualificationId], [DistrictId], [OfficialAddress], [ResidentialAddress], [PhoneWithExt], [Fax], [Cell], [Email], [Skype], [AnyPreviousTrainingAttended], [PreviousTrainings], [IsFeePaid], [AmountPaid], [PaymentProofDocument], [ApprovalStatus], [IsActive], [OtherOrganization], [OrganizationTypeId]) VALUES (8, 1, N'Mr.', N'Jahanzeb', NULL, 0, NULL, 0, NULL, NULL, NULL, 15, 1, 14, NULL, NULL, NULL, NULL, NULL, N'nisar83@gmail.com', NULL, 0, NULL, 0, 0, NULL, 0, 0, NULL, 5)
INSERT [dbo].[Participant] ([ParticipantId], [TrainingId], [Title], [Name], [CNIC], [Gender], [DateOfBirth], [HasSpecialAbility], [OrganizationId], [Designation], [BPSNo], [YearsOfExperience], [AcademicQualificationId], [DistrictId], [OfficialAddress], [ResidentialAddress], [PhoneWithExt], [Fax], [Cell], [Email], [Skype], [AnyPreviousTrainingAttended], [PreviousTrainings], [IsFeePaid], [AmountPaid], [PaymentProofDocument], [ApprovalStatus], [IsActive], [OtherOrganization], [OrganizationTypeId]) VALUES (9, 5, N'Mr.', N'Participant 1', NULL, 1, CAST(N'1967-05-08 19:00:00.000' AS DateTime), 0, 5, NULL, NULL, 5, 1, 55, NULL, NULL, NULL, NULL, NULL, N'nisar83@gmail.com', NULL, 0, N'', 0, 0, NULL, 0, 0, NULL, 1)
INSERT [dbo].[Participant] ([ParticipantId], [TrainingId], [Title], [Name], [CNIC], [Gender], [DateOfBirth], [HasSpecialAbility], [OrganizationId], [Designation], [BPSNo], [YearsOfExperience], [AcademicQualificationId], [DistrictId], [OfficialAddress], [ResidentialAddress], [PhoneWithExt], [Fax], [Cell], [Email], [Skype], [AnyPreviousTrainingAttended], [PreviousTrainings], [IsFeePaid], [AmountPaid], [PaymentProofDocument], [ApprovalStatus], [IsActive], [OtherOrganization], [OrganizationTypeId]) VALUES (10, 5, N'Dr.', N'Ayesha Mumtaz', NULL, 1, CAST(N'1972-05-10 19:00:00.000' AS DateTime), 0, 9, NULL, NULL, 5, 1, 94, NULL, NULL, NULL, NULL, NULL, N'nisar83@gmail.com', NULL, 0, NULL, 0, 0, NULL, 2, 0, N'', 1)
INSERT [dbo].[Participant] ([ParticipantId], [TrainingId], [Title], [Name], [CNIC], [Gender], [DateOfBirth], [HasSpecialAbility], [OrganizationId], [Designation], [BPSNo], [YearsOfExperience], [AcademicQualificationId], [DistrictId], [OfficialAddress], [ResidentialAddress], [PhoneWithExt], [Fax], [Cell], [Email], [Skype], [AnyPreviousTrainingAttended], [PreviousTrainings], [IsFeePaid], [AmountPaid], [PaymentProofDocument], [ApprovalStatus], [IsActive], [OtherOrganization], [OrganizationTypeId]) VALUES (11, 3, N'Mr.', N'Javed Iqbal', NULL, 0, CAST(N'1948-06-07 19:00:00.000' AS DateTime), 0, 5, NULL, NULL, 5, 1, 97, NULL, NULL, NULL, NULL, NULL, N'nisar83@gmail.com', NULL, 0, NULL, 0, 0, NULL, 0, 0, NULL, 1)
INSERT [dbo].[Participant] ([ParticipantId], [TrainingId], [Title], [Name], [CNIC], [Gender], [DateOfBirth], [HasSpecialAbility], [OrganizationId], [Designation], [BPSNo], [YearsOfExperience], [AcademicQualificationId], [DistrictId], [OfficialAddress], [ResidentialAddress], [PhoneWithExt], [Fax], [Cell], [Email], [Skype], [AnyPreviousTrainingAttended], [PreviousTrainings], [IsFeePaid], [AmountPaid], [PaymentProofDocument], [ApprovalStatus], [IsActive], [OtherOrganization], [OrganizationTypeId]) VALUES (12, 2, N'Mrs.', N'Sajida Naeem', NULL, 1, CAST(N'1988-05-05 19:00:00.000' AS DateTime), 1, 1, NULL, 20, 15, 7, 51, NULL, NULL, NULL, NULL, NULL, N'nisar83@gmail.com', NULL, 1, N'Previous Training', 0, 0, NULL, 0, 0, N'', 1)
INSERT [dbo].[Participant] ([ParticipantId], [TrainingId], [Title], [Name], [CNIC], [Gender], [DateOfBirth], [HasSpecialAbility], [OrganizationId], [Designation], [BPSNo], [YearsOfExperience], [AcademicQualificationId], [DistrictId], [OfficialAddress], [ResidentialAddress], [PhoneWithExt], [Fax], [Cell], [Email], [Skype], [AnyPreviousTrainingAttended], [PreviousTrainings], [IsFeePaid], [AmountPaid], [PaymentProofDocument], [ApprovalStatus], [IsActive], [OtherOrganization], [OrganizationTypeId]) VALUES (13, 1, N'Engr.', N'Sultan Ahmad', N'37405-8846151-1', 0, CAST(N'1969-09-15 19:00:00.000' AS DateTime), 0, 5, NULL, NULL, 5, 1, 59, NULL, NULL, NULL, NULL, NULL, N'nisar83@gmail.com', NULL, 0, NULL, 0, 0, NULL, 0, 0, NULL, 1)
INSERT [dbo].[Participant] ([ParticipantId], [TrainingId], [Title], [Name], [CNIC], [Gender], [DateOfBirth], [HasSpecialAbility], [OrganizationId], [Designation], [BPSNo], [YearsOfExperience], [AcademicQualificationId], [DistrictId], [OfficialAddress], [ResidentialAddress], [PhoneWithExt], [Fax], [Cell], [Email], [Skype], [AnyPreviousTrainingAttended], [PreviousTrainings], [IsFeePaid], [AmountPaid], [PaymentProofDocument], [ApprovalStatus], [IsActive], [OtherOrganization], [OrganizationTypeId]) VALUES (14, 3, N'Mr.', N'Participant 1', NULL, 0, NULL, 0, 5, NULL, NULL, 0, 1, 55, NULL, NULL, NULL, NULL, NULL, N'nisar83@gmail.com', NULL, 0, NULL, 0, 0, NULL, 0, 0, NULL, 1)
INSERT [dbo].[Participant] ([ParticipantId], [TrainingId], [Title], [Name], [CNIC], [Gender], [DateOfBirth], [HasSpecialAbility], [OrganizationId], [Designation], [BPSNo], [YearsOfExperience], [AcademicQualificationId], [DistrictId], [OfficialAddress], [ResidentialAddress], [PhoneWithExt], [Fax], [Cell], [Email], [Skype], [AnyPreviousTrainingAttended], [PreviousTrainings], [IsFeePaid], [AmountPaid], [PaymentProofDocument], [ApprovalStatus], [IsActive], [OtherOrganization], [OrganizationTypeId]) VALUES (15, 3, N'Ms.', N'Fatima Gul', NULL, 1, CAST(N'2001-05-08 19:00:00.000' AS DateTime), 0, 5, NULL, NULL, 0, 5, 55, NULL, NULL, NULL, NULL, N'03335258985', N'nisar83@gmail.com', NULL, 0, NULL, 0, 0, NULL, 0, 0, NULL, 1)
SET IDENTITY_INSERT [dbo].[Participant] OFF
INSERT [dbo].[ParticipantDisabilityType] ([ParticipantId], [DisabilityTypeId]) VALUES (2, 1)
INSERT [dbo].[ParticipantDisabilityType] ([ParticipantId], [DisabilityTypeId]) VALUES (2, 3)
INSERT [dbo].[ParticipantDisabilityType] ([ParticipantId], [DisabilityTypeId]) VALUES (7, 3)
INSERT [dbo].[ParticipantDisabilityType] ([ParticipantId], [DisabilityTypeId]) VALUES (12, 3)
INSERT [dbo].[ParticipantDisabilityType] ([ParticipantId], [DisabilityTypeId]) VALUES (2, 4)
INSERT [dbo].[ParticipantDisabilityType] ([ParticipantId], [DisabilityTypeId]) VALUES (6, 4)
INSERT [dbo].[ParticipantDisabilityType] ([ParticipantId], [DisabilityTypeId]) VALUES (12, 6)
SET IDENTITY_INSERT [dbo].[PotentialResourcePerson] ON 

INSERT [dbo].[PotentialResourcePerson] ([PotentialResourcePersonId], [Name], [DeptOrgDesignation], [ContactNoTel], [ContactNoMob], [ContactNoFax], [EmailAddress], [PostalAddress], [TrainingActivityId], [CNIC]) VALUES (1, N'Awab Hasan', N'CEO', N'5515155', N'03335555555', N'', N'awab@ceo.com', N'', 1, NULL)
SET IDENTITY_INSERT [dbo].[PotentialResourcePerson] OFF
SET IDENTITY_INSERT [dbo].[Project] ON 

INSERT [dbo].[Project] ([ProjectId], [OrganizationId], [Name], [Description], [ProjectNumber], [Proposal], [Workplan], [LOA], [OtherDocuments], [IsActive], [StartDate], [EndDate]) VALUES (1, 8, N'DFID Project 1', N'P1 Description', N'P1', N'NDMA_Annual_Report_2012.pdf', N'ndma-logo.jpg', N'NRTD – WFP – ODTKMS – SRS v6 _Module 10_ 4.8.15.pdf', N'usaid-logo.jpg', 1, CAST(N'2015-01-14 00:00:00.000' AS DateTime), CAST(N'2015-08-22 00:00:00.000' AS DateTime))
INSERT [dbo].[Project] ([ProjectId], [OrganizationId], [Name], [Description], [ProjectNumber], [Proposal], [Workplan], [LOA], [OtherDocuments], [IsActive], [StartDate], [EndDate]) VALUES (2, 3, N'USAID Project 2', N'Description P2', N'USAID-P2', NULL, NULL, NULL, NULL, 1, CAST(N'2015-07-20 00:00:00.000' AS DateTime), CAST(N'2016-06-30 00:00:00.000' AS DateTime))
SET IDENTITY_INSERT [dbo].[Project] OFF
SET IDENTITY_INSERT [dbo].[Province] ON 

INSERT [dbo].[Province] ([ProvinceId], [Name], [Description]) VALUES (1, N'AJK', N'Azad Jammu & Kashmir')
INSERT [dbo].[Province] ([ProvinceId], [Name], [Description]) VALUES (2, N'Balochistan', N'')
INSERT [dbo].[Province] ([ProvinceId], [Name], [Description]) VALUES (3, N'FATA', N'')
INSERT [dbo].[Province] ([ProvinceId], [Name], [Description]) VALUES (4, N'Capital', N'Federal Capital Territory')
INSERT [dbo].[Province] ([ProvinceId], [Name], [Description]) VALUES (5, N'GB', N'Gilgit Baltistan')
INSERT [dbo].[Province] ([ProvinceId], [Name], [Description]) VALUES (6, N'KPK', N'Khyber Pakhtunkhwa')
INSERT [dbo].[Province] ([ProvinceId], [Name], [Description]) VALUES (7, N'Punjab', N'')
INSERT [dbo].[Province] ([ProvinceId], [Name], [Description]) VALUES (8, N'Sindh', N'')
SET IDENTITY_INSERT [dbo].[Province] OFF
SET IDENTITY_INSERT [dbo].[Question] ON 

INSERT [dbo].[Question] ([QuestionId], [Type], [BroaderTrainingArea], [Statement], [Choices], [AskReason], [Active], [DateCreated]) VALUES (1, 1, 4, N'Overall the training met my expectations', N'', 1, 1, CAST(N'2015-08-30 00:00:00.000' AS DateTime))
INSERT [dbo].[Question] ([QuestionId], [Type], [BroaderTrainingArea], [Statement], [Choices], [AskReason], [Active], [DateCreated]) VALUES (2, 1, 4, N'Overall the course materials/hand-outs used in presentations were helpful and well-designed', N'', 1, 1, CAST(N'2015-08-30 00:00:00.000' AS DateTime))
INSERT [dbo].[Question] ([QuestionId], [Type], [BroaderTrainingArea], [Statement], [Choices], [AskReason], [Active], [DateCreated]) VALUES (3, 1, 4, N'Overall, the resource persons were very knowledgeable on the topics', N'', 1, 1, CAST(N'2015-08-30 00:00:00.000' AS DateTime))
INSERT [dbo].[Question] ([QuestionId], [Type], [BroaderTrainingArea], [Statement], [Choices], [AskReason], [Active], [DateCreated]) VALUES (4, 1, 4, N'Overall, the resource persons presentation style was pleasing and well-suited to the content', N'', 1, 1, CAST(N'2015-08-30 00:00:00.000' AS DateTime))
INSERT [dbo].[Question] ([QuestionId], [Type], [BroaderTrainingArea], [Statement], [Choices], [AskReason], [Active], [DateCreated]) VALUES (5, 1, 4, N'Was the duration of training appropriate?', N'', 1, 1, CAST(N'2015-08-30 00:00:00.000' AS DateTime))
INSERT [dbo].[Question] ([QuestionId], [Type], [BroaderTrainingArea], [Statement], [Choices], [AskReason], [Active], [DateCreated]) VALUES (6, 4, 4, N'Which sessions were useful for you (title of the sessions)?', N'', 0, 1, CAST(N'2015-08-30 00:00:00.000' AS DateTime))
INSERT [dbo].[Question] ([QuestionId], [Type], [BroaderTrainingArea], [Statement], [Choices], [AskReason], [Active], [DateCreated]) VALUES (7, 4, 4, N'Which sessions were not useful for you and why (title of the sessions)?', N'', 0, 1, CAST(N'2015-08-30 00:00:00.000' AS DateTime))
INSERT [dbo].[Question] ([QuestionId], [Type], [BroaderTrainingArea], [Statement], [Choices], [AskReason], [Active], [DateCreated]) VALUES (8, 4, 4, N'Which topic/session should be added into the training?', N'', 0, 1, CAST(N'2015-08-30 00:00:00.000' AS DateTime))
INSERT [dbo].[Question] ([QuestionId], [Type], [BroaderTrainingArea], [Statement], [Choices], [AskReason], [Active], [DateCreated]) VALUES (9, 4, 4, N'What change has the workshop brought to you? What were your knowledge and experience like before the workshop and what did you learn?', N'', 0, 1, CAST(N'2015-08-30 00:00:00.000' AS DateTime))
INSERT [dbo].[Question] ([QuestionId], [Type], [BroaderTrainingArea], [Statement], [Choices], [AskReason], [Active], [DateCreated]) VALUES (10, 4, 4, N'What were the gaps in the training you observed and what are your suggestions to improve it?', N'', 0, 1, CAST(N'2015-08-30 00:00:00.000' AS DateTime))
INSERT [dbo].[Question] ([QuestionId], [Type], [BroaderTrainingArea], [Statement], [Choices], [AskReason], [Active], [DateCreated]) VALUES (11, 4, 4, N'Any additional comments and suggestions for overall improvement of the course', N'', 0, 1, CAST(N'2015-08-30 00:00:00.000' AS DateTime))
INSERT [dbo].[Question] ([QuestionId], [Type], [BroaderTrainingArea], [Statement], [Choices], [AskReason], [Active], [DateCreated]) VALUES (12, 0, 2, N'Yes/No Question', NULL, 0, 0, CAST(N'2015-09-14 21:11:41.157' AS DateTime))
INSERT [dbo].[Question] ([QuestionId], [Type], [BroaderTrainingArea], [Statement], [Choices], [AskReason], [Active], [DateCreated]) VALUES (13, 2, 1, N'Satisfaction', NULL, 1, 1, CAST(N'2015-09-14 23:48:55.197' AS DateTime))
INSERT [dbo].[Question] ([QuestionId], [Type], [BroaderTrainingArea], [Statement], [Choices], [AskReason], [Active], [DateCreated]) VALUES (14, 3, 3, N'Interest', NULL, 1, 1, CAST(N'2015-09-14 23:49:19.580' AS DateTime))
INSERT [dbo].[Question] ([QuestionId], [Type], [BroaderTrainingArea], [Statement], [Choices], [AskReason], [Active], [DateCreated]) VALUES (15, 5, 0, N'CheckBoxes', N'1,2,3,4,5', 0, 1, CAST(N'2015-09-14 23:49:58.457' AS DateTime))
INSERT [dbo].[Question] ([QuestionId], [Type], [BroaderTrainingArea], [Statement], [Choices], [AskReason], [Active], [DateCreated]) VALUES (16, 6, 3, N'Percentages', N'1,2,3', 0, 1, CAST(N'2015-09-14 23:50:24.870' AS DateTime))
INSERT [dbo].[Question] ([QuestionId], [Type], [BroaderTrainingArea], [Statement], [Choices], [AskReason], [Active], [DateCreated]) VALUES (17, 7, 2, N'TextBoxes', N'1,2,3,4,5,6,7,8,9,10', 0, 1, CAST(N'2015-09-14 23:50:52.047' AS DateTime))
SET IDENTITY_INSERT [dbo].[Question] OFF
SET IDENTITY_INSERT [dbo].[ResourcePerson] ON 

INSERT [dbo].[ResourcePerson] ([ResourcePersonId], [Title], [Name], [Gender], [DateOfBirth], [HasSpecialAbility], [OrganizationId], [BPSNo], [YearsOfExperience], [AcademicQualificationId], [DistrictId], [OfficialAddress], [ResidentialAddress], [PhoneWithExt], [Fax], [Cell], [Email], [Skype], [BankName], [BranchName], [BranchCode], [AccountTitle], [AccountNo], [AccountType], [IBAN], [ApprovalStatus], [Resume], [Photo], [CNIC], [Designation], [IsActive], [OtherOrganization], [OrganizationTypeId]) VALUES (1, N'Mr.', N'Waseem', 0, CAST(N'1980-07-11 00:00:00.000' AS DateTime), 1, 1, 18, 10, 5, 116, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, 1, N'NDM_ACT_2010.pdf', N'waseem_ahmed.jpg', NULL, NULL, 1, N'', 1)
INSERT [dbo].[ResourcePerson] ([ResourcePersonId], [Title], [Name], [Gender], [DateOfBirth], [HasSpecialAbility], [OrganizationId], [BPSNo], [YearsOfExperience], [AcademicQualificationId], [DistrictId], [OfficialAddress], [ResidentialAddress], [PhoneWithExt], [Fax], [Cell], [Email], [Skype], [BankName], [BranchName], [BranchCode], [AccountTitle], [AccountNo], [AccountType], [IBAN], [ApprovalStatus], [Resume], [Photo], [CNIC], [Designation], [IsActive], [OtherOrganization], [OrganizationTypeId]) VALUES (2, N'Dr.', N'Nisar Ahmad', 0, CAST(N'1985-07-08 00:00:00.000' AS DateTime), 1, 1, 22, 10, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'', NULL, 1, NULL, 1, N'NDMA_Annual_Report_2012.pdf', N'aaron_skonnard.jpg', NULL, NULL, 1, NULL, 2)
INSERT [dbo].[ResourcePerson] ([ResourcePersonId], [Title], [Name], [Gender], [DateOfBirth], [HasSpecialAbility], [OrganizationId], [BPSNo], [YearsOfExperience], [AcademicQualificationId], [DistrictId], [OfficialAddress], [ResidentialAddress], [PhoneWithExt], [Fax], [Cell], [Email], [Skype], [BankName], [BranchName], [BranchCode], [AccountTitle], [AccountNo], [AccountType], [IBAN], [ApprovalStatus], [Resume], [Photo], [CNIC], [Designation], [IsActive], [OtherOrganization], [OrganizationTypeId]) VALUES (3, N'Ms.', N'Shaista Lodhi', 1, CAST(N'1980-07-23 00:00:00.000' AS DateTime), 0, 1, NULL, 5, 3, 10, N'Home', N'Home', N'051 5587932', NULL, N'0333 5984126', N'shaista@lodhi.com', N'hello1', N'HBL', N'Blue Area', N'051', N'Shaista Lodhi', N'01-55541841-01', 1, N'015615151548415', 0, N'NDM_ACT_2010 (1).pdf', N'julie_lerman.jpg', NULL, NULL, 1, N'', 1)
INSERT [dbo].[ResourcePerson] ([ResourcePersonId], [Title], [Name], [Gender], [DateOfBirth], [HasSpecialAbility], [OrganizationId], [BPSNo], [YearsOfExperience], [AcademicQualificationId], [DistrictId], [OfficialAddress], [ResidentialAddress], [PhoneWithExt], [Fax], [Cell], [Email], [Skype], [BankName], [BranchName], [BranchCode], [AccountTitle], [AccountNo], [AccountType], [IBAN], [ApprovalStatus], [Resume], [Photo], [CNIC], [Designation], [IsActive], [OtherOrganization], [OrganizationTypeId]) VALUES (4, N'Mr.', N'Khalid', 0, CAST(N'1990-07-06 00:00:00.000' AS DateTime), 0, 1, 5, 10, 1, 28, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, 2, N'Hydrangeas.jpg', N'ryan_niemeyer.jpg', NULL, NULL, 1, N'', 1)
INSERT [dbo].[ResourcePerson] ([ResourcePersonId], [Title], [Name], [Gender], [DateOfBirth], [HasSpecialAbility], [OrganizationId], [BPSNo], [YearsOfExperience], [AcademicQualificationId], [DistrictId], [OfficialAddress], [ResidentialAddress], [PhoneWithExt], [Fax], [Cell], [Email], [Skype], [BankName], [BranchName], [BranchCode], [AccountTitle], [AccountNo], [AccountType], [IBAN], [ApprovalStatus], [Resume], [Photo], [CNIC], [Designation], [IsActive], [OtherOrganization], [OrganizationTypeId]) VALUES (5, N'Dr.', N'Syed Awab Hasan', 0, CAST(N'1970-07-28 00:00:00.000' AS DateTime), 0, 2, NULL, 5, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, NULL, N'shawn_wildermuth.jpg', NULL, NULL, 1, N'', 2)
INSERT [dbo].[ResourcePerson] ([ResourcePersonId], [Title], [Name], [Gender], [DateOfBirth], [HasSpecialAbility], [OrganizationId], [BPSNo], [YearsOfExperience], [AcademicQualificationId], [DistrictId], [OfficialAddress], [ResidentialAddress], [PhoneWithExt], [Fax], [Cell], [Email], [Skype], [BankName], [BranchName], [BranchCode], [AccountTitle], [AccountNo], [AccountType], [IBAN], [ApprovalStatus], [Resume], [Photo], [CNIC], [Designation], [IsActive], [OtherOrganization], [OrganizationTypeId]) VALUES (6, N'Mr.', N'Haris Khan', 0, CAST(N'1962-05-15 19:00:00.000' AS DateTime), 1, 4, 4, 6, 1, 88, N'7867876', N'67867', N'8678678', N'67867', N'867867', N'nisar83@gmail.com', NULL, N'665', N'yu', N'ghj', N'ghj', N'ghj', 0, N'sdfsd', 0, NULL, N'eric_barnard.jpg', NULL, NULL, 1, N'', 2)
INSERT [dbo].[ResourcePerson] ([ResourcePersonId], [Title], [Name], [Gender], [DateOfBirth], [HasSpecialAbility], [OrganizationId], [BPSNo], [YearsOfExperience], [AcademicQualificationId], [DistrictId], [OfficialAddress], [ResidentialAddress], [PhoneWithExt], [Fax], [Cell], [Email], [Skype], [BankName], [BranchName], [BranchCode], [AccountTitle], [AccountNo], [AccountType], [IBAN], [ApprovalStatus], [Resume], [Photo], [CNIC], [Designation], [IsActive], [OtherOrganization], [OrganizationTypeId]) VALUES (7, N'Ms.', N'Hameeda', 1, CAST(N'1968-05-08 19:00:00.000' AS DateTime), 1, 4, 12, 20, 6, 116, N'6456', N'54654', N'546', N'ss', N'dds', N'nisar@prohelix.com', NULL, N'6546', N'54654', N'356', N'6456', N'645', 0, N'', 0, N'NRTD – WFP – ODTKMS – SRS v6 _Module 10_ 4.8.15 (1).pdf', N'colleen_papa.jpg', NULL, NULL, 0, N'', 2)
INSERT [dbo].[ResourcePerson] ([ResourcePersonId], [Title], [Name], [Gender], [DateOfBirth], [HasSpecialAbility], [OrganizationId], [BPSNo], [YearsOfExperience], [AcademicQualificationId], [DistrictId], [OfficialAddress], [ResidentialAddress], [PhoneWithExt], [Fax], [Cell], [Email], [Skype], [BankName], [BranchName], [BranchCode], [AccountTitle], [AccountNo], [AccountType], [IBAN], [ApprovalStatus], [Resume], [Photo], [CNIC], [Designation], [IsActive], [OtherOrganization], [OrganizationTypeId]) VALUES (8, N'Mr.', N'Haris Baig', 0, CAST(N'2015-08-11 19:00:00.000' AS DateTime), 0, 5, NULL, 50, 1, 55, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, N'', 0, N'NDMA_Annual_Report_2012 (1).pdf', N'aaron_skonnard (1).jpg', NULL, NULL, 0, NULL, 1)
INSERT [dbo].[ResourcePerson] ([ResourcePersonId], [Title], [Name], [Gender], [DateOfBirth], [HasSpecialAbility], [OrganizationId], [BPSNo], [YearsOfExperience], [AcademicQualificationId], [DistrictId], [OfficialAddress], [ResidentialAddress], [PhoneWithExt], [Fax], [Cell], [Email], [Skype], [BankName], [BranchName], [BranchCode], [AccountTitle], [AccountNo], [AccountType], [IBAN], [ApprovalStatus], [Resume], [Photo], [CNIC], [Designation], [IsActive], [OtherOrganization], [OrganizationTypeId]) VALUES (9, N'Mr.', N'Imran Khan', 0, CAST(N'1983-08-08 19:00:00.000' AS DateTime), 0, 5, NULL, 5, 1, 55, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, N'jghj', 0, NULL, N'elijah_manor.jpg', NULL, NULL, 0, NULL, 1)
INSERT [dbo].[ResourcePerson] ([ResourcePersonId], [Title], [Name], [Gender], [DateOfBirth], [HasSpecialAbility], [OrganizationId], [BPSNo], [YearsOfExperience], [AcademicQualificationId], [DistrictId], [OfficialAddress], [ResidentialAddress], [PhoneWithExt], [Fax], [Cell], [Email], [Skype], [BankName], [BranchName], [BranchCode], [AccountTitle], [AccountNo], [AccountType], [IBAN], [ApprovalStatus], [Resume], [Photo], [CNIC], [Designation], [IsActive], [OtherOrganization], [OrganizationTypeId]) VALUES (10, N'Mr.', N'Sajid Nawaz', 0, CAST(N'2002-05-13 19:00:00.000' AS DateTime), 0, 5, NULL, 10, 1, 55, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, N'NRTD – WFP – ODTKMS – SRS v6 _Module 10_ 4.8.15.pdf', N'dave_ward.jpg', NULL, NULL, 0, NULL, 1)
SET IDENTITY_INSERT [dbo].[ResourcePerson] OFF
INSERT [dbo].[ResourcePersonArea] ([ResourcePersonId], [AreaId]) VALUES (7, 2)
INSERT [dbo].[ResourcePersonArea] ([ResourcePersonId], [AreaId]) VALUES (6, 3)
INSERT [dbo].[ResourcePersonArea] ([ResourcePersonId], [AreaId]) VALUES (8, 3)
INSERT [dbo].[ResourcePersonArea] ([ResourcePersonId], [AreaId]) VALUES (7, 4)
INSERT [dbo].[ResourcePersonDisabilityType] ([ResourcePersonId], [DisabilityTypeId]) VALUES (2, 2)
INSERT [dbo].[ResourcePersonDisabilityType] ([ResourcePersonId], [DisabilityTypeId]) VALUES (2, 3)
INSERT [dbo].[ResourcePersonDisabilityType] ([ResourcePersonId], [DisabilityTypeId]) VALUES (6, 3)
INSERT [dbo].[ResourcePersonDisabilityType] ([ResourcePersonId], [DisabilityTypeId]) VALUES (2, 4)
INSERT [dbo].[ResourcePersonDisabilityType] ([ResourcePersonId], [DisabilityTypeId]) VALUES (7, 5)
INSERT [dbo].[ResourcePersonDisabilityType] ([ResourcePersonId], [DisabilityTypeId]) VALUES (2, 6)
INSERT [dbo].[ResourcePersonTraining] ([ResourcePersonId], [TrainingSessionId], [IsPaid], [AmountPaid]) VALUES (2, 1, 1, 50000)
INSERT [dbo].[ResourcePersonTraining] ([ResourcePersonId], [TrainingSessionId], [IsPaid], [AmountPaid]) VALUES (2, 5, 1, 500)
INSERT [dbo].[ResourcePersonTraining] ([ResourcePersonId], [TrainingSessionId], [IsPaid], [AmountPaid]) VALUES (5, 1, 1, 1000)
INSERT [dbo].[ResourcePersonTraining] ([ResourcePersonId], [TrainingSessionId], [IsPaid], [AmountPaid]) VALUES (7, 1, 1, 2000)
SET IDENTITY_INSERT [dbo].[Respondent] ON 

INSERT [dbo].[Respondent] ([RespondentId], [Title], [Name], [CNIC], [Gender], [DateOfBirth], [HasSpecialAbility], [OrganizationTypeId], [OrganizationId], [OtherOrganization], [Designation], [BPSNo], [YearsOfExperience], [AcademicQualificationId], [DistrictId], [OfficialAddress], [ResidentialAddress], [PhoneWithExt], [Fax], [Cell], [Email], [Skype], [ApprovalStatus], [IsActive]) VALUES (1, N'Mr.', N'Nisar Ahmad', N'37405-8871125-3', 0, CAST(N'1983-04-22 19:00:00.000' AS DateTime), 1, 3, NULL, N'FAST', N'Professor', 18, 10, 6, 55, N'G-9/4', N'Home', N'+92-51-5552151 Ext 57', N'051-11512151', N'0333-5556161', N'nisar@prohelix.com', N'talk2nisar', 0, 0)
INSERT [dbo].[Respondent] ([RespondentId], [Title], [Name], [CNIC], [Gender], [DateOfBirth], [HasSpecialAbility], [OrganizationTypeId], [OrganizationId], [OtherOrganization], [Designation], [BPSNo], [YearsOfExperience], [AcademicQualificationId], [DistrictId], [OfficialAddress], [ResidentialAddress], [PhoneWithExt], [Fax], [Cell], [Email], [Skype], [ApprovalStatus], [IsActive]) VALUES (2, N'Mr.', N'Syed Awab Hasan', NULL, 0, NULL, 0, 1, 9, N'', NULL, NULL, 5, 6, 55, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0)
INSERT [dbo].[Respondent] ([RespondentId], [Title], [Name], [CNIC], [Gender], [DateOfBirth], [HasSpecialAbility], [OrganizationTypeId], [OrganizationId], [OtherOrganization], [Designation], [BPSNo], [YearsOfExperience], [AcademicQualificationId], [DistrictId], [OfficialAddress], [ResidentialAddress], [PhoneWithExt], [Fax], [Cell], [Email], [Skype], [ApprovalStatus], [IsActive]) VALUES (3, N'Mr.', N'Respondent 1', NULL, 0, NULL, 0, 1, 5, NULL, NULL, NULL, 5, 1, 55, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0)
INSERT [dbo].[Respondent] ([RespondentId], [Title], [Name], [CNIC], [Gender], [DateOfBirth], [HasSpecialAbility], [OrganizationTypeId], [OrganizationId], [OtherOrganization], [Designation], [BPSNo], [YearsOfExperience], [AcademicQualificationId], [DistrictId], [OfficialAddress], [ResidentialAddress], [PhoneWithExt], [Fax], [Cell], [Email], [Skype], [ApprovalStatus], [IsActive]) VALUES (4, N'Mr.', N'Respondent 2', NULL, 0, NULL, 0, 1, 5, NULL, NULL, NULL, 5, 1, 55, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0)
INSERT [dbo].[Respondent] ([RespondentId], [Title], [Name], [CNIC], [Gender], [DateOfBirth], [HasSpecialAbility], [OrganizationTypeId], [OrganizationId], [OtherOrganization], [Designation], [BPSNo], [YearsOfExperience], [AcademicQualificationId], [DistrictId], [OfficialAddress], [ResidentialAddress], [PhoneWithExt], [Fax], [Cell], [Email], [Skype], [ApprovalStatus], [IsActive]) VALUES (5, N'Mr.', N'Haris Baig', NULL, 0, NULL, 0, 1, 5, NULL, NULL, NULL, 7, 1, 92, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0)
SET IDENTITY_INSERT [dbo].[Respondent] OFF
INSERT [dbo].[RespondentDisabilityType] ([RespondentId], [DisabilityTypeId]) VALUES (1, 3)
INSERT [dbo].[RespondentDisabilityType] ([RespondentId], [DisabilityTypeId]) VALUES (1, 4)
SET IDENTITY_INSERT [dbo].[Survey] ON 

INSERT [dbo].[Survey] ([SurveyId], [Name], [Description], [WelcomeMessage], [ExitMessage], [Active], [StartDate], [EndDate]) VALUES (1, N'Training Evaluation', N'Default Survey for all Training Evaluations done by Participants', N'Please take a minute to provide us with your valuable feedback regarding the training you attended.', N'Thank you for participating in this survey!', 1, NULL, NULL)
INSERT [dbo].[Survey] ([SurveyId], [Name], [Description], [WelcomeMessage], [ExitMessage], [Active], [StartDate], [EndDate]) VALUES (2, N'Test Survey', N'Description', N'Welcome, please take a moment to provide your valuable feedback.', N'Thank you for your valuable feedback!', 1, NULL, NULL)
INSERT [dbo].[Survey] ([SurveyId], [Name], [Description], [WelcomeMessage], [ExitMessage], [Active], [StartDate], [EndDate]) VALUES (3, N'Mitigation Needs Assessment', N'Mitigation Needs Assessment', N'Welcome, please take a moment to provide your valuable feedback.', N'Thank you for your valuable feedback!', 1, NULL, NULL)
SET IDENTITY_INSERT [dbo].[Survey] OFF
INSERT [dbo].[SurveyQuestion] ([SurveyId], [QuestionId]) VALUES (1, 1)
INSERT [dbo].[SurveyQuestion] ([SurveyId], [QuestionId]) VALUES (2, 1)
INSERT [dbo].[SurveyQuestion] ([SurveyId], [QuestionId]) VALUES (3, 1)
INSERT [dbo].[SurveyQuestion] ([SurveyId], [QuestionId]) VALUES (1, 2)
INSERT [dbo].[SurveyQuestion] ([SurveyId], [QuestionId]) VALUES (1, 3)
INSERT [dbo].[SurveyQuestion] ([SurveyId], [QuestionId]) VALUES (3, 3)
INSERT [dbo].[SurveyQuestion] ([SurveyId], [QuestionId]) VALUES (1, 4)
INSERT [dbo].[SurveyQuestion] ([SurveyId], [QuestionId]) VALUES (1, 5)
INSERT [dbo].[SurveyQuestion] ([SurveyId], [QuestionId]) VALUES (1, 6)
INSERT [dbo].[SurveyQuestion] ([SurveyId], [QuestionId]) VALUES (2, 6)
INSERT [dbo].[SurveyQuestion] ([SurveyId], [QuestionId]) VALUES (3, 6)
INSERT [dbo].[SurveyQuestion] ([SurveyId], [QuestionId]) VALUES (1, 7)
INSERT [dbo].[SurveyQuestion] ([SurveyId], [QuestionId]) VALUES (1, 8)
INSERT [dbo].[SurveyQuestion] ([SurveyId], [QuestionId]) VALUES (1, 9)
INSERT [dbo].[SurveyQuestion] ([SurveyId], [QuestionId]) VALUES (1, 10)
INSERT [dbo].[SurveyQuestion] ([SurveyId], [QuestionId]) VALUES (3, 10)
INSERT [dbo].[SurveyQuestion] ([SurveyId], [QuestionId]) VALUES (1, 11)
INSERT [dbo].[SurveyQuestion] ([SurveyId], [QuestionId]) VALUES (1, 12)
INSERT [dbo].[SurveyQuestion] ([SurveyId], [QuestionId]) VALUES (2, 12)
INSERT [dbo].[SurveyQuestion] ([SurveyId], [QuestionId]) VALUES (3, 12)
INSERT [dbo].[SurveyQuestion] ([SurveyId], [QuestionId]) VALUES (1, 13)
INSERT [dbo].[SurveyQuestion] ([SurveyId], [QuestionId]) VALUES (2, 13)
INSERT [dbo].[SurveyQuestion] ([SurveyId], [QuestionId]) VALUES (3, 13)
INSERT [dbo].[SurveyQuestion] ([SurveyId], [QuestionId]) VALUES (1, 14)
INSERT [dbo].[SurveyQuestion] ([SurveyId], [QuestionId]) VALUES (2, 14)
INSERT [dbo].[SurveyQuestion] ([SurveyId], [QuestionId]) VALUES (3, 14)
INSERT [dbo].[SurveyQuestion] ([SurveyId], [QuestionId]) VALUES (1, 15)
INSERT [dbo].[SurveyQuestion] ([SurveyId], [QuestionId]) VALUES (2, 15)
INSERT [dbo].[SurveyQuestion] ([SurveyId], [QuestionId]) VALUES (3, 15)
INSERT [dbo].[SurveyQuestion] ([SurveyId], [QuestionId]) VALUES (1, 16)
INSERT [dbo].[SurveyQuestion] ([SurveyId], [QuestionId]) VALUES (2, 16)
INSERT [dbo].[SurveyQuestion] ([SurveyId], [QuestionId]) VALUES (3, 16)
INSERT [dbo].[SurveyQuestion] ([SurveyId], [QuestionId]) VALUES (1, 17)
INSERT [dbo].[SurveyQuestion] ([SurveyId], [QuestionId]) VALUES (2, 17)
INSERT [dbo].[SurveyQuestionResponse] ([SurveyId], [QuestionId], [RespondentId], [Response], [Reason], [ResponseDate]) VALUES (2, 1, 5, N'2', N'wer', CAST(N'2015-09-15 05:28:42.000' AS DateTime))
INSERT [dbo].[SurveyQuestionResponse] ([SurveyId], [QuestionId], [RespondentId], [Response], [Reason], [ResponseDate]) VALUES (2, 2, 5, N'2', N'sdfsd', CAST(N'2015-09-15 05:28:42.000' AS DateTime))
INSERT [dbo].[SurveyQuestionResponse] ([SurveyId], [QuestionId], [RespondentId], [Response], [Reason], [ResponseDate]) VALUES (2, 3, 5, N'0', N'sdf', CAST(N'2015-09-15 05:28:42.000' AS DateTime))
INSERT [dbo].[SurveyQuestionResponse] ([SurveyId], [QuestionId], [RespondentId], [Response], [Reason], [ResponseDate]) VALUES (2, 4, 5, N'2', N'sdfsd', CAST(N'2015-09-15 05:28:42.000' AS DateTime))
INSERT [dbo].[SurveyQuestionResponse] ([SurveyId], [QuestionId], [RespondentId], [Response], [Reason], [ResponseDate]) VALUES (2, 5, 5, N'2', N'sf', CAST(N'2015-09-15 05:28:42.000' AS DateTime))
INSERT [dbo].[SurveyQuestionResponse] ([SurveyId], [QuestionId], [RespondentId], [Response], [Reason], [ResponseDate]) VALUES (2, 6, 5, NULL, N'sdf', CAST(N'2015-09-15 05:28:42.000' AS DateTime))
INSERT [dbo].[SurveyQuestionResponse] ([SurveyId], [QuestionId], [RespondentId], [Response], [Reason], [ResponseDate]) VALUES (2, 7, 5, NULL, N'sdf', CAST(N'2015-09-15 05:28:42.000' AS DateTime))
INSERT [dbo].[SurveyQuestionResponse] ([SurveyId], [QuestionId], [RespondentId], [Response], [Reason], [ResponseDate]) VALUES (2, 8, 4, NULL, N'ssdf', CAST(N'2015-09-15 05:23:59.740' AS DateTime))
INSERT [dbo].[SurveyQuestionResponse] ([SurveyId], [QuestionId], [RespondentId], [Response], [Reason], [ResponseDate]) VALUES (2, 8, 5, NULL, N'sdf', CAST(N'2015-09-15 05:28:42.000' AS DateTime))
INSERT [dbo].[SurveyQuestionResponse] ([SurveyId], [QuestionId], [RespondentId], [Response], [Reason], [ResponseDate]) VALUES (2, 9, 4, NULL, N'sf', CAST(N'2015-09-15 05:23:59.743' AS DateTime))
INSERT [dbo].[SurveyQuestionResponse] ([SurveyId], [QuestionId], [RespondentId], [Response], [Reason], [ResponseDate]) VALUES (2, 9, 5, NULL, N'ssd', CAST(N'2015-09-15 05:28:42.000' AS DateTime))
INSERT [dbo].[SurveyQuestionResponse] ([SurveyId], [QuestionId], [RespondentId], [Response], [Reason], [ResponseDate]) VALUES (2, 10, 4, NULL, N'sdf', CAST(N'2015-09-15 05:23:59.743' AS DateTime))
INSERT [dbo].[SurveyQuestionResponse] ([SurveyId], [QuestionId], [RespondentId], [Response], [Reason], [ResponseDate]) VALUES (2, 10, 5, NULL, N'sdf', CAST(N'2015-09-15 05:28:42.000' AS DateTime))
INSERT [dbo].[SurveyQuestionResponse] ([SurveyId], [QuestionId], [RespondentId], [Response], [Reason], [ResponseDate]) VALUES (2, 11, 5, NULL, N'sdf', CAST(N'2015-09-15 05:28:42.000' AS DateTime))
INSERT [dbo].[SurveyQuestionResponse] ([SurveyId], [QuestionId], [RespondentId], [Response], [Reason], [ResponseDate]) VALUES (2, 12, 4, N'0', NULL, CAST(N'2015-09-15 05:23:59.747' AS DateTime))
INSERT [dbo].[SurveyQuestionResponse] ([SurveyId], [QuestionId], [RespondentId], [Response], [Reason], [ResponseDate]) VALUES (2, 12, 5, N'0', NULL, CAST(N'2015-09-15 05:28:42.000' AS DateTime))
INSERT [dbo].[SurveyQuestionResponse] ([SurveyId], [QuestionId], [RespondentId], [Response], [Reason], [ResponseDate]) VALUES (2, 13, 5, N'2', N'sdf', CAST(N'2015-09-15 05:28:42.000' AS DateTime))
INSERT [dbo].[SurveyQuestionResponse] ([SurveyId], [QuestionId], [RespondentId], [Response], [Reason], [ResponseDate]) VALUES (2, 14, 5, N'3', N'sdfs', CAST(N'2015-09-15 05:28:42.000' AS DateTime))
INSERT [dbo].[SurveyQuestionResponse] ([SurveyId], [QuestionId], [RespondentId], [Response], [Reason], [ResponseDate]) VALUES (2, 15, 5, N'|true||true|true', NULL, CAST(N'2015-09-15 05:28:42.000' AS DateTime))
INSERT [dbo].[SurveyQuestionResponse] ([SurveyId], [QuestionId], [RespondentId], [Response], [Reason], [ResponseDate]) VALUES (2, 16, 5, N'34|43|34', NULL, CAST(N'2015-09-15 05:28:42.000' AS DateTime))
INSERT [dbo].[SurveyQuestionResponse] ([SurveyId], [QuestionId], [RespondentId], [Response], [Reason], [ResponseDate]) VALUES (2, 17, 5, N'erwe|wer|rwe|wrwer|werwerwe|werwe|rwe|rwerwe|rwe|r', NULL, CAST(N'2015-09-15 05:28:42.000' AS DateTime))
INSERT [dbo].[SurveyQuestionResponse] ([SurveyId], [QuestionId], [RespondentId], [Response], [Reason], [ResponseDate]) VALUES (3, 1, 3, N'4', N'34', CAST(N'2015-09-15 05:34:51.000' AS DateTime))
INSERT [dbo].[SurveyQuestionResponse] ([SurveyId], [QuestionId], [RespondentId], [Response], [Reason], [ResponseDate]) VALUES (3, 3, 3, N'4', N'343', CAST(N'2015-09-15 05:34:51.000' AS DateTime))
INSERT [dbo].[SurveyQuestionResponse] ([SurveyId], [QuestionId], [RespondentId], [Response], [Reason], [ResponseDate]) VALUES (3, 6, 3, NULL, N'34', CAST(N'2015-09-15 05:34:51.000' AS DateTime))
INSERT [dbo].[SurveyQuestionResponse] ([SurveyId], [QuestionId], [RespondentId], [Response], [Reason], [ResponseDate]) VALUES (3, 10, 3, NULL, N'34', CAST(N'2015-09-15 05:34:51.000' AS DateTime))
INSERT [dbo].[SurveyQuestionResponse] ([SurveyId], [QuestionId], [RespondentId], [Response], [Reason], [ResponseDate]) VALUES (3, 12, 3, N'0', NULL, CAST(N'2015-09-15 05:34:51.000' AS DateTime))
INSERT [dbo].[SurveyQuestionResponse] ([SurveyId], [QuestionId], [RespondentId], [Response], [Reason], [ResponseDate]) VALUES (3, 13, 3, N'1', N'43', CAST(N'2015-09-15 05:34:51.000' AS DateTime))
INSERT [dbo].[SurveyQuestionResponse] ([SurveyId], [QuestionId], [RespondentId], [Response], [Reason], [ResponseDate]) VALUES (3, 14, 3, N'4', N'34', CAST(N'2015-09-15 05:34:51.000' AS DateTime))
INSERT [dbo].[SurveyQuestionResponse] ([SurveyId], [QuestionId], [RespondentId], [Response], [Reason], [ResponseDate]) VALUES (3, 15, 3, N'true|||true|true', NULL, CAST(N'2015-09-15 05:34:51.000' AS DateTime))
INSERT [dbo].[SurveyQuestionResponse] ([SurveyId], [QuestionId], [RespondentId], [Response], [Reason], [ResponseDate]) VALUES (3, 16, 3, N'43|53|4', NULL, CAST(N'2015-09-15 05:34:51.000' AS DateTime))
SET IDENTITY_INSERT [dbo].[ThematicArea] ON 

INSERT [dbo].[ThematicArea] ([ThematicAreaId], [Name], [Description]) VALUES (1, N'DRR', NULL)
INSERT [dbo].[ThematicArea] ([ThematicAreaId], [Name], [Description]) VALUES (2, N'Protection', NULL)
INSERT [dbo].[ThematicArea] ([ThematicAreaId], [Name], [Description]) VALUES (3, N'Gender', NULL)
INSERT [dbo].[ThematicArea] ([ThematicAreaId], [Name], [Description]) VALUES (4, N'Disability', N'Disability')
INSERT [dbo].[ThematicArea] ([ThematicAreaId], [Name], [Description]) VALUES (5, N'Human Development', NULL)
SET IDENTITY_INSERT [dbo].[ThematicArea] OFF
SET IDENTITY_INSERT [dbo].[Training] ON 

INSERT [dbo].[Training] ([TrainingId], [Description], [Name], [Status], [TrainingType], [TrainingLevel], [BroaderTrainingArea], [StartDate], [EndDate], [Fee], [ProvinceId], [DistrictId], [CityId], [LogisticNote], [ReferenceMaterial], [Location], [Objective], [FeeVoucher], [SurveyId], [DateCreated], [DateModified]) VALUES (1, NULL, N'Disaster Risk Assessment', 3, 0, 0, 0, CAST(N'2015-12-01 00:00:00.000' AS DateTime), CAST(N'2015-12-02 00:00:00.000' AS DateTime), 10000, 8, 129, 129, NULL, NULL, N'67.03857421875 28.69058765425071', NULL, NULL, 1, CAST(N'2015-09-16 12:30:35.603' AS DateTime), CAST(N'2015-09-21 08:03:30.540' AS DateTime))
INSERT [dbo].[Training] ([TrainingId], [Description], [Name], [Status], [TrainingType], [TrainingLevel], [BroaderTrainingArea], [StartDate], [EndDate], [Fee], [ProvinceId], [DistrictId], [CityId], [LogisticNote], [ReferenceMaterial], [Location], [Objective], [FeeVoucher], [SurveyId], [DateCreated], [DateModified]) VALUES (2, NULL, N'Skills Workshop', 2, 0, 0, 0, CAST(N'2015-11-01 00:00:00.000' AS DateTime), CAST(N'2015-11-01 00:00:00.000' AS DateTime), 1000, 7, 103, 103, NULL, NULL, N'67.52197265625 24.726874870506972', NULL, NULL, 1, CAST(N'2015-09-16 12:30:35.603' AS DateTime), CAST(N'2015-12-02 00:00:00.000' AS DateTime))
INSERT [dbo].[Training] ([TrainingId], [Description], [Name], [Status], [TrainingType], [TrainingLevel], [BroaderTrainingArea], [StartDate], [EndDate], [Fee], [ProvinceId], [DistrictId], [CityId], [LogisticNote], [ReferenceMaterial], [Location], [Objective], [FeeVoucher], [SurveyId], [DateCreated], [DateModified]) VALUES (3, NULL, N'Disaster Mitigation', 4, 1, 1, 0, CAST(N'2015-05-01 00:00:00.000' AS DateTime), CAST(N'2015-05-02 00:00:00.000' AS DateTime), 5000, 4, 55, 55, NULL, NULL, N'73.048095703125 33.815666308702774', NULL, NULL, 1, CAST(N'2015-09-16 12:30:35.603' AS DateTime), CAST(N'2015-12-02 00:00:00.000' AS DateTime))
INSERT [dbo].[Training] ([TrainingId], [Description], [Name], [Status], [TrainingType], [TrainingLevel], [BroaderTrainingArea], [StartDate], [EndDate], [Fee], [ProvinceId], [DistrictId], [CityId], [LogisticNote], [ReferenceMaterial], [Location], [Objective], [FeeVoucher], [SurveyId], [DateCreated], [DateModified]) VALUES (5, N'', N'Earthquake Preparedness', 1, 0, 0, 1, CAST(N'2015-08-04 12:27:06.153' AS DateTime), CAST(N'2015-08-04 12:27:06.153' AS DateTime), 0, 1, 63, 63, NULL, N'', N'71.96044921875 30.486550842588482', NULL, NULL, 1, CAST(N'2015-09-16 12:30:35.603' AS DateTime), CAST(N'2015-12-02 00:00:00.000' AS DateTime))
INSERT [dbo].[Training] ([TrainingId], [Description], [Name], [Status], [TrainingType], [TrainingLevel], [BroaderTrainingArea], [StartDate], [EndDate], [Fee], [ProvinceId], [DistrictId], [CityId], [LogisticNote], [ReferenceMaterial], [Location], [Objective], [FeeVoucher], [SurveyId], [DateCreated], [DateModified]) VALUES (6, N'Response', N'Flood Response', 2, 0, 3, 2, CAST(N'2015-09-16 12:30:35.603' AS DateTime), CAST(N'2015-09-19 12:30:35.603' AS DateTime), 0, 4, 55, 55, NULL, NULL, N'69.01611328125 25.99754991957211', NULL, NULL, 1, CAST(N'2015-09-16 12:30:35.603' AS DateTime), CAST(N'2015-12-02 00:00:00.000' AS DateTime))
INSERT [dbo].[Training] ([TrainingId], [Description], [Name], [Status], [TrainingType], [TrainingLevel], [BroaderTrainingArea], [StartDate], [EndDate], [Fee], [ProvinceId], [DistrictId], [CityId], [LogisticNote], [ReferenceMaterial], [Location], [Objective], [FeeVoucher], [SurveyId], [DateCreated], [DateModified]) VALUES (7, N'dfdfd', N'New Training', 4, 0, 0, 2, CAST(N'2014-04-28 15:44:37.710' AS DateTime), CAST(N'2014-04-30 15:44:37.710' AS DateTime), 3434, 6, 74, 74, NULL, N'erwer', N'71.092529296875 29.57345707301757', NULL, NULL, 1, CAST(N'2015-09-16 12:30:35.603' AS DateTime), CAST(N'2015-12-02 00:00:00.000' AS DateTime))
INSERT [dbo].[Training] ([TrainingId], [Description], [Name], [Status], [TrainingType], [TrainingLevel], [BroaderTrainingArea], [StartDate], [EndDate], [Fee], [ProvinceId], [DistrictId], [CityId], [LogisticNote], [ReferenceMaterial], [Location], [Objective], [FeeVoucher], [SurveyId], [DateCreated], [DateModified]) VALUES (8, NULL, N'Multan Training', 1, 0, 0, 0, CAST(N'2015-08-30 19:49:11.990' AS DateTime), CAST(N'2015-08-30 19:49:11.990' AS DateTime), 0, 4, 55, 55, NULL, NULL, N'71.400146484375 30.278044377800153', NULL, NULL, 1, CAST(N'2015-09-16 12:30:35.603' AS DateTime), CAST(N'2015-12-02 00:00:00.000' AS DateTime))
SET IDENTITY_INSERT [dbo].[Training] OFF
SET IDENTITY_INSERT [dbo].[TrainingActivity] ON 

INSERT [dbo].[TrainingActivity] ([TrainingActivityId], [OrganizationId], [CollaboratingOrganization], [TitleOfTraining], [TrainingType], [TrainingLevel], [BroaderTrainingArea], [DurationOfTraining], [NoOfParticipants], [GenderRepresentationMale], [GenderRepresentationFemale], [VulnerableGroups], [OwnStaff], [Government], [ArmedForces], [Police], [UNAgencies], [INGOs], [NGOs], [CBOs], [Students], [Teachers], [EducationalManagement], [ReligiousLeader], [PrivateCommercialOrg], [Community], [Media], [OthersTitle], [OthersNo], [Punjab], [Sindh], [Balochistan], [KhyberPakhtunkhawa], [FATA], [GilgitBaltistan], [AJK], [TrainingLocation], [DistrictId], [Name], [ContactNoTel], [ContactNoMob], [EmailAddress], [GuestofHonour], [AnyAdditionalInformation], [ListOfParticipants], [TrainingAgenda], [Picture1], [Picture2], [Picture3], [Picture4], [Picture5], [ApprovalStatus], [StartDate], [EndDate], [ProvinceId], [Location]) VALUES (1, 6, 0, N'Drought Preparedness', 0, 3, 1, 2, 100, N'50', N'50', 50, 11, 5, 5, 5, 5, 5, 5, 1, 5, 5, 5, 5, 1, 1, 1, N'1', 5, 40, 30, 20, 10, 5, 5, 5, N'Faisalabad', 1, N'Waseem Ahmad', N'042 51555548', N'0335 0054154', N'waseem@hello.com', N'Sajid', N'', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, CAST(N'2015-07-23 00:00:00.000' AS DateTime), CAST(N'2015-07-24 00:00:00.000' AS DateTime), 1, N'74.28955078125 31.728167146023935')
INSERT [dbo].[TrainingActivity] ([TrainingActivityId], [OrganizationId], [CollaboratingOrganization], [TitleOfTraining], [TrainingType], [TrainingLevel], [BroaderTrainingArea], [DurationOfTraining], [NoOfParticipants], [GenderRepresentationMale], [GenderRepresentationFemale], [VulnerableGroups], [OwnStaff], [Government], [ArmedForces], [Police], [UNAgencies], [INGOs], [NGOs], [CBOs], [Students], [Teachers], [EducationalManagement], [ReligiousLeader], [PrivateCommercialOrg], [Community], [Media], [OthersTitle], [OthersNo], [Punjab], [Sindh], [Balochistan], [KhyberPakhtunkhawa], [FATA], [GilgitBaltistan], [AJK], [TrainingLocation], [DistrictId], [Name], [ContactNoTel], [ContactNoMob], [EmailAddress], [GuestofHonour], [AnyAdditionalInformation], [ListOfParticipants], [TrainingAgenda], [Picture1], [Picture2], [Picture3], [Picture4], [Picture5], [ApprovalStatus], [StartDate], [EndDate], [ProvinceId], [Location]) VALUES (2, 5, 0, N'Heatwave Preparedness', 0, 3, 1, 2, 100, N'50', N'50', 50, 11, NULL, NULL, NULL, 5, NULL, NULL, 1, NULL, 5, 5, 5, 1, 1, 1, N'1', 5, 40, 30, 20, 10, NULL, NULL, NULL, N'Faisalabad', 94, N'Waseem Ahmad', N'042 51555548', N'0335 0054154', N'waseem@hello.com', N'Sajid', NULL, N'img_25.jpg', N'img_26.jpg', N'img_7.jpg', N'img_26.jpg', N'img_16.jpg', N'esteban_garcia.jpg', N'dave_ward.jpg', 0, CAST(N'2015-07-23 00:00:00.000' AS DateTime), CAST(N'2015-07-24 00:00:00.000' AS DateTime), 4, N'67.21435546875 25.16517336866393')
INSERT [dbo].[TrainingActivity] ([TrainingActivityId], [OrganizationId], [CollaboratingOrganization], [TitleOfTraining], [TrainingType], [TrainingLevel], [BroaderTrainingArea], [DurationOfTraining], [NoOfParticipants], [GenderRepresentationMale], [GenderRepresentationFemale], [VulnerableGroups], [OwnStaff], [Government], [ArmedForces], [Police], [UNAgencies], [INGOs], [NGOs], [CBOs], [Students], [Teachers], [EducationalManagement], [ReligiousLeader], [PrivateCommercialOrg], [Community], [Media], [OthersTitle], [OthersNo], [Punjab], [Sindh], [Balochistan], [KhyberPakhtunkhawa], [FATA], [GilgitBaltistan], [AJK], [TrainingLocation], [DistrictId], [Name], [ContactNoTel], [ContactNoMob], [EmailAddress], [GuestofHonour], [AnyAdditionalInformation], [ListOfParticipants], [TrainingAgenda], [Picture1], [Picture2], [Picture3], [Picture4], [Picture5], [ApprovalStatus], [StartDate], [EndDate], [ProvinceId], [Location]) VALUES (3, 5, 0, N'4W Training', 2, 1, 2, 5, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 66, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, CAST(N'2015-09-14 19:00:00.000' AS DateTime), CAST(N'2015-09-20 19:00:00.000' AS DateTime), 6, N'70.86181640625 33.32134852669881')
INSERT [dbo].[TrainingActivity] ([TrainingActivityId], [OrganizationId], [CollaboratingOrganization], [TitleOfTraining], [TrainingType], [TrainingLevel], [BroaderTrainingArea], [DurationOfTraining], [NoOfParticipants], [GenderRepresentationMale], [GenderRepresentationFemale], [VulnerableGroups], [OwnStaff], [Government], [ArmedForces], [Police], [UNAgencies], [INGOs], [NGOs], [CBOs], [Students], [Teachers], [EducationalManagement], [ReligiousLeader], [PrivateCommercialOrg], [Community], [Media], [OthersTitle], [OthersNo], [Punjab], [Sindh], [Balochistan], [KhyberPakhtunkhawa], [FATA], [GilgitBaltistan], [AJK], [TrainingLocation], [DistrictId], [Name], [ContactNoTel], [ContactNoMob], [EmailAddress], [GuestofHonour], [AnyAdditionalInformation], [ListOfParticipants], [TrainingAgenda], [Picture1], [Picture2], [Picture3], [Picture4], [Picture5], [ApprovalStatus], [StartDate], [EndDate], [ProvinceId], [Location]) VALUES (4, 5, 0, N'Heatwave Mitigation', 0, 0, 0, 2, 100, N'50', N'50', 10, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 55, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, CAST(N'2015-08-30 05:56:21.583' AS DateTime), CAST(N'2015-08-30 19:00:00.000' AS DateTime), 4, N'73.0667 33.7167')
SET IDENTITY_INSERT [dbo].[TrainingActivity] OFF
SET IDENTITY_INSERT [dbo].[TrainingCost] ON 

INSERT [dbo].[TrainingCost] ([TrainingId], [FundingId], [Cost], [TrainingCostId], [Description], [DateOfActivity]) VALUES (1, 2, 1000, 1, NULL, CAST(N'2015-08-20 00:00:00.000' AS DateTime))
INSERT [dbo].[TrainingCost] ([TrainingId], [FundingId], [Cost], [TrainingCostId], [Description], [DateOfActivity]) VALUES (3, 1, 2000, 2, NULL, CAST(N'2015-08-20 00:00:00.000' AS DateTime))
INSERT [dbo].[TrainingCost] ([TrainingId], [FundingId], [Cost], [TrainingCostId], [Description], [DateOfActivity]) VALUES (5, 1, 5000, 3, NULL, CAST(N'2015-08-20 00:00:00.000' AS DateTime))
SET IDENTITY_INSERT [dbo].[TrainingCost] OFF
INSERT [dbo].[TrainingEvaluation] ([TrainingId], [SurveyId], [QuestionId], [ParticipantId], [Response], [Reason], [ResponseDate]) VALUES (3, 1, 1, 4, N'0', N'sdfsdfg', CAST(N'2015-09-15 03:19:39.773' AS DateTime))
INSERT [dbo].[TrainingEvaluation] ([TrainingId], [SurveyId], [QuestionId], [ParticipantId], [Response], [Reason], [ResponseDate]) VALUES (3, 1, 1, 6, N'1', N'sdf', CAST(N'2015-09-14 17:57:35.713' AS DateTime))
INSERT [dbo].[TrainingEvaluation] ([TrainingId], [SurveyId], [QuestionId], [ParticipantId], [Response], [Reason], [ResponseDate]) VALUES (3, 1, 2, 4, N'2', N'dgdf', CAST(N'2015-09-15 03:19:39.777' AS DateTime))
INSERT [dbo].[TrainingEvaluation] ([TrainingId], [SurveyId], [QuestionId], [ParticipantId], [Response], [Reason], [ResponseDate]) VALUES (3, 1, 2, 6, N'1', N'sdf', CAST(N'2015-09-14 17:57:35.717' AS DateTime))
INSERT [dbo].[TrainingEvaluation] ([TrainingId], [SurveyId], [QuestionId], [ParticipantId], [Response], [Reason], [ResponseDate]) VALUES (3, 1, 3, 4, N'3', N'dfgdfg', CAST(N'2015-09-15 03:19:39.777' AS DateTime))
INSERT [dbo].[TrainingEvaluation] ([TrainingId], [SurveyId], [QuestionId], [ParticipantId], [Response], [Reason], [ResponseDate]) VALUES (3, 1, 3, 6, N'1', N'sdf', CAST(N'2015-09-14 17:57:35.717' AS DateTime))
INSERT [dbo].[TrainingEvaluation] ([TrainingId], [SurveyId], [QuestionId], [ParticipantId], [Response], [Reason], [ResponseDate]) VALUES (3, 1, 4, 4, N'1', N'dfgdf', CAST(N'2015-09-15 03:19:39.777' AS DateTime))
INSERT [dbo].[TrainingEvaluation] ([TrainingId], [SurveyId], [QuestionId], [ParticipantId], [Response], [Reason], [ResponseDate]) VALUES (3, 1, 4, 6, N'3', N'sdf', CAST(N'2015-09-14 17:57:35.717' AS DateTime))
INSERT [dbo].[TrainingEvaluation] ([TrainingId], [SurveyId], [QuestionId], [ParticipantId], [Response], [Reason], [ResponseDate]) VALUES (3, 1, 5, 4, N'3', N'sdf', CAST(N'2015-09-15 03:19:39.777' AS DateTime))
INSERT [dbo].[TrainingEvaluation] ([TrainingId], [SurveyId], [QuestionId], [ParticipantId], [Response], [Reason], [ResponseDate]) VALUES (3, 1, 5, 6, N'4', N'sdf', CAST(N'2015-09-14 17:57:35.717' AS DateTime))
INSERT [dbo].[TrainingEvaluation] ([TrainingId], [SurveyId], [QuestionId], [ParticipantId], [Response], [Reason], [ResponseDate]) VALUES (3, 1, 6, 4, NULL, N'sdf', CAST(N'2015-09-15 03:19:39.777' AS DateTime))
INSERT [dbo].[TrainingEvaluation] ([TrainingId], [SurveyId], [QuestionId], [ParticipantId], [Response], [Reason], [ResponseDate]) VALUES (3, 1, 6, 6, NULL, N'dsfsd', CAST(N'2015-09-14 17:57:35.717' AS DateTime))
INSERT [dbo].[TrainingEvaluation] ([TrainingId], [SurveyId], [QuestionId], [ParticipantId], [Response], [Reason], [ResponseDate]) VALUES (3, 1, 7, 4, NULL, N'sdfsdf', CAST(N'2015-09-15 03:19:39.777' AS DateTime))
INSERT [dbo].[TrainingEvaluation] ([TrainingId], [SurveyId], [QuestionId], [ParticipantId], [Response], [Reason], [ResponseDate]) VALUES (3, 1, 7, 6, NULL, N'sdf', CAST(N'2015-09-14 17:57:35.720' AS DateTime))
INSERT [dbo].[TrainingEvaluation] ([TrainingId], [SurveyId], [QuestionId], [ParticipantId], [Response], [Reason], [ResponseDate]) VALUES (3, 1, 8, 4, NULL, N'dfg', CAST(N'2015-09-15 03:19:39.777' AS DateTime))
INSERT [dbo].[TrainingEvaluation] ([TrainingId], [SurveyId], [QuestionId], [ParticipantId], [Response], [Reason], [ResponseDate]) VALUES (3, 1, 8, 6, NULL, N'dfsdf', CAST(N'2015-09-14 17:57:35.720' AS DateTime))
INSERT [dbo].[TrainingEvaluation] ([TrainingId], [SurveyId], [QuestionId], [ParticipantId], [Response], [Reason], [ResponseDate]) VALUES (3, 1, 9, 4, NULL, N'dfg', CAST(N'2015-09-15 03:19:39.780' AS DateTime))
INSERT [dbo].[TrainingEvaluation] ([TrainingId], [SurveyId], [QuestionId], [ParticipantId], [Response], [Reason], [ResponseDate]) VALUES (3, 1, 9, 6, NULL, N'sdfs', CAST(N'2015-09-14 17:57:35.720' AS DateTime))
INSERT [dbo].[TrainingEvaluation] ([TrainingId], [SurveyId], [QuestionId], [ParticipantId], [Response], [Reason], [ResponseDate]) VALUES (3, 1, 10, 4, NULL, N'sdf', CAST(N'2015-09-15 03:19:39.780' AS DateTime))
INSERT [dbo].[TrainingEvaluation] ([TrainingId], [SurveyId], [QuestionId], [ParticipantId], [Response], [Reason], [ResponseDate]) VALUES (3, 1, 10, 6, NULL, N'sdfsd', CAST(N'2015-09-14 17:57:35.720' AS DateTime))
INSERT [dbo].[TrainingEvaluation] ([TrainingId], [SurveyId], [QuestionId], [ParticipantId], [Response], [Reason], [ResponseDate]) VALUES (3, 1, 11, 4, NULL, N'fgdf', CAST(N'2015-09-15 03:19:39.780' AS DateTime))
INSERT [dbo].[TrainingEvaluation] ([TrainingId], [SurveyId], [QuestionId], [ParticipantId], [Response], [Reason], [ResponseDate]) VALUES (3, 1, 11, 6, NULL, N'fsd', CAST(N'2015-09-14 17:57:35.720' AS DateTime))
INSERT [dbo].[TrainingEvaluation] ([TrainingId], [SurveyId], [QuestionId], [ParticipantId], [Response], [Reason], [ResponseDate]) VALUES (3, 1, 12, 4, N'0', NULL, CAST(N'2015-09-15 03:19:39.780' AS DateTime))
INSERT [dbo].[TrainingEvaluation] ([TrainingId], [SurveyId], [QuestionId], [ParticipantId], [Response], [Reason], [ResponseDate]) VALUES (3, 1, 13, 4, N'3', N'sdf', CAST(N'2015-09-15 03:19:39.780' AS DateTime))
INSERT [dbo].[TrainingEvaluation] ([TrainingId], [SurveyId], [QuestionId], [ParticipantId], [Response], [Reason], [ResponseDate]) VALUES (3, 1, 14, 4, N'2', N'sdf', CAST(N'2015-09-15 03:19:39.780' AS DateTime))
INSERT [dbo].[TrainingEvaluation] ([TrainingId], [SurveyId], [QuestionId], [ParticipantId], [Response], [Reason], [ResponseDate]) VALUES (3, 1, 15, 4, N'false|false|true|false|false', NULL, CAST(N'2015-09-15 03:19:39.780' AS DateTime))
INSERT [dbo].[TrainingEvaluation] ([TrainingId], [SurveyId], [QuestionId], [ParticipantId], [Response], [Reason], [ResponseDate]) VALUES (3, 1, 16, 4, N'56|999|54', NULL, CAST(N'2015-09-15 03:19:39.780' AS DateTime))
INSERT [dbo].[TrainingEvaluation] ([TrainingId], [SurveyId], [QuestionId], [ParticipantId], [Response], [Reason], [ResponseDate]) VALUES (3, 1, 17, 4, N'fgh|fgh|fgh|fgh|fghfgfg|hfghfg|hfghfg||hfg|fgh', NULL, CAST(N'2015-09-15 03:19:39.780' AS DateTime))
INSERT [dbo].[TrainingOrganization] ([TrainingId], [OrganizationId]) VALUES (3, 1)
INSERT [dbo].[TrainingOrganization] ([TrainingId], [OrganizationId]) VALUES (3, 3)
INSERT [dbo].[TrainingOrganization] ([TrainingId], [OrganizationId]) VALUES (3, 8)
SET IDENTITY_INSERT [dbo].[TrainingSession] ON 

INSERT [dbo].[TrainingSession] ([TrainingSessionId], [TrainingId], [Name], [Module], [DateOfSession], [StartTime], [EndTime], [Agenda], [LogisticNote]) VALUES (1, 3, N'Session 1', N'Module 1', CAST(N'2015-09-14 00:00:00.000' AS DateTime), CAST(N'1900-01-01 04:00:00.000' AS DateTime), CAST(N'1900-01-01 07:00:00.000' AS DateTime), N'Introduction', N'')
INSERT [dbo].[TrainingSession] ([TrainingSessionId], [TrainingId], [Name], [Module], [DateOfSession], [StartTime], [EndTime], [Agenda], [LogisticNote]) VALUES (2, 6, N'Session 1', N'Main', CAST(N'2015-08-13 00:00:00.000' AS DateTime), CAST(N'1900-01-01 03:00:00.000' AS DateTime), CAST(N'1900-01-01 19:30:00.000' AS DateTime), NULL, NULL)
INSERT [dbo].[TrainingSession] ([TrainingSessionId], [TrainingId], [Name], [Module], [DateOfSession], [StartTime], [EndTime], [Agenda], [LogisticNote]) VALUES (3, 6, N'Session 2', N'Main', CAST(N'2015-08-14 00:00:00.000' AS DateTime), CAST(N'1900-01-01 08:00:00.000' AS DateTime), CAST(N'1900-01-01 11:00:00.000' AS DateTime), NULL, NULL)
INSERT [dbo].[TrainingSession] ([TrainingSessionId], [TrainingId], [Name], [Module], [DateOfSession], [StartTime], [EndTime], [Agenda], [LogisticNote]) VALUES (4, 3, N'Session 3', N'Module 1', CAST(N'2015-09-14 00:00:00.000' AS DateTime), CAST(N'1900-01-01 08:00:00.000' AS DateTime), CAST(N'1900-01-01 12:00:00.000' AS DateTime), N'Mitigation Practice', NULL)
INSERT [dbo].[TrainingSession] ([TrainingSessionId], [TrainingId], [Name], [Module], [DateOfSession], [StartTime], [EndTime], [Agenda], [LogisticNote]) VALUES (5, 3, N'Session 2', N'Module 2', CAST(N'2015-09-14 00:00:00.000' AS DateTime), CAST(N'1900-01-01 04:00:00.000' AS DateTime), CAST(N'1900-01-01 12:00:00.000' AS DateTime), N'Parallel', NULL)
SET IDENTITY_INSERT [dbo].[TrainingSession] OFF
INSERT [dbo].[TrainingSessionParticipant] ([TrainingSessionId], [ParticipantId]) VALUES (1, 3)
INSERT [dbo].[TrainingSessionParticipant] ([TrainingSessionId], [ParticipantId]) VALUES (4, 3)
INSERT [dbo].[TrainingSessionParticipant] ([TrainingSessionId], [ParticipantId]) VALUES (1, 4)
INSERT [dbo].[TrainingSessionParticipant] ([TrainingSessionId], [ParticipantId]) VALUES (5, 4)
INSERT [dbo].[TrainingSessionParticipant] ([TrainingSessionId], [ParticipantId]) VALUES (5, 6)
/****** Object:  Index [IX_ActivityTypeId]    Script Date: 21-Sep-15 1:40:59 PM ******/
CREATE NONCLUSTERED INDEX [IX_ActivityTypeId] ON [dbo].[Activity]
(
	[ActivityTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_CityId]    Script Date: 21-Sep-15 1:40:59 PM ******/
CREATE NONCLUSTERED INDEX [IX_CityId] ON [dbo].[Activity]
(
	[CityId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_ProjectId]    Script Date: 21-Sep-15 1:40:59 PM ******/
CREATE NONCLUSTERED INDEX [IX_ProjectId] ON [dbo].[Activity]
(
	[ProjectId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_ActivityId]    Script Date: 21-Sep-15 1:40:59 PM ******/
CREATE NONCLUSTERED INDEX [IX_ActivityId] ON [dbo].[ActivityCost]
(
	[ActivityId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_FundingId]    Script Date: 21-Sep-15 1:40:59 PM ******/
CREATE NONCLUSTERED INDEX [IX_FundingId] ON [dbo].[ActivityCost]
(
	[FundingId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_GalleryId]    Script Date: 21-Sep-15 1:40:59 PM ******/
CREATE NONCLUSTERED INDEX [IX_GalleryId] ON [dbo].[Album]
(
	[GalleryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [RoleNameIndex]    Script Date: 21-Sep-15 1:40:59 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [RoleNameIndex] ON [dbo].[AspNetRoles]
(
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_UserId]    Script Date: 21-Sep-15 1:40:59 PM ******/
CREATE NONCLUSTERED INDEX [IX_UserId] ON [dbo].[AspNetUserClaims]
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_UserId]    Script Date: 21-Sep-15 1:40:59 PM ******/
CREATE NONCLUSTERED INDEX [IX_UserId] ON [dbo].[AspNetUserLogins]
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_RoleId]    Script Date: 21-Sep-15 1:40:59 PM ******/
CREATE NONCLUSTERED INDEX [IX_RoleId] ON [dbo].[AspNetUserRoles]
(
	[RoleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_UserId]    Script Date: 21-Sep-15 1:40:59 PM ******/
CREATE NONCLUSTERED INDEX [IX_UserId] ON [dbo].[AspNetUserRoles]
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [UserNameIndex]    Script Date: 21-Sep-15 1:40:59 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [UserNameIndex] ON [dbo].[AspNetUsers]
(
	[UserName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_DistrictId]    Script Date: 21-Sep-15 1:40:59 PM ******/
CREATE NONCLUSTERED INDEX [IX_DistrictId] ON [dbo].[City]
(
	[DistrictId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_ProvinceId]    Script Date: 21-Sep-15 1:40:59 PM ******/
CREATE NONCLUSTERED INDEX [IX_ProvinceId] ON [dbo].[District]
(
	[ProvinceId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_DocumentCategoryId1]    Script Date: 21-Sep-15 1:40:59 PM ******/
CREATE NONCLUSTERED INDEX [IX_DocumentCategoryId1] ON [dbo].[Document]
(
	[DocumentCategoryId1] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_DocumentCategoryId2]    Script Date: 21-Sep-15 1:40:59 PM ******/
CREATE NONCLUSTERED INDEX [IX_DocumentCategoryId2] ON [dbo].[Document]
(
	[DocumentCategoryId2] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_DocumentCategoryId3]    Script Date: 21-Sep-15 1:40:59 PM ******/
CREATE NONCLUSTERED INDEX [IX_DocumentCategoryId3] ON [dbo].[Document]
(
	[DocumentCategoryId3] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_ThematicAreaId]    Script Date: 21-Sep-15 1:40:59 PM ******/
CREATE NONCLUSTERED INDEX [IX_ThematicAreaId] ON [dbo].[Document]
(
	[ThematicAreaId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_TrainingId]    Script Date: 21-Sep-15 1:40:59 PM ******/
CREATE NONCLUSTERED INDEX [IX_TrainingId] ON [dbo].[Document]
(
	[TrainingId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_ParentDocumentCategoryId]    Script Date: 21-Sep-15 1:40:59 PM ******/
CREATE NONCLUSTERED INDEX [IX_ParentDocumentCategoryId] ON [dbo].[DocumentCategory]
(
	[ParentDocumentCategoryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_ApprovedActivityId]    Script Date: 21-Sep-15 1:40:59 PM ******/
CREATE NONCLUSTERED INDEX [IX_ApprovedActivityId] ON [dbo].[Funding]
(
	[ApprovedActivityId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_ProjectId]    Script Date: 21-Sep-15 1:40:59 PM ******/
CREATE NONCLUSTERED INDEX [IX_ProjectId] ON [dbo].[Funding]
(
	[ProjectId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_AlbumId]    Script Date: 21-Sep-15 1:40:59 PM ******/
CREATE NONCLUSTERED INDEX [IX_AlbumId] ON [dbo].[MediaFile]
(
	[AlbumId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_DistrictId]    Script Date: 21-Sep-15 1:40:59 PM ******/
CREATE NONCLUSTERED INDEX [IX_DistrictId] ON [dbo].[Organization]
(
	[DistrictId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_OrganizationTypeId]    Script Date: 21-Sep-15 1:40:59 PM ******/
CREATE NONCLUSTERED INDEX [IX_OrganizationTypeId] ON [dbo].[Organization]
(
	[OrganizationTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_AreaId]    Script Date: 21-Sep-15 1:40:59 PM ******/
CREATE NONCLUSTERED INDEX [IX_AreaId] ON [dbo].[OrganizationArea]
(
	[AreaId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_OrganizationId]    Script Date: 21-Sep-15 1:40:59 PM ******/
CREATE NONCLUSTERED INDEX [IX_OrganizationId] ON [dbo].[OrganizationArea]
(
	[OrganizationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_AcademicQualificationId]    Script Date: 21-Sep-15 1:40:59 PM ******/
CREATE NONCLUSTERED INDEX [IX_AcademicQualificationId] ON [dbo].[Participant]
(
	[AcademicQualificationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_DistrictId]    Script Date: 21-Sep-15 1:40:59 PM ******/
CREATE NONCLUSTERED INDEX [IX_DistrictId] ON [dbo].[Participant]
(
	[DistrictId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_OrganizationId]    Script Date: 21-Sep-15 1:40:59 PM ******/
CREATE NONCLUSTERED INDEX [IX_OrganizationId] ON [dbo].[Participant]
(
	[OrganizationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_OrganizationTypeId]    Script Date: 21-Sep-15 1:40:59 PM ******/
CREATE NONCLUSTERED INDEX [IX_OrganizationTypeId] ON [dbo].[Participant]
(
	[OrganizationTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_TrainingId]    Script Date: 21-Sep-15 1:40:59 PM ******/
CREATE NONCLUSTERED INDEX [IX_TrainingId] ON [dbo].[Participant]
(
	[TrainingId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_DisabilityTypeId]    Script Date: 21-Sep-15 1:40:59 PM ******/
CREATE NONCLUSTERED INDEX [IX_DisabilityTypeId] ON [dbo].[ParticipantDisabilityType]
(
	[DisabilityTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_ParticipantId]    Script Date: 21-Sep-15 1:40:59 PM ******/
CREATE NONCLUSTERED INDEX [IX_ParticipantId] ON [dbo].[ParticipantDisabilityType]
(
	[ParticipantId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_TrainingActivityId]    Script Date: 21-Sep-15 1:40:59 PM ******/
CREATE NONCLUSTERED INDEX [IX_TrainingActivityId] ON [dbo].[PotentialResourcePerson]
(
	[TrainingActivityId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_OrganizationId]    Script Date: 21-Sep-15 1:40:59 PM ******/
CREATE NONCLUSTERED INDEX [IX_OrganizationId] ON [dbo].[Project]
(
	[OrganizationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_AcademicQualificationId]    Script Date: 21-Sep-15 1:40:59 PM ******/
CREATE NONCLUSTERED INDEX [IX_AcademicQualificationId] ON [dbo].[ResourcePerson]
(
	[AcademicQualificationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_DistrictId]    Script Date: 21-Sep-15 1:40:59 PM ******/
CREATE NONCLUSTERED INDEX [IX_DistrictId] ON [dbo].[ResourcePerson]
(
	[DistrictId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_OrganizationId]    Script Date: 21-Sep-15 1:40:59 PM ******/
CREATE NONCLUSTERED INDEX [IX_OrganizationId] ON [dbo].[ResourcePerson]
(
	[OrganizationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_OrganizationTypeId]    Script Date: 21-Sep-15 1:40:59 PM ******/
CREATE NONCLUSTERED INDEX [IX_OrganizationTypeId] ON [dbo].[ResourcePerson]
(
	[OrganizationTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_AreaId]    Script Date: 21-Sep-15 1:40:59 PM ******/
CREATE NONCLUSTERED INDEX [IX_AreaId] ON [dbo].[ResourcePersonArea]
(
	[AreaId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_ResourcePersonId]    Script Date: 21-Sep-15 1:40:59 PM ******/
CREATE NONCLUSTERED INDEX [IX_ResourcePersonId] ON [dbo].[ResourcePersonArea]
(
	[ResourcePersonId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_DisabilityTypeId]    Script Date: 21-Sep-15 1:40:59 PM ******/
CREATE NONCLUSTERED INDEX [IX_DisabilityTypeId] ON [dbo].[ResourcePersonDisabilityType]
(
	[DisabilityTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_ResourcePersonId]    Script Date: 21-Sep-15 1:40:59 PM ******/
CREATE NONCLUSTERED INDEX [IX_ResourcePersonId] ON [dbo].[ResourcePersonDisabilityType]
(
	[ResourcePersonId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_ResourcePersonId]    Script Date: 21-Sep-15 1:40:59 PM ******/
CREATE NONCLUSTERED INDEX [IX_ResourcePersonId] ON [dbo].[ResourcePersonTraining]
(
	[ResourcePersonId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_TrainingSessionId]    Script Date: 21-Sep-15 1:40:59 PM ******/
CREATE NONCLUSTERED INDEX [IX_TrainingSessionId] ON [dbo].[ResourcePersonTraining]
(
	[TrainingSessionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_AcademicQualificationId]    Script Date: 21-Sep-15 1:40:59 PM ******/
CREATE NONCLUSTERED INDEX [IX_AcademicQualificationId] ON [dbo].[Respondent]
(
	[AcademicQualificationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_DistrictId]    Script Date: 21-Sep-15 1:40:59 PM ******/
CREATE NONCLUSTERED INDEX [IX_DistrictId] ON [dbo].[Respondent]
(
	[DistrictId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_OrganizationId]    Script Date: 21-Sep-15 1:40:59 PM ******/
CREATE NONCLUSTERED INDEX [IX_OrganizationId] ON [dbo].[Respondent]
(
	[OrganizationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_OrganizationTypeId]    Script Date: 21-Sep-15 1:40:59 PM ******/
CREATE NONCLUSTERED INDEX [IX_OrganizationTypeId] ON [dbo].[Respondent]
(
	[OrganizationTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_DisabilityTypeId]    Script Date: 21-Sep-15 1:40:59 PM ******/
CREATE NONCLUSTERED INDEX [IX_DisabilityTypeId] ON [dbo].[RespondentDisabilityType]
(
	[DisabilityTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_RespondentId]    Script Date: 21-Sep-15 1:40:59 PM ******/
CREATE NONCLUSTERED INDEX [IX_RespondentId] ON [dbo].[RespondentDisabilityType]
(
	[RespondentId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_QuestionId]    Script Date: 21-Sep-15 1:40:59 PM ******/
CREATE NONCLUSTERED INDEX [IX_QuestionId] ON [dbo].[SurveyQuestion]
(
	[QuestionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_SurveyId]    Script Date: 21-Sep-15 1:40:59 PM ******/
CREATE NONCLUSTERED INDEX [IX_SurveyId] ON [dbo].[SurveyQuestion]
(
	[SurveyId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_QuestionId]    Script Date: 21-Sep-15 1:40:59 PM ******/
CREATE NONCLUSTERED INDEX [IX_QuestionId] ON [dbo].[SurveyQuestionResponse]
(
	[QuestionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_RespondentId]    Script Date: 21-Sep-15 1:40:59 PM ******/
CREATE NONCLUSTERED INDEX [IX_RespondentId] ON [dbo].[SurveyQuestionResponse]
(
	[RespondentId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_SurveyId]    Script Date: 21-Sep-15 1:40:59 PM ******/
CREATE NONCLUSTERED INDEX [IX_SurveyId] ON [dbo].[SurveyQuestionResponse]
(
	[SurveyId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_CityId]    Script Date: 21-Sep-15 1:40:59 PM ******/
CREATE NONCLUSTERED INDEX [IX_CityId] ON [dbo].[Training]
(
	[CityId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_DistrictId]    Script Date: 21-Sep-15 1:40:59 PM ******/
CREATE NONCLUSTERED INDEX [IX_DistrictId] ON [dbo].[Training]
(
	[DistrictId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_ProvinceId]    Script Date: 21-Sep-15 1:40:59 PM ******/
CREATE NONCLUSTERED INDEX [IX_ProvinceId] ON [dbo].[Training]
(
	[ProvinceId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_SurveyId]    Script Date: 21-Sep-15 1:40:59 PM ******/
CREATE NONCLUSTERED INDEX [IX_SurveyId] ON [dbo].[Training]
(
	[SurveyId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_DistrictId]    Script Date: 21-Sep-15 1:40:59 PM ******/
CREATE NONCLUSTERED INDEX [IX_DistrictId] ON [dbo].[TrainingActivity]
(
	[DistrictId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_OrganizationId]    Script Date: 21-Sep-15 1:40:59 PM ******/
CREATE NONCLUSTERED INDEX [IX_OrganizationId] ON [dbo].[TrainingActivity]
(
	[OrganizationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_ProvinceId]    Script Date: 21-Sep-15 1:40:59 PM ******/
CREATE NONCLUSTERED INDEX [IX_ProvinceId] ON [dbo].[TrainingActivity]
(
	[ProvinceId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_FundingId]    Script Date: 21-Sep-15 1:40:59 PM ******/
CREATE NONCLUSTERED INDEX [IX_FundingId] ON [dbo].[TrainingCost]
(
	[FundingId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_TrainingId]    Script Date: 21-Sep-15 1:40:59 PM ******/
CREATE NONCLUSTERED INDEX [IX_TrainingId] ON [dbo].[TrainingCost]
(
	[TrainingId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_ParticipantId]    Script Date: 21-Sep-15 1:40:59 PM ******/
CREATE NONCLUSTERED INDEX [IX_ParticipantId] ON [dbo].[TrainingEvaluation]
(
	[ParticipantId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_QuestionId]    Script Date: 21-Sep-15 1:40:59 PM ******/
CREATE NONCLUSTERED INDEX [IX_QuestionId] ON [dbo].[TrainingEvaluation]
(
	[QuestionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_SurveyId]    Script Date: 21-Sep-15 1:40:59 PM ******/
CREATE NONCLUSTERED INDEX [IX_SurveyId] ON [dbo].[TrainingEvaluation]
(
	[SurveyId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_TrainingId]    Script Date: 21-Sep-15 1:40:59 PM ******/
CREATE NONCLUSTERED INDEX [IX_TrainingId] ON [dbo].[TrainingEvaluation]
(
	[TrainingId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_OrganizationId]    Script Date: 21-Sep-15 1:40:59 PM ******/
CREATE NONCLUSTERED INDEX [IX_OrganizationId] ON [dbo].[TrainingOrganization]
(
	[OrganizationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_TrainingId]    Script Date: 21-Sep-15 1:40:59 PM ******/
CREATE NONCLUSTERED INDEX [IX_TrainingId] ON [dbo].[TrainingOrganization]
(
	[TrainingId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_TrainingId]    Script Date: 21-Sep-15 1:40:59 PM ******/
CREATE NONCLUSTERED INDEX [IX_TrainingId] ON [dbo].[TrainingSession]
(
	[TrainingId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_ParticipantId]    Script Date: 21-Sep-15 1:40:59 PM ******/
CREATE NONCLUSTERED INDEX [IX_ParticipantId] ON [dbo].[TrainingSessionParticipant]
(
	[ParticipantId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_TrainingSessionId]    Script Date: 21-Sep-15 1:40:59 PM ******/
CREATE NONCLUSTERED INDEX [IX_TrainingSessionId] ON [dbo].[TrainingSessionParticipant]
(
	[TrainingSessionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Activity]  WITH CHECK ADD  CONSTRAINT [FK_dbo.Activity_dbo.ActivityType_ActivityTypeId] FOREIGN KEY([ActivityTypeId])
REFERENCES [dbo].[ActivityType] ([ActivityTypeId])
GO
ALTER TABLE [dbo].[Activity] CHECK CONSTRAINT [FK_dbo.Activity_dbo.ActivityType_ActivityTypeId]
GO
ALTER TABLE [dbo].[Activity]  WITH CHECK ADD  CONSTRAINT [FK_dbo.Activity_dbo.City_CityId] FOREIGN KEY([CityId])
REFERENCES [dbo].[City] ([CityId])
GO
ALTER TABLE [dbo].[Activity] CHECK CONSTRAINT [FK_dbo.Activity_dbo.City_CityId]
GO
ALTER TABLE [dbo].[ActivityCost]  WITH CHECK ADD  CONSTRAINT [FK_dbo.ActivityCost_dbo.Activity_ActivityId] FOREIGN KEY([ActivityId])
REFERENCES [dbo].[Activity] ([ActivityId])
GO
ALTER TABLE [dbo].[ActivityCost] CHECK CONSTRAINT [FK_dbo.ActivityCost_dbo.Activity_ActivityId]
GO
ALTER TABLE [dbo].[ActivityCost]  WITH CHECK ADD  CONSTRAINT [FK_dbo.ActivityCost_dbo.Funding_FundingId] FOREIGN KEY([FundingId])
REFERENCES [dbo].[Funding] ([FundingId])
GO
ALTER TABLE [dbo].[ActivityCost] CHECK CONSTRAINT [FK_dbo.ActivityCost_dbo.Funding_FundingId]
GO
ALTER TABLE [dbo].[Album]  WITH CHECK ADD  CONSTRAINT [FK_dbo.Album_dbo.Gallery_GalleryId] FOREIGN KEY([GalleryId])
REFERENCES [dbo].[Gallery] ([GalleryId])
GO
ALTER TABLE [dbo].[Album] CHECK CONSTRAINT [FK_dbo.Album_dbo.Gallery_GalleryId]
GO
ALTER TABLE [dbo].[AspNetUserClaims]  WITH CHECK ADD  CONSTRAINT [FK_dbo.AspNetUserClaims_dbo.AspNetUsers_UserId] FOREIGN KEY([UserId])
REFERENCES [dbo].[AspNetUsers] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[AspNetUserClaims] CHECK CONSTRAINT [FK_dbo.AspNetUserClaims_dbo.AspNetUsers_UserId]
GO
ALTER TABLE [dbo].[AspNetUserLogins]  WITH CHECK ADD  CONSTRAINT [FK_dbo.AspNetUserLogins_dbo.AspNetUsers_UserId] FOREIGN KEY([UserId])
REFERENCES [dbo].[AspNetUsers] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[AspNetUserLogins] CHECK CONSTRAINT [FK_dbo.AspNetUserLogins_dbo.AspNetUsers_UserId]
GO
ALTER TABLE [dbo].[AspNetUserRoles]  WITH CHECK ADD  CONSTRAINT [FK_dbo.AspNetUserRoles_dbo.AspNetRoles_RoleId] FOREIGN KEY([RoleId])
REFERENCES [dbo].[AspNetRoles] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[AspNetUserRoles] CHECK CONSTRAINT [FK_dbo.AspNetUserRoles_dbo.AspNetRoles_RoleId]
GO
ALTER TABLE [dbo].[AspNetUserRoles]  WITH CHECK ADD  CONSTRAINT [FK_dbo.AspNetUserRoles_dbo.AspNetUsers_UserId] FOREIGN KEY([UserId])
REFERENCES [dbo].[AspNetUsers] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[AspNetUserRoles] CHECK CONSTRAINT [FK_dbo.AspNetUserRoles_dbo.AspNetUsers_UserId]
GO
ALTER TABLE [dbo].[City]  WITH CHECK ADD  CONSTRAINT [FK_dbo.Cities_dbo.Districts_DistrictId] FOREIGN KEY([DistrictId])
REFERENCES [dbo].[District] ([DistrictId])
GO
ALTER TABLE [dbo].[City] CHECK CONSTRAINT [FK_dbo.Cities_dbo.Districts_DistrictId]
GO
ALTER TABLE [dbo].[District]  WITH CHECK ADD  CONSTRAINT [FK_dbo.Districts_dbo.Provinces_ProviceId] FOREIGN KEY([ProvinceId])
REFERENCES [dbo].[Province] ([ProvinceId])
GO
ALTER TABLE [dbo].[District] CHECK CONSTRAINT [FK_dbo.Districts_dbo.Provinces_ProviceId]
GO
ALTER TABLE [dbo].[Document]  WITH CHECK ADD  CONSTRAINT [FK_dbo.Documents_dbo.DocumentCategories_DocumentCategoryId1] FOREIGN KEY([DocumentCategoryId1])
REFERENCES [dbo].[DocumentCategory] ([DocumentCategoryId])
GO
ALTER TABLE [dbo].[Document] CHECK CONSTRAINT [FK_dbo.Documents_dbo.DocumentCategories_DocumentCategoryId1]
GO
ALTER TABLE [dbo].[Document]  WITH CHECK ADD  CONSTRAINT [FK_dbo.Documents_dbo.DocumentCategories_DocumentCategoryId2] FOREIGN KEY([DocumentCategoryId2])
REFERENCES [dbo].[DocumentCategory] ([DocumentCategoryId])
GO
ALTER TABLE [dbo].[Document] CHECK CONSTRAINT [FK_dbo.Documents_dbo.DocumentCategories_DocumentCategoryId2]
GO
ALTER TABLE [dbo].[Document]  WITH CHECK ADD  CONSTRAINT [FK_dbo.Documents_dbo.DocumentCategories_DocumentCategoryId3] FOREIGN KEY([DocumentCategoryId3])
REFERENCES [dbo].[DocumentCategory] ([DocumentCategoryId])
GO
ALTER TABLE [dbo].[Document] CHECK CONSTRAINT [FK_dbo.Documents_dbo.DocumentCategories_DocumentCategoryId3]
GO
ALTER TABLE [dbo].[Document]  WITH CHECK ADD  CONSTRAINT [FK_dbo.Documents_dbo.ThematicAreas_ThematicAreaId] FOREIGN KEY([ThematicAreaId])
REFERENCES [dbo].[ThematicArea] ([ThematicAreaId])
GO
ALTER TABLE [dbo].[Document] CHECK CONSTRAINT [FK_dbo.Documents_dbo.ThematicAreas_ThematicAreaId]
GO
ALTER TABLE [dbo].[Document]  WITH CHECK ADD  CONSTRAINT [FK_dbo.Documents_dbo.Trainings_TrainingId] FOREIGN KEY([TrainingId])
REFERENCES [dbo].[Training] ([TrainingId])
GO
ALTER TABLE [dbo].[Document] CHECK CONSTRAINT [FK_dbo.Documents_dbo.Trainings_TrainingId]
GO
ALTER TABLE [dbo].[DocumentCategory]  WITH CHECK ADD  CONSTRAINT [FK_dbo.DocumentCategories_dbo.DocumentCategories_ParentDocumentCategoryId] FOREIGN KEY([ParentDocumentCategoryId])
REFERENCES [dbo].[DocumentCategory] ([DocumentCategoryId])
GO
ALTER TABLE [dbo].[DocumentCategory] CHECK CONSTRAINT [FK_dbo.DocumentCategories_dbo.DocumentCategories_ParentDocumentCategoryId]
GO
ALTER TABLE [dbo].[Funding]  WITH CHECK ADD  CONSTRAINT [FK_dbo.Funding_dbo.ApprovedActivity_ApprovedActivityId] FOREIGN KEY([ApprovedActivityId])
REFERENCES [dbo].[ApprovedActivity] ([ApprovedActivityId])
GO
ALTER TABLE [dbo].[Funding] CHECK CONSTRAINT [FK_dbo.Funding_dbo.ApprovedActivity_ApprovedActivityId]
GO
ALTER TABLE [dbo].[Funding]  WITH CHECK ADD  CONSTRAINT [FK_dbo.Fundings_dbo.Projects_ProjectId] FOREIGN KEY([ProjectId])
REFERENCES [dbo].[Project] ([ProjectId])
GO
ALTER TABLE [dbo].[Funding] CHECK CONSTRAINT [FK_dbo.Fundings_dbo.Projects_ProjectId]
GO
ALTER TABLE [dbo].[MediaFile]  WITH CHECK ADD  CONSTRAINT [FK_dbo.MediaFiles_dbo.Albums_AlbumId] FOREIGN KEY([AlbumId])
REFERENCES [dbo].[Album] ([AlbumId])
GO
ALTER TABLE [dbo].[MediaFile] CHECK CONSTRAINT [FK_dbo.MediaFiles_dbo.Albums_AlbumId]
GO
ALTER TABLE [dbo].[Organization]  WITH CHECK ADD  CONSTRAINT [FK_dbo.Organizations_dbo.Districts_District_DistrictId] FOREIGN KEY([DistrictId])
REFERENCES [dbo].[District] ([DistrictId])
GO
ALTER TABLE [dbo].[Organization] CHECK CONSTRAINT [FK_dbo.Organizations_dbo.Districts_District_DistrictId]
GO
ALTER TABLE [dbo].[Organization]  WITH CHECK ADD  CONSTRAINT [FK_dbo.Organizations_dbo.OrganizationTypes_OrganizationTypeId] FOREIGN KEY([OrganizationTypeId])
REFERENCES [dbo].[OrganizationType] ([OrganizationTypeId])
GO
ALTER TABLE [dbo].[Organization] CHECK CONSTRAINT [FK_dbo.Organizations_dbo.OrganizationTypes_OrganizationTypeId]
GO
ALTER TABLE [dbo].[OrganizationArea]  WITH CHECK ADD  CONSTRAINT [FK_dbo.OrganizationArea_dbo.Area_AreaId] FOREIGN KEY([AreaId])
REFERENCES [dbo].[Area] ([AreaId])
GO
ALTER TABLE [dbo].[OrganizationArea] CHECK CONSTRAINT [FK_dbo.OrganizationArea_dbo.Area_AreaId]
GO
ALTER TABLE [dbo].[OrganizationArea]  WITH CHECK ADD  CONSTRAINT [FK_dbo.OrganizationArea_dbo.Organization_OrganizationId] FOREIGN KEY([OrganizationId])
REFERENCES [dbo].[Organization] ([OrganizationId])
GO
ALTER TABLE [dbo].[OrganizationArea] CHECK CONSTRAINT [FK_dbo.OrganizationArea_dbo.Organization_OrganizationId]
GO
ALTER TABLE [dbo].[Participant]  WITH CHECK ADD  CONSTRAINT [FK_dbo.Participant_dbo.OrganizationType_OrganizationTypeId] FOREIGN KEY([OrganizationTypeId])
REFERENCES [dbo].[OrganizationType] ([OrganizationTypeId])
GO
ALTER TABLE [dbo].[Participant] CHECK CONSTRAINT [FK_dbo.Participant_dbo.OrganizationType_OrganizationTypeId]
GO
ALTER TABLE [dbo].[Participant]  WITH CHECK ADD  CONSTRAINT [FK_dbo.Participants_dbo.AcademicQualifications_AcademicQualificationId] FOREIGN KEY([AcademicQualificationId])
REFERENCES [dbo].[AcademicQualification] ([AcademicQualificationId])
GO
ALTER TABLE [dbo].[Participant] CHECK CONSTRAINT [FK_dbo.Participants_dbo.AcademicQualifications_AcademicQualificationId]
GO
ALTER TABLE [dbo].[Participant]  WITH CHECK ADD  CONSTRAINT [FK_dbo.Participants_dbo.Districts_DistrictId] FOREIGN KEY([DistrictId])
REFERENCES [dbo].[District] ([DistrictId])
GO
ALTER TABLE [dbo].[Participant] CHECK CONSTRAINT [FK_dbo.Participants_dbo.Districts_DistrictId]
GO
ALTER TABLE [dbo].[Participant]  WITH CHECK ADD  CONSTRAINT [FK_dbo.Participants_dbo.Organizations_OrganizationId] FOREIGN KEY([OrganizationId])
REFERENCES [dbo].[Organization] ([OrganizationId])
GO
ALTER TABLE [dbo].[Participant] CHECK CONSTRAINT [FK_dbo.Participants_dbo.Organizations_OrganizationId]
GO
ALTER TABLE [dbo].[Participant]  WITH CHECK ADD  CONSTRAINT [FK_dbo.Participants_dbo.Trainings_TrainingtId] FOREIGN KEY([TrainingId])
REFERENCES [dbo].[Training] ([TrainingId])
GO
ALTER TABLE [dbo].[Participant] CHECK CONSTRAINT [FK_dbo.Participants_dbo.Trainings_TrainingtId]
GO
ALTER TABLE [dbo].[ParticipantDisabilityType]  WITH CHECK ADD  CONSTRAINT [FK_dbo.ParticipantDisabilityType_dbo.DisabilityType_DisabilityTypeId] FOREIGN KEY([DisabilityTypeId])
REFERENCES [dbo].[DisabilityType] ([DisabilityTypeId])
GO
ALTER TABLE [dbo].[ParticipantDisabilityType] CHECK CONSTRAINT [FK_dbo.ParticipantDisabilityType_dbo.DisabilityType_DisabilityTypeId]
GO
ALTER TABLE [dbo].[ParticipantDisabilityType]  WITH CHECK ADD  CONSTRAINT [FK_dbo.ParticipantDisabilityType_dbo.Participant_ParticipantId] FOREIGN KEY([ParticipantId])
REFERENCES [dbo].[Participant] ([ParticipantId])
GO
ALTER TABLE [dbo].[ParticipantDisabilityType] CHECK CONSTRAINT [FK_dbo.ParticipantDisabilityType_dbo.Participant_ParticipantId]
GO
ALTER TABLE [dbo].[PotentialResourcePerson]  WITH CHECK ADD  CONSTRAINT [FK_dbo.PotentialResourcePersons_dbo.TrainingActivities_TrainingActivityId] FOREIGN KEY([TrainingActivityId])
REFERENCES [dbo].[TrainingActivity] ([TrainingActivityId])
GO
ALTER TABLE [dbo].[PotentialResourcePerson] CHECK CONSTRAINT [FK_dbo.PotentialResourcePersons_dbo.TrainingActivities_TrainingActivityId]
GO
ALTER TABLE [dbo].[Project]  WITH CHECK ADD  CONSTRAINT [FK_dbo.Projects_dbo.Organizations_OrganizationId] FOREIGN KEY([OrganizationId])
REFERENCES [dbo].[Organization] ([OrganizationId])
GO
ALTER TABLE [dbo].[Project] CHECK CONSTRAINT [FK_dbo.Projects_dbo.Organizations_OrganizationId]
GO
ALTER TABLE [dbo].[ResourcePerson]  WITH CHECK ADD  CONSTRAINT [FK_dbo.ResourcePerson_dbo.OrganizationType_OrganizationTypeId] FOREIGN KEY([OrganizationTypeId])
REFERENCES [dbo].[OrganizationType] ([OrganizationTypeId])
GO
ALTER TABLE [dbo].[ResourcePerson] CHECK CONSTRAINT [FK_dbo.ResourcePerson_dbo.OrganizationType_OrganizationTypeId]
GO
ALTER TABLE [dbo].[ResourcePerson]  WITH CHECK ADD  CONSTRAINT [FK_dbo.ResourcePersons_dbo.AcademicQualifications_AcademicQualificationId] FOREIGN KEY([AcademicQualificationId])
REFERENCES [dbo].[AcademicQualification] ([AcademicQualificationId])
GO
ALTER TABLE [dbo].[ResourcePerson] CHECK CONSTRAINT [FK_dbo.ResourcePersons_dbo.AcademicQualifications_AcademicQualificationId]
GO
ALTER TABLE [dbo].[ResourcePerson]  WITH CHECK ADD  CONSTRAINT [FK_dbo.ResourcePersons_dbo.Districts_DistrictId] FOREIGN KEY([DistrictId])
REFERENCES [dbo].[District] ([DistrictId])
GO
ALTER TABLE [dbo].[ResourcePerson] CHECK CONSTRAINT [FK_dbo.ResourcePersons_dbo.Districts_DistrictId]
GO
ALTER TABLE [dbo].[ResourcePerson]  WITH CHECK ADD  CONSTRAINT [FK_dbo.ResourcePersons_dbo.Organizations_OrganizationId] FOREIGN KEY([OrganizationId])
REFERENCES [dbo].[Organization] ([OrganizationId])
GO
ALTER TABLE [dbo].[ResourcePerson] CHECK CONSTRAINT [FK_dbo.ResourcePersons_dbo.Organizations_OrganizationId]
GO
ALTER TABLE [dbo].[ResourcePersonArea]  WITH CHECK ADD  CONSTRAINT [FK_dbo.ResourcePersonArea_dbo.Area_AreaId] FOREIGN KEY([AreaId])
REFERENCES [dbo].[Area] ([AreaId])
GO
ALTER TABLE [dbo].[ResourcePersonArea] CHECK CONSTRAINT [FK_dbo.ResourcePersonArea_dbo.Area_AreaId]
GO
ALTER TABLE [dbo].[ResourcePersonArea]  WITH CHECK ADD  CONSTRAINT [FK_dbo.ResourcePersonArea_dbo.ResourcePerson_ResourcePersonId] FOREIGN KEY([ResourcePersonId])
REFERENCES [dbo].[ResourcePerson] ([ResourcePersonId])
GO
ALTER TABLE [dbo].[ResourcePersonArea] CHECK CONSTRAINT [FK_dbo.ResourcePersonArea_dbo.ResourcePerson_ResourcePersonId]
GO
ALTER TABLE [dbo].[ResourcePersonDisabilityType]  WITH CHECK ADD  CONSTRAINT [FK_dbo.ResourcePersonDisabilityType_dbo.DisabilityType_DisabilityTypeId] FOREIGN KEY([DisabilityTypeId])
REFERENCES [dbo].[DisabilityType] ([DisabilityTypeId])
GO
ALTER TABLE [dbo].[ResourcePersonDisabilityType] CHECK CONSTRAINT [FK_dbo.ResourcePersonDisabilityType_dbo.DisabilityType_DisabilityTypeId]
GO
ALTER TABLE [dbo].[ResourcePersonDisabilityType]  WITH CHECK ADD  CONSTRAINT [FK_dbo.ResourcePersonDisabilityType_dbo.ResourcePerson_ResourcePersonId] FOREIGN KEY([ResourcePersonId])
REFERENCES [dbo].[ResourcePerson] ([ResourcePersonId])
GO
ALTER TABLE [dbo].[ResourcePersonDisabilityType] CHECK CONSTRAINT [FK_dbo.ResourcePersonDisabilityType_dbo.ResourcePerson_ResourcePersonId]
GO
ALTER TABLE [dbo].[ResourcePersonTraining]  WITH CHECK ADD  CONSTRAINT [FK_dbo.ResourcePersonTrainings_dbo.ResourcePersons_ResourcePersonId] FOREIGN KEY([ResourcePersonId])
REFERENCES [dbo].[ResourcePerson] ([ResourcePersonId])
GO
ALTER TABLE [dbo].[ResourcePersonTraining] CHECK CONSTRAINT [FK_dbo.ResourcePersonTrainings_dbo.ResourcePersons_ResourcePersonId]
GO
ALTER TABLE [dbo].[ResourcePersonTraining]  WITH CHECK ADD  CONSTRAINT [FK_dbo.ResourcePersonTrainings_dbo.TrainingSessions_TrainingSessionId] FOREIGN KEY([TrainingSessionId])
REFERENCES [dbo].[TrainingSession] ([TrainingSessionId])
GO
ALTER TABLE [dbo].[ResourcePersonTraining] CHECK CONSTRAINT [FK_dbo.ResourcePersonTrainings_dbo.TrainingSessions_TrainingSessionId]
GO
ALTER TABLE [dbo].[Respondent]  WITH CHECK ADD  CONSTRAINT [FK_dbo.Respondent_dbo.AcademicQualification_AcademicQualificationId] FOREIGN KEY([AcademicQualificationId])
REFERENCES [dbo].[AcademicQualification] ([AcademicQualificationId])
GO
ALTER TABLE [dbo].[Respondent] CHECK CONSTRAINT [FK_dbo.Respondent_dbo.AcademicQualification_AcademicQualificationId]
GO
ALTER TABLE [dbo].[Respondent]  WITH CHECK ADD  CONSTRAINT [FK_dbo.Respondent_dbo.District_DistrictId] FOREIGN KEY([DistrictId])
REFERENCES [dbo].[District] ([DistrictId])
GO
ALTER TABLE [dbo].[Respondent] CHECK CONSTRAINT [FK_dbo.Respondent_dbo.District_DistrictId]
GO
ALTER TABLE [dbo].[Respondent]  WITH CHECK ADD  CONSTRAINT [FK_dbo.Respondent_dbo.Organization_OrganizationId] FOREIGN KEY([OrganizationId])
REFERENCES [dbo].[Organization] ([OrganizationId])
GO
ALTER TABLE [dbo].[Respondent] CHECK CONSTRAINT [FK_dbo.Respondent_dbo.Organization_OrganizationId]
GO
ALTER TABLE [dbo].[Respondent]  WITH CHECK ADD  CONSTRAINT [FK_dbo.Respondent_dbo.OrganizationType_OrganizationTypeId] FOREIGN KEY([OrganizationTypeId])
REFERENCES [dbo].[OrganizationType] ([OrganizationTypeId])
GO
ALTER TABLE [dbo].[Respondent] CHECK CONSTRAINT [FK_dbo.Respondent_dbo.OrganizationType_OrganizationTypeId]
GO
ALTER TABLE [dbo].[RespondentDisabilityType]  WITH CHECK ADD  CONSTRAINT [FK_dbo.RespondentDisabilityType_dbo.DisabilityType_DisabilityTypeId] FOREIGN KEY([DisabilityTypeId])
REFERENCES [dbo].[DisabilityType] ([DisabilityTypeId])
GO
ALTER TABLE [dbo].[RespondentDisabilityType] CHECK CONSTRAINT [FK_dbo.RespondentDisabilityType_dbo.DisabilityType_DisabilityTypeId]
GO
ALTER TABLE [dbo].[RespondentDisabilityType]  WITH CHECK ADD  CONSTRAINT [FK_dbo.RespondentDisabilityType_dbo.Respondent_RespondentId] FOREIGN KEY([RespondentId])
REFERENCES [dbo].[Respondent] ([RespondentId])
GO
ALTER TABLE [dbo].[RespondentDisabilityType] CHECK CONSTRAINT [FK_dbo.RespondentDisabilityType_dbo.Respondent_RespondentId]
GO
ALTER TABLE [dbo].[SurveyQuestion]  WITH CHECK ADD  CONSTRAINT [FK_dbo.SurveyQuestion_dbo.Question_QuestionId] FOREIGN KEY([QuestionId])
REFERENCES [dbo].[Question] ([QuestionId])
GO
ALTER TABLE [dbo].[SurveyQuestion] CHECK CONSTRAINT [FK_dbo.SurveyQuestion_dbo.Question_QuestionId]
GO
ALTER TABLE [dbo].[SurveyQuestion]  WITH CHECK ADD  CONSTRAINT [FK_dbo.SurveyQuestion_dbo.Survey_SurveyId] FOREIGN KEY([SurveyId])
REFERENCES [dbo].[Survey] ([SurveyId])
GO
ALTER TABLE [dbo].[SurveyQuestion] CHECK CONSTRAINT [FK_dbo.SurveyQuestion_dbo.Survey_SurveyId]
GO
ALTER TABLE [dbo].[SurveyQuestionResponse]  WITH CHECK ADD  CONSTRAINT [FK_dbo.SurveyQuestionResponse_dbo.Question_QuestionId] FOREIGN KEY([QuestionId])
REFERENCES [dbo].[Question] ([QuestionId])
GO
ALTER TABLE [dbo].[SurveyQuestionResponse] CHECK CONSTRAINT [FK_dbo.SurveyQuestionResponse_dbo.Question_QuestionId]
GO
ALTER TABLE [dbo].[SurveyQuestionResponse]  WITH CHECK ADD  CONSTRAINT [FK_dbo.SurveyQuestionResponse_dbo.Respondent_RespondentId] FOREIGN KEY([RespondentId])
REFERENCES [dbo].[Respondent] ([RespondentId])
GO
ALTER TABLE [dbo].[SurveyQuestionResponse] CHECK CONSTRAINT [FK_dbo.SurveyQuestionResponse_dbo.Respondent_RespondentId]
GO
ALTER TABLE [dbo].[SurveyQuestionResponse]  WITH CHECK ADD  CONSTRAINT [FK_dbo.SurveyQuestionResponse_dbo.Survey_SurveyId] FOREIGN KEY([SurveyId])
REFERENCES [dbo].[Survey] ([SurveyId])
GO
ALTER TABLE [dbo].[SurveyQuestionResponse] CHECK CONSTRAINT [FK_dbo.SurveyQuestionResponse_dbo.Survey_SurveyId]
GO
ALTER TABLE [dbo].[Training]  WITH CHECK ADD  CONSTRAINT [FK_dbo.Training_dbo.Survey_SurveyId] FOREIGN KEY([SurveyId])
REFERENCES [dbo].[Survey] ([SurveyId])
GO
ALTER TABLE [dbo].[Training] CHECK CONSTRAINT [FK_dbo.Training_dbo.Survey_SurveyId]
GO
ALTER TABLE [dbo].[Training]  WITH CHECK ADD  CONSTRAINT [FK_dbo.Trainings_dbo.Cities_CityId] FOREIGN KEY([CityId])
REFERENCES [dbo].[City] ([CityId])
GO
ALTER TABLE [dbo].[Training] CHECK CONSTRAINT [FK_dbo.Trainings_dbo.Cities_CityId]
GO
ALTER TABLE [dbo].[Training]  WITH CHECK ADD  CONSTRAINT [FK_dbo.Trainings_dbo.Districts_DistrictId] FOREIGN KEY([DistrictId])
REFERENCES [dbo].[District] ([DistrictId])
GO
ALTER TABLE [dbo].[Training] CHECK CONSTRAINT [FK_dbo.Trainings_dbo.Districts_DistrictId]
GO
ALTER TABLE [dbo].[Training]  WITH CHECK ADD  CONSTRAINT [FK_dbo.Trainings_dbo.Provinces_ProvinceId] FOREIGN KEY([ProvinceId])
REFERENCES [dbo].[Province] ([ProvinceId])
GO
ALTER TABLE [dbo].[Training] CHECK CONSTRAINT [FK_dbo.Trainings_dbo.Provinces_ProvinceId]
GO
ALTER TABLE [dbo].[TrainingActivity]  WITH CHECK ADD  CONSTRAINT [FK_dbo.TrainingActivities_dbo.Districts_DistrictId] FOREIGN KEY([DistrictId])
REFERENCES [dbo].[District] ([DistrictId])
GO
ALTER TABLE [dbo].[TrainingActivity] CHECK CONSTRAINT [FK_dbo.TrainingActivities_dbo.Districts_DistrictId]
GO
ALTER TABLE [dbo].[TrainingActivity]  WITH CHECK ADD  CONSTRAINT [FK_dbo.TrainingActivities_dbo.Organizations_OrganizationId] FOREIGN KEY([OrganizationId])
REFERENCES [dbo].[Organization] ([OrganizationId])
GO
ALTER TABLE [dbo].[TrainingActivity] CHECK CONSTRAINT [FK_dbo.TrainingActivities_dbo.Organizations_OrganizationId]
GO
ALTER TABLE [dbo].[TrainingActivity]  WITH CHECK ADD  CONSTRAINT [FK_dbo.TrainingActivities_dbo.Provinces_ProvinceId] FOREIGN KEY([ProvinceId])
REFERENCES [dbo].[Province] ([ProvinceId])
GO
ALTER TABLE [dbo].[TrainingActivity] CHECK CONSTRAINT [FK_dbo.TrainingActivities_dbo.Provinces_ProvinceId]
GO
ALTER TABLE [dbo].[TrainingCost]  WITH CHECK ADD  CONSTRAINT [FK_dbo.TrainingCosts_dbo.Fundings_FundingId] FOREIGN KEY([FundingId])
REFERENCES [dbo].[Funding] ([FundingId])
GO
ALTER TABLE [dbo].[TrainingCost] CHECK CONSTRAINT [FK_dbo.TrainingCosts_dbo.Fundings_FundingId]
GO
ALTER TABLE [dbo].[TrainingCost]  WITH CHECK ADD  CONSTRAINT [FK_dbo.TrainingCosts_dbo.Trainings_TrainingId] FOREIGN KEY([TrainingId])
REFERENCES [dbo].[Training] ([TrainingId])
GO
ALTER TABLE [dbo].[TrainingCost] CHECK CONSTRAINT [FK_dbo.TrainingCosts_dbo.Trainings_TrainingId]
GO
ALTER TABLE [dbo].[TrainingEvaluation]  WITH CHECK ADD  CONSTRAINT [FK_dbo.TrainingEvaluation_dbo.Participant_ParticipantId] FOREIGN KEY([ParticipantId])
REFERENCES [dbo].[Participant] ([ParticipantId])
GO
ALTER TABLE [dbo].[TrainingEvaluation] CHECK CONSTRAINT [FK_dbo.TrainingEvaluation_dbo.Participant_ParticipantId]
GO
ALTER TABLE [dbo].[TrainingEvaluation]  WITH CHECK ADD  CONSTRAINT [FK_dbo.TrainingEvaluation_dbo.Question_QuestionId] FOREIGN KEY([QuestionId])
REFERENCES [dbo].[Question] ([QuestionId])
GO
ALTER TABLE [dbo].[TrainingEvaluation] CHECK CONSTRAINT [FK_dbo.TrainingEvaluation_dbo.Question_QuestionId]
GO
ALTER TABLE [dbo].[TrainingEvaluation]  WITH CHECK ADD  CONSTRAINT [FK_dbo.TrainingEvaluation_dbo.Survey_SurveyId] FOREIGN KEY([SurveyId])
REFERENCES [dbo].[Survey] ([SurveyId])
GO
ALTER TABLE [dbo].[TrainingEvaluation] CHECK CONSTRAINT [FK_dbo.TrainingEvaluation_dbo.Survey_SurveyId]
GO
ALTER TABLE [dbo].[TrainingEvaluation]  WITH CHECK ADD  CONSTRAINT [FK_dbo.TrainingEvaluation_dbo.Training_TrainingId] FOREIGN KEY([TrainingId])
REFERENCES [dbo].[Training] ([TrainingId])
GO
ALTER TABLE [dbo].[TrainingEvaluation] CHECK CONSTRAINT [FK_dbo.TrainingEvaluation_dbo.Training_TrainingId]
GO
ALTER TABLE [dbo].[TrainingOrganization]  WITH CHECK ADD  CONSTRAINT [FK_dbo.TrainingOrganization_dbo.Organization_OrganizationId] FOREIGN KEY([OrganizationId])
REFERENCES [dbo].[Organization] ([OrganizationId])
GO
ALTER TABLE [dbo].[TrainingOrganization] CHECK CONSTRAINT [FK_dbo.TrainingOrganization_dbo.Organization_OrganizationId]
GO
ALTER TABLE [dbo].[TrainingOrganization]  WITH CHECK ADD  CONSTRAINT [FK_dbo.TrainingOrganization_dbo.Training_TrainingId] FOREIGN KEY([TrainingId])
REFERENCES [dbo].[Training] ([TrainingId])
GO
ALTER TABLE [dbo].[TrainingOrganization] CHECK CONSTRAINT [FK_dbo.TrainingOrganization_dbo.Training_TrainingId]
GO
ALTER TABLE [dbo].[TrainingSession]  WITH CHECK ADD  CONSTRAINT [FK_dbo.TrainingSessions_dbo.Trainings_Training_TrainingId] FOREIGN KEY([TrainingId])
REFERENCES [dbo].[Training] ([TrainingId])
GO
ALTER TABLE [dbo].[TrainingSession] CHECK CONSTRAINT [FK_dbo.TrainingSessions_dbo.Trainings_Training_TrainingId]
GO
ALTER TABLE [dbo].[TrainingSessionParticipant]  WITH CHECK ADD  CONSTRAINT [FK_dbo.TrainingSessionParticipant_dbo.Participant_ParticipantId] FOREIGN KEY([ParticipantId])
REFERENCES [dbo].[Participant] ([ParticipantId])
GO
ALTER TABLE [dbo].[TrainingSessionParticipant] CHECK CONSTRAINT [FK_dbo.TrainingSessionParticipant_dbo.Participant_ParticipantId]
GO
ALTER TABLE [dbo].[TrainingSessionParticipant]  WITH CHECK ADD  CONSTRAINT [FK_dbo.TrainingSessionParticipant_dbo.TrainingSession_TrainingSessionId] FOREIGN KEY([TrainingSessionId])
REFERENCES [dbo].[TrainingSession] ([TrainingSessionId])
GO
ALTER TABLE [dbo].[TrainingSessionParticipant] CHECK CONSTRAINT [FK_dbo.TrainingSessionParticipant_dbo.TrainingSession_TrainingSessionId]
GO
USE [master]
GO
ALTER DATABASE [ODTKMS] SET  READ_WRITE 
GO
