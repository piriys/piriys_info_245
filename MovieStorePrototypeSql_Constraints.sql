USE [DBP]
GO

BEGIN TRANSACTION CreateMovieConstraint
	----RATING
	ALTER TABLE [dbo].[RATING]
	ADD CONSTRAINT CK_RatingID
	CHECK ([RatingID] LIKE '[1-5]')

	----CUSTOMER
	ALTER TABLE [dbo].[CUSTOMER]
	ADD CONSTRAINT CK_CustomerEmail
	CHECK ([CustomerEmail] LIKE '%@%')

	ALTER TABLE [dbo].[CUSTOMER]
	ADD CONSTRAINT CK_CustomerDOB
	CHECK (DATEDIFF(YEAR, [CustomerDOB], GETDATE()) > 18)

	ALTER TABLE [dbo].[CUSTOMER]
	ADD CONSTRAINT CK_CustomerCity
	CHECK ([CustomerCity] NOT LIKE '%[0-9]%') --No numbers

	ALTER TABLE [dbo].[CUSTOMER]
	ADD CONSTRAINT CK_CustomerState
	CHECK ([CustomerState] LIKE '[a-z][a-z]') --Two alphabet only

	ALTER TABLE [dbo].[CUSTOMER]
	ADD CONSTRAINT CK_CustomerPostal
	CHECK ([CustomerPostal] LIKE '[0-9][0-9][0-9][0-9][0-9]') --Five numbers only

	ALTER TABLE [dbo].[CUSTOMER]
	ADD CONSTRAINT CK_Username
	CHECK ([Username] LIKE '%[a-z0-9]%') --Contain only numbers and/or alphabets

	ALTER TABLE [dbo].[CUSTOMER]
	ADD CONSTRAINT CK_Password
	CHECK (([Password] LIKE '%[0-9]%') --Number
	AND ([Password] LIKE '%[a-z]%') --Alphabet
	AND ([Password] LIKE '%[^a-z0-9]%') --Special Character
	) --Must contain at least one of alphabet, number and special character
COMMIT TRANSACTION CreateMovieConstraint
GO