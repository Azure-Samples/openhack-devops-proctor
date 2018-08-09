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
VALUES(NEWID(), @TeamId, @ChallengeDefinitionId, GETDATE(), GETDATE()+1, 10);

SELECT @TeamId=Id From leaderboard.dbo.Teams where teamName = 'team2'
select @ChallengeDefinitionId=Id from leaderboard.dbo.ChallengeDefinitions where Name = 'Challenge 2'


INSERT INTO leaderboard.dbo.Challenges (Id, TeamId, ChallengeDefinitionId, StartDateTime, EndDateTime, Score)
VALUES(NEWID(), @TeamId, @ChallengeDefinitionId, GETDATE(), GETDATE()+1, 20);

SELECT @TeamId=Id From leaderboard.dbo.Teams where teamName = 'team2'
select @ChallengeDefinitionId=Id from leaderboard.dbo.ChallengeDefinitions where Name = 'Challenge 1'


INSERT INTO leaderboard.dbo.Challenges (Id, TeamId, ChallengeDefinitionId, StartDateTime, EndDateTime, Score)
VALUES(NEWID(), @TeamId, @ChallengeDefinitionId, GETDATE(), GETDATE()+1, 50);

GO
--LogMessages
INSERT INTO leaderboard.dbo.LogMessages
(Id, TeamName, EndpointUri, CreatedDate, [Type], StatusCode)
VALUES(NEWID(), 'team1', 'http://test/poi', GETDATE(), 1, 404);

INSERT INTO leaderboard.dbo.LogMessages
(Id, TeamName, EndpointUri, CreatedDate, [Type], StatusCode)
VALUES(NEWID(), 'team1', 'http://test/poi', GETDATE()+.01, 1, 404);

INSERT INTO leaderboard.dbo.LogMessages
(Id, TeamName, EndpointUri, CreatedDate, [Type], StatusCode)
VALUES(NEWID(), 'team1', 'http://test/user', GETDATE()+.001, 2, 404);

INSERT INTO leaderboard.dbo.LogMessages
(Id, TeamName, EndpointUri, CreatedDate, [Type], StatusCode)
VALUES(NEWID(), 'team1', 'http://test/user', GETDATE()+.002, 2, 404);
