
--Challenge Definitions
INSERT INTO leaderboard.dbo.ChallengeDefinitions
(Id, Name, MaxPoints, Description, ScoreEnabled)
VALUES(NEWID(),'Challenge 1', 50, 'Implement a Continuous Integration (CI) pipeline', 0);

INSERT INTO leaderboard.dbo.ChallengeDefinitions
(Id, Name, MaxPoints, Description, ScoreEnabled)
VALUES(NEWID(),'Challenge 2', 50, 'Implement Release Management', 0);

INSERT INTO leaderboard.dbo.ChallengeDefinitions
(Id, Name, MaxPoints, Description, ScoreEnabled)
VALUES(NEWID(),'Challenge 3', 50, 'Implement a monitoring solution for your MyDriving', 0);

INSERT INTO leaderboard.dbo.ChallengeDefinitions
(Id, Name, MaxPoints, Description, ScoreEnabled)
VALUES(NEWID(),'Challenge 0.5', 50, 'Establish your plan', 0);

INSERT INTO leaderboard.dbo.ChallengeDefinitions
(Id, Name, MaxPoints, Description, ScoreEnabled)
VALUES(NEWID(),'Challenge - Medium 1', 100, 'Testing, testing, and testing', 1);

INSERT INTO leaderboard.dbo.ChallengeDefinitions
(Id, Name, MaxPoints, Description, ScoreEnabled)
VALUES(NEWID(),'Challenge - Medium 2', 100, 'Are you production-ready?', 1);

INSERT INTO leaderboard.dbo.ChallengeDefinitions
(Id, Name, MaxPoints, Description, ScoreEnabled)
VALUES(NEWID(),'Challenge - Difficult 1', 200, 'Implement deployment with phased rollout', 1);

INSERT INTO leaderboard.dbo.ChallengeDefinitions
(Id, Name, MaxPoints, Description, ScoreEnabled)
VALUES(NEWID(),'Challenge - Difficult 1', 200, 'Can you survive a major disaster?', 1);