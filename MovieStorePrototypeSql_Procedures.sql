USE [DBP]
GO

----Non-Dependent Entities----
CREATE PROCEDURE [uspAddDiscount]
	@discountName VARCHAR (50),
	@discountDescription VARCHAR (100) = 'No description available.'
AS	
BEGIN TRANSACTION AddDiscount 
	INSERT INTO [dbo].[DISCOUNT]
	VALUES
	(
		@discountName,
		@discountDescription 
	)
COMMIT TRANSACTION AddDiscount
GO

CREATE PROCEDURE [uspAddRating]
	@ratingID INT,
	@ratingName VARCHAR (50),
	@ratingDescription VARCHAR (100) = 'No description available.'
AS
BEGIN TRANSACTION AddRating
	INSERT INTO [dbo].[RATING]
	VALUES
	(
		@ratingID,
		@ratingName,
		@ratingDescription
	)
COMMIT TRANSACTION AddRating
GO

CREATE PROCEDURE [uspAddCustomer]
	@firstName VARCHAR (50),
	@lastName VARCHAR (50),
	@email VARCHAR (50),
	@dob DATE,
	@street VARCHAR (50),
	@city VARCHAR (50),
	@state CHAR (2), 
	@postal CHAR (5), 
	@username VARCHAR (15),
	@password VARCHAR (15)
AS
BEGIN TRANSACTION AddCustomer
	INSERT INTO [dbo].[CUSTOMER]
	VALUES
	(
		@firstName,
		@lastName,
		@email,
		@dob,
		@street,
		@city,
		@state, 
		@postal, 
		@username,
		@password,
		'',
		GETDATE (),
		CAST(GETDATE () AS DATE)
	)
COMMIT TRANSACTION AddCustomer
GO

CREATE PROCEDURE [uspAddCondition]
	@conditionName VARCHAR (50),
	@conditionDescription VARCHAR (100) = 'No description available.'
AS
BEGIN TRANSACTION AddCondition
	INSERT INTO [dbo].[CONDITION]
	VALUES
	(
		@conditionName,
		@conditionDescription
	)
COMMIT TRANSACTION AddCondition
GO

CREATE PROCEDURE [uspAddMembershipType]
	@membershipTypeName VARCHAR (15),
	@membershipTypeDescription VARCHAR (50) = 'No description available.'
AS
BEGIN TRANSACTION AddMembershipType
	INSERT INTO [dbo].[MEMBERSHIP_TYPE]
	VALUES
	(
		@membershipTypeName,
		@membershipTypeDescription
	)
COMMIT TRANSACTION AddMembershipType
GO

CREATE PROCEDURE [uspAddFormat]
	@formatName VARCHAR (15),
	@formatDescription VARCHAR (50) = 'No description available.'
AS
BEGIN TRANSACTION AddFormat
	INSERT INTO [dbo].[FORMAT]
	VALUES
	(
		@formatName,
		@formatDescription
	)
COMMIT TRANSACTION AddFormat
GO

CREATE PROCEDURE [uspAddStatus]
	@statusName VARCHAR (25),
	@statusDescription VARCHAR (50) = 'No description available.'
AS
BEGIN TRANSACTION AddStatus
	INSERT INTO [dbo].[STATUS]
	VALUES
	(
		@statusName,
		@statusDescription
	)
COMMIT TRANSACTION AddStatus
GO

CREATE PROCEDURE [uspAddGenre]
	@genreName VARCHAR (25),
	@genreDescription VARCHAR (50) = 'No description available.'
AS
BEGIN TRANSACTION AddGenre
	INSERT INTO [dbo].[GENRE]
	VALUES
	(
		@genreName,
		@genreDescription
	)
COMMIT TRANSACTION AddGenre
GO

CREATE PROCEDURE [uspAddAward]
	@awardName VARCHAR (50),
	@awardDescription VARCHAR (100) = 'No description available.'
