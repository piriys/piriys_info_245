USE [Master]
GO

CREATE DATABASE [DBP]
GO

USE [DBP]
GO

BEGIN TRANSACTION CreateTables
	CREATE TABLE [dbo].[SL_GAME]
	(
		[GameID] INT IDENTITY (1,1) NOT NULL,
		[GameName] VARCHAR (50) NOT NULL,
		[GameIsMultiplayer] BOOLEAN NOT NULL,
		[GameDescription] VARCHAR (100),
		
		PRIMARY KEY ([GameID]),
		UNIQUE ([GameName])
	) ON [PRIMARY]

	CREATE TABLE [dbo].[SL_GAME_VERSION]
	(
		[GameVersionID] INT (1,1) IDENTITY NOT NULL,
		[GameVersionName] VARCHAR (50) NOT NULL,
		[GameVersionDescription] VARCHAR (100),
		[GameVersionPlayCount] INT NOT NULL DEFAULT 0,
		
		/*Foreign Keys*/
		[GameID] INT NOT NULL,
		
		PRIMARY KEY ([GameVersionID]),
		UNIQUE ([GameID], [GameVersionName]),
	) ON [PRIMARY]

	CREATE TABLE [dbo].[SL_SP_GAME_SESSION]
	(
		[SessionID] UNIQUEIDENTIFIER IDENTITY NOT NULL,
		[SessionScore] INT NOT NULL,
		[SessionTime] DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
		
		/*Foreign Keys*/ 
		[PlayerID] UNIQUEIDENTIFIER NOT NULL, /*AvatarID*/
		[GameID] INT NOT NULL,
		
		PRIMARY KEY ([SessionID])
	) ON [PRIMARY]	
	
	CREATE TABLE [dbo].[SL_AVATAR]
	{
		[AvatarID] UNIQUEIDENTIFIER IDENTITY NOT NULL,
		[AvatarName] VARCHAR (50) NOT NULL,
		[AvatarRegisterDate] DATETIME NOT NULL
		
		PRIMARY KEY ([AvatarID]),
		UNIQUE ([AvatarName])		
	} ON [PRIMARY]

COMMIT TRANSACTION CreateTables
GO