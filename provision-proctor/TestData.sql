-- Teams
INSERT INTO leaderboard.dbo.Teams
(Id, TeamName, DownTimeMinutes, Points, IsScoringEnabled)
VALUES(NEWID(), 'team1', 10, 50, 0);

INSERT INTO leaderboard.dbo.Teams
(Id, TeamName, DownTimeMinutes, Points, IsScoringEnabled)
VALUES(NEWID(), 'team2', 50, 150, 1);

INSERT INTO leaderboard.dbo.Teams
(Id, TeamName, DownTimeMinutes, Points, IsScoringEnabled)
VALUES(NEWID(), 'team3', 10, 50, 1);

INSERT INTO leaderboard.dbo.Teams
(Id, TeamName, DownTimeMinutes, Points, IsScoringEnabled)
VALUES(NEWID(), 'team4', 15, 340, 1);

GO
-- Challenges
DECLARE @TeamId UNIQUEIDENTIFIER
DECLARE @ChallengeDefinitionId UNIQUEIDENTIFIER

SELECT @TeamId=Id From leaderboard.dbo.Teams where teamName = 'team1'
select @ChallengeDefinitionId=Id from leaderboard.dbo.ChallengeDefinitions where Name = 'Challenge 1'

INSERT INTO leaderboard.dbo.Challenges (Id, TeamId, ChallengeDefinitionId, StartDateTime, EndDateTime, IsCompleted, Score)
VALUES(NEWID(), @TeamId, @ChallengeDefinitionId, GETDATE(), GETDATE()+0.5, 1, 10);

select @ChallengeDefinitionId=Id from leaderboard.dbo.ChallengeDefinitions where Name = 'Challenge 2'

INSERT INTO leaderboard.dbo.Challenges (Id, TeamId, ChallengeDefinitionId, StartDateTime, EndDateTime, IsCompleted, Score)
VALUES(NEWID(), @TeamId, @ChallengeDefinitionId, GETDATE()+0.51, GETDATE()+1, 1, 20);

select @ChallengeDefinitionId=Id from leaderboard.dbo.ChallengeDefinitions where Name = 'Challenge 3'

INSERT INTO leaderboard.dbo.Challenges (Id, TeamId, ChallengeDefinitionId, StartDateTime, EndDateTime, IsCompleted, Score)
VALUES(NEWID(), @TeamId, @ChallengeDefinitionId, GETDATE()+1.01, GETDATE()+1.5, 1, 30);

select @ChallengeDefinitionId=Id from leaderboard.dbo.ChallengeDefinitions where Name = 'Challenge - Medium 1'

INSERT INTO leaderboard.dbo.Challenges (Id, TeamId, ChallengeDefinitionId, StartDateTime, EndDateTime, IsCompleted, Score)
VALUES(NEWID(), @TeamId, @ChallengeDefinitionId, GETDATE()+1.51, GETDATE()+2.0, 1, 60);

SELECT @TeamId=Id From leaderboard.dbo.Teams where teamName = 'team2'
select @ChallengeDefinitionId=Id from leaderboard.dbo.ChallengeDefinitions where Name = 'Challenge 1'

INSERT INTO leaderboard.dbo.Challenges (Id, TeamId, ChallengeDefinitionId, StartDateTime, EndDateTime, IsCompleted, Score)
VALUES(NEWID(), @TeamId, @ChallengeDefinitionId, GETDATE(), GETDATE()+0.5, 1, 50);

select @ChallengeDefinitionId=Id from leaderboard.dbo.ChallengeDefinitions where Name = 'Challenge 2'

INSERT INTO leaderboard.dbo.Challenges (Id, TeamId, ChallengeDefinitionId, StartDateTime, EndDateTime, IsCompleted, Score)
VALUES(NEWID(), @TeamId, @ChallengeDefinitionId, GETDATE()+0.51, GETDATE()+1, 1, 20);

--challenges not completed yet
SELECT @TeamId=Id From leaderboard.dbo.Teams where teamName = 'team3'

select @ChallengeDefinitionId=Id from leaderboard.dbo.ChallengeDefinitions where Name = 'Challenge 1'

INSERT INTO leaderboard.dbo.Challenges (Id, TeamId, ChallengeDefinitionId, StartDateTime, EndDateTime, IsCompleted, Score)
VALUES(NEWID(), @TeamId, @ChallengeDefinitionId, GETDATE(), GETDATE()+0.5, 1, 10);

