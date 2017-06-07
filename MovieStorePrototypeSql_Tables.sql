USE [Master]
GO

CREATE DATABASE [DBP]
GO

USE [DBP]
GO

BEGIN TRANSACTION CreateMovieTable
	----Non-Dependent Entities----
	CREATE TABLE [dbo].[DISCOUNT]
	(
		[DiscountID] INT IDENTITY (1,1) NOT NULL,
		
		[DiscountName] VARCHAR (50) NOT NULL,
		[DiscountDescription] VARCHAR (100),

		PRIMARY KEY ([DiscountID]),
		UNIQUE ([DiscountName])
	) ON [PRIMARY]


	CREATE TABLE [dbo].[RATING]
	(
		[RatingID] INT NOT NULL,

		[RatingName] VARCHAR (50) NOT NULL,
		[RatingDescription] VARCHAR (100) 

		PRIMARY KEY ([RatingID]),
		UNIQUE ([RatingName])
	) ON [PRIMARY]

	CREATE TABLE [dbo].[CUSTOMER]
	(
		[CustomerID] INT IDENTITY (1,1) NOT NULL,
	
		[CustomerFirstName] VARCHAR (50) NOT NULL,
		[CustomerLastName] VARCHAR (50) NOT NULL,
		[CustomerEmail] VARCHAR (50) NOT NULL,
		[CustomerDOB] DATE NOT NULL,
		[CustomerStreet] VARCHAR (50) NOT NULL,
		[CustomerCity] VARCHAR (50) NOT NULL,
		[CustomerState] CHAR (2) NOT NULL, --Use state abbreviations instead (e.g. WA, CA, NY)
		[CustomerPostal] CHAR (5) NOT NULL, --Some postal codes start with 0
		[Username] VARCHAR (15) NOT NULL,
		[Password] VARCHAR (15) NOT NULL,
		[CustomerImage] IMAGE,
	
		PRIMARY KEY ([CustomerID]),
		UNIQUE ([Username]), 
		UNIQUE ([CustomerEmail])
	) ON [PRIMARY]

	CREATE TABLE [dbo].[CONDITION]
	(
		[ConditionID] INT IDENTITY (1,1) NOT NULL,

		[ConditionName] VARCHAR (50) NOT NULL,
		[ConditionDescription] VARCHAR (100),

		PRIMARY KEY ([ConditionID]),
		UNIQUE ([ConditionName])
	) ON [PRIMARY]

	CREATE TABLE [dbo].[FORMAT]
	(
		[FormatID] INT IDENTITY (1,1) NOT NULL,

		[FormatName] VARCHAR (15) NOT NULL,
		[FormatDescription] VARCHAR (50),

		PRIMARY KEY ([FormatID]),
		UNIQUE ([FormatName])
	) ON [PRIMARY]

	CREATE TABLE [dbo].[MEMBERSHIP_TYPE]
	(
		[MembershipTypeID] INT IDENTITY (1,1) NOT NULL,

		[MembershipTypeName] VARCHAR (15) NOT NULL,
		[MembershipTypeDescription] VARCHAR (50),

		PRIMARY KEY ([MembershipTypeID]),
		UNIQUE ([MembershipTypeName])
	) ON [PRIMARY]

	CREATE TABLE [dbo].[STATUS]
	(
		[StatusID] INT IDENTITY (1,1) NOT NULL,

		[StatusName] VARCHAR (25) NOT NULL,
		[StatusDescription] VARCHAR (50),

		PRIMARY KEY ([StatusID]),
		UNIQUE ([StatusName])
	) ON [PRIMARY]

	CREATE TABLE [dbo].[GENRE]
	(
		[GenreID] INT IDENTITY (1,1) NOT NULL,
	
		[GenreName] VARCHAR (25) NOT NULL,
		[GenreDescription] VARCHAR (50),

		PRIMARY KEY ([GenreID]),
		UNIQUE ([GenreName])	
	) ON [PRIMARY]

	CREATE TABLE [dbo].[MOVIE]
	(
		[MovieID] INT IDENTITY (1,1) NOT NULL,

		[MovieName] VARCHAR (250) NOT NULL,
		[MovieReleaseDate] DATE NOT NULL,
		[RunningTime] DECIMAL (7,2) NOT NULL,
		[MovieDescription] VARCHAR (500),
		[MoviePoster] IMAGE,

		PRIMARY KEY ([MovieID]),
		UNIQUE ([MovieName], [MovieReleaseDate])
	) ON [PRIMARY]

	CREATE TABLE [dbo].[AWARD]
	(
		[AwardID] INT IDENTITY (1,1) NOT NULL,

		[AwardName] VARCHAR (50) NOT NULL,
		[AwardDescription] VARCHAR (100),

		PRIMARY KEY ([AwardID]),
		UNIQUE ([AwardName])
	) ON [PRIMARY]

	CREATE TABLE [dbo].[PROFESSIONAL]
	(
		[ProfessionalID] INT IDENTITY (1,1) NOT NULL,
	
		[ProfessionalFirstName] VARCHAR (50) NOT NULL,
		[ProfessionalLastName] VARCHAR (50) NOT NULL,
		[ProfessionalDOB] DATE NOT NULL,
		[ProfessionalBiography] VARCHAR (500),
		[ProfessionalImage] IMAGE,
		
		PRIMARY KEY ([ProfessionalID]),
		UNIQUE ([ProfessionalFirstName], [ProfessionalLastName], [ProfessionalDOB])
	) ON [PRIMARY]

	----Dependent Entities/Associate Entities----
	CREATE TABLE [dbo].[PROMOTION]
	(
		[PromotionID] INT IDENTITY (1,1) NOT NULL,
		[DiscountID] INT NOT NULL,
	
		[PromotionName] VARCHAR (50) NOT NULL,
		[BeginDate] DATE NOT NULL, 
		[EndDate] DATE,
		[PromotionDescription] VARCHAR (100),
	
		PRIMARY KEY ([PromotionID]),
		UNIQUE ([PromotionName], [BeginDate], [EndDate])
	) ON [PRIMARY]

	CREATE TABLE [dbo].[REVIEW]
	(
		[ReviewID] INT IDENTITY (1,1) NOT NULL,
		[RatingID] INT,
		[RentalID] INT,

		[ReviewText] VARCHAR (500) NOT NULL,

		PRIMARY KEY ([ReviewID])
	) ON [PRIMARY]

	CREATE TABLE [dbo].[RENTAL] 
	(
		[RentalID] INT IDENTITY (1,1) NOT NULL,
		[CustomerID] INT,
		[DiscID] INT,
		[PromotionID] INT,

		[RentalDate] DATE,

		PRIMARY KEY ([RentalID])
	) ON [PRIMARY]

	CREATE TABLE [dbo].[DISC_CONDITION]
	(
		[DiscID] INT NOT NULL,
		[ConditionID] INT NOT NULL,

		[BeginDate] DATE NOT NULL,

		PRIMARY KEY ([DiscID], [ConditionID])
	) ON [PRIMARY]

	CREATE TABLE [dbo].[DISC]
	(
		[DiscID] INT IDENTITY (1,1) NOT NULL,
		[MovieID] INT NOT NULL,
		[FormatID] INT NOT NULL,

		[PurchaseDate] DATE NOT NULL,

		PRIMARY KEY ([DiscID])
	) ON [PRIMARY]

	CREATE TABLE [dbo].[MEMBERSHIP]
	(
		[MembershipID] INT IDENTITY (1,1) NOT NULL,
		[MembershipTypeID] INT,
		[CustomerID] INT,
	
		[BeginDate] DATE NOT NULL,
		[EndDate] DATE,

		PRIMARY KEY ([MembershipID]),
		UNIQUE ([MembershipTypeID], [CustomerID])
	) ON [PRIMARY]

	CREATE TABLE [dbo].[MOVIE_GENRE]
	(
		[MovieID] INT NOT NULL,
		[GenreID] INT NOT NULL,

		PRIMARY KEY ([MovieID], [GenreID])
	) ON [PRIMARY]

	CREATE TABLE [dbo].[MOVIE_STATUS]
	(
		[MovieID] INT NOT NULL,
		[StatusID] INT NOT NULL,

		[BeginDate] DATE NOT NULL,
		[EndDate] DATE,

		PRIMARY KEY ([MovieID], [StatusID])	
	) ON [PRIMARY]

	CREATE TABLE [dbo].[NOMINATION]
	(
		[AwardID] INT NOT NULL,
		[CastID] INT NOT NULL,

		[Year] DATE NOT NULL,
		[Winner] BIT,

		PRIMARY KEY ([AwardID], [CastID])		
	) ON [PRIMARY]

	CREATE TABLE [dbo].[CAST]
	(
		[CastID] INT IDENTITY (1,1) NOT NULL,
		[ProfessionalID] INT NOT NULL,
		[MovieID] INT NOT NULL,

		PRIMARY KEY ([CastID]),
		UNIQUE ([ProfessionalID], [MovieID])
	) ON [PRIMARY]

	CREATE TABLE [dbo].[CREW]
	(
		[CastID] INT NOT NULL,
	
		[Title] VARCHAR (50) NOT NULL,
		[BeginDate] DATE NOT NULL,
		[EndDate] DATE,
		[Union] VARCHAR (50)
		
		PRIMARY KEY ([CastID])
	) ON [PRIMARY]

	CREATE TABLE [dbo].[ACTOR]
	(
		[CastID] INT NOT NULL,
	
		[CharacterFirstName] VARCHAR (50) NOT NULL,
		[CharacterLastName] VARCHAR (50) NOT NULL,
		[CharacterAge] VARCHAR (3) NOT NULL,
		
		PRIMARY KEY ([CastID])	
	) ON [PRIMARY]

	CREATE TABLE [dbo].[WRITER]
	(
		[CastID] INT NOT NULL,
	
		[DraftSubmitDate] DATE NOT NULL,
		[RevisionRetainer] BIT NOT NULL

		PRIMARY KEY ([CastID])	
	) ON [PRIMARY]

	CREATE TABLE [dbo].[DIRECTOR]
	(
		[CastID] INT NOT NULL,	
	
		[IsFinalCut] BIT NOT NULL,
		[LensDensity] DECIMAL (10,2)

		PRIMARY KEY ([CastID])		
	) ON [PRIMARY]
COMMIT TRANSACTION CreateMovieTable
GO