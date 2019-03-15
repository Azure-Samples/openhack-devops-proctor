SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE dbo.LogMessages (
	Id nvarchar(128) NOT NULL,
	TeamName nvarchar(50) NOT NULL,
	EndpointUri nvarchar(512) NOT NULL,
	CreatedDate datetime2 NOT NULL,
	TimeSlice datetime2 NOT NULL,
	[Type] int NOT NULL,
	StatusCode int NOT NULL
)

GO

ALTER TABLE dbo.LogMessages ADD CONSTRAINT LogMessages_PK PRIMARY KEY (TeamName, EndpointUri, CreatedDate, [Type])

GO

CREATE INDEX LogMessages_TimeSlice_IDX ON dbo.LogMessages (TimeSlice)

GO

CREATE TABLE dbo.Teams (
	Id nvarchar(128) NOT NULL,
	TeamName nvarchar(50) NOT NULL,
	DownTimeMinutes int NOT NULL,
	IsScoringEnabled bit DEFAULT ((0)) NOT NULL,
	Points int NOT NULL
)

GO

ALTER TABLE dbo.Teams ADD CONSTRAINT Teams_PK PRIMARY KEY (Id)

GO


CREATE UNIQUE INDEX Teams_TeamName_IDX ON dbo.Teams (TeamName)

GO

CREATE TABLE dbo.ChallengeDefinitions (
    Id nvarchar(128) NOT NULL,
	Name nvarchar(100) NOT NULL,
	MaxPoints int NOT NULL,
	Description nvarchar(512),
    ScoreEnabled bit DEFAULT ((0)) NOT NULL
)

GO

ALTER TABLE dbo.ChallengeDefinitions ADD CONSTRAINT ChallengeDefinitions_PK PRIMARY KEY (Id)

GO

CREATE INDEX ChallengeDefinitions_Name_IDX ON dbo.ChallengeDefinitions (Name)

GO

CREATE TABLE dbo.Challenges (
    Id nvarchar(128) NOT NULL,
	TeamId nvarchar(128) NOT NULL,
	ChallengeDefinitionId nvarchar(128) NOT NULL,
	StartDateTime datetime2 NOT NULL,
	EndDateTime datetime2,
	IsCompleted BIT NOT NULL,
	Score INT,

)

GO

ALTER TABLE dbo.Challenges ADD CONSTRAINT Challenges_PK PRIMARY KEY (Id,TeamId,ChallengeDefinitionId)

GO

CREATE INDEX Challenges_StartEndDateTime_IDX ON dbo.Challenges (StartDateTime,EndDateTime)

GO

ALTER TABLE dbo.Challenges ADD CONSTRAINT FK_Challenges_Team FOREIGN KEY (TeamId) REFERENCES dbo.Teams (Id)

GO

ALTER TABLE dbo.Challenges ADD CONSTRAINT FK_Challenges_ChallengeDefinition FOREIGN KEY (ChallengeDefinitionId) REFERENCES dbo.ChallengeDefinitions (Id)

GO

ALTER TABLE dbo.Challenges ADD CONSTRAINT DF_Challenges_IsCompleted DEFAULT 0 FOR IsCompleted

GO

CREATE TABLE dbo.ServiceStatus (
	TeamId nvarchar(128) NOT NULL,
	ServiceType int NOT NULL,
	Status nvarchar(12) NOT NULL,
)

GO

ALTER TABLE dbo.ServiceStatus ADD CONSTRAINT ServiceStatus_PK PRIMARY KEY (TeamId,ServiceType)

GO

CREATE TABLE dbo.AspNetRoleClaims(
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

CREATE TABLE dbo.AspNetRoles (
	Id nvarchar(128) NOT NULL,
	Name nvarchar(256),
	NormalizedName nvarchar(256),
	ConcurrencyStamp nvarchar(128)
)

GO

ALTER TABLE dbo.AspNetRoles ADD CONSTRAINT PK_AspNetRoles PRIMARY KEY (Id)

GO

CREATE TABLE dbo.AspNetUserClaims(
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

CREATE TABLE dbo.AspNetUserLogins(
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

CREATE TABLE dbo.AspNetUserRoles(
	[UserId] [nvarchar](128) NOT NULL,
	[RoleId] [nvarchar](128) NOT NULL,
 CONSTRAINT [PK_AspNetUserRoles] PRIMARY KEY CLUSTERED
(
	[UserId] ASC,
	[RoleId] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO

CREATE TABLE dbo.AspNetUsers (
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

ALTER TABLE dbo.AspNetUsers ADD CONSTRAINT PK_AspNetUsers PRIMARY KEY (Id)

GO

CREATE TABLE dbo.AspNetUserTokens(
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

ALTER TABLE dbo.AspNetRoleClaims  WITH CHECK ADD  CONSTRAINT [FK_AspNetRoleClaims_AspNetRoles_RoleId] FOREIGN KEY([RoleId])
REFERENCES dbo.AspNetRoles(Id)
ON DELETE CASCADE

GO

ALTER TABLE dbo.AspNetRoleClaims CHECK CONSTRAINT [FK_AspNetRoleClaims_AspNetRoles_RoleId]

GO

ALTER TABLE dbo.AspNetUserClaims WITH CHECK ADD  CONSTRAINT [FK_AspNetUserClaims_AspNetUsers_UserId] FOREIGN KEY([UserId])
REFERENCES dbo.AspNetUsers (Id)
ON DELETE CASCADE

GO

ALTER TABLE dbo.AspNetUserClaims CHECK CONSTRAINT [FK_AspNetUserClaims_AspNetUsers_UserId]

GO

ALTER TABLE dbo.AspNetUserLogins  WITH CHECK ADD  CONSTRAINT [FK_AspNetUserLogins_AspNetUsers_UserId] FOREIGN KEY([UserId])
REFERENCES dbo.AspNetUsers(Id)
ON DELETE CASCADE

GO

ALTER TABLE dbo.AspNetUserLogins CHECK CONSTRAINT [FK_AspNetUserLogins_AspNetUsers_UserId]

GO

ALTER TABLE dbo.AspNetUserRoles  WITH CHECK ADD  CONSTRAINT [FK_AspNetUserRoles_AspNetRoles_RoleId] FOREIGN KEY([RoleId])
REFERENCES dbo.AspNetRoles(Id)
ON DELETE CASCADE

GO

ALTER TABLE dbo.AspNetUserRoles CHECK CONSTRAINT [FK_AspNetUserRoles_AspNetRoles_RoleId]

GO

ALTER TABLE dbo.AspNetUserRoles  WITH CHECK ADD  CONSTRAINT [FK_AspNetUserRoles_AspNetUsers_UserId] FOREIGN KEY([UserId])
REFERENCES dbo.AspNetUsers ([Id])
ON DELETE CASCADE

GO

ALTER TABLE dbo.AspNetUserRoles CHECK CONSTRAINT [FK_AspNetUserRoles_AspNetUsers_UserId]

GO

CREATE INDEX AspNetUsers_NormalizedUserName_IDX ON dbo.AspNetUsers (NormalizedUserName)
CREATE INDEX AspNetUsers_NormalizedEmail_IDX ON dbo.AspNetUsers (NormalizedEmail)

ALTER TABLE dbo.AspNetUserTokens WITH CHECK ADD  CONSTRAINT [FK_AspNetUserTokens_AspNetUsers_UserId] FOREIGN KEY([UserId])
REFERENCES dbo.AspNetUsers ([Id])
ON DELETE CASCADE

GO

ALTER TABLE dbo.AspNetUserTokens CHECK CONSTRAINT [FK_AspNetUserTokens_AspNetUsers_UserId]

GO
