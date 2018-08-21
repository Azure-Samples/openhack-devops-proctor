-- Teams
INSERT INTO leaderboard.dbo.Teams
(Id, TeamName, DowntimeSeconds, Points, IsScoringEnabled)
VALUES(NEWID(), 'team1', 10, 50, 0);

INSERT INTO leaderboard.dbo.Teams
(Id, TeamName, DowntimeSeconds, Points, IsScoringEnabled)
VALUES(NEWID(), 'team2', 100, 150, 1);

INSERT INTO leaderboard.dbo.Teams
(Id, TeamName, DowntimeSeconds, Points, IsScoringEnabled)
VALUES(NEWID(), 'team3', 10, 50, 1);

INSERT INTO leaderboard.dbo.Teams
(Id, TeamName, DowntimeSeconds, Points, IsScoringEnabled)
VALUES(NEWID(), 'team4', 920, 340, 1);

GO
-- Challenges
DECLARE @TeamId UNIQUEIDENTIFIER
DECLARE @ChallengeDefinitionId UNIQUEIDENTIFIER

SELECT @TeamId=Id From leaderboard.dbo.Teams where teamName = 'team1'
select @ChallengeDefinitionId=Id from leaderboard.dbo.ChallengeDefinitions where Name = 'Challenge 1'

INSERT INTO leaderboard.dbo.Challenges (Id, TeamId, ChallengeDefinitionId, StartDateTime, EndDateTime, Score)
VALUES(NEWID(), @TeamId, @ChallengeDefinitionId, GETDATE(), GETDATE()+0.5, 10);

select @ChallengeDefinitionId=Id from leaderboard.dbo.ChallengeDefinitions where Name = 'Challenge 2'

INSERT INTO leaderboard.dbo.Challenges (Id, TeamId, ChallengeDefinitionId, StartDateTime, EndDateTime, Score)
VALUES(NEWID(), @TeamId, @ChallengeDefinitionId, GETDATE()+0.51, GETDATE()+1, 20);

select @ChallengeDefinitionId=Id from leaderboard.dbo.ChallengeDefinitions where Name = 'Challenge 3'

INSERT INTO leaderboard.dbo.Challenges (Id, TeamId, ChallengeDefinitionId, StartDateTime, EndDateTime, Score)
VALUES(NEWID(), @TeamId, @ChallengeDefinitionId, GETDATE()+1.01, GETDATE()+1.5, 30);

select @ChallengeDefinitionId=Id from leaderboard.dbo.ChallengeDefinitions where Name = 'Challenge - Medium 1'

INSERT INTO leaderboard.dbo.Challenges (Id, TeamId, ChallengeDefinitionId, StartDateTime, EndDateTime, Score)
VALUES(NEWID(), @TeamId, @ChallengeDefinitionId, GETDATE()+1.51, GETDATE()+2, 60);

SELECT @TeamId=Id From leaderboard.dbo.Teams where teamName = 'team2'
select @ChallengeDefinitionId=Id from leaderboard.dbo.ChallengeDefinitions where Name = 'Challenge 1'

INSERT INTO leaderboard.dbo.Challenges (Id, TeamId, ChallengeDefinitionId, StartDateTime, EndDateTime, Score)
VALUES(NEWID(), @TeamId, @ChallengeDefinitionId, GETDATE(), GETDATE()+0.5, 50);

select @ChallengeDefinitionId=Id from leaderboard.dbo.ChallengeDefinitions where Name = 'Challenge 2'

INSERT INTO leaderboard.dbo.Challenges (Id, TeamId, ChallengeDefinitionId, StartDateTime, EndDateTime, Score)
VALUES(NEWID(), @TeamId, @ChallengeDefinitionId, GETDATE()+0.51, GETDATE()+1, 20);

GO
--LogMessages
DECLARE @Start int;
DECLARE @End int;
DECLARE @I decimal(10,5);
DECLARE @CS decimal(10,5);
DECLARE @dt DATETIME2;
DECLARE @dtRounded DATETIME2;

--Team 1, Challenge 1, Challenge Start 0-0.5, POI = 2
SET @Start = 10;
SET @End = 30;
SET @CS = 0.0;
SET @I = 0.0;

WHILE @Start < @End
BEGIN
SET @I = @Start * 0.001;
IF RAND() > 0.5
    BEGIN
    SET @dt = getdate()+@I+@CS;
    SET @dtRounded = dateadd(mi, datediff(mi, 0, @dt), 0);
    IF RAND() < 0.5
    	BEGIN
	    INSERT INTO leaderboard.dbo.LogMessages
	    (Id, TeamName, EndpointUri, CreatedDate, [Type], TimeSlice, StatusCode)
	    VALUES(NEWID(), 'team1', 'http://test/poi', @dt, 2, @dtRounded, 404);
	    END
	ELSE
	    BEGIN
	    INSERT INTO leaderboard.dbo.LogMessages
	    (Id, TeamName, EndpointUri, CreatedDate, [Type], TimeSlice, StatusCode)
	    VALUES(NEWID(), 'team1', 'http://test/poi', @dt, 2, @dtRounded, 500);
	    END
    END
