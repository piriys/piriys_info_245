USE [DBP]
GO

----SAMPLE MOVIE
EXECUTE uspAddMovie 
	@movieNameParam = 'Star Wars: Episode IV - A New Hope', 
	@releaseDateParam = '1977-05-25', 
	@runningTimeParam = 2.01, 
	@movieDescriptionParam = 'Luke Skywalker joins forces with a Jedi Knight, a cocky pilot, a wookiee and two droids to save the universe from the Empire''s world-destroying battle-station, while also attempting to rescue Princess Leia from the evil Darth Vader.'
EXECUTE uspAddMovie 
	@movieNameParam = 'The Matrix',
	@releaseDateParam = '1999-03-31',
	@runningTimeParam = 2.16,
	@movieDescriptionParam = 'A computer hacker learns from mysterious rebels about the true nature of his reality and his role in the war against its controllers.'
EXECUTE uspAddMovie 
	@movieNameParam = 'The Expendibles',
	@releaseDateParam = '2010-08-13',
	@runningTimeParam = 1.43,
	@movieDescriptionParam = 'A CIA operative hires a team of mercenaries to eliminate a Latin dictator and a renegade CIA agent.'

----SAMPLE CAST
EXECUTE uspAddCast
	@firstName = 'George',
	@lastName = 'Lucas',
	@dob = '1944-05-14',
	@movieName = 'Star Wars: Episode IV - A New Hope',
	@releaseDate = '1977-05-25',
	@createChildIfNotExisted = 1
EXECUTE uspAddCast
	@firstName = 'Mark',
	@lastName = 'Hamil',
	@dob = '1951-11-25',
	@movieName = 'Star Wars: Episode IV - A New Hope',
	@releaseDate = '1977-05-25',
	@createChildIfNotExisted = 1
GO

----SAMPLE ACTOR 
EXECUTE uspAddActor
	@firstName = 'Harrison',
	@lastName = 'Ford',
	@dob = '1942-07-13',
	@movieName = 'Star Wars: Episode IV - A New Hope',
	@releaseDate = '1977-05-25',
	@characterFirstName = 'Han',
	@characterLastName = 'Solo',
	@characterAge = 35,
	@createChildIfNotExisted = 1
EXECUTE uspAddActor
	@firstName = 'Carrie',
	@lastName = 'Fisher',
	@dob = '1956-10-21',
	@movieName = 'Star Wars: Episode IV - A New Hope',
	@releaseDate = '1977-05-25',
	@characterFirstName = 'Leia',
	@characterLastName = 'Organa',
	@characterAge = 21,
	@createChildIfNotExisted = 1	
EXECUTE uspAddActor
	@firstName = 'Alec',
	@lastName = 'Guinness',
	@dob = '1914-04-02',
	@movieName = 'Star Wars: Episode IV - A New Hope',
	@releaseDate = '1977-05-25',
	@characterFirstName = 'Ben',
	@characterLastName = 'Kenobi',
	@characterAge = 63,
	@createChildIfNotExisted = 1	
GO

----SAMPLE WRITER
EXECUTE uspAddWriter
	@firstName = 'George',
	@lastName = 'Lucas',
	@dob = '1944-05-14',
	@movieName = 'Star Wars: Episode IV - A New Hope',
	@releaseDate = '1977-05-25',
	@draftSubmitDate = '1974-05-25',
	@revisionRetainer = 1,
	@createChildIfNotExisted = 1
GO