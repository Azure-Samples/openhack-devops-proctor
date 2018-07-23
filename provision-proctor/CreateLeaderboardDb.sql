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
        Points int NOT NULL
)

GO

CREATE UNIQUE INDEX Teams_TeamName_IDX ON leaderboard.dbo.Teams (TeamName)

GO