AS
BEGIN TRANSACTION AddAward
	INSERT INTO [dbo].[AWARD]
	VALUES
	(
		@awardName,
		@awardDescription
	)
COMMIT TRANSACTION AddAward
GO

CREATE PROCEDURE [uspAddProfessional]
	@firstName VARCHAR (50),
	@lastName VARCHAR (50),
	@dob DATE,
	@biography VARCHAR (500) = 'No description available.',
	@image IMAGE = ''
AS 
BEGIN TRANSACTION AddProfessional
	INSERT INTO [dbo].[PROFESSIONAL]
	VALUES
	(
		@firstName,
		@lastName,
		@dob,
		@biography,
		@image
	)
COMMIT TRANSACTION AddProfessional
GO

----Dependent Entities/Associate Entities----
CREATE PROCEDURE [uspAddPromotion]
	----DISCOUNT FK
	@discountName VARCHAR (50),
	----PROMOTION Attributes
	@promotionName VARCHAR (50),
	@beginDate DATE,
	@endDate DATE,
	@promotionDescription VARCHAR(100) = 'No description available.',
	----Additional Flag
	@createChildIfNotExisted BIT = 0
AS 
BEGIN TRANSACTION AddPromotion
		IF NOT EXISTS ( 
			SELECT * 
			FROM [dbo].[DISCOUNT]
			WHERE [DiscountName] = @discountName
		)
		BEGIN
			IF NOT (@createChildIfNotExisted = 0)
				EXECUTE uspAddDiscount @discountName
			ELSE
				RAISERROR ('Discount is not existed in database.', 16, 1)
		END
	INSERT INTO [dbo].[PROMOTION]
	VALUES
	(
		(
			SELECT [DiscountID]
			FROM [dbo].[DISCOUNT]
			WHERE [DiscountName] = @discountName
		),
		@promotionName,
		@beginDate,
		@endDate,
		@promotionDescription
	)
COMMIT TRANSACTION AddPromotion
GO

CREATE PROCEDURE [uspAddDisc]
	----MOVIE FK
	@movieName VARCHAR (250),
	@releaseDate DATE,
	----FORMAT FK
	@formatName VARCHAR (15),
	----DISC Attribute
	@purchaseDate  DATE,
	----Additional Flag
	@createChildIfNotExisted BIT = 0
AS 
BEGIN TRANSACTION AddDisk
	IF NOT EXISTS ( 
		SELECT * 
		FROM [dbo].[MOVIE]
		WHERE [MovieName] = @movieName AND
		[MovieReleaseDate] = @releaseDate
	)
		RAISERROR ('Movie is not existed in database.', 16, 1)
	
	IF NOT EXISTS ( 
		SELECT * 
		FROM [dbo].[FORMAT]
		WHERE [FormatName] = @formatName
	)
	BEGIN
		IF NOT (@createChildIfNotExisted = 0)
			EXECUTE uspAddCondition @formatName
		ELSE
			RAISERROR ('Format is not existed in database.', 16, 1)				
	END	
			
	INSERT INTO [dbo].[DISC]
	VALUES
	(
		(
			SELECT [MovieID]
			FROM [dbo].[MOVIE]
			WHERE [MovieName] = @movieName AND
			[MovieReleaseDate] = @releaseDate 
		),
		(
			SELECT [FormatID]
			FROM [dbo].[FORMAT]
			WHERE [FormatName] = @formatName
		),
		@purchaseDate
	)	
COMMIT TRANSACTION AddDisk
GO

CREATE PROCEDURE [uspAddConditionToDisc]
	----CONDITION FK
	@conditionName VARCHAR (50),
	----DISC FK
	@discID INT,
	----DISC_CONDITION Attribute
	@beginDate DATE,
	----Additional Flag
	@createChildIfNotExisted BIT = 0
