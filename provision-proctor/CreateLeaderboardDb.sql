SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE leaderboard.dbo.LogMessages (
        Id nvarchar(128) NOT NULL,
        TeamName nvarchar(50) NOT NULL,
        EndpointUri nvarchar(512) NOT NULL,
        CreatedDate datetime NOT NULL,
        [Type] int NOT NULL,
        StatusCode int NOT NULL
)

GO

ALTER TABLE leaderboard.dbo.LogMessages ADD CONSTRAINT LogMessages_PK PRIMARY KEY (TeamName,EndpointUri,CreatedDate,[Type])

GO

CREATE INDEX LogMessages_StatusCode_IDX ON leaderboard.dbo.LogMessages (StatusCode)

GO

CREATE TABLE leaderboard.dbo.Teams (
        Id nvarchar(128) NOT NULL,
        TeamName nvarchar(50) NOT NULL,
        DowntimeSeconds int NOT NULL,
        IsScoringEnabled bit DEFAULT ((0)) NOT NULL,
        Points int NOT NULL
)

GO

ALTER TABLE leaderboard.dbo.Teams ADD CONSTRAINT Teams_PK PRIMARY KEY (Id)

GO


CREATE UNIQUE INDEX Teams_TeamName_IDX ON leaderboard.dbo.Teams (TeamName)

GO

CREATE TABLE leaderboard.dbo.ChallengeDefinitions (
        Id nvarchar(128) NOT NULL,
	Name nvarchar(100) NOT NULL,
	MaxPoints int NOT NULL,
	Description nvarchar(512),
        ScoreEnabled bit DEFAULT ((0)) NOT NULL
)

GO

ALTER TABLE leaderboard.dbo.ChallengeDefinitions ADD CONSTRAINT ChallengeDefinitions_PK PRIMARY KEY (Name,Id)

GO


CREATE TABLE leaderboard.dbo.Challenges (
        Id nvarchar(128) NOT NULL,
	TeamId nvarchar(128) NOT NULL,
	ChallengeDefinitionId nvarchar(128) NOT NULL,
	StartDateTime datetime NOT NULL,
	EndDateTime datetime,
	Score int,

)

GO

ALTER TABLE leaderboard.dbo.Challenges ADD CONSTRAINT Challenges_PK PRIMARY KEY (Id,TeamId,ChallengeDefinitionId)

GO

CREATE INDEX Challenges_StartEndDateTime_IDX ON leaderboard.dbo.Challenges (StartDateTime,EndDateTime)

GO

ALTER TABLE leaderboard.dbo.Challenges ADD CONSTRAINT FK_Challenges_Team FOREIGN KEY (TeamId) REFERENCES leaderboard.dbo.Teams (TeamId)

GO

ALTER TABLE leaderboard.dbo.Challenges ADD CONSTRAINT FK_Challenges_ChallengeDefinition FOREIGN KEY (ChallengeDefinitionId) REFERENCES leaderboard.dbo.Teams (Id)