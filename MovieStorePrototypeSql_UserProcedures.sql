USE [DBP_245]
GO

CREATE PROCEDURE [uspPublicRegister]
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
BEGIN TRANSACTION PublicRegister
	EXECUTE uspAddCustomer @firstName, @lastName, @email, @dob, @street, @city, @state, @postal, @username, @password
	EXECUTE uspAddMembership 'Free', @username, NULL, NULL, 0
COMMIT TRANSACTION PublicRegister
GO

CREATE PROCEDURE [uspCustomerLogin]
	@username VARCHAR (15)
AS
BEGIN TRANSACTION CustomerLogin
	UPDATE [dbo].[CUSTOMER]
	SET [LastLogin] = GETDATE ()
	WHERE @username = [Username]
COMMIT TRANSACTION CustomerLogin
GO

CREATE VIEW [vwMovieList]
AS
	SELECT [MovieName], [MovieReleaseDate], [RunningTime], [MovieDescription], [MoviePoster], G.[GenreName], P.[ProfessionalFirstName], P.[ProfessionalLastName], A.[CharacterFirstName], A.[CharacterLastName], F.[FormatName], S.[StatusName]
	FROM [dbo].[MOVIE] AS M
	JOIN [dbo].[MOVIE_GENRE] AS MG
	ON M.[MovieID] = MG.[MovieID]
	JOIN [dbo].[GENRE] AS G
	ON MG.[GenreID] = G.[GenreID]
	JOIN [dbo].[CAST] AS C
	ON M.[MovieID] = C.[CastID]
	JOIN [dbo].[PROFESSIONAL] AS P
	ON C.[ProfessionalID] = P.[ProfessionalID]
	JOIN [dbo].[ACTOR] AS A 
	ON C.[CastID] = A.[CastID]
	JOIN [dbo].[DISC] AS D
	ON M.[MovieID] = D.[MovieID]
	JOIN [dbo].[FORMAT] AS F
	ON D.[FormatID] = F.[FormatID]
	JOIN [dbo].[MOVIE_STATUS] AS MS
	ON M.[MovieID] = MS.[MovieID]
	JOIN [dbo].[STATUS] AS S
	ON MS.[StatusID] = S.[StatusID]
GO

CREATE FUNCTION [ufnSearchMovieByKeyword]
(
	@keyword VARCHAR (250),
	@category VARCHAR (50) = 'all'
)
RETURNS
	CASE 
	@category = all 
GO

CREATE PROCEDURE [vwMovieReviewScoreAvg]
	@movieName VARCHAR (250)
AS 
	SELECT [MovieName], AVG(RAT.[RatingID])
	FROM [dbo].[MOVIE] AS M
	JOIN [dbo].[DISC] AS D
	ON M.[MovieID] = D.[MovieID]
	JOIN [dbo].[RENTAL] AS REN
	ON D.[DiscID] = REN.[DiscID]
	JOIN [dbo].[REVIEW] AS REV
	ON REN.[RentalID] = REV.[RentalID]
	JOIN [dbo].[RATING] AS RAT
	ON REV.[RatingID] = RAT.[RatingID]
	WHERE @movieName = [MovieName]
	GROUP BY [MovieName]
GO