AS
BEGIN TRANSACTION AddConditionToDisc
	IF (@beginDate IS NULL)
		SET @beginDate = GETDATE()

	IF NOT EXISTS (
		SELECT *
		FROM [dbo].[DISC]
		WHERE [DiscID] = @discID
	)	
		RAISERROR ('Disc is not existed in database.', 16, 1)	

	IF NOT EXISTS ( 
		SELECT * 
		FROM [dbo].[CONDITION]
		WHERE [ConditionName] = @conditionName
	)
	BEGIN
		IF NOT (@createChildIfNotExisted = 0)
			EXECUTE uspAddCondition @conditionName
		ELSE
			RAISERROR ('Condition is not existed in database.', 16, 1)	
	END	

	INSERT INTO [dbo].[DISC_CONDITION]
	VALUES
	(
		@discID,
		(
			SELECT [ConditionID]
			FROM [dbo].[CONDITION]
			WHERE [ConditionName] = @conditionName
		),
		@beginDate
	)
COMMIT TRANSACTION AddConditionToDisc
GO

CREATE PROCEDURE [uspAddGenreToMovie]
	----MOVIE FK
	@movieName VARCHAR (250),
	@releaseDate DATE,
	----GENRE FK
	@genreName VARCHAR (25),
	----Additional Flag
	@createChildIfNotExisted BIT = 0
AS
BEGIN TRANSACTION AddGenreToMovie
	IF NOT EXISTS (
		SELECT *
		FROM [dbo].[MOVIE]
		WHERE [MovieName] = @movieName AND
		[MovieReleaseDate] = @releaseDate
	)
		RAISERROR ('Movie is not existed in database.', 16, 1)
	
	IF NOT EXISTS (
		SELECT * 
		FROM [dbo].[GENRE]
		WHERE [GenreName] = @genreName
	)		
	BEGIN
		IF NOT (@createChildIfNotExisted = 0)
			EXECUTE uspAddGenre @genreName
		ELSE 
			RAISERROR ('Genre is not existed in database.', 16, 1)
	END

	INSERT INTO [dbo].[MOVIE_GENRE]
	VALUES
	(
		(
			SELECT [MovieID] 
			FROM [dbo].[MOVIE] 
			WHERE [MovieName] = @movieName AND
			[MovieReleaseDate] = @releaseDate
		),
		(
			SELECT [GenreID]
			FROM [dbo].[GENRE]
			WHERE [GenreName] = @genreName
		)
	)
COMMIT TRANSACTION AddGenreToMovie
GO

CREATE PROCEDURE [uspAddMovie]
	@movieNameParam VARCHAR (250),
	@releaseDateParam DATE,
	@runningTimeParam DECIMAL (7,2),
	@movieDescriptionParam VARCHAR (500) = 'No description available.', 
	@moviePosterParam IMAGE = ''
AS
BEGIN TRANSACTION AddMovie
	INSERT INTO [dbo].[MOVIE]
	VALUES
	(
		@movieNameParam,
		@releaseDateParam,
		@runningTimeParam,
		@movieDescriptionParam, 
		@moviePosterParam
	)
COMMIT TRANSACTION AddMovie
GO

CREATE PROCEDURE [uspAddStatusToMovie]
	----MOVIE FK
	@movieName VARCHAR (250),
	@releaseDate DATE,
	----STATUS FK
	@statusName VARCHAR (25),
	----MOVIE_STATUS Attribute
	@beginDate DATE,
	@endDATE DATE,
	----Additional Flag
	@createChildIfNotExisted BIT = 0