select @ChallengeDefinitionId=Id from leaderboard.dbo.ChallengeDefinitions where Name = 'Challenge 2'

INSERT INTO leaderboard.dbo.Challenges (Id, TeamId, ChallengeDefinitionId, StartDateTime, EndDateTime, IsCompleted, Score)
VALUES(NEWID(), @TeamId, @ChallengeDefinitionId, GETDATE()+0.51, GETDATE()+1, 1, 20);
select @ChallengeDefinitionId=Id from leaderboard.dbo.ChallengeDefinitions where Name = 'Challenge 3'

INSERT INTO leaderboard.dbo.Challenges (Id, TeamId, ChallengeDefinitionId, StartDateTime, EndDateTime, IsCompleted, Score)
VALUES(NEWID(), @TeamId, @ChallengeDefinitionId, GETDATE()+1.01, GETDATE()+1.50, 1, 20);

select @ChallengeDefinitionId=Id from leaderboard.dbo.ChallengeDefinitions where Name = 'Challenge - Medium 1'

INSERT INTO leaderboard.dbo.Challenges (Id, TeamId, ChallengeDefinitionId, StartDateTime, EndDateTime, IsCompleted, Score)
VALUES(NEWID(), @TeamId, @ChallengeDefinitionId, GETDATE()+1.51, GETDATE()+2.00, 1, 20);

select @ChallengeDefinitionId=Id from leaderboard.dbo.ChallengeDefinitions where Name = 'Challenge - Medium 2'

INSERT INTO leaderboard.dbo.Challenges (Id, TeamId, ChallengeDefinitionId, StartDateTime, EndDateTime, IsCompleted, Score)
VALUES(NEWID(), @TeamId, @ChallengeDefinitionId, GETDATE()+2.01, GETDATE()+2.5, 1, 20);

select @ChallengeDefinitionId=Id from leaderboard.dbo.ChallengeDefinitions where Name = 'Challenge - Difficult 1'

INSERT INTO leaderboard.dbo.Challenges (Id, TeamId, ChallengeDefinitionId, StartDateTime, Score)
VALUES(NEWID(), @TeamId, @ChallengeDefinitionId, GETDATE()+2.51, 20);



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
SET @I = @Start * 0.001
IF RAND() > 0.5
    BEGIN
    SET @dt = getdate()+@I+@CS
    SET @dtRounded = dateadd(mi, datediff(mi, 0, @dt), 0)
    IF RAND() < 0.5
    	BEGIN
	    INSERT INTO leaderboard.dbo.LogMessages
	    (Id, TeamName, EndpointUri, CreatedDate, [Type], TimeSlice, StatusCode)
	    VALUES(NEWID(), 'team1', 'http://test/poi', @dt, 2, @dtRounded, 404)
	    END
	ELSE
	    BEGIN
	    INSERT INTO leaderboard.dbo.LogMessages
	    (Id, TeamName, EndpointUri, CreatedDate, [Type], TimeSlice, StatusCode)
	    VALUES(NEWID(), 'team1', 'http://test/poi', @dt, 2, @dtRounded, 500)
	    END
    END
SET @Start = @Start+1
END;

--Team 1, Challenge 1, Challenge Start 0.0-0.5, USER = 1
SET @Start = 200;
SET @End = 250;
SET @CS = 0.0;
SET @I = 0.0;

WHILE @Start < @End
BEGIN
SET @I = @Start * 0.001
IF RAND() > 0.5
    BEGIN
    SET @dt = getdate()+@I+@CS
    SET @dtRounded = dateadd(mi, datediff(mi, 0, @dt), 0)
    IF RAND() < 0.5
    	BEGIN
	    INSERT INTO leaderboard.dbo.LogMessages
	    (Id, TeamName, EndpointUri, CreatedDate, [Type], TimeSlice, StatusCode)
	    VALUES(NEWID(), 'team1', 'http://test/user', @dt, 1, @dtRounded, 404)
	    END
	ELSE
	    BEGIN
	    INSERT INTO leaderboard.dbo.LogMessages
	    (Id, TeamName, EndpointUri, CreatedDate, [Type], TimeSlice, StatusCode)
	    VALUES(NEWID(), 'team1', 'http://test/user', @dt, 1, @dtRounded, 500)
	    END
    END
