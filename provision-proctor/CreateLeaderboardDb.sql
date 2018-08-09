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


CREATE TABLE leaderboard.dbo.AspNetRoleClaims(
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[RoleId] [nvarchar](128) NOT NULL,
	[ClaimType] [nvarchar](max) NULL,
	[ClaimValue] [nvarchar](max) NULL,
 CONSTRAINT [PK_AspNetRoleClaims] PRIMARY KEY CLUSTERED
(
	[Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

CREATE TABLE leaderboard.dbo.AspNetRoles (
	Id nvarchar(128) NOT NULL,
	Name nvarchar(256),
	NormalizedName nvarchar(256),
	ConcurrencyStamp nvarchar(128)
)

GO

ALTER TABLE leaderboard.dbo.AspNetRoles ADD CONSTRAINT PK_AspNetRoles PRIMARY KEY (Id)

GO

CREATE TABLE leaderboard.dbo.AspNetUserClaims(
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [nvarchar](128) NOT NULL,
	[ClaimType] [nvarchar](max) NULL,
	[ClaimValue] [nvarchar](max) NULL,
 CONSTRAINT [PK_AspNetUserClaims] PRIMARY KEY CLUSTERED
(
	[Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

CREATE TABLE leaderboard.dbo.AspNetUserLogins(
	[LoginProvider] [nvarchar](450) NOT NULL,
	[ProviderKey] [nvarchar](450) NOT NULL,
	[ProviderDisplayName] [nvarchar](max) NULL,
	[UserId] [nvarchar](128) NOT NULL,
 CONSTRAINT [PK_AspNetUserLogins] PRIMARY KEY CLUSTERED
(
	[LoginProvider] ASC,
	[ProviderKey] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

CREATE TABLE leaderboard.dbo.AspNetUserRoles(
	[UserId] [nvarchar](128) NOT NULL,
	[RoleId] [nvarchar](128) NOT NULL,
 CONSTRAINT [PK_AspNetUserRoles] PRIMARY KEY CLUSTERED
(
	[UserId] ASC,
	[RoleId] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO

CREATE TABLE leaderboard.dbo.AspNetUsers (
	Id nvarchar(128) NOT NULL,
	UserName nvarchar(256),
	NormalizedUserName nvarchar(256),
	Email nvarchar(256),
	NormalizedEmail nvarchar(128),
	EmailConfirmed bit DEFAULT ((0)) NOT NULL,
	PasswordHash nvarchar(256),
	SecurityStamp nvarchar(256),
	ConcurrencyStamp nvarchar(256),
	PhoneNumber nvarchar(50),
	PhoneNumberConfirmed bit DEFAULT ((0)) NOT NULL,
	TwoFactorEnabled bit DEFAULT ((0)) NOT NULL,
	LockoutEnd datetime,
	LockoutEnabled bit DEFAULT ((0)) NOT NULL,
	AccessFailedCount int NOT NULL,
	FirstName nvarchar(128),
	Lastname nvarchar(128)
)

GO

ALTER TABLE leaderboard.dbo.AspNetUsers ADD CONSTRAINT PK_AspNetUsers PRIMARY KEY (Id)

GO

CREATE TABLE leaderboard.dbo.AspNetUserTokens(
	[UserId] [nvarchar](128) NOT NULL,
	[LoginProvider] [nvarchar](450) NOT NULL,
	[Name] [nvarchar](450) NOT NULL,
	[Value] [nvarchar](max) NULL,
 CONSTRAINT [PK_AspNetUserTokens] PRIMARY KEY CLUSTERED
(
	[UserId] ASC,
	[LoginProvider] ASC,
	[Name] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

ALTER TABLE leaderboard.dbo.AspNetRoleClaims  WITH CHECK ADD  CONSTRAINT [FK_AspNetRoleClaims_AspNetRoles_RoleId] FOREIGN KEY([RoleId])
REFERENCES leaderboard.dbo.AspNetRoles(Id)
ON DELETE CASCADE

GO

ALTER TABLE leaderboard.dbo.AspNetRoleClaims CHECK CONSTRAINT [FK_AspNetRoleClaims_AspNetRoles_RoleId]

GO

ALTER TABLE leaderboard.dbo.AspNetUserClaims WITH CHECK ADD  CONSTRAINT [FK_AspNetUserClaims_AspNetUsers_UserId] FOREIGN KEY([UserId])
REFERENCES leaderboard.dbo.AspNetUsers (Id)
ON DELETE CASCADE

GO

ALTER TABLE leaderboard.dbo.AspNetUserClaims CHECK CONSTRAINT [FK_AspNetUserClaims_AspNetUsers_UserId]

GO

ALTER TABLE leaderboard.dbo.AspNetUserLogins  WITH CHECK ADD  CONSTRAINT [FK_AspNetUserLogins_AspNetUsers_UserId] FOREIGN KEY([UserId])
REFERENCES leaderboard.dbo.AspNetUsers(Id)
ON DELETE CASCADE

GO

ALTER TABLE leaderboard.dbo.AspNetUserLogins CHECK CONSTRAINT [FK_AspNetUserLogins_AspNetUsers_UserId]

GO

ALTER TABLE leaderboard.dbo.AspNetUserRoles  WITH CHECK ADD  CONSTRAINT [FK_AspNetUserRoles_AspNetRoles_RoleId] FOREIGN KEY([RoleId])
REFERENCES leaderboard.dbo.AspNetRoles(Id)
ON DELETE CASCADE

GO

ALTER TABLE leaderboard.dbo.AspNetUserRoles CHECK CONSTRAINT [FK_AspNetUserRoles_AspNetRoles_RoleId]

GO

ALTER TABLE leaderboard.dbo.AspNetUserRoles  WITH CHECK ADD  CONSTRAINT [FK_AspNetUserRoles_AspNetUsers_UserId] FOREIGN KEY([UserId])
REFERENCES leaderboard.dbo.AspNetUsers ([Id])
ON DELETE CASCADE

GO

ALTER TABLE leaderboard.dbo.AspNetUserRoles CHECK CONSTRAINT [FK_AspNetUserRoles_AspNetUsers_UserId]

GO

CREATE INDEX AspNetUsers_NormalizedUserName_IDX ON leaderboard.dbo.AspNetUsers (NormalizedUserName)
CREATE INDEX AspNetUsers_NormalizedEmail_IDX ON leaderboard.dbo.AspNetUsers (NormalizedEmail)

ALTER TABLE leaderboard.dbo.AspNetUserTokens WITH CHECK ADD  CONSTRAINT [FK_AspNetUserTokens_AspNetUsers_UserId] FOREIGN KEY([UserId])
REFERENCES leaderboard.dbo.AspNetUsers ([Id])
ON DELETE CASCADE

GO

ALTER TABLE leaderboard.dbo.AspNetUserTokens CHECK CONSTRAINT [FK_AspNetUserTokens_AspNetUsers_UserId]

GO