AS
BEGIN TRANSACTION AddStatusToMovie
	IF NOT EXISTS (
		SELECT *
		FROM [dbo].[MOVIE]
		WHERE [MovieName] = @movieName AND
		[MovieReleaseDate] = @releaseDate
	)
		RAISERROR ('Movie is not existed in database.', 16, 1)

	IF NOT EXISTS (
		SELECT * 
		FROM [dbo].[STATUS]
		WHERE [StatusName] = @statusName
	)		
	BEGIN
		IF NOT (@createChildIfNotExisted = 0)
			EXECUTE uspAddStatus @statusName 	
		ELSE 
			RAISERROR ('Status is not existed in database.', 16, 1)
	END

	INSERT INTO [dbo].[MOVIE_STATUS]
	VALUES
	(
		(
			SELECT [MovieID]
			FROM [dbo].[MOVIE]
			WHERE [MovieName] = @movieName AND 
			[MovieReleaseDate] = @releaseDate
		),
		(
			SELECT [StatusID]
			FROM [dbo].[STATUS]
			WHERE [StatusName] = @statusName
		),
		@beginDate,
		@endDATE
	)
COMMIT TRANSACTION AddStatusToMovie
GO

CREATE PROCEDURE [uspAddMembership]
	----MEMBERSHIP_TYPE FK
	@membershipTypeName VARCHAR (15),
	----CUSTOMER FK
	@username VARCHAR (15),
	----MEMBERSHIP Attribute
	@beginDate DATE,
	@endDate DATE,
	----Additional Flag
	@createChildIfNotExisted BIT = 0
AS
BEGIN TRANSACTION AddMembership
	IF (@beginDate IS NULL)
		SET @beginDate = GETDATE()
	
	IF NOT EXISTS (
		SELECT * 
		FROM [MEMBERSHIP_TYPE]
		WHERE [MembershipTypeName] = @membershipTypeName
	)
	BEGIN
		IF NOT (@createChildIfNotExisted = 0)
			EXECUTE uspAddMembershipType @membershipTypeName
		ELSE
			RAISERROR ('Membership type is not existed in database.', 16, 1)
	END

	INSERT INTO [dbo].[MEMBERSHIP]
	VALUES
	(
		(
			SELECT [MembershipTypeID]
			FROM [dbo].[MEMBERSHIP_TYPE]
			WHERE [MembershipTypeName] = @membershipTypeName
		),
		(
			SELECT [CustomerID]
			FROM [dbo].[CUSTOMER]
			WHERE [Username] = @username
		),
		@beginDate,
		@endDate
	)
COMMIT TRANSACTION AddMembership
GO

CREATE PROCEDURE [uspAddRental]
	----Customer FK
	@username VARCHAR (15),
	----DISC FK
	@discID INT,
	----Promotion FK
	@promotionName VARCHAR (50),
	@promotionBeginDate DATE,
	@promotionEndDate DATE,
	----Rental Attribute
	@rentalDate DATE
AS
BEGIN TRANSACTION AddRental
	IF (@rentalDate IS NULL)
		SET @rentalDate = GETDATE()

	IF NOT EXISTS (
		SELECT * 
		FROM [dbo].[CUSTOMER]
		WHERE [Username] = @username
	)
		RAISERROR ('Customer is not existed in database.', 16, 1)

	IF NOT EXISTS (
		SELECT *
		FROM [dbo].[PROMOTION]
		WHERE [PromotionName] = @promotionName AND
		[BeginDate] = @promotionBeginDate AND
		[EndDate] = @promotionEndDate
	)
		RAISERROR ('Promotion is not existed in database.', 16, 1)

	INSERT INTO [dbo].[RENTAL]
	VALUES 
	(
		(
			SELECT [CustomerID]
			FROM [dbo].[CUSTOMER]
			WHERE [Username] = @username
		),
		@discID,
		(
			SELECT [PromotionID]
			FROM [dbo].[PROMOTION]
			WHERE [PromotionName] = @promotionName AND
			[BeginDate] = @promotionBeginDate AND
			[EndDate] = @promotionEndDate
		),
		@rentalDate
	)
COMMIT TRANSACTION AddRental
GO

CREATE PROCEDURE [uspAddCast]
	----PROFESSIONAL FK
	@firstName VARCHAR (50),
	@lastName VARCHAR (50),
	@dob DATE,
	----MOVIE FK
	@movieName VARCHAR (250),
	@releaseDate DATE,
	----Additional Flag
	@createChildIfNotExisted BIT = 0