SET @Start = @Start+1
END;

--Team 1, Challenge 2, Challenge Start 0.51-1.0, USER = 1
SET @Start = 40;
SET @End = 50;
SET @CS = 0.51;
SET @I = 0.0;

WHILE @Start < @End
BEGIN
SET @I = @Start * 0.001
IF RAND() > 0.5
    BEGIN
    SET @dt = getdate()+@I+@CS
    SET @dtRounded = dateadd(mi, datediff(mi, 0, @dt), 0)
    IF RAND() < 0.5
    	BEGIN
	    INSERT INTO leaderboard.dbo.LogMessages
	    (Id, TeamName, EndpointUri, CreatedDate, [Type], TimeSlice, StatusCode)
	    VALUES(NEWID(), 'team1', 'http://test/user', @dt, 1, @dtRounded, 404)
	    END
	ELSE
	    BEGIN
	    INSERT INTO leaderboard.dbo.LogMessages
	    (Id, TeamName, EndpointUri, CreatedDate, [Type], TimeSlice, StatusCode)
	    VALUES(NEWID(), 'team1', 'http://test/user', @dt, 1, @dtRounded, 500)
	    END
    END
SET @Start = @Start+1
END;

--Team 1, Challenge 3, Challenge Start 1.01-1.5, USER = 1
SET @Start = 80;
SET @End = 99;
SET @CS = 1.01;
SET @I = 0.0;

WHILE @Start < @End
BEGIN
SET @I = @Start * 0.001
IF RAND() > 0.5
    BEGIN
    SET @dt = getdate()+@I+@CS
    SET @dtRounded = dateadd(mi, datediff(mi, 0, @dt), 0)
    IF RAND() < 0.5
    	BEGIN
	    INSERT INTO leaderboard.dbo.LogMessages
	    (Id, TeamName, EndpointUri, CreatedDate, [Type], TimeSlice, StatusCode)
	    VALUES(NEWID(), 'team1', 'http://test/user', @dt, 1, @dtRounded, 404)
	    END
	ELSE
	    BEGIN
	    INSERT INTO leaderboard.dbo.LogMessages
	    (Id, TeamName, EndpointUri, CreatedDate, [Type], TimeSlice, StatusCode)
	    VALUES(NEWID(), 'team1', 'http://test/user', @dt, 1, @dtRounded, 500)
	    END
    END
SET @Start = @Start+1
END;


--Team 1, Challenge 1 - Medium, Challenge Start 1.51-2.0, USER = 1
SET @Start = 100;
SET @End = 260;
SET @CS = 1.51;
SET @I = 0.0;

WHILE @Start < @End
BEGIN
SET @I = @Start * 0.001
IF RAND() > 0.5
    BEGIN
    SET @dt = getdate()+@I+@CS
    SET @dtRounded = dateadd(mi, datediff(mi, 0, @dt), 0)
    IF RAND() < 0.5
    	BEGIN
	    INSERT INTO leaderboard.dbo.LogMessages
	    (Id, TeamName, EndpointUri, CreatedDate, [Type], TimeSlice, StatusCode)
	    VALUES(NEWID(), 'team1', 'http://test/user', @dt, 1, @dtRounded, 404)
	    END
	ELSE
	    BEGIN
	    INSERT INTO leaderboard.dbo.LogMessages
	    (Id, TeamName, EndpointUri, CreatedDate, [Type], TimeSlice, StatusCode)
	    VALUES(NEWID(), 'team1', 'http://test/user', @dt, 1, @dtRounded, 500)
	    END
    END
SET @Start = @Start+1
END;

--Team 1, Challenge - Medium 1, Challenge Start 1.51-2, POI = 2
SET @Start = 100;
SET @End = 280;
SET @CS = 1.51;
SET @I = 0.0;