SET @Start = @Start+1;
END;

--Team 1, Challenge 1, Challenge Start 0.0-0.5, USER = 1
SET @Start = 200;
SET @End = 250;
SET @CS = 0.0;
SET @I = 0.0;

WHILE @Start < @End
BEGIN
SET @I = @Start * 0.001;
IF RAND() > 0.5
    BEGIN
    SET @dt = getdate()+@I+@CS;
    SET @dtRounded = dateadd(mi, datediff(mi, 0, @dt), 0);
    IF RAND() < 0.5
    	BEGIN
	    INSERT INTO leaderboard.dbo.LogMessages
	    (Id, TeamName, EndpointUri, CreatedDate, [Type], TimeSlice, StatusCode)
	    VALUES(NEWID(), 'team1', 'http://test/user', @dt, 1, @dtRounded, 404);
	    END
	ELSE
	    BEGIN
	    INSERT INTO leaderboard.dbo.LogMessages
	    (Id, TeamName, EndpointUri, CreatedDate, [Type], TimeSlice, StatusCode)
	    VALUES(NEWID(), 'team1', 'http://test/user', @dt, 1, @dtRounded, 500);
	    END
    END
SET @Start = @Start+1;
END;

--Team 1, Challenge 2, Challenge Start 0.51-1.0, USER = 1
SET @Start = 40;
SET @End = 50;
SET @CS = 0.51;
SET @I = 0.0;

WHILE @Start < @End
BEGIN
SET @I = @Start * 0.001;
IF RAND() > 0.5
    BEGIN
    SET @dt = getdate()+@I+@CS;
    SET @dtRounded = dateadd(mi, datediff(mi, 0, @dt), 0);
    IF RAND() < 0.5
    	BEGIN
	    INSERT INTO leaderboard.dbo.LogMessages
	    (Id, TeamName, EndpointUri, CreatedDate, [Type], TimeSlice, StatusCode)
	    VALUES(NEWID(), 'team1', 'http://test/user', @dt, 1, @dtRounded, 404);
	    END
	ELSE
	    BEGIN
	    INSERT INTO leaderboard.dbo.LogMessages
	    (Id, TeamName, EndpointUri, CreatedDate, [Type], TimeSlice, StatusCode)
	    VALUES(NEWID(), 'team1', 'http://test/user', @dt, 1, @dtRounded, 500);
	    END
    END
SET @Start = @Start+1;
END;

--Team 1, Challenge 3, Challenge Start, USER = 1
SET @Start = 80;
SET @End = 99;
SET @CS = 1.01;
SET @I = 0.0;

WHILE @Start < @End
BEGIN
SET @I = @Start * 0.001;
IF RAND() > 0.5
    BEGIN
    SET @dt = getdate()+@I+@CS;
    SET @dtRounded = dateadd(mi, datediff(mi, 0, @dt), 0);
    IF RAND() < 0.5
    	BEGIN
	    INSERT INTO leaderboard.dbo.LogMessages
	    (Id, TeamName, EndpointUri, CreatedDate, [Type], TimeSlice, StatusCode)
	    VALUES(NEWID(), 'team1', 'http://test/user', @dt, 1, @dtRounded, 404);
	    END
	ELSE
	    BEGIN
	    INSERT INTO leaderboard.dbo.LogMessages
	    (Id, TeamName, EndpointUri, CreatedDate, [Type], TimeSlice, StatusCode)
	    VALUES(NEWID(), 'team1', 'http://test/user', @dt, 1, @dtRounded, 500);
	    END
    END
SET @Start = @Start+1;
END;


--Team 1, Challenge 3, Challenge Start, USER = 1
SET @Start = 100;
SET @End = 160;
SET @CS = 1.51;
SET @I = 0.0;

WHILE @Start < @End
BEGIN
SET @I = @Start * 0.001;
IF RAND() > 0.5
    BEGIN
    SET @dt = getdate()+@I+@CS;
    SET @dtRounded = dateadd(mi, datediff(mi, 0, @dt), 0);
    IF RAND() < 0.5
    	BEGIN
	    INSERT INTO leaderboard.dbo.LogMessages
	    (Id, TeamName, EndpointUri, CreatedDate, [Type], TimeSlice, StatusCode)
	    VALUES(NEWID(), 'team1', 'http://test/user', @dt, 1, @dtRounded, 404);
	    END
	ELSE
	    BEGIN
	    INSERT INTO leaderboard.dbo.LogMessages
	    (Id, TeamName, EndpointUri, CreatedDate, [Type], TimeSlice, StatusCode)
	    VALUES(NEWID(), 'team1', 'http://test/user', @dt, 1, @dtRounded, 500);
	    END
    END
