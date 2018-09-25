
--Challenge Definitions
INSERT INTO leaderboard.dbo.ChallengeDefinitions
(Id, Name, MaxPoints, Description, ScoreEnabled)
VALUES(NEWID(),'Challenge 1', 50, 'Establish your plan', 0);

INSERT INTO leaderboard.dbo.ChallengeDefinitions
(Id, Name, MaxPoints, Description, ScoreEnabled)
VALUES(NEWID(),'Challenge 2', 50, 'Implement Continuous Integration (CI)', 0);

INSERT INTO leaderboard.dbo.ChallengeDefinitions
(Id, Name, MaxPoints, Description, ScoreEnabled)
VALUES(NEWID(),'Challenge 3', 50, 'Implement Unit Testing', 0);

INSERT INTO leaderboard.dbo.ChallengeDefinitions
(Id, Name, MaxPoints, Description, ScoreEnabled)
VALUES(NEWID(),'Challenge 4', 50, 'Implement Continous Delivery (CD)', 0);

INSERT INTO leaderboard.dbo.ChallengeDefinitions
(Id, Name, MaxPoints, Description, ScoreEnabled)
VALUES(NEWID(),'Challenge 5', 100, 'Implement a basic Blue/Green Deployment Strategy', 1);

INSERT INTO leaderboard.dbo.ChallengeDefinitions
(Id, Name, MaxPoints, Description, ScoreEnabled)
VALUES(NEWID(),'Challenge 6', 200, 'Implement a monitoring solution for your MyDriving APIs', 1);

INSERT INTO leaderboard.dbo.ChallengeDefinitions
(Id, Name, MaxPoints, Description, ScoreEnabled)
VALUES(NEWID(),'Challenge 7', 200, 'Implement Integration and Load Testing', 1);

INSERT INTO leaderboard.dbo.ChallengeDefinitions
(Id, Name, MaxPoints, Description, ScoreEnabled)
VALUES(NEWID(),'Challenge 8', 200, 'Implement phased rollout with rollback', 1);