WHILE @Start < @End
BEGIN
SET @I = @Start * 0.001
IF RAND() > 0.5
    BEGIN
    SET @dt = getdate()+@I+@CS
    SET @dtRounded = dateadd(mi, datediff(mi, 0, @dt), 0)
    IF RAND() < 0.5
    	BEGIN
	    INSERT INTO leaderboard.dbo.LogMessages
	    (Id, TeamName, EndpointUri, CreatedDate, [Type], TimeSlice, StatusCode)
	    VALUES(NEWID(), 'team1', 'http://test/poi', @dt, 2, @dtRounded, 404)
	    END
	ELSE
	    BEGIN
	    INSERT INTO leaderboard.dbo.LogMessages
	    (Id, TeamName, EndpointUri, CreatedDate, [Type], TimeSlice, StatusCode)
	    VALUES(NEWID(), 'team1', 'http://test/poi', @dt, 2, @dtRounded, 500)
	    END
    END
SET @Start = @Start+1
END;

--Team 2, Challenge 1, Challenge Start = 0.0, USER = 1
SET @Start = 50;
SET @End = 100;
SET @CS = 0.0;
SET @I = 0.0;

WHILE @Start < @End
BEGIN
SET @I = @Start * 0.001
IF RAND() > 0.5
    BEGIN
    SET @dt = getdate()+@I+@CS
    SET @dtRounded = dateadd(mi, datediff(mi, 0, @dt), 0)
    IF RAND() < 0.5
    	BEGIN
	    INSERT INTO leaderboard.dbo.LogMessages
	    (Id, TeamName, EndpointUri, CreatedDate, [Type], TimeSlice, StatusCode)
	    VALUES(NEWID(), 'team2', 'http://test/user', @dt, 1, @dtRounded, 404)
	    END
	ELSE
	    BEGIN
	    INSERT INTO leaderboard.dbo.LogMessages
	    (Id, TeamName, EndpointUri, CreatedDate, [Type], TimeSlice, StatusCode)
	    VALUES(NEWID(), 'team2', 'http://test/user', @dt, 1, @dtRounded, 500)
	    END
    END
SET @Start = @Start+1
END;

--Team 2, Challenge 2, Challenge Start = 0.5001, USER = 1
SET @Start = 200;
SET @End = 280;
SET @CS = 0.51;
SET @I = 0.0;

WHILE @Start < @End
BEGIN
SET @I = @Start * 0.001
IF RAND() > 0.5
    BEGIN
    SET @dt = getdate()+@I+@CS
    SET @dtRounded = dateadd(mi, datediff(mi, 0, @dt), 0)
    IF RAND() < 0.5
    	BEGIN
	    INSERT INTO leaderboard.dbo.LogMessages
	    (Id, TeamName, EndpointUri, CreatedDate, [Type], TimeSlice, StatusCode)
	    VALUES(NEWID(), 'team2', 'http://test/user', @dt, 1, @dtRounded, 404)
	    END
	ELSE
	    BEGIN
	    INSERT INTO leaderboard.dbo.LogMessages
	    (Id, TeamName, EndpointUri, CreatedDate, [Type], TimeSlice, StatusCode)
	    VALUES(NEWID(), 'team2', 'http://test/user', @dt, 1, @dtRounded, 500)
	    END
    END
SET @Start = @Start+1
END;

--Team 2, Challenge 1, Challenge Start = 0.0, poi = 2
SET @Start = 50;
SET @End = 100;
SET @CS = 0.0;
SET @I = 0.0;

WHILE @Start < @End
BEGIN
SET @I = @Start * 0.001
IF RAND() > 0.5
    BEGIN
    SET @dt = getdate()+@I+@CS
    SET @dtRounded = dateadd(mi, datediff(mi, 0, @dt), 0)
    IF RAND() < 0.5
    	BEGIN
	    INSERT INTO leaderboard.dbo.LogMessages
	    (Id, TeamName, EndpointUri, CreatedDate, [Type], TimeSlice, StatusCode)
	    VALUES(NEWID(), 'team2', 'http://test/poi', @dt, 2, @dtRounded, 404)
	    END
	ELSE
	    BEGIN
	    INSERT INTO leaderboard.dbo.LogMessages
	    (Id, TeamName, EndpointUri, CreatedDate, [Type], TimeSlice, StatusCode)
	    VALUES(NEWID(), 'team2', 'http://test/poi', @dt, 2, @dtRounded, 500)
	    END
    END
SET @Start = @Start+1
END;

--Team 2, Challenge 2, Challenge Start 0.5001, poi = 2
SET @Start = 200;
SET @End = 280;
SET @CS = 0.51;
SET @I = 0.0;