SET @Start = @Start+1;
END;

--Team 2, Challenge 1, Challenge Start = 0.0, USER = 1
SET @Start = 50;
SET @End = 100;
SET @CS = 0.0;
SET @I = 0.0;

WHILE @Start < @End
BEGIN
SET @I = @Start * 0.001;
IF RAND() > 0.5
    BEGIN
    SET @dt = getdate()+@I+@CS;
    SET @dtRounded = dateadd(mi, datediff(mi, 0, @dt), 0);
    IF RAND() < 0.5
    	BEGIN
	    INSERT INTO leaderboard.dbo.LogMessages
	    (Id, TeamName, EndpointUri, CreatedDate, [Type], TimeSlice, StatusCode)
	    VALUES(NEWID(), 'team2', 'http://test/user', @dt, 1, @dtRounded, 404);
	    END
	ELSE
	    BEGIN
	    INSERT INTO leaderboard.dbo.LogMessages
	    (Id, TeamName, EndpointUri, CreatedDate, [Type], TimeSlice, StatusCode)
	    VALUES(NEWID(), 'team2', 'http://test/user', @dt, 1, @dtRounded, 500);
	    END
    END
SET @Start = @Start+1;
END;

--Team 2, Challenge 2, Challenge Start = 0.5001, USER = 1
SET @Start = 200;
SET @End = 280;
SET @CS = 0.51;
SET @I = 0.0;

WHILE @Start < @End
BEGIN
SET @I = @Start * 0.001;
IF RAND() > 0.5
    BEGIN
    SET @dt = getdate()+@I+@CS;
    SET @dtRounded = dateadd(mi, datediff(mi, 0, @dt), 0);
    IF RAND() < 0.5
    	BEGIN
	    INSERT INTO leaderboard.dbo.LogMessages
	    (Id, TeamName, EndpointUri, CreatedDate, [Type], TimeSlice, StatusCode)
	    VALUES(NEWID(), 'team2', 'http://test/user', @dt, 1, @dtRounded, 404);
	    END
	ELSE
	    BEGIN
	    INSERT INTO leaderboard.dbo.LogMessages
	    (Id, TeamName, EndpointUri, CreatedDate, [Type], TimeSlice, StatusCode)
	    VALUES(NEWID(), 'team2', 'http://test/user', @dt, 1, @dtRounded, 500);
	    END
    END
SET @Start = @Start+1;
END;

--Team 2, Challenge 1, Challenge Start = 0.0, poi = 2
SET @Start = 50;
SET @End = 100;
SET @CS = 0.0;
SET @I = 0.0;

WHILE @Start < @End
BEGIN
SET @I = @Start * 0.001;
IF RAND() > 0.5
    BEGIN
    SET @dt = getdate()+@I+@CS;
    SET @dtRounded = dateadd(mi, datediff(mi, 0, @dt), 0);
    IF RAND() < 0.5
    	BEGIN
	    INSERT INTO leaderboard.dbo.LogMessages
	    (Id, TeamName, EndpointUri, CreatedDate, [Type], TimeSlice, StatusCode)
	    VALUES(NEWID(), 'team2', 'http://test/poi', @dt, 2, @dtRounded, 404);
	    END
	ELSE
	    BEGIN
	    INSERT INTO leaderboard.dbo.LogMessages
	    (Id, TeamName, EndpointUri, CreatedDate, [Type], TimeSlice, StatusCode)
	    VALUES(NEWID(), 'team2', 'http://test/poi', @dt, 2, @dtRounded, 500);
	    END
    END
SET @Start = @Start+1;
END;

--Team 2, Challenge 2, Challenge Start 0.5001, poi = 2
SET @Start = 200;
SET @End = 280;
SET @CS = 0.51;
SET @I = 0.0;

WHILE @Start < @End
BEGIN
SET @I = @Start * 0.001;
IF RAND() > 0.5
    BEGIN
    SET @dt = getdate()+@I+@CS;
    SET @dtRounded = dateadd(mi, datediff(mi, 0, @dt), 0);
    IF RAND() < 0.5
    	BEGIN
	    INSERT INTO leaderboard.dbo.LogMessages
	    (Id, TeamName, EndpointUri, CreatedDate, [Type], TimeSlice, StatusCode)
	    VALUES(NEWID(), 'team2', 'http://test/poi', @dt, 2, @dtRounded, 404);
	    END
	ELSE
	    BEGIN
	    INSERT INTO leaderboard.dbo.LogMessages
	    (Id, TeamName, EndpointUri, CreatedDate, [Type], TimeSlice, StatusCode)
	    VALUES(NEWID(), 'team2', 'http://test/poi', @dt, 2, @dtRounded, 500);
	    END
    END
SET @Start = @Start+1;
END;