AS
BEGIN TRANSACTION AddCast
	IF NOT EXISTS ( 
		SELECT *
		FROM [dbo].[PROFESSIONAL]
		WHERE [ProfessionalFirstName] = @firstName AND
		[ProfessionalLastName] = @lastName AND
		[ProfessionalDOB] = @dob
	)
	BEGIN
		IF NOT (@createChildIfNotExisted = 0)
			EXECUTE uspAddProfessional @firstName, @lastName, @dob
		ELSE
			RAISERROR ('Professional is not existed in database.', 16, 1)
	END

	IF NOT EXISTS ( 
		SELECT * 
		FROM [dbo].[MOVIE]
		WHERE [MovieName] = @movieName AND 
		[MovieReleaseDate] = @releaseDate
	)
		RAISERROR ('Movie is not existed in database. Please add new movie by using uspAddMovie', 16, 1)

	INSERT INTO [dbo].[CAST]
	VALUES
	(
		(
			SELECT [ProfessionalID]
			FROM [dbo].[PROFESSIONAL]
			WHERE [ProfessionalFirstName] = @firstName AND
			[ProfessionalLastName] = @lastName AND
			[ProfessionalDOB] = @dob
		),
		(
			SELECT [MovieID]
			FROM [dbo].[MOVIE]
			WHERE [MovieName] = @movieName AND
			[MovieReleaseDate] = @releaseDate
		)
	)
COMMIT TRANSACTION AddCast
GO

CREATE PROCEDURE [uspAddNomination]
	----AWARD FK
	@awardName VARCHAR (50),
	----PROFESSIONAL FK (CAST)
	@firstName VARCHAR (50),
	@lastName VARCHAR (50),
	@dob DATE,
	----MOVIE FK (CAST)
	@movieName VARCHAR (250),
	@releaseDate DATE,	
	----NOMINATION Attribute
	@year DATE,
	@winner BIT = 0,
	----Additional Flag
	@createChildIfNotExisted BIT = 0
AS
BEGIN TRANSACTION AddNomination
	IF NOT EXISTS (
		SELECT * 
		FROM [dbo].[AWARD]
		WHERE [AwardName] = @awardName
	)
	BEGIN 
		IF NOT (@createChildIfNotExisted = 0)
			EXECUTE uspAddAward @awardName
		ELSE
			RAISERROR ('Award is not existed in database.', 16, 1)
	END

	IF NOT EXISTS (
		SELECT * 
		FROM [dbo].[CAST] AS C
		JOIN [dbo].[PROFESSIONAL] AS P
		ON C.[ProfessionalID] = P.[ProfessionalID]
		JOIN [dbo].[MOVIE] AS M
		ON C.[MovieID] = M.[MovieID]
		WHERE [ProfessionalFirstName] = @firstName AND
		[ProfessionalLastName] = @lastName AND
		[ProfessionalDOB] = @dob AND
		[MovieName] = @movieName AND
		[MovieReleaseDate] = @releaseDate
	)
	BEGIN
		IF NOT (@createChildIfNotExisted = 0)
			EXECUTE uspAddCast @firstName, @lastName, @dob, @movieName, @releaseDate, 1
		ELSE
			RAISERROR ('Cast is not existed in database.', 16, 1)

		INSERT INTO [dbo].[NOMINATION]
		VALUES
		(
			(
				SELECT [AwardID]
				FROM [dbo].[AWARD]
				WHERE [AwardName] = @awardName
			),
			(
				SELECT [CastID]
				FROM [dbo].[CAST] AS C
				JOIN [dbo].[PROFESSIONAL] AS P
				ON C.[ProfessionalID] = P.[ProfessionalID]
				JOIN [dbo].[MOVIE] AS M
				ON C.[MovieID] = M.[MovieID]
				WHERE [ProfessionalFirstName] = @firstName AND
				[ProfessionalLastName] = @lastName AND
				[ProfessionalDOB] = @dob AND
				[MovieName] = @movieName AND
				[MovieReleaseDate] = @releaseDate
			),
			@year,
			@winner
		)
	END
COMMIT TRANSACTION AddNomination
GO

CREATE PROCEDURE uspAddActor
	----PROFESSIONAL FK (CAST)
	@firstName VARCHAR (50),
	@lastName VARCHAR (50),
	@dob DATE,
	----MOVIE FK (CAST)
	@movieName VARCHAR (250),
	@releaseDate DATE,
	----ACTOR Attribute
	@characterFirstName VARCHAR (50),
	@characterLastName VARCHAR (50),
	@characterAge INT, 
	----Additional Flag
	@createChildIfNotExisted BIT = 0
AS
BEGIN TRANSACTION AddActor
	IF NOT EXISTS (
		SELECT * 
		FROM [dbo].[CAST] AS C
		JOIN [dbo].[PROFESSIONAL] AS P
		ON C.[ProfessionalID] = P.[ProfessionalID]
		JOIN [dbo].[MOVIE] AS M
		ON C.[MovieID] = M.[MovieID]
		WHERE [ProfessionalFirstName] = @firstName AND
		[ProfessionalLastName] = @lastName AND
		[ProfessionalDOB] = @dob AND
		[MovieName] = @movieName AND
		[MovieReleaseDate] = @releaseDate
	)
	BEGIN
		IF NOT (@createChildIfNotExisted = 0)
			EXECUTE uspAddCast @firstName, @lastName, @dob, @movieName, @releaseDate, 1
		ELSE
			RAISERROR ('Cast is not existed in database.', 16, 1)
	END

	INSERT INTO [dbo].[ACTOR]
	VALUES
	(
		(
			SELECT [CastID]
			FROM [dbo].[CAST] AS C
			JOIN [dbo].[PROFESSIONAL] AS P
			ON C.[ProfessionalID] = P.[ProfessionalID]
			JOIN [dbo].[MOVIE] AS M
			ON C.[MovieID] = M.[MovieID]
			WHERE [ProfessionalFirstName] = @firstName AND
			[ProfessionalLastName] = @lastName AND
			[ProfessionalDOB] = @dob AND
			[MovieName] = @movieName AND
			[MovieReleaseDate] = @releaseDate
		),
		@characterFirstName,
		@characterLastName
	)
COMMIT TRANSACTION AddActor
GO

CREATE PROCEDURE uspAddWriter
	----PROFESSIONAL FK (CAST)
	@firstName VARCHAR (50),
	@lastName VARCHAR (50),
	@dob DATE,
	----MOVIE FK (CAST)
	@movieName VARCHAR (250),
	@releaseDate DATE,
	----WRITER Attribute
	@isOriginalAuthor BIT = 0,
	----Additional Flag
	@createChildIfNotExisted BIT = 0
AS
BEGIN TRANSACTION AddWriter
	IF NOT EXISTS (
		SELECT * 
		FROM [dbo].[CAST] AS C
		JOIN [dbo].[PROFESSIONAL] AS P
		ON C.[ProfessionalID] = P.[ProfessionalID]
		JOIN [dbo].[MOVIE] AS M
		ON C.[MovieID] = M.[MovieID]
		WHERE [ProfessionalFirstName] = @firstName AND
		[ProfessionalLastName] = @lastName AND
		[ProfessionalDOB] = @dob AND
		[MovieName] = @movieName AND
		[MovieReleaseDate] = @releaseDate
	)
	BEGIN
		IF NOT (@createChildIfNotExisted = 0)
			EXECUTE uspAddCast @firstName, @lastName, @dob, @movieName, @releaseDate, 1
		ELSE
			RAISERROR ('Cast is not existed in database.', 16, 1)
	END

	INSERT INTO [dbo].[WRITER]
	VALUES
	(
		(
			SELECT [CastID]
			FROM [dbo].[CAST] AS C
			JOIN [dbo].[PROFESSIONAL] AS P
			ON C.[ProfessionalID] = P.[ProfessionalID]
			JOIN [dbo].[MOVIE] AS M
			ON C.[MovieID] = M.[MovieID]
			WHERE [ProfessionalFirstName] = @firstName AND
			[ProfessionalLastName] = @lastName AND
			[ProfessionalDOB] = @dob AND
			[MovieName] = @movieName AND
			[MovieReleaseDate] = @releaseDate
		),
		@isOriginalAuthor
	)