WHILE @Start < @End
BEGIN
SET @I = @Start * 0.001
IF RAND() > 0.5
    BEGIN
    SET @dt = getdate()+@I+@CS
    SET @dtRounded = dateadd(mi, datediff(mi, 0, @dt), 0)
    IF RAND() < 0.5
    	BEGIN
	    INSERT INTO leaderboard.dbo.LogMessages
	    (Id, TeamName, EndpointUri, CreatedDate, [Type], TimeSlice, StatusCode)
	    VALUES(NEWID(), 'team2', 'http://test/poi', @dt, 2, @dtRounded, 404)
	    END
	ELSE
	    BEGIN
	    INSERT INTO leaderboard.dbo.LogMessages
	    (Id, TeamName, EndpointUri, CreatedDate, [Type], TimeSlice, StatusCode)
	    VALUES(NEWID(), 'team2', 'http://test/poi', @dt, 2, @dtRounded, 500)
	    END
    END
SET @Start = @Start+1
END;

--Team 3, Challenge 1, Challenge Start 0-0.5, POI = 2
SET @Start = 10;
SET @End = 30;
SET @CS = 0.0;
SET @I = 0.0;

WHILE @Start < @End
BEGIN
SET @I = @Start * 0.001
IF RAND() > 0.5
    BEGIN
    SET @dt = getdate()+@I+@CS
    SET @dtRounded = dateadd(mi, datediff(mi, 0, @dt), 0)
    IF RAND() < 0.5
    	BEGIN
	    INSERT INTO leaderboard.dbo.LogMessages
	    (Id, TeamName, EndpointUri, CreatedDate, [Type], TimeSlice, StatusCode)
	    VALUES(NEWID(), 'team3', 'http://test/poi', @dt, 2, @dtRounded, 404)
	    END
	ELSE
	    BEGIN
	    INSERT INTO leaderboard.dbo.LogMessages
	    (Id, TeamName, EndpointUri, CreatedDate, [Type], TimeSlice, StatusCode)
	    VALUES(NEWID(), 'team3', 'http://test/poi', @dt, 2, @dtRounded, 500)
	    END
    END
SET @Start = @Start+1
END;

--Team 3, Challenge 1, Challenge Start 0.0-0.5, USER = 1
SET @Start = 200;
SET @End = 250;
SET @CS = 0.0;
SET @I = 0.0;

WHILE @Start < @End
BEGIN
SET @I = @Start * 0.001
IF RAND() > 0.5
    BEGIN
    SET @dt = getdate()+@I+@CS
    SET @dtRounded = dateadd(mi, datediff(mi, 0, @dt), 0)
    IF RAND() < 0.5
    	BEGIN
	    INSERT INTO leaderboard.dbo.LogMessages
	    (Id, TeamName, EndpointUri, CreatedDate, [Type], TimeSlice, StatusCode)
	    VALUES(NEWID(), 'team3', 'http://test/user', @dt, 1, @dtRounded, 404)
	    END
	ELSE
	    BEGIN
	    INSERT INTO leaderboard.dbo.LogMessages
	    (Id, TeamName, EndpointUri, CreatedDate, [Type], TimeSlice, StatusCode)
	    VALUES(NEWID(), 'team3', 'http://test/user', @dt, 1, @dtRounded, 500)
	    END
    END
SET @Start = @Start+1
END;

--Team 3, Challenge 2, Challenge Start 0.51-1.0, USER = 1
SET @Start = 40;
SET @End = 50;
SET @CS = 0.51;
SET @I = 0.0;

WHILE @Start < @End
BEGIN
SET @I = @Start * 0.001
IF RAND() > 0.5
    BEGIN
    SET @dt = getdate()+@I+@CS
    SET @dtRounded = dateadd(mi, datediff(mi, 0, @dt), 0)
    IF RAND() < 0.5
    	BEGIN
	    INSERT INTO leaderboard.dbo.LogMessages
	    (Id, TeamName, EndpointUri, CreatedDate, [Type], TimeSlice, StatusCode)
	    VALUES(NEWID(), 'team3', 'http://test/user', @dt, 1, @dtRounded, 404)
	    END
	ELSE
	    BEGIN
	    INSERT INTO leaderboard.dbo.LogMessages
	    (Id, TeamName, EndpointUri, CreatedDate, [Type], TimeSlice, StatusCode)
	    VALUES(NEWID(), 'team3', 'http://test/user', @dt, 1, @dtRounded, 500)
	    END
    END
