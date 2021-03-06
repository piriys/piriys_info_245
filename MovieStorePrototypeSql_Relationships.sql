USE [DBP]
GO

BEGIN TRANSACTION CreateMovieRelationship
	----PROMOTION
	ALTER TABLE [dbo].[PROMOTION]
	ADD CONSTRAINT FK_PROMOTION_DiscountID
	FOREIGN KEY ([DiscountID])
	REFERENCES [dbo].[DISCOUNT] ([DiscountID])

	----REVIEW
	ALTER TABLE [dbo].[REVIEW]
	ADD CONSTRAINT FK_REVIEW_RatingID
	FOREIGN KEY ([RatingID])
	REFERENCES [dbo].[RATING] ([RatingID])

	ALTER TABLE [dbo].[REVIEW]
	ADD CONSTRAINT FK_REVIEW_RentalID
	FOREIGN KEY ([RentalID])
	REFERENCES [dbo].[RENTAL] ([RentalID])

	----RENTAL
	ALTER TABLE [dbo].[RENTAL]
	ADD CONSTRAINT FK_RENTAL_CustomerID
	FOREIGN KEY ([CustomerID])
	REFERENCES [dbo].[CUSTOMER] ([CustomerID])

	ALTER TABLE [dbo].[RENTAL]
	ADD CONSTRAINT FK_RENTAL_DiscID
	FOREIGN KEY ([DiscID])
	REFERENCES [dbo].[DISC] ([DiscID])

	ALTER TABLE [dbo].[RENTAL]
	ADD CONSTRAINT FK_RENTAL_PromotionID
	FOREIGN KEY ([PromotionID])
	REFERENCES [dbo].[PROMOTION] ([PromotionID])

	----DISC_CONDITION
	ALTER TABLE [dbo].[DISC_CONDITION]
	ADD CONSTRAINT FK_DISC_CONDITION_DiscID
	FOREIGN KEY ([DiscID])
	REFERENCES [dbo].[DISC] ([DiscID])

	ALTER TABLE [dbo].[DISC_CONDITION]
	ADD CONSTRAINT FK_DISC_CONDITION_ConditionID
	FOREIGN KEY ([ConditionID])
	REFERENCES [dbo].[CONDITION] ([ConditionID])

	----DISC
	ALTER TABLE [dbo].[DISC]
	ADD CONSTRAINT FK_DISC_MovieID
	FOREIGN KEY ([MovieID])
	REFERENCES [dbo].[MOVIE] ([MovieID])

	ALTER TABLE [dbo].[DISC]
	ADD CONSTRAINT FK_DISC_FormatID
	FOREIGN KEY ([FormatID])
	REFERENCES [dbo].[FORMAT] ([FormatID])

	----MEMBERSHIP
	ALTER TABLE [dbo].[MEMBERSHIP]
	ADD CONSTRAINT FK_MEMBERSHIP_MembershipTypeID
	FOREIGN KEY ([MembershipTypeID])
	REFERENCES [dbo].[MEMBERSHIP_TYPE] ([MembershipTypeID])

	ALTER TABLE [dbo].[MEMBERSHIP]
	ADD CONSTRAINT FK_MEMBERSHIP_CustomerID
	FOREIGN KEY ([CustomerID])
	REFERENCES [dbo].[CUSTOMER] ([CustomerID])

	----MOVIE_GENRE
	ALTER TABLE [dbo].[MOVIE_GENRE]
	ADD CONSTRAINT FK_MOVIE_GENRE_MovieID
	FOREIGN KEY ([MovieID])
	REFERENCES [dbo].[MOVIE] ([MovieID])

	ALTER TABLE [dbo].[MOVIE_GENRE]
	ADD CONSTRAINT FK_MOVIE_GENRE_GenreID
	FOREIGN KEY ([GenreID])
	REFERENCES [dbo].[GENRE] ([GenreID])

	----MOVIE_STATUS
	ALTER TABLE [dbo].[MOVIE_STATUS]
	ADD CONSTRAINT FK_MOVIE_STATUS_MovieID
	FOREIGN KEY ([MovieID])
	REFERENCES [dbo].[MOVIE] ([MovieID])

	ALTER TABLE [dbo].[MOVIE_STATUS]
	ADD CONSTRAINT FK_MOVIE_STATUS_StatusID
	FOREIGN KEY ([StatusID])
	REFERENCES [dbo].[STATUS] ([StatusID])

	----NOMINATION
	ALTER TABLE [dbo].[NOMINATION]
	ADD CONSTRAINT FK_NOMINATION_AwardID
	FOREIGN KEY ([AwardID])
	REFERENCES [dbo].[AWARD] ([AwardID])

	ALTER TABLE [dbo].[NOMINATION]
	ADD CONSTRAINT FK_NOMINATION_CastID
	FOREIGN KEY ([CastID])
	REFERENCES [dbo].[CAST] ([CastID])

	----CAST
	ALTER TABLE [dbo].[CAST]
	ADD CONSTRAINT FK_CAST_ProfessionalID
	FOREIGN KEY ([ProfessionalID])
	REFERENCES [dbo].[PROFESSIONAL] ([ProfessionalID])

	ALTER TABLE [dbo].[CAST]
	ADD CONSTRAINT FK_CAST_MovieID
	FOREIGN KEY ([MovieID])
	REFERENCES [dbo].[MOVIE] ([MovieID])

	----CREW
	ALTER TABLE [dbo].[CREW]
	ADD CONSTRAINT FK_CREW_CastID
	FOREIGN KEY ([CastID])
	REFERENCES [dbo].[CAST] ([CastID])

	----ACTOR
	ALTER TABLE [dbo].[ACTOR]
	ADD CONSTRAINT FK_ACTOR_CastID
	FOREIGN KEY ([CastID])
	REFERENCES [dbo].[CAST] ([CastID])

	----WRITER
	ALTER TABLE [dbo].[WRITER]
	ADD CONSTRAINT FK_WRITER_CastID
	FOREIGN KEY ([CastID])
	REFERENCES [dbo].[CAST] ([CastID])

	----DIRECTOR
	ALTER TABLE [dbo].[DIRECTOR]
	ADD CONSTRAINT FK_DIRECTOR_CastID
	FOREIGN KEY ([CastID])
	REFERENCES [dbo].[CAST] ([CastID])
COMMIT TRANSACTION CreateMovieRelationship
GO