COMMIT TRANSACTION AddWriter
GO

CREATE PROCEDURE uspAddCrew
	----PROFESSIONAL FK (CAST)
	@firstName VARCHAR (50),
	@lastName VARCHAR (50),
	@dob DATE,
	----MOVIE FK (CAST)
	@movieName VARCHAR (250),
	@releaseDate DATE,
	----Crew Attribute
	@crewTitle VARCHAR (50),
	----Additional Flag
	@createChildIfNotExisted BIT = 0
AS
BEGIN TRANSACTION AddCrew
	IF NOT EXISTS (
		SELECT * 
		FROM [dbo].[CAST] AS C
		JOIN [dbo].[PROFESSIONAL] AS P
		ON C.[ProfessionalID] = P.[ProfessionalID]
		JOIN [dbo].[MOVIE] AS M
		ON C.[MovieID] = M.[MovieID]
		WHERE [ProfessionalFirstName] = @firstName AND
		[ProfessionalLastName] = @lastName AND
		[ProfessionalDOB] = @dob AND
		[MovieName] = @movieName AND
		[MovieReleaseDate] = @releaseDate
	)
	BEGIN
		IF NOT (@createChildIfNotExisted = 0)
			EXECUTE uspAddCast @firstName, @lastName, @dob, @movieName, @releaseDate, 1
		ELSE
			RAISERROR ('Cast is not existed in database.', 16, 1)
	END

	INSERT INTO [dbo].[CREW]
	VALUES
	(
		(
			SELECT [CastID]
			FROM [dbo].[CAST] AS C
			JOIN [dbo].[PROFESSIONAL] AS P
			ON C.[ProfessionalID] = P.[ProfessionalID]
			JOIN [dbo].[MOVIE] AS M
			ON C.[MovieID] = M.[MovieID]
			WHERE [ProfessionalFirstName] = @firstName AND
			[ProfessionalLastName] = @lastName AND
			[ProfessionalDOB] = @dob AND
			[MovieName] = @movieName AND
			[MovieReleaseDate] = @releaseDate
		),
		@crewTitle
	)
COMMIT TRANSACTION AddCrew
GO

CREATE PROCEDURE uspAddDirector
	----PROFESSIONAL FK (CAST)
	@firstName VARCHAR (50),
	@lastName VARCHAR (50),
	@dob DATE,
	----MOVIE FK (CAST)
	@movieName VARCHAR (250),
	@releaseDate DATE,
	----Director Attribute
	@isExecutive BIT = 0,
	----Additional Flag
	@createChildIfNotExisted BIT = 0
AS
BEGIN TRANSACTION AddWriter
	IF NOT EXISTS (
		SELECT * 
		FROM [dbo].[CAST] AS C
		JOIN [dbo].[PROFESSIONAL] AS P
		ON C.[ProfessionalID] = P.[ProfessionalID]
		JOIN [dbo].[MOVIE] AS M
		ON C.[MovieID] = M.[MovieID]
		WHERE [ProfessionalFirstName] = @firstName AND
		[ProfessionalLastName] = @lastName AND
		[ProfessionalDOB] = @dob AND
		[MovieName] = @movieName AND
		[MovieReleaseDate] = @releaseDate
	)
	BEGIN
		IF NOT (@createChildIfNotExisted = 0)
			EXECUTE uspAddCast @firstName, @lastName, @dob, @movieName, @releaseDate, 1
		ELSE
			RAISERROR ('Cast is not existed in database.', 16, 1)
	END

	INSERT INTO [dbo].[WRITER]
	VALUES
	(
		(
			SELECT [CastID]
			FROM [dbo].[CAST] AS C
			JOIN [dbo].[PROFESSIONAL] AS P
			ON C.[ProfessionalID] = P.[ProfessionalID]
			JOIN [dbo].[MOVIE] AS M
			ON C.[MovieID] = M.[MovieID]
			WHERE [ProfessionalFirstName] = @firstName AND
			[ProfessionalLastName] = @lastName AND
			[ProfessionalDOB] = @dob AND
			[MovieName] = @movieName AND
			[MovieReleaseDate] = @releaseDate
		),
		@isExecutive
	)
COMMIT TRANSACTION AddWriter
GO

----DEFAULT MEMBERSHIP TYPE
EXECUTE uspAddMembershipType @membershipTypeName = 'Free', @membershipTypeDescription = 'Default account with no monthly fee'
EXECUTE uspAddMembershipType @membershipTypeName = 'Silver', @membershipTypeDescription = 'First tier account with $5.99 per month membership fee' 
EXECUTE uspAddMembershipType @membershipTypeName = 'Gold', @membershipTypeDescription = 'Second tier account with $9.99 per month membership fee'

----DEFAULT FORMAT
EXECUTE uspAddFormat @formatName = 'Bluray'
EXECUTE uspAddFormat @formatName = 'DVD'
EXECUTE uspAddFormat @formatName = 'XDVD'
GO

----DEFAULT CONDITION
EXECUTE uspAddCondition @conditionName = 'New'
EXECUTE uspAddCondition @conditionName = 'Used'
EXECUTE uspAddCondition @conditionName = 'Missing'
EXECUTE uspAddCondition @conditionName = 'Damaged'
GO

----DEFAULT STATUS
EXECUTE uspAddStatus 
	@statusName = 'In theaters', 
	@statusDescription = 'Movie currently available in theaters.'
EXECUTE uspAddStatus
	@statusName = 'Cancelled',
	@statusDescription = 'Cancelled movie which is no longer in production' 
EXECUTE uspAddStatus
	@statusName = 'Released',
	@statusDescription = 'Movies available in physical disc format' 
GO

----DEFAULT RATING
EXECUTE uspAddRating @ratingID = 1, @ratingName = 'Terrible'
EXECUTE uspAddRating @ratingID = 2, @ratingName = 'Mediocre'
EXECUTE uspAddRating @ratingID = 3, @ratingName = 'Good'
EXECUTE uspAddRating @ratingID = 4, @ratingName = 'Excellent'
EXECUTE uspAddRating @ratingID = 5, @ratingName = 'Perfect'
GO

----DEFAULT GENRE
EXECUTE uspAddGenre @genreName = 'Action'
EXECUTE uspAddGenre @genreName = 'Fantasy'
EXECUTE uspAddGenre @genreName = 'Sci-fi'
EXECUTE uspAddGenre @genreName = 'Thriller'
EXECUTE uspAddGenre @genreName = 'Comedy'
EXECUTE uspAddGenre @genreName = 'Romance'
EXECUTE uspAddGenre @genreName = 'Horror'
EXECUTE uspAddGenre @genreName = 'Documentary'
GO

----DEFAULT AWARD
EXECUTE uspAddAward 
	@awardName = 'Academy Award', 
	@awardDescription = 'The Academy Awards, now officially known as The Oscars, are a set of awards given annually for excellence of cinematic achievements.'
EXECUTE uspAddAward 
	@awardName = 'Golden Globe Award', 
	@awardDescription = 'The Golden Globe Award is an accolade bestowed by the 93 members of the Hollywood Foreign Press Association (HFPA) recognizing excellence in film and television, both domestic and foreign.'
GO