SET @Start = @Start+1
END;

--Team 3, Challenge 3, Challenge Start 1.01-1.5, USER = 1
SET @Start = 80;
SET @End = 99;
SET @CS = 1.01;
SET @I = 0.0;

WHILE @Start < @End
BEGIN
SET @I = @Start * 0.001
IF RAND() > 0.5
    BEGIN
    SET @dt = getdate()+@I+@CS
    SET @dtRounded = dateadd(mi, datediff(mi, 0, @dt), 0)
    IF RAND() < 0.5
    	BEGIN
	    INSERT INTO leaderboard.dbo.LogMessages
	    (Id, TeamName, EndpointUri, CreatedDate, [Type], TimeSlice, StatusCode)
	    VALUES(NEWID(), 'team3', 'http://test/user', @dt, 1, @dtRounded, 404)
	    END
	ELSE
	    BEGIN
	    INSERT INTO leaderboard.dbo.LogMessages
	    (Id, TeamName, EndpointUri, CreatedDate, [Type], TimeSlice, StatusCode)
	    VALUES(NEWID(), 'team3', 'http://test/user', @dt, 1, @dtRounded, 500)
	    END
    END
SET @Start = @Start+1
END;


--Team 3, Challenge 1 - Medium, Challenge Start 1.51-2.0, USER = 1
SET @Start = 180;
SET @End = 200;
SET @CS = 1.51;
SET @I = 0.0;

WHILE @Start < @End
BEGIN
SET @I = @Start * 0.001
IF RAND() > 0.5
    BEGIN
    SET @dt = getdate()+@I+@CS
    SET @dtRounded = dateadd(mi, datediff(mi, 0, @dt), 0)
    IF RAND() < 0.5
    	BEGIN
	    INSERT INTO leaderboard.dbo.LogMessages
	    (Id, TeamName, EndpointUri, CreatedDate, [Type], TimeSlice, StatusCode)
	    VALUES(NEWID(), 'team3', 'http://test/user', @dt, 1, @dtRounded, 404)
	    END
	ELSE
	    BEGIN
	    INSERT INTO leaderboard.dbo.LogMessages
	    (Id, TeamName, EndpointUri, CreatedDate, [Type], TimeSlice, StatusCode)
	    VALUES(NEWID(), 'team3', 'http://test/user', @dt, 1, @dtRounded, 500)
	    END
    END
SET @Start = @Start+1
END;

--Team 3, Challenge - Medium 1, Challenge Start 1.51-2, POI = 2
SET @Start = 180;
SET @End = 200;
SET @CS = 1.51;
SET @I = 0.0;

WHILE @Start < @End
BEGIN
SET @I = @Start * 0.001
IF RAND() > 0.5
    BEGIN
    SET @dt = getdate()+@I+@CS
    SET @dtRounded = dateadd(mi, datediff(mi, 0, @dt), 0)
    IF RAND() < 0.5
    	BEGIN
	    INSERT INTO leaderboard.dbo.LogMessages
	    (Id, TeamName, EndpointUri, CreatedDate, [Type], TimeSlice, StatusCode)
	    VALUES(NEWID(), 'team3', 'http://test/poi', @dt, 2, @dtRounded, 404)
	    END
	ELSE
	    BEGIN
	    INSERT INTO leaderboard.dbo.LogMessages
	    (Id, TeamName, EndpointUri, CreatedDate, [Type], TimeSlice, StatusCode)
	    VALUES(NEWID(), 'team3', 'http://test/poi', @dt, 2, @dtRounded, 500)
	    END
    END
SET @Start = @Start+1
END;

--Team 3, Challenge 2 - Medium, Challenge Start 2.01-2.5, USER = 1
SET @Start = 180;
SET @End = 250;
SET @CS = 2.01;
SET @I = 0.0;

WHILE @Start < @End
BEGIN
SET @I = @Start * 0.001
IF RAND() > 0.5
    BEGIN
    SET @dt = getdate()+@I+@CS
    SET @dtRounded = dateadd(mi, datediff(mi, 0, @dt), 0)
    IF RAND() < 0.5
    	BEGIN
	    INSERT INTO leaderboard.dbo.LogMessages
	    (Id, TeamName, EndpointUri, CreatedDate, [Type], TimeSlice, StatusCode)
	    VALUES(NEWID(), 'team3', 'http://test/user', @dt, 1, @dtRounded, 404)
	    END
	ELSE
	    BEGIN
	    INSERT INTO leaderboard.dbo.LogMessages
	    (Id, TeamName, EndpointUri, CreatedDate, [Type], TimeSlice, StatusCode)
	    VALUES(NEWID(), 'team3', 'http://test/user', @dt, 1, @dtRounded, 500)
	    END
    END
SET @Start = @Start+1
END;

--Team 3, Challenge - Medium 2, Challenge Start 2.01-2.5, POI = 2
SET @Start = 180;
SET @End = 250;
SET @CS = 2.01;
SET @I = 0.0;

WHILE @Start < @End
BEGIN
SET @I = @Start * 0.001
IF RAND() > 0.5
    BEGIN
    SET @dt = getdate()+@I+@CS
    SET @dtRounded = dateadd(mi, datediff(mi, 0, @dt), 0)
    IF RAND() < 0.5
    	BEGIN
	    INSERT INTO leaderboard.dbo.LogMessages
	    (Id, TeamName, EndpointUri, CreatedDate, [Type], TimeSlice, StatusCode)
	    VALUES(NEWID(), 'team3', 'http://test/poi', @dt, 2, @dtRounded, 404)
	    END
	ELSE
	    BEGIN
	    INSERT INTO leaderboard.dbo.LogMessages
	    (Id, TeamName, EndpointUri, CreatedDate, [Type], TimeSlice, StatusCode)
	    VALUES(NEWID(), 'team3', 'http://test/poi', @dt, 2, @dtRounded, 500)
	    END
    END
SET @Start = @Start+1
END;

--Team 3, Challenge - Difficult 1, Challenge Start 2.51-3.0, USER = 1
SET @Start = 90;
SET @End = 120;
SET @CS = 2.51;
SET @I = 0.0;

WHILE @Start < @End
BEGIN
SET @I = @Start * 0.001
IF RAND() > 0.5
    BEGIN
    SET @dt = getdate()+@I+@CS
    SET @dtRounded = dateadd(mi, datediff(mi, 0, @dt), 0)
    IF RAND() < 0.5
    	BEGIN
	    INSERT INTO leaderboard.dbo.LogMessages
	    (Id, TeamName, EndpointUri, CreatedDate, [Type], TimeSlice, StatusCode)
	    VALUES(NEWID(), 'team3', 'http://test/user', @dt, 1, @dtRounded, 404)
	    END
	ELSE
	    BEGIN
	    INSERT INTO leaderboard.dbo.LogMessages
	    (Id, TeamName, EndpointUri, CreatedDate, [Type], TimeSlice, StatusCode)
	    VALUES(NEWID(), 'team3', 'http://test/user', @dt, 1, @dtRounded, 500)
	    END
    END
SET @Start = @Start+1
END;

--TTeam 3, Challenge - Difficult 1, Challenge Start 2.51-3.0, POI = 2
SET @Start = 80;
SET @End = 100;
SET @CS = 2.51;
SET @I = 0.0;

WHILE @Start < @End
BEGIN
SET @I = @Start * 0.001
IF RAND() > 0.5
    BEGIN
    SET @dt = getdate()+@I+@CS
    SET @dtRounded = dateadd(mi, datediff(mi, 0, @dt), 0)
    IF RAND() < 0.5
    	BEGIN
	    INSERT INTO leaderboard.dbo.LogMessages
	    (Id, TeamName, EndpointUri, CreatedDate, [Type], TimeSlice, StatusCode)
	    VALUES(NEWID(), 'team3', 'http://test/poi', @dt, 2, @dtRounded, 404)
	    END
	ELSE
	    BEGIN
	    INSERT INTO leaderboard.dbo.LogMessages
	    (Id, TeamName, EndpointUri, CreatedDate, [Type], TimeSlice, StatusCode)
	    VALUES(NEWID(), 'team3', 'http://test/poi', @dt, 2, @dtRounded, 500)
	    END
    END
SET @Start = @Start+1
END;