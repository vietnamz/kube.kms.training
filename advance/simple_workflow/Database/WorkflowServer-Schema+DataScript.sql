USE [master]
GO
/****** Object:  Database [WFTemp]    Script Date: 6/23/2018 3:08:41 PM ******/
CREATE DATABASE [WFTemp]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'WFTemp', FILENAME = N'/var/WFTemp.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'WFTemp_log', FILENAME = N'/var/WFTemp_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
GO
ALTER DATABASE [WFTemp] SET COMPATIBILITY_LEVEL = 140
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [WFTemp].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [WFTemp] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [WFTemp] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [WFTemp] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [WFTemp] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [WFTemp] SET ARITHABORT OFF 
GO
ALTER DATABASE [WFTemp] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [WFTemp] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [WFTemp] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [WFTemp] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [WFTemp] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [WFTemp] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [WFTemp] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [WFTemp] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [WFTemp] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [WFTemp] SET  DISABLE_BROKER 
GO
ALTER DATABASE [WFTemp] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [WFTemp] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [WFTemp] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [WFTemp] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [WFTemp] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [WFTemp] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [WFTemp] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [WFTemp] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [WFTemp] SET  MULTI_USER 
GO
ALTER DATABASE [WFTemp] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [WFTemp] SET DB_CHAINING OFF 
GO
ALTER DATABASE [WFTemp] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [WFTemp] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [WFTemp] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [WFTemp] SET QUERY_STORE = OFF
GO
USE [WFTemp]
GO
ALTER DATABASE SCOPED CONFIGURATION SET IDENTITY_CACHE = ON;
GO
ALTER DATABASE SCOPED CONFIGURATION SET LEGACY_CARDINALITY_ESTIMATION = OFF;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET LEGACY_CARDINALITY_ESTIMATION = PRIMARY;
GO
ALTER DATABASE SCOPED CONFIGURATION SET MAXDOP = 0;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET MAXDOP = PRIMARY;
GO
ALTER DATABASE SCOPED CONFIGURATION SET PARAMETER_SNIFFING = ON;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET PARAMETER_SNIFFING = PRIMARY;
GO
ALTER DATABASE SCOPED CONFIGURATION SET QUERY_OPTIMIZER_HOTFIXES = OFF;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET QUERY_OPTIMIZER_HOTFIXES = PRIMARY;
GO
USE [WFTemp]
GO
/****** Object:  UserDefinedTableType [dbo].[IdsTableType]    Script Date: 6/23/2018 3:08:41 PM ******/
CREATE TYPE [dbo].[IdsTableType] AS TABLE(
	[Id] [uniqueidentifier] NULL
)
GO
/****** Object:  View [dbo].[vStructDivisionParents]    Script Date: 6/23/2018 3:08:41 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vStructDivisionParents]
	AS
	with cteRecursive as (
	 select sd.Id FirstId, sd.ParentId ParentId, sd.Id Id
	  from  [dbo].[StructDivision] sd WHERE sd.ParentId IS NOT NULL
	 union all 
	 select r.FirstId FirstId, sdr.ParentId ParentId, sdr.Id Id
	 from [dbo].[StructDivision] sdr
	 inner join cteRecursive r ON r.ParentId = sdr.Id)

	select DISTINCT FirstId Id, ParentId ParentId FROM cteRecursive 
GO
/****** Object:  View [dbo].[vStructDivisionParentsAndThis]    Script Date: 6/23/2018 3:08:41 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vStructDivisionParentsAndThis]
	AS
	select  Id Id, Id ParentId FROM [dbo].[StructDivision]
	UNION 
	select  Id Id, ParentId ParentId FROM [dbo].[vStructDivisionParents]
GO
/****** Object:  View [dbo].[vHeads]    Script Date: 6/23/2018 3:08:41 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vHeads]
	AS
	select  e.Id Id, e.Name Name, eh.Id HeadId, eh.Name HeadName FROM Employee e 
		INNER JOIN [vStructDivisionParentsAndThis] vsp ON e.StructDivisionId = vsp.Id
		INNER JOIN Employee eh ON eh.StructDivisionId = vsp.ParentId AND eh.IsHead = 1
GO
/****** Object:  Table [dbo].[WorkflowGlobalParameter]    Script Date: 6/23/2018 3:08:41 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WorkflowGlobalParameter](
	[Id] [uniqueidentifier] NOT NULL,
	[Type] [nvarchar](max) NOT NULL,
	[Name] [nvarchar](max) NOT NULL,
	[Value] [nvarchar](max) NOT NULL,
 CONSTRAINT [PK_WorkflowGlobalParameter] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[WorkflowInbox]    Script Date: 6/23/2018 3:08:41 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WorkflowInbox](
	[Id] [uniqueidentifier] NOT NULL,
	[ProcessId] [uniqueidentifier] NOT NULL,
	[IdentityId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_WorkflowInbox] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[WorkflowProcessInstance]    Script Date: 6/23/2018 3:08:41 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WorkflowProcessInstance](
	[Id] [uniqueidentifier] NOT NULL,
	[StateName] [nvarchar](max) NULL,
	[ActivityName] [nvarchar](max) NOT NULL,
	[SchemeId] [uniqueidentifier] NULL,
	[PreviousState] [nvarchar](max) NULL,
	[PreviousStateForDirect] [nvarchar](max) NULL,
	[PreviousStateForReverse] [nvarchar](max) NULL,
	[PreviousActivity] [nvarchar](max) NULL,
	[PreviousActivityForDirect] [nvarchar](max) NULL,
	[PreviousActivityForReverse] [nvarchar](max) NULL,
	[ParentProcessId] [uniqueidentifier] NULL,
	[RootProcessId] [uniqueidentifier] NOT NULL,
	[IsDeterminingParametersChanged] [bit] NOT NULL,
 CONSTRAINT [PK_WorkflowProcessInstance_1] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[WorkflowProcessInstancePersistence]    Script Date: 6/23/2018 3:08:41 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WorkflowProcessInstancePersistence](
	[Id] [uniqueidentifier] NOT NULL,
	[ProcessId] [uniqueidentifier] NOT NULL,
	[ParameterName] [nvarchar](max) NOT NULL,
	[Value] [ntext] NOT NULL,
 CONSTRAINT [PK_WorkflowProcessInstancePersistence] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[WorkflowProcessInstanceStatus]    Script Date: 6/23/2018 3:08:41 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WorkflowProcessInstanceStatus](
	[Id] [uniqueidentifier] NOT NULL,
	[Status] [tinyint] NOT NULL,
	[Lock] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_WorkflowProcessInstanceStatus] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[WorkflowProcessScheme]    Script Date: 6/23/2018 3:08:41 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WorkflowProcessScheme](
	[Id] [uniqueidentifier] NOT NULL,
	[Scheme] [ntext] NOT NULL,
	[DefiningParameters] [ntext] NOT NULL,
	[DefiningParametersHash] [nvarchar](1024) NOT NULL,
	[SchemeCode] [nvarchar](max) NOT NULL,
	[IsObsolete] [bit] NOT NULL,
	[RootSchemeCode] [nvarchar](max) NULL,
	[RootSchemeId] [uniqueidentifier] NULL,
	[AllowedActivities] [nvarchar](max) NULL,
	[StartingTransition] [nvarchar](max) NULL,
 CONSTRAINT [PK_WorkflowProcessScheme] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[WorkflowProcessTimer]    Script Date: 6/23/2018 3:08:41 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WorkflowProcessTimer](
	[Id] [uniqueidentifier] NOT NULL,
	[ProcessId] [uniqueidentifier] NOT NULL,
	[Name] [nvarchar](max) NOT NULL,
	[NextExecutionDateTime] [datetime] NOT NULL,
	[Ignore] [bit] NOT NULL,
 CONSTRAINT [PK_WorkflowProcessTimer] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[WorkflowProcessTransitionHistory]    Script Date: 6/23/2018 3:08:41 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WorkflowProcessTransitionHistory](
	[Id] [uniqueidentifier] NOT NULL,
	[ProcessId] [uniqueidentifier] NOT NULL,
	[ExecutorIdentityId] [nvarchar](max) NULL,
	[ActorIdentityId] [nvarchar](max) NULL,
	[FromActivityName] [nvarchar](max) NOT NULL,
	[ToActivityName] [nvarchar](max) NOT NULL,
	[ToStateName] [nvarchar](max) NULL,
	[TransitionTime] [datetime] NOT NULL,
	[TransitionClassifier] [nvarchar](max) NOT NULL,
	[IsFinalised] [bit] NOT NULL,
	[FromStateName] [nvarchar](max) NULL,
	[TriggerName] [nvarchar](max) NULL,
 CONSTRAINT [PK_WorkflowProcessTransitionHistory] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[WorkflowScheme]    Script Date: 6/23/2018 3:08:41 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WorkflowScheme](
	[Code] [nvarchar](256) NOT NULL,
	[Scheme] [nvarchar](max) NOT NULL,
 CONSTRAINT [PK_WorkflowScheme] PRIMARY KEY CLUSTERED 
(
	[Code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
INSERT [dbo].[WorkflowProcessInstance] ([Id], [StateName], [ActivityName], [SchemeId], [PreviousState], [PreviousStateForDirect], [PreviousStateForReverse], [PreviousActivity], [PreviousActivityForDirect], [PreviousActivityForReverse], [ParentProcessId], [RootProcessId], [IsDeterminingParametersChanged]) VALUES (N'6b36c36c-5b8b-4c0e-a819-015e3ad2704d', N'User Is Editing The OT Request', N'Fail', N'f8e1b455-041f-406c-b83e-22c2a9c6d096', N'User Is Editing The OT Request', N'User Is Editing The OT Request', N'The PM Is Confirm of Reject', N'User Edit Activity', N'User Edit Activity', N'PM Activity', NULL, N'6b36c36c-5b8b-4c0e-a819-015e3ad2704d', 0)
INSERT [dbo].[WorkflowProcessInstance] ([Id], [StateName], [ActivityName], [SchemeId], [PreviousState], [PreviousStateForDirect], [PreviousStateForReverse], [PreviousActivity], [PreviousActivityForDirect], [PreviousActivityForReverse], [ParentProcessId], [RootProcessId], [IsDeterminingParametersChanged]) VALUES (N'6929dca1-d9ad-457a-8aed-059a0fb59db7', N'User Cancelled', N'Fail', N'f8e1b455-041f-406c-b83e-22c2a9c6d096', N'User Must Edit The Item', N'User Must Edit The Item', N'The Director Will Approve or Reject', N'User Edit Activity', N'User Edit Activity', N'Director Activity', NULL, N'6929dca1-d9ad-457a-8aed-059a0fb59db7', 0)
INSERT [dbo].[WorkflowProcessInstance] ([Id], [StateName], [ActivityName], [SchemeId], [PreviousState], [PreviousStateForDirect], [PreviousStateForReverse], [PreviousActivity], [PreviousActivityForDirect], [PreviousActivityForReverse], [ParentProcessId], [RootProcessId], [IsDeterminingParametersChanged]) VALUES (N'c731d909-8c32-44ad-bcd8-1a3a3da8d7ee', N'User Cancelled', N'Fail', N'f8e1b455-041f-406c-b83e-22c2a9c6d096', N'User Is Editing The OT Request', N'User Is Editing The OT Request', N'The PM Is Confirm of Reject', N'User Edit Activity', N'User Edit Activity', N'PM Activity', NULL, N'c731d909-8c32-44ad-bcd8-1a3a3da8d7ee', 0)
INSERT [dbo].[WorkflowProcessInstance] ([Id], [StateName], [ActivityName], [SchemeId], [PreviousState], [PreviousStateForDirect], [PreviousStateForReverse], [PreviousActivity], [PreviousActivityForDirect], [PreviousActivityForReverse], [ParentProcessId], [RootProcessId], [IsDeterminingParametersChanged]) VALUES (N'3ada0065-a9d3-4c26-95e2-272b167bce54', N'OT Request Created', N'User Request Activity', N'9ea0c8f2-a6e1-44da-af81-e12ef7b3d5b0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'3ada0065-a9d3-4c26-95e2-272b167bce54', 0)
INSERT [dbo].[WorkflowProcessInstance] ([Id], [StateName], [ActivityName], [SchemeId], [PreviousState], [PreviousStateForDirect], [PreviousStateForReverse], [PreviousActivity], [PreviousActivityForDirect], [PreviousActivityForReverse], [ParentProcessId], [RootProcessId], [IsDeterminingParametersChanged]) VALUES (N'c1bba69a-f927-4ccc-887c-2a60012f43d2', N'The Director Will Approve or Reject', N'Director Activity', N'eea8dc22-eabb-4572-8a47-589fb12834d2', N'The PM Is Confirm of Reject', N'The PM Is Confirm of Reject', NULL, N'PM Activity', N'PM Activity', NULL, NULL, N'c1bba69a-f927-4ccc-887c-2a60012f43d2', 0)
INSERT [dbo].[WorkflowProcessInstance] ([Id], [StateName], [ActivityName], [SchemeId], [PreviousState], [PreviousStateForDirect], [PreviousStateForReverse], [PreviousActivity], [PreviousActivityForDirect], [PreviousActivityForReverse], [ParentProcessId], [RootProcessId], [IsDeterminingParametersChanged]) VALUES (N'935ef8e7-e5e1-4406-b57b-2d41b8732d99', N'OT Request Created', N'User Request Activity', N'f8e1b455-041f-406c-b83e-22c2a9c6d096', NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'935ef8e7-e5e1-4406-b57b-2d41b8732d99', 0)
INSERT [dbo].[WorkflowProcessInstance] ([Id], [StateName], [ActivityName], [SchemeId], [PreviousState], [PreviousStateForDirect], [PreviousStateForReverse], [PreviousActivity], [PreviousActivityForDirect], [PreviousActivityForReverse], [ParentProcessId], [RootProcessId], [IsDeterminingParametersChanged]) VALUES (N'403f8d17-fb54-4154-97c1-38819da3d25b', N'User Cancelled', N'Fail', N'f8e1b455-041f-406c-b83e-22c2a9c6d096', N'User Is Editing The OT Request', N'User Is Editing The OT Request', N'The PM Is Confirm of Reject', N'User Edit Activity', N'User Edit Activity', N'PM Activity', NULL, N'403f8d17-fb54-4154-97c1-38819da3d25b', 0)
INSERT [dbo].[WorkflowProcessInstance] ([Id], [StateName], [ActivityName], [SchemeId], [PreviousState], [PreviousStateForDirect], [PreviousStateForReverse], [PreviousActivity], [PreviousActivityForDirect], [PreviousActivityForReverse], [ParentProcessId], [RootProcessId], [IsDeterminingParametersChanged]) VALUES (N'36f7db48-77a5-40ec-9d96-3d0a3c75efe6', N'OT Request Created', N'User Request Activity', N'f8e1b455-041f-406c-b83e-22c2a9c6d096', NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'36f7db48-77a5-40ec-9d96-3d0a3c75efe6', 0)
INSERT [dbo].[WorkflowProcessInstance] ([Id], [StateName], [ActivityName], [SchemeId], [PreviousState], [PreviousStateForDirect], [PreviousStateForReverse], [PreviousActivity], [PreviousActivityForDirect], [PreviousActivityForReverse], [ParentProcessId], [RootProcessId], [IsDeterminingParametersChanged]) VALUES (N'c6e46058-0695-4cd4-8758-4d54865df14c', N'The PM Is Confirm of Reject', N'PM Activity', N'f8e1b455-041f-406c-b83e-22c2a9c6d096', N'OT Request Created', N'OT Request Created', NULL, N'User Request Activity', N'User Request Activity', NULL, NULL, N'c6e46058-0695-4cd4-8758-4d54865df14c', 0)
INSERT [dbo].[WorkflowProcessInstance] ([Id], [StateName], [ActivityName], [SchemeId], [PreviousState], [PreviousStateForDirect], [PreviousStateForReverse], [PreviousActivity], [PreviousActivityForDirect], [PreviousActivityForReverse], [ParentProcessId], [RootProcessId], [IsDeterminingParametersChanged]) VALUES (N'4f9221fc-bbdf-4c44-b50b-556ba0620484', N'OT Request Created', N'User Request Activity', N'35faf432-a7e0-4b1d-9681-e143df742abe', NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'4f9221fc-bbdf-4c44-b50b-556ba0620484', 0)
INSERT [dbo].[WorkflowProcessInstance] ([Id], [StateName], [ActivityName], [SchemeId], [PreviousState], [PreviousStateForDirect], [PreviousStateForReverse], [PreviousActivity], [PreviousActivityForDirect], [PreviousActivityForReverse], [ParentProcessId], [RootProcessId], [IsDeterminingParametersChanged]) VALUES (N'4f38b710-c718-411f-8d67-69ab874aed0c', N'User Cancelled', N'Fail', N'f8e1b455-041f-406c-b83e-22c2a9c6d096', N'User Is Editing The OT Request', N'User Is Editing The OT Request', N'The PM Is Confirm of Reject', N'User Edit Activity', N'User Edit Activity', N'PM Activity', NULL, N'4f38b710-c718-411f-8d67-69ab874aed0c', 0)
INSERT [dbo].[WorkflowProcessInstance] ([Id], [StateName], [ActivityName], [SchemeId], [PreviousState], [PreviousStateForDirect], [PreviousStateForReverse], [PreviousActivity], [PreviousActivityForDirect], [PreviousActivityForReverse], [ParentProcessId], [RootProcessId], [IsDeterminingParametersChanged]) VALUES (N'97bf28e1-081c-4808-a5ee-6b00bd02adb6', N'User Cancelled', N'Fail', N'f8e1b455-041f-406c-b83e-22c2a9c6d096', N'User Must Edit The Item', N'User Must Edit The Item', N'The Director Will Approve or Reject', N'User Edit Activity', N'User Edit Activity', N'Director Activity', NULL, N'97bf28e1-081c-4808-a5ee-6b00bd02adb6', 0)
INSERT [dbo].[WorkflowProcessInstance] ([Id], [StateName], [ActivityName], [SchemeId], [PreviousState], [PreviousStateForDirect], [PreviousStateForReverse], [PreviousActivity], [PreviousActivityForDirect], [PreviousActivityForReverse], [ParentProcessId], [RootProcessId], [IsDeterminingParametersChanged]) VALUES (N'ffd2b05e-285e-491c-bc43-81a9b6095655', N'OT Request Created', N'User Request Activity', N'e4e4faf8-3419-4a38-8376-fad7a861b04b', NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'ffd2b05e-285e-491c-bc43-81a9b6095655', 0)
INSERT [dbo].[WorkflowProcessInstance] ([Id], [StateName], [ActivityName], [SchemeId], [PreviousState], [PreviousStateForDirect], [PreviousStateForReverse], [PreviousActivity], [PreviousActivityForDirect], [PreviousActivityForReverse], [ParentProcessId], [RootProcessId], [IsDeterminingParametersChanged]) VALUES (N'ffd2b05e-285e-491c-bc43-81a9b6095657', N'OT Request Created', N'User Request Activity', N'e4e4faf8-3419-4a38-8376-fad7a861b04b', NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'ffd2b05e-285e-491c-bc43-81a9b6095657', 0)
INSERT [dbo].[WorkflowProcessInstance] ([Id], [StateName], [ActivityName], [SchemeId], [PreviousState], [PreviousStateForDirect], [PreviousStateForReverse], [PreviousActivity], [PreviousActivityForDirect], [PreviousActivityForReverse], [ParentProcessId], [RootProcessId], [IsDeterminingParametersChanged]) VALUES (N'eed2b05e-285e-491c-bc43-81a9b609568f', N'The PM Is Confirm of Reject', N'PM Activity', N'eea8dc22-eabb-4572-8a47-589fb12834d2', N'OT Request Created', N'OT Request Created', NULL, N'User Request Activity', N'User Request Activity', NULL, NULL, N'eed2b05e-285e-491c-bc43-81a9b609568f', 0)
INSERT [dbo].[WorkflowProcessInstance] ([Id], [StateName], [ActivityName], [SchemeId], [PreviousState], [PreviousStateForDirect], [PreviousStateForReverse], [PreviousActivity], [PreviousActivityForDirect], [PreviousActivityForReverse], [ParentProcessId], [RootProcessId], [IsDeterminingParametersChanged]) VALUES (N'07afe990-812e-4eaf-ab9f-8627fd5aec32', N'The OT Request Is Approved', N'Done', N'f8e1b455-041f-406c-b83e-22c2a9c6d096', N'The Director Will Approve or Reject', N'The Director Will Approve or Reject', NULL, N'Director Activity', N'Director Activity', NULL, NULL, N'07afe990-812e-4eaf-ab9f-8627fd5aec32', 0)
INSERT [dbo].[WorkflowProcessInstance] ([Id], [StateName], [ActivityName], [SchemeId], [PreviousState], [PreviousStateForDirect], [PreviousStateForReverse], [PreviousActivity], [PreviousActivityForDirect], [PreviousActivityForReverse], [ParentProcessId], [RootProcessId], [IsDeterminingParametersChanged]) VALUES (N'e13232c3-dd6a-447a-ae1e-90f2022e32c9', N'OT Request Created', N'User Request Activity', N'f8e1b455-041f-406c-b83e-22c2a9c6d096', NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'e13232c3-dd6a-447a-ae1e-90f2022e32c9', 0)
INSERT [dbo].[WorkflowProcessInstance] ([Id], [StateName], [ActivityName], [SchemeId], [PreviousState], [PreviousStateForDirect], [PreviousStateForReverse], [PreviousActivity], [PreviousActivityForDirect], [PreviousActivityForReverse], [ParentProcessId], [RootProcessId], [IsDeterminingParametersChanged]) VALUES (N'6df419d0-a1f3-4616-a15b-9ac7992cbaeb', N'OT Request Created', N'User Request Activity', N'9ea0c8f2-a6e1-44da-af81-e12ef7b3d5b0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'6df419d0-a1f3-4616-a15b-9ac7992cbaeb', 0)
INSERT [dbo].[WorkflowProcessInstance] ([Id], [StateName], [ActivityName], [SchemeId], [PreviousState], [PreviousStateForDirect], [PreviousStateForReverse], [PreviousActivity], [PreviousActivityForDirect], [PreviousActivityForReverse], [ParentProcessId], [RootProcessId], [IsDeterminingParametersChanged]) VALUES (N'e8a744b6-67da-4134-849c-ac3b1e737f29', N'User Cancelled', N'Fail', N'f8e1b455-041f-406c-b83e-22c2a9c6d096', N'User Is Editing The OT Request', N'User Is Editing The OT Request', N'The PM Is Confirm of Reject', N'User Edit Activity', N'User Edit Activity', N'PM Activity', NULL, N'e8a744b6-67da-4134-849c-ac3b1e737f29', 0)
INSERT [dbo].[WorkflowProcessInstance] ([Id], [StateName], [ActivityName], [SchemeId], [PreviousState], [PreviousStateForDirect], [PreviousStateForReverse], [PreviousActivity], [PreviousActivityForDirect], [PreviousActivityForReverse], [ParentProcessId], [RootProcessId], [IsDeterminingParametersChanged]) VALUES (N'5b3bbe52-b94c-4288-a795-b409c9b5671a', N'OT Request Created', N'User Request Activity', N'd339bf66-c6f2-4f11-8f2f-e0cc4d7bc870', NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'5b3bbe52-b94c-4288-a795-b409c9b5671a', 0)
INSERT [dbo].[WorkflowProcessInstance] ([Id], [StateName], [ActivityName], [SchemeId], [PreviousState], [PreviousStateForDirect], [PreviousStateForReverse], [PreviousActivity], [PreviousActivityForDirect], [PreviousActivityForReverse], [ParentProcessId], [RootProcessId], [IsDeterminingParametersChanged]) VALUES (N'a8c34c0f-2f29-47bd-8602-b52b0107e9bc', N'OT Request Created', N'User Request Activity', N'9ea0c8f2-a6e1-44da-af81-e12ef7b3d5b0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'a8c34c0f-2f29-47bd-8602-b52b0107e9bc', 0)
INSERT [dbo].[WorkflowProcessInstance] ([Id], [StateName], [ActivityName], [SchemeId], [PreviousState], [PreviousStateForDirect], [PreviousStateForReverse], [PreviousActivity], [PreviousActivityForDirect], [PreviousActivityForReverse], [ParentProcessId], [RootProcessId], [IsDeterminingParametersChanged]) VALUES (N'6a8a8d22-194b-4e90-8c62-baff9332c218', N'The OT Request Is Approved', N'Done', N'f8e1b455-041f-406c-b83e-22c2a9c6d096', N'The Director Will Approve or Reject', N'The Director Will Approve or Reject', NULL, N'Director Activity', N'Director Activity', NULL, NULL, N'6a8a8d22-194b-4e90-8c62-baff9332c218', 0)
INSERT [dbo].[WorkflowProcessInstance] ([Id], [StateName], [ActivityName], [SchemeId], [PreviousState], [PreviousStateForDirect], [PreviousStateForReverse], [PreviousActivity], [PreviousActivityForDirect], [PreviousActivityForReverse], [ParentProcessId], [RootProcessId], [IsDeterminingParametersChanged]) VALUES (N'74c59b87-7aa4-4c37-a653-bc7f76edf772', N'OT Request Created', N'User Request Activity', N'f8e1b455-041f-406c-b83e-22c2a9c6d096', NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'74c59b87-7aa4-4c37-a653-bc7f76edf772', 0)
INSERT [dbo].[WorkflowProcessInstance] ([Id], [StateName], [ActivityName], [SchemeId], [PreviousState], [PreviousStateForDirect], [PreviousStateForReverse], [PreviousActivity], [PreviousActivityForDirect], [PreviousActivityForReverse], [ParentProcessId], [RootProcessId], [IsDeterminingParametersChanged]) VALUES (N'e1a57d16-0f3b-4b81-b669-c53ba231163a', N'User Cancelled', N'Fail', N'f8e1b455-041f-406c-b83e-22c2a9c6d096', N'User Must Edit The Item', N'User Must Edit The Item', N'The PM Is Confirm of Reject', N'User Edit Activity', N'User Edit Activity', N'PM Activity', NULL, N'e1a57d16-0f3b-4b81-b669-c53ba231163a', 0)
INSERT [dbo].[WorkflowProcessInstance] ([Id], [StateName], [ActivityName], [SchemeId], [PreviousState], [PreviousStateForDirect], [PreviousStateForReverse], [PreviousActivity], [PreviousActivityForDirect], [PreviousActivityForReverse], [ParentProcessId], [RootProcessId], [IsDeterminingParametersChanged]) VALUES (N'4d4ec185-a4d8-4b40-930e-c56f9bed229a', N'OT Request Created', N'User Request Activity', N'f8e1b455-041f-406c-b83e-22c2a9c6d096', NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'4d4ec185-a4d8-4b40-930e-c56f9bed229a', 0)
INSERT [dbo].[WorkflowProcessInstance] ([Id], [StateName], [ActivityName], [SchemeId], [PreviousState], [PreviousStateForDirect], [PreviousStateForReverse], [PreviousActivity], [PreviousActivityForDirect], [PreviousActivityForReverse], [ParentProcessId], [RootProcessId], [IsDeterminingParametersChanged]) VALUES (N'dc66822a-7678-43bd-af07-da1d4aee1c7e', N'User Is Editing The OT Request', N'User Edit Activity', N'f8e1b455-041f-406c-b83e-22c2a9c6d096', N'The Director Will Approve or Reject', N'The PM Is Confirm of Reject', N'The Director Will Approve or Reject', N'Director Activity', N'PM Activity', N'Director Activity', NULL, N'dc66822a-7678-43bd-af07-da1d4aee1c7e', 0)
INSERT [dbo].[WorkflowProcessInstance] ([Id], [StateName], [ActivityName], [SchemeId], [PreviousState], [PreviousStateForDirect], [PreviousStateForReverse], [PreviousActivity], [PreviousActivityForDirect], [PreviousActivityForReverse], [ParentProcessId], [RootProcessId], [IsDeterminingParametersChanged]) VALUES (N'172e22da-1496-459d-947d-e41497ae839d', N'OT Request Created', N'User Request Activity', N'9ea0c8f2-a6e1-44da-af81-e12ef7b3d5b0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'172e22da-1496-459d-947d-e41497ae839d', 0)
INSERT [dbo].[WorkflowProcessInstance] ([Id], [StateName], [ActivityName], [SchemeId], [PreviousState], [PreviousStateForDirect], [PreviousStateForReverse], [PreviousActivity], [PreviousActivityForDirect], [PreviousActivityForReverse], [ParentProcessId], [RootProcessId], [IsDeterminingParametersChanged]) VALUES (N'cd154f8a-c0d4-4f8d-b955-eb658692e9ff', N'OT Request Created', N'User Request Activity', N'f8e1b455-041f-406c-b83e-22c2a9c6d096', NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'cd154f8a-c0d4-4f8d-b955-eb658692e9ff', 0)
INSERT [dbo].[WorkflowProcessInstance] ([Id], [StateName], [ActivityName], [SchemeId], [PreviousState], [PreviousStateForDirect], [PreviousStateForReverse], [PreviousActivity], [PreviousActivityForDirect], [PreviousActivityForReverse], [ParentProcessId], [RootProcessId], [IsDeterminingParametersChanged]) VALUES (N'a6429ef9-cc92-45aa-b6db-f6beda73e275', N'OT Request Created', N'User Request Activity', N'9ea0c8f2-a6e1-44da-af81-e12ef7b3d5b0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'a6429ef9-cc92-45aa-b6db-f6beda73e275', 0)
INSERT [dbo].[WorkflowProcessInstancePersistence] ([Id], [ProcessId], [ParameterName], [Value]) VALUES (N'd2369058-a70d-4916-9a2c-59433e6b15de', N'ffd2b05e-285e-491c-bc43-81a9b6095657', N'Number', N'1')
INSERT [dbo].[WorkflowProcessInstancePersistence] ([Id], [ProcessId], [ParameterName], [Value]) VALUES (N'98457282-52f8-4919-ae7b-c6d015e2b507', N'ffd2b05e-285e-491c-bc43-81a9b6095655', N'Number', N'1')
INSERT [dbo].[WorkflowProcessInstanceStatus] ([Id], [Status], [Lock]) VALUES (N'6b36c36c-5b8b-4c0e-a819-015e3ad2704d', 3, N'e1d7c035-e996-4505-b624-6aafe1fcf259')
INSERT [dbo].[WorkflowProcessInstanceStatus] ([Id], [Status], [Lock]) VALUES (N'6929dca1-d9ad-457a-8aed-059a0fb59db7', 3, N'06af8228-9ed6-4fd4-a615-5ed7960f7569')
INSERT [dbo].[WorkflowProcessInstanceStatus] ([Id], [Status], [Lock]) VALUES (N'c731d909-8c32-44ad-bcd8-1a3a3da8d7ee', 3, N'2b41f340-d27c-488a-8401-68a90addec2b')
INSERT [dbo].[WorkflowProcessInstanceStatus] ([Id], [Status], [Lock]) VALUES (N'3ada0065-a9d3-4c26-95e2-272b167bce54', 2, N'3ebce8da-71f0-4dbb-8be3-670e84ba31c4')
INSERT [dbo].[WorkflowProcessInstanceStatus] ([Id], [Status], [Lock]) VALUES (N'c1bba69a-f927-4ccc-887c-2a60012f43d2', 2, N'96a4838b-3e1d-4a16-8e25-074b8f67250b')
INSERT [dbo].[WorkflowProcessInstanceStatus] ([Id], [Status], [Lock]) VALUES (N'935ef8e7-e5e1-4406-b57b-2d41b8732d99', 2, N'ed8b4cb2-cdb3-4353-a7b6-5948b9890420')
INSERT [dbo].[WorkflowProcessInstanceStatus] ([Id], [Status], [Lock]) VALUES (N'403f8d17-fb54-4154-97c1-38819da3d25b', 3, N'3c0cdfbc-d263-427b-9296-ec52f2723578')
INSERT [dbo].[WorkflowProcessInstanceStatus] ([Id], [Status], [Lock]) VALUES (N'36f7db48-77a5-40ec-9d96-3d0a3c75efe6', 2, N'65b23528-d69d-4627-bdfc-b4a256c50b2b')
INSERT [dbo].[WorkflowProcessInstanceStatus] ([Id], [Status], [Lock]) VALUES (N'c6e46058-0695-4cd4-8758-4d54865df14c', 2, N'7ea3c69b-2631-4177-8271-d9556d869b3a')
INSERT [dbo].[WorkflowProcessInstanceStatus] ([Id], [Status], [Lock]) VALUES (N'4f9221fc-bbdf-4c44-b50b-556ba0620484', 2, N'75f87119-3f62-447e-8659-5ec23015e2ef')
INSERT [dbo].[WorkflowProcessInstanceStatus] ([Id], [Status], [Lock]) VALUES (N'4f38b710-c718-411f-8d67-69ab874aed0c', 3, N'f8fcdda0-4955-4e0f-ad4b-f71a44e2d695')
INSERT [dbo].[WorkflowProcessInstanceStatus] ([Id], [Status], [Lock]) VALUES (N'97bf28e1-081c-4808-a5ee-6b00bd02adb6', 3, N'29435957-2328-4788-8fdc-3e3719578c98')
INSERT [dbo].[WorkflowProcessInstanceStatus] ([Id], [Status], [Lock]) VALUES (N'ffd2b05e-285e-491c-bc43-81a9b6095655', 2, N'97d7691c-7d06-4c34-adfb-5f4339b1c30c')
INSERT [dbo].[WorkflowProcessInstanceStatus] ([Id], [Status], [Lock]) VALUES (N'ffd2b05e-285e-491c-bc43-81a9b6095657', 2, N'9800d2de-4163-4b14-8fab-fb61b804d2b0')
INSERT [dbo].[WorkflowProcessInstanceStatus] ([Id], [Status], [Lock]) VALUES (N'eed2b05e-285e-491c-bc43-81a9b609568f', 2, N'481b265b-3082-4b61-85fc-69479ea192c3')
INSERT [dbo].[WorkflowProcessInstanceStatus] ([Id], [Status], [Lock]) VALUES (N'07afe990-812e-4eaf-ab9f-8627fd5aec32', 3, N'368c6d92-8d18-4cfa-b6ce-2db8d5168953')
INSERT [dbo].[WorkflowProcessInstanceStatus] ([Id], [Status], [Lock]) VALUES (N'e13232c3-dd6a-447a-ae1e-90f2022e32c9', 2, N'22b16725-5702-44a7-926a-c3f2d609cb72')
INSERT [dbo].[WorkflowProcessInstanceStatus] ([Id], [Status], [Lock]) VALUES (N'6df419d0-a1f3-4616-a15b-9ac7992cbaeb', 2, N'9fd0387b-b334-4d01-9cd7-65428817e487')
INSERT [dbo].[WorkflowProcessInstanceStatus] ([Id], [Status], [Lock]) VALUES (N'e8a744b6-67da-4134-849c-ac3b1e737f29', 3, N'c20e4987-4b22-4733-8f84-fe6155d253fe')
INSERT [dbo].[WorkflowProcessInstanceStatus] ([Id], [Status], [Lock]) VALUES (N'5b3bbe52-b94c-4288-a795-b409c9b5671a', 2, N'1d985e4d-b94c-42db-940c-f2a65dbec65e')
INSERT [dbo].[WorkflowProcessInstanceStatus] ([Id], [Status], [Lock]) VALUES (N'a8c34c0f-2f29-47bd-8602-b52b0107e9bc', 2, N'0b1996d2-2534-4b13-b9e2-1be23ec19357')
INSERT [dbo].[WorkflowProcessInstanceStatus] ([Id], [Status], [Lock]) VALUES (N'6a8a8d22-194b-4e90-8c62-baff9332c218', 3, N'fb32e531-995d-4ca3-95f5-42e201fc7d16')
INSERT [dbo].[WorkflowProcessInstanceStatus] ([Id], [Status], [Lock]) VALUES (N'74c59b87-7aa4-4c37-a653-bc7f76edf772', 2, N'34ffed92-a14d-49d1-868d-b603dc1c2bbf')
INSERT [dbo].[WorkflowProcessInstanceStatus] ([Id], [Status], [Lock]) VALUES (N'e1a57d16-0f3b-4b81-b669-c53ba231163a', 3, N'd40f493f-f17b-4e09-b1ba-9f176ffbda8d')
INSERT [dbo].[WorkflowProcessInstanceStatus] ([Id], [Status], [Lock]) VALUES (N'4d4ec185-a4d8-4b40-930e-c56f9bed229a', 2, N'6c32caa3-9070-4fc8-b422-4db61e3f779c')
INSERT [dbo].[WorkflowProcessInstanceStatus] ([Id], [Status], [Lock]) VALUES (N'dc66822a-7678-43bd-af07-da1d4aee1c7e', 2, N'cfd22f6a-4bb7-4334-ae0a-9064f134163d')
INSERT [dbo].[WorkflowProcessInstanceStatus] ([Id], [Status], [Lock]) VALUES (N'172e22da-1496-459d-947d-e41497ae839d', 2, N'e474ee58-42fb-47ca-bfb0-7dc37a193bd1')
INSERT [dbo].[WorkflowProcessInstanceStatus] ([Id], [Status], [Lock]) VALUES (N'cd154f8a-c0d4-4f8d-b955-eb658692e9ff', 2, N'ba89e7b2-b766-4d10-b688-69a086d89edd')
INSERT [dbo].[WorkflowProcessInstanceStatus] ([Id], [Status], [Lock]) VALUES (N'a6429ef9-cc92-45aa-b6db-f6beda73e275', 2, N'1a300b96-7ad9-4796-b116-9cefcffb1b06')
INSERT [dbo].[WorkflowProcessScheme] ([Id], [Scheme], [DefiningParameters], [DefiningParametersHash], [SchemeCode], [IsObsolete], [RootSchemeCode], [RootSchemeId], [AllowedActivities], [StartingTransition]) VALUES (N'f8e1b455-041f-406c-b83e-22c2a9c6d096', N'<Process>
  <Designer />
  <Actors>
    <Actor Name="User" Rule="CheckRole" Value="User" />
    <Actor Name="ProjectManager" Rule="CheckRole" Value="ProjectManager" />
    <Actor Name="Director" Rule="CheckRole" Value="Director" />
  </Actors>
  <Commands>
    <Command Name="Submit" />
    <Command Name="Reject" />
    <Command Name="Confirm" />
    <Command Name="Approve" />
    <Command Name="Cancel" />
  </Commands>
  <Activities>
    <Activity Name="User Request Activity" State="OT Request Created" IsInitial="True" IsFinal="False" IsForSetState="True" IsAutoSchemeUpdate="True">
      <Designer X="90" Y="180" />
    </Activity>
    <Activity Name="PM Activity" State="The PM Is Confirm of Reject" IsInitial="False" IsFinal="False" IsForSetState="True" IsAutoSchemeUpdate="True">
      <Designer X="470" Y="180" />
    </Activity>
    <Activity Name="Director Activity" State="The Director Will Approve or Reject" IsInitial="False" IsFinal="False" IsForSetState="True" IsAutoSchemeUpdate="True">
      <Designer X="840" Y="180" />
    </Activity>
    <Activity Name="Done" State="The OT Request Is Approved" IsInitial="False" IsFinal="True" IsForSetState="True" IsAutoSchemeUpdate="True">
      <Designer X="1320" Y="190" />
    </Activity>
    <Activity Name="User Edit Activity" State="User Must Edit The Item" IsInitial="False" IsFinal="False" IsForSetState="True" IsAutoSchemeUpdate="True">
      <Designer X="480" Y="490" />
    </Activity>
    <Activity Name="Fail" State="User Cancelled" IsInitial="False" IsFinal="True" IsForSetState="True" IsAutoSchemeUpdate="True">
      <Designer X="1300" Y="490" />
    </Activity>
    <Activity Name="Activity_1" IsInitial="False" IsFinal="False" IsForSetState="True" IsAutoSchemeUpdate="True">
      <Designer X="140" Y="380" />
    </Activity>
  </Activities>
  <Transitions>
    <Transition Name="User Request Activity_PM Activity_1" To="PM Activity" From="User Request Activity" Classifier="Direct" AllowConcatenationType="And" RestrictConcatenationType="And" ConditionsConcatenationType="And" IsFork="false" MergeViaSetState="false" DisableParentStateControl="false">
      <Restrictions>
        <Restriction Type="Allow" NameRef="User" />
      </Restrictions>
      <Triggers>
        <Trigger Type="Command" NameRef="Submit" />
      </Triggers>
      <Conditions>
        <Condition Type="Always" />
      </Conditions>
      <Designer />
    </Transition>
    <Transition Name="PM Activity_Director Activity_1" To="Director Activity" From="PM Activity" Classifier="Direct" AllowConcatenationType="And" RestrictConcatenationType="And" ConditionsConcatenationType="And" IsFork="false" MergeViaSetState="false" DisableParentStateControl="false">
      <Restrictions>
        <Restriction Type="Allow" NameRef="ProjectManager" />
      </Restrictions>
      <Triggers>
        <Trigger Type="Command" NameRef="Confirm" />
      </Triggers>
      <Conditions>
        <Condition Type="Always" />
      </Conditions>
      <Designer />
    </Transition>
    <Transition Name="Director Activity_Done_1" To="Done" From="Director Activity" Classifier="Direct" AllowConcatenationType="And" RestrictConcatenationType="And" ConditionsConcatenationType="And" IsFork="false" MergeViaSetState="false" DisableParentStateControl="false">
      <Restrictions>
        <Restriction Type="Allow" NameRef="Director" />
      </Restrictions>
      <Triggers>
        <Trigger Type="Command" NameRef="Approve" />
      </Triggers>
      <Conditions>
        <Condition Type="Always" />
      </Conditions>
      <Designer />
    </Transition>
    <Transition Name="Director Activity_User Edit Activity_1" To="User Edit Activity" From="Director Activity" Classifier="Reverse" AllowConcatenationType="And" RestrictConcatenationType="And" ConditionsConcatenationType="And" IsFork="false" MergeViaSetState="false" DisableParentStateControl="false">
      <Restrictions>
        <Restriction Type="Allow" NameRef="Director" />
      </Restrictions>
      <Triggers>
        <Trigger Type="Command" NameRef="Reject" />
      </Triggers>
      <Conditions>
        <Condition Type="Always" />
      </Conditions>
      <Designer X="948" Y="430" />
    </Transition>
    <Transition Name="PM Activity_User Edit Activity_1" To="User Edit Activity" From="PM Activity" Classifier="Reverse" AllowConcatenationType="And" RestrictConcatenationType="And" ConditionsConcatenationType="And" IsFork="false" MergeViaSetState="false" DisableParentStateControl="false">
      <Restrictions>
        <Restriction Type="Allow" NameRef="ProjectManager" />
      </Restrictions>
      <Triggers>
        <Trigger Type="Command" NameRef="Reject" />
      </Triggers>
      <Conditions>
        <Condition Type="Always" />
      </Conditions>
      <Designer X="528" Y="364" />
    </Transition>
    <Transition Name="User Edit Activity_PM Activity_1" To="PM Activity" From="User Edit Activity" Classifier="Direct" AllowConcatenationType="And" RestrictConcatenationType="And" ConditionsConcatenationType="And" IsFork="false" MergeViaSetState="false" DisableParentStateControl="false">
      <Restrictions>
        <Restriction Type="Allow" NameRef="User" />
      </Restrictions>
      <Triggers>
        <Trigger Type="Command" NameRef="Submit" />
      </Triggers>
      <Conditions>
        <Condition Type="Always" />
      </Conditions>
      <Designer X="600" Y="366" />
    </Transition>
    <Transition Name="User Edit Activity_Fail_1" To="Fail" From="User Edit Activity" Classifier="Direct" AllowConcatenationType="And" RestrictConcatenationType="And" ConditionsConcatenationType="And" IsFork="false" MergeViaSetState="false" DisableParentStateControl="false">
      <Restrictions>
        <Restriction Type="Allow" NameRef="User" />
      </Restrictions>
      <Triggers>
        <Trigger Type="Command" NameRef="Cancel" />
      </Triggers>
      <Conditions>
        <Condition Type="Always" />
      </Conditions>
      <Designer />
    </Transition>
  </Transitions>
</Process>', N'{}', N'r4ztHEDMTwYwDqoEyePFlg==', N'SimpleWF', 0, NULL, NULL, N'null', NULL)
INSERT [dbo].[WorkflowProcessScheme] ([Id], [Scheme], [DefiningParameters], [DefiningParametersHash], [SchemeCode], [IsObsolete], [RootSchemeCode], [RootSchemeId], [AllowedActivities], [StartingTransition]) VALUES (N'495fba5b-e3de-4cbf-aeb6-5375a4f94960', N'<Process>
  <Designer />
  <Actors>
    <Actor Name="User" Rule="CheckRole" Value="User" />
    <Actor Name="ProjectManager" Rule="CheckRole" Value="ProjectManager" />
    <Actor Name="Director" Rule="CheckRole" Value="Director" />
  </Actors>
  <Commands>
    <Command Name="Submit" />
    <Command Name="Reject" />
    <Command Name="Confirm" />
    <Command Name="Approve" />
    <Command Name="Cancel" />
  </Commands>
  <Activities>
    <Activity Name="User Request Activity" State="OT Request Created" IsInitial="True" IsFinal="False" IsForSetState="True" IsAutoSchemeUpdate="True">
      <Implementation>
        <ActionRef Order="1" NameRef="LogHistory">
          <ActionParameter><![CDATA[TESTSSSSS]]></ActionParameter>
        </ActionRef>
      </Implementation>
      <Designer X="120" Y="180" />
    </Activity>
    <Activity Name="PM Activity" State="The PM Is Confirm of Reject" IsInitial="False" IsFinal="False" IsForSetState="True" IsAutoSchemeUpdate="True">
      <Implementation>
        <ActionRef Order="1" NameRef="LogHistory" />
      </Implementation>
      <Designer X="470" Y="180" />
    </Activity>
    <Activity Name="Director Activity" State="The Director Will Approve or Reject" IsInitial="False" IsFinal="False" IsForSetState="True" IsAutoSchemeUpdate="True">
      <Designer X="840" Y="180" />
    </Activity>
    <Activity Name="Done" State="The OT Request Is Approved" IsInitial="False" IsFinal="True" IsForSetState="True" IsAutoSchemeUpdate="True">
      <Designer X="1260" Y="180" />
    </Activity>
    <Activity Name="User Edit Activity" State="User Is Editing The OT Request" IsInitial="False" IsFinal="False" IsForSetState="True" IsAutoSchemeUpdate="True">
      <Designer X="480" Y="490" />
    </Activity>
    <Activity Name="Fail" IsInitial="False" IsFinal="True" IsForSetState="True" IsAutoSchemeUpdate="True">
      <Designer X="1280" Y="500" />
    </Activity>
  </Activities>
  <Transitions>
    <Transition Name="User Request Activity_PM Activity_1" To="PM Activity" From="User Request Activity" Classifier="Direct" AllowConcatenationType="And" RestrictConcatenationType="And" ConditionsConcatenationType="And" IsFork="false" MergeViaSetState="false" DisableParentStateControl="false">
      <Restrictions>
        <Restriction Type="Allow" NameRef="User" />
      </Restrictions>
      <Triggers>
        <Trigger Type="Command" NameRef="Submit" />
      </Triggers>
      <Conditions>
        <Condition Type="Always" />
      </Conditions>
      <Designer X="395" Y="213" />
    </Transition>
    <Transition Name="PM Activity_Director Activity_1" To="Director Activity" From="PM Activity" Classifier="Direct" AllowConcatenationType="And" RestrictConcatenationType="And" ConditionsConcatenationType="And" IsFork="false" MergeViaSetState="false" DisableParentStateControl="false">
      <Restrictions>
        <Restriction Type="Allow" NameRef="ProjectManager" />
      </Restrictions>
      <Triggers>
        <Trigger Type="Command" NameRef="Confirm" />
      </Triggers>
      <Conditions>
        <Condition Type="Always" />
      </Conditions>
      <Designer />
    </Transition>
    <Transition Name="Director Activity_Done_1" To="Done" From="Director Activity" Classifier="Direct" AllowConcatenationType="And" RestrictConcatenationType="And" ConditionsConcatenationType="And" IsFork="false" MergeViaSetState="false" DisableParentStateControl="false">
      <Restrictions>
        <Restriction Type="Allow" NameRef="Director" />
      </Restrictions>
      <Triggers>
        <Trigger Type="Command" NameRef="Approve" />
      </Triggers>
      <Conditions>
        <Condition Type="Always" />
      </Conditions>
      <Designer />
    </Transition>
    <Transition Name="Director Activity_User Edit Activity_1" To="User Edit Activity" From="Director Activity" Classifier="Reverse" AllowConcatenationType="And" RestrictConcatenationType="And" ConditionsConcatenationType="And" IsFork="false" MergeViaSetState="false" DisableParentStateControl="false">
      <Restrictions>
        <Restriction Type="Allow" NameRef="Director" />
      </Restrictions>
      <Triggers>
        <Trigger Type="Command" NameRef="Reject" />
      </Triggers>
      <Conditions>
        <Condition Type="Always" />
      </Conditions>
      <Designer X="948" Y="430" />
    </Transition>
    <Transition Name="PM Activity_User Edit Activity_1" To="User Edit Activity" From="PM Activity" Classifier="Reverse" AllowConcatenationType="And" RestrictConcatenationType="And" ConditionsConcatenationType="And" IsFork="false" MergeViaSetState="false" DisableParentStateControl="false">
      <Restrictions>
        <Restriction Type="Allow" NameRef="ProjectManager" />
      </Restrictions>
      <Triggers>
        <Trigger Type="Command" NameRef="Reject" />
      </Triggers>
      <Conditions>
        <Condition Type="Always" />
      </Conditions>
      <Designer X="528" Y="364" />
    </Transition>
    <Transition Name="User Edit Activity_PM Activity_1" To="PM Activity" From="User Edit Activity" Classifier="Direct" AllowConcatenationType="And" RestrictConcatenationType="And" ConditionsConcatenationType="And" IsFork="false" MergeViaSetState="false" DisableParentStateControl="false">
      <Restrictions>
        <Restriction Type="Allow" NameRef="User" />
      </Restrictions>
      <Triggers>
        <Trigger Type="Command" NameRef="Submit" />
      </Triggers>
      <Conditions>
        <Condition Type="Always" />
      </Conditions>
      <Designer X="600" Y="366" />
    </Transition>
    <Transition Name="User Edit Activity_Fail_1" To="Fail" From="User Edit Activity" Classifier="Direct" AllowConcatenationType="And" RestrictConcatenationType="And" ConditionsConcatenationType="And" IsFork="false" MergeViaSetState="false" DisableParentStateControl="false">
      <Triggers>
        <Trigger Type="Command" NameRef="Cancel" />
      </Triggers>
      <Conditions>
        <Condition Type="Always" />
      </Conditions>
      <Designer />
    </Transition>
  </Transitions>
  <CodeActions>
    <CodeAction Name="LogHistory" Type="Action" IsGlobal="False" IsAsync="True">
      <ActionCode><![CDATA[await "http://localhost:62001/api/demo/test".PostJsonAsync(new { parameter = parameter });]]></ActionCode>
      <Usings><![CDATA[LinqToSqlShared.Mapping;System;OptimaJet.Workflow.Core.Model;WF.Sample.Business.Workflow;System.Data.Linq;System.Data.Linq.SqlClient;System.Data.Linq.Mapping;System.Collections;WF.Sample.Business.Helpers;OptimaJet.Workflow;System.Data.Linq.SqlClient.Implementation;System.Linq;WF.Sample.Business;System.Threading;System.Threading.Tasks;System.Data.Linq.Provider;System.Collections.Generic;WF.Sample.Business.Properties;Flurl.Http;]]></Usings>
    </CodeAction>
  </CodeActions>
</Process>', N'{}', N'r4ztHEDMTwYwDqoEyePFlg==', N'SimpleWF', 1, NULL, NULL, N'null', NULL)
INSERT [dbo].[WorkflowProcessScheme] ([Id], [Scheme], [DefiningParameters], [DefiningParametersHash], [SchemeCode], [IsObsolete], [RootSchemeCode], [RootSchemeId], [AllowedActivities], [StartingTransition]) VALUES (N'eea8dc22-eabb-4572-8a47-589fb12834d2', N'<Process>
  <Designer />
  <Actors>
    <Actor Name="User" Rule="CheckRole" Value="User" />
    <Actor Name="ProjectManager" Rule="CheckRole" Value="ProjectManager" />
    <Actor Name="Director" Rule="CheckRole" Value="Director" />
  </Actors>
  <Commands>
    <Command Name="Submit" />
    <Command Name="Reject" />
    <Command Name="Confirm" />
    <Command Name="Approve" />
    <Command Name="Cancel" />
  </Commands>
  <Activities>
    <Activity Name="User Request Activity" State="OT Request Created" IsInitial="True" IsFinal="False" IsForSetState="True" IsAutoSchemeUpdate="True">
      <Designer X="120" Y="180" />
    </Activity>
    <Activity Name="PM Activity" State="The PM Is Confirm of Reject" IsInitial="False" IsFinal="False" IsForSetState="True" IsAutoSchemeUpdate="True">
      <Implementation>
        <ActionRef Order="1" NameRef="LogHistory" />
      </Implementation>
      <Designer X="470" Y="180" />
    </Activity>
    <Activity Name="Director Activity" State="The Director Will Approve or Reject" IsInitial="False" IsFinal="False" IsForSetState="True" IsAutoSchemeUpdate="True">
      <Designer X="840" Y="180" />
    </Activity>
    <Activity Name="Done" State="The OT Request Is Approved" IsInitial="False" IsFinal="True" IsForSetState="True" IsAutoSchemeUpdate="True">
      <Designer X="1260" Y="180" />
    </Activity>
    <Activity Name="User Edit Activity" State="User Is Editing The OT Request" IsInitial="False" IsFinal="False" IsForSetState="True" IsAutoSchemeUpdate="True">
      <Designer X="480" Y="490" />
    </Activity>
    <Activity Name="Fail" IsInitial="False" IsFinal="True" IsForSetState="True" IsAutoSchemeUpdate="True">
      <Designer X="1280" Y="500" />
    </Activity>
  </Activities>
  <Transitions>
    <Transition Name="User Request Activity_PM Activity_1" To="PM Activity" From="User Request Activity" Classifier="Direct" AllowConcatenationType="And" RestrictConcatenationType="And" ConditionsConcatenationType="And" IsFork="false" MergeViaSetState="false" DisableParentStateControl="false">
      <Restrictions>
        <Restriction Type="Allow" NameRef="User" />
      </Restrictions>
      <Triggers>
        <Trigger Type="Command" NameRef="Submit" />
      </Triggers>
      <Conditions>
        <Condition Type="Always" />
      </Conditions>
      <Designer X="395" Y="213" />
    </Transition>
    <Transition Name="PM Activity_Director Activity_1" To="Director Activity" From="PM Activity" Classifier="Direct" AllowConcatenationType="And" RestrictConcatenationType="And" ConditionsConcatenationType="And" IsFork="false" MergeViaSetState="false" DisableParentStateControl="false">
      <Restrictions>
        <Restriction Type="Allow" NameRef="ProjectManager" />
      </Restrictions>
      <Triggers>
        <Trigger Type="Command" NameRef="Confirm" />
      </Triggers>
      <Conditions>
        <Condition Type="Always" />
      </Conditions>
      <Designer />
    </Transition>
    <Transition Name="Director Activity_Done_1" To="Done" From="Director Activity" Classifier="Direct" AllowConcatenationType="And" RestrictConcatenationType="And" ConditionsConcatenationType="And" IsFork="false" MergeViaSetState="false" DisableParentStateControl="false">
      <Restrictions>
        <Restriction Type="Allow" NameRef="Director" />
      </Restrictions>
      <Triggers>
        <Trigger Type="Command" NameRef="Approve" />
      </Triggers>
      <Conditions>
        <Condition Type="Always" />
      </Conditions>
      <Designer />
    </Transition>
    <Transition Name="Director Activity_User Edit Activity_1" To="User Edit Activity" From="Director Activity" Classifier="Reverse" AllowConcatenationType="And" RestrictConcatenationType="And" ConditionsConcatenationType="And" IsFork="false" MergeViaSetState="false" DisableParentStateControl="false">
      <Restrictions>
        <Restriction Type="Allow" NameRef="Director" />
      </Restrictions>
      <Triggers>
        <Trigger Type="Command" NameRef="Reject" />
      </Triggers>
      <Conditions>
        <Condition Type="Always" />
      </Conditions>
      <Designer X="948" Y="430" />
    </Transition>
    <Transition Name="PM Activity_User Edit Activity_1" To="User Edit Activity" From="PM Activity" Classifier="Reverse" AllowConcatenationType="And" RestrictConcatenationType="And" ConditionsConcatenationType="And" IsFork="false" MergeViaSetState="false" DisableParentStateControl="false">
      <Restrictions>
        <Restriction Type="Allow" NameRef="ProjectManager" />
      </Restrictions>
      <Triggers>
        <Trigger Type="Command" NameRef="Reject" />
      </Triggers>
      <Conditions>
        <Condition Type="Always" />
      </Conditions>
      <Designer X="528" Y="364" />
    </Transition>
    <Transition Name="User Edit Activity_PM Activity_1" To="PM Activity" From="User Edit Activity" Classifier="Direct" AllowConcatenationType="And" RestrictConcatenationType="And" ConditionsConcatenationType="And" IsFork="false" MergeViaSetState="false" DisableParentStateControl="false">
      <Restrictions>
        <Restriction Type="Allow" NameRef="User" />
      </Restrictions>
      <Triggers>
        <Trigger Type="Command" NameRef="Submit" />
      </Triggers>
      <Conditions>
        <Condition Type="Always" />
      </Conditions>
      <Designer X="600" Y="366" />
    </Transition>
    <Transition Name="User Edit Activity_Fail_1" To="Fail" From="User Edit Activity" Classifier="Direct" AllowConcatenationType="And" RestrictConcatenationType="And" ConditionsConcatenationType="And" IsFork="false" MergeViaSetState="false" DisableParentStateControl="false">
      <Triggers>
        <Trigger Type="Command" NameRef="Cancel" />
      </Triggers>
      <Conditions>
        <Condition Type="Always" />
      </Conditions>
      <Designer />
    </Transition>
  </Transitions>
  <CodeActions>
    <CodeAction Name="LogHistory" Type="Action" IsGlobal="False" IsAsync="False">
      <ActionCode><![CDATA[Console.WriteLine("Hello All");]]></ActionCode>
      <Usings><![CDATA[LinqToSqlShared.Mapping;System;OptimaJet.Workflow.Core.Model;WF.Sample.Business.Workflow;System.Data.Linq;System.Data.Linq.SqlClient;System.Data.Linq.Mapping;System.Collections;WF.Sample.Business.Helpers;OptimaJet.Workflow;System.Data.Linq.SqlClient.Implementation;System.Linq;WF.Sample.Business;System.Threading;System.Threading.Tasks;System.Data.Linq.Provider;System.Collections.Generic;WF.Sample.Business.Properties;]]></Usings>
    </CodeAction>
  </CodeActions>
</Process>', N'{}', N'r4ztHEDMTwYwDqoEyePFlg==', N'SimpleWF', 1, NULL, NULL, N'null', NULL)
INSERT [dbo].[WorkflowProcessScheme] ([Id], [Scheme], [DefiningParameters], [DefiningParametersHash], [SchemeCode], [IsObsolete], [RootSchemeCode], [RootSchemeId], [AllowedActivities], [StartingTransition]) VALUES (N'eeaf6209-017b-495b-a800-b50b66d43fa2', N'<Process>
  <Designer />
  <Actors>
    <Actor Name="User" Rule="CheckRole" Value="User" />
    <Actor Name="ProjectManager" Rule="CheckRole" Value="ProjectManager" />
    <Actor Name="Director" Rule="CheckRole" Value="Director" />
  </Actors>
  <Commands>
    <Command Name="Submit" />
    <Command Name="Reject" />
    <Command Name="Confirm" />
    <Command Name="Approve" />
    <Command Name="Cancel" />
  </Commands>
  <Activities>
    <Activity Name="User Request Activity" State="OT Request Created" IsInitial="True" IsFinal="False" IsForSetState="True" IsAutoSchemeUpdate="True">
      <Designer X="90" Y="180" />
    </Activity>
    <Activity Name="PM Activity" State="The PM Is Confirm of Reject" IsInitial="False" IsFinal="False" IsForSetState="True" IsAutoSchemeUpdate="True">
      <Designer X="470" Y="180" />
    </Activity>
    <Activity Name="Director Activity" State="The Director Will Approve or Reject" IsInitial="False" IsFinal="False" IsForSetState="True" IsAutoSchemeUpdate="True">
      <Designer X="840" Y="180" />
    </Activity>
    <Activity Name="Done" State="The OT Request Is Approved" IsInitial="False" IsFinal="True" IsForSetState="True" IsAutoSchemeUpdate="True">
      <Designer X="1260" Y="180" />
    </Activity>
    <Activity Name="User Edit Activity" State="User Is Editing The OT Request" IsInitial="False" IsFinal="False" IsForSetState="True" IsAutoSchemeUpdate="True">
      <Designer X="480" Y="490" />
    </Activity>
    <Activity Name="Fail" State="User Cancelled" IsInitial="False" IsFinal="True" IsForSetState="True" IsAutoSchemeUpdate="True">
      <Designer X="1300" Y="490" />
    </Activity>
  </Activities>
  <Transitions>
    <Transition Name="User Request Activity_PM Activity_1" To="PM Activity" From="User Request Activity" Classifier="Direct" AllowConcatenationType="And" RestrictConcatenationType="And" ConditionsConcatenationType="And" IsFork="false" MergeViaSetState="false" DisableParentStateControl="false">
      <Restrictions>
        <Restriction Type="Allow" NameRef="User" />
      </Restrictions>
      <Triggers>
        <Trigger Type="Command" NameRef="Submit" />
      </Triggers>
      <Conditions>
        <Condition Type="Always" />
      </Conditions>
      <Designer />
    </Transition>
    <Transition Name="PM Activity_Director Activity_1" To="Director Activity" From="PM Activity" Classifier="Direct" AllowConcatenationType="And" RestrictConcatenationType="And" ConditionsConcatenationType="And" IsFork="false" MergeViaSetState="false" DisableParentStateControl="false">
      <Restrictions>
        <Restriction Type="Allow" NameRef="ProjectManager" />
      </Restrictions>
      <Triggers>
        <Trigger Type="Command" NameRef="Confirm" />
      </Triggers>
      <Conditions>
        <Condition Type="Always" />
      </Conditions>
      <Designer />
    </Transition>
    <Transition Name="Director Activity_Done_1" To="Done" From="Director Activity" Classifier="Direct" AllowConcatenationType="And" RestrictConcatenationType="And" ConditionsConcatenationType="And" IsFork="false" MergeViaSetState="false" DisableParentStateControl="false">
      <Restrictions>
        <Restriction Type="Allow" NameRef="Director" />
      </Restrictions>
      <Triggers>
        <Trigger Type="Command" NameRef="Approve" />
      </Triggers>
      <Conditions>
        <Condition Type="Always" />
      </Conditions>
      <Designer />
    </Transition>
    <Transition Name="Director Activity_User Edit Activity_1" To="User Edit Activity" From="Director Activity" Classifier="Reverse" AllowConcatenationType="And" RestrictConcatenationType="And" ConditionsConcatenationType="And" IsFork="false" MergeViaSetState="false" DisableParentStateControl="false">
      <Restrictions>
        <Restriction Type="Allow" NameRef="Director" />
      </Restrictions>
      <Triggers>
        <Trigger Type="Command" NameRef="Reject" />
      </Triggers>
      <Conditions>
        <Condition Type="Always" />
      </Conditions>
      <Designer X="948" Y="430" />
    </Transition>
    <Transition Name="PM Activity_User Edit Activity_1" To="User Edit Activity" From="PM Activity" Classifier="Reverse" AllowConcatenationType="And" RestrictConcatenationType="And" ConditionsConcatenationType="And" IsFork="false" MergeViaSetState="false" DisableParentStateControl="false">
      <Restrictions>
        <Restriction Type="Allow" NameRef="ProjectManager" />
      </Restrictions>
      <Triggers>
        <Trigger Type="Command" NameRef="Reject" />
      </Triggers>
      <Conditions>
        <Condition Type="Always" />
      </Conditions>
      <Designer X="528" Y="364" />
    </Transition>
    <Transition Name="User Edit Activity_PM Activity_1" To="PM Activity" From="User Edit Activity" Classifier="Direct" AllowConcatenationType="And" RestrictConcatenationType="And" ConditionsConcatenationType="And" IsFork="false" MergeViaSetState="false" DisableParentStateControl="false">
      <Restrictions>
        <Restriction Type="Allow" NameRef="User" />
      </Restrictions>
      <Triggers>
        <Trigger Type="Command" NameRef="Submit" />
      </Triggers>
      <Conditions>
        <Condition Type="Always" />
      </Conditions>
      <Designer X="600" Y="366" />
    </Transition>
    <Transition Name="User Edit Activity_Fail_1" To="Fail" From="User Edit Activity" Classifier="Direct" AllowConcatenationType="And" RestrictConcatenationType="And" ConditionsConcatenationType="And" IsFork="false" MergeViaSetState="false" DisableParentStateControl="false">
      <Triggers>
        <Trigger Type="Command" NameRef="Cancel" />
      </Triggers>
      <Conditions>
        <Condition Type="Always" />
      </Conditions>
      <Designer />
    </Transition>
  </Transitions>
</Process>', N'{}', N'r4ztHEDMTwYwDqoEyePFlg==', N'SimpleWF', 1, NULL, NULL, N'null', NULL)
INSERT [dbo].[WorkflowProcessScheme] ([Id], [Scheme], [DefiningParameters], [DefiningParametersHash], [SchemeCode], [IsObsolete], [RootSchemeCode], [RootSchemeId], [AllowedActivities], [StartingTransition]) VALUES (N'ef7790ea-1d8d-4b3a-8921-d3edafd4aaa3', N'<Process>
  <Designer />
  <Actors>
    <Actor Name="User" Rule="CheckRole" Value="User" />
    <Actor Name="ProjectManager" Rule="CheckRole" Value="ProjectManager" />
    <Actor Name="Director" Rule="CheckRole" Value="Director" />
  </Actors>
  <Commands>
    <Command Name="Submit" />
    <Command Name="Reject" />
    <Command Name="Confirm" />
    <Command Name="Approve" />
    <Command Name="Cancel" />
  </Commands>
  <Activities>
    <Activity Name="User Request Activity" State="OT Request Created" IsInitial="True" IsFinal="False" IsForSetState="True" IsAutoSchemeUpdate="True">
      <Designer X="90" Y="180" />
    </Activity>
    <Activity Name="PM Activity" State="The PM Is Confirm of Reject" IsInitial="False" IsFinal="False" IsForSetState="True" IsAutoSchemeUpdate="True">
      <Designer X="470" Y="180" />
    </Activity>
    <Activity Name="Director Activity" State="The Director Will Approve or Reject" IsInitial="False" IsFinal="False" IsForSetState="True" IsAutoSchemeUpdate="True">
      <Designer X="840" Y="180" />
    </Activity>
    <Activity Name="Done" State="The OT Request Is Approved" IsInitial="False" IsFinal="True" IsForSetState="True" IsAutoSchemeUpdate="True">
      <Designer X="1320" Y="190" />
    </Activity>
    <Activity Name="User Edit Activity" State="User Must Edit The Item" IsInitial="False" IsFinal="False" IsForSetState="True" IsAutoSchemeUpdate="True">
      <Designer X="480" Y="490" />
    </Activity>
    <Activity Name="Fail" State="User Cancelled" IsInitial="False" IsFinal="True" IsForSetState="True" IsAutoSchemeUpdate="True">
      <Designer X="1300" Y="490" />
    </Activity>
  </Activities>
  <Transitions>
    <Transition Name="User Request Activity_PM Activity_1" To="PM Activity" From="User Request Activity" Classifier="Direct" AllowConcatenationType="And" RestrictConcatenationType="And" ConditionsConcatenationType="And" IsFork="false" MergeViaSetState="false" DisableParentStateControl="false">
      <Restrictions>
        <Restriction Type="Allow" NameRef="User" />
      </Restrictions>
      <Triggers>
        <Trigger Type="Command" NameRef="Submit" />
      </Triggers>
      <Conditions>
        <Condition Type="Always" />
      </Conditions>
      <Designer />
    </Transition>
    <Transition Name="PM Activity_Director Activity_1" To="Director Activity" From="PM Activity" Classifier="Direct" AllowConcatenationType="And" RestrictConcatenationType="And" ConditionsConcatenationType="And" IsFork="false" MergeViaSetState="false" DisableParentStateControl="false">
      <Restrictions>
        <Restriction Type="Allow" NameRef="ProjectManager" />
      </Restrictions>
      <Triggers>
        <Trigger Type="Command" NameRef="Confirm" />
      </Triggers>
      <Conditions>
        <Condition Type="Always" />
      </Conditions>
      <Designer />
    </Transition>
    <Transition Name="Director Activity_Done_1" To="Done" From="Director Activity" Classifier="Direct" AllowConcatenationType="And" RestrictConcatenationType="And" ConditionsConcatenationType="And" IsFork="false" MergeViaSetState="false" DisableParentStateControl="false">
      <Restrictions>
        <Restriction Type="Allow" NameRef="Director" />
      </Restrictions>
      <Triggers>
        <Trigger Type="Command" NameRef="Approve" />
      </Triggers>
      <Conditions>
        <Condition Type="Always" />
      </Conditions>
      <Designer />
    </Transition>
    <Transition Name="Director Activity_User Edit Activity_1" To="User Edit Activity" From="Director Activity" Classifier="Reverse" AllowConcatenationType="And" RestrictConcatenationType="And" ConditionsConcatenationType="And" IsFork="false" MergeViaSetState="false" DisableParentStateControl="false">
      <Restrictions>
        <Restriction Type="Allow" NameRef="Director" />
      </Restrictions>
      <Triggers>
        <Trigger Type="Command" NameRef="Reject" />
      </Triggers>
      <Conditions>
        <Condition Type="Always" />
      </Conditions>
      <Designer X="948" Y="430" />
    </Transition>
    <Transition Name="PM Activity_User Edit Activity_1" To="User Edit Activity" From="PM Activity" Classifier="Reverse" AllowConcatenationType="And" RestrictConcatenationType="And" ConditionsConcatenationType="And" IsFork="false" MergeViaSetState="false" DisableParentStateControl="false">
      <Restrictions>
        <Restriction Type="Allow" NameRef="ProjectManager" />
      </Restrictions>
      <Triggers>
        <Trigger Type="Command" NameRef="Reject" />
      </Triggers>
      <Conditions>
        <Condition Type="Always" />
      </Conditions>
      <Designer X="528" Y="364" />
    </Transition>
    <Transition Name="User Edit Activity_PM Activity_1" To="PM Activity" From="User Edit Activity" Classifier="Direct" AllowConcatenationType="And" RestrictConcatenationType="And" ConditionsConcatenationType="And" IsFork="false" MergeViaSetState="false" DisableParentStateControl="false">
      <Restrictions>
        <Restriction Type="Allow" NameRef="User" />
      </Restrictions>
      <Triggers>
        <Trigger Type="Command" NameRef="Submit" />
      </Triggers>
      <Conditions>
        <Condition Type="Always" />
      </Conditions>
      <Designer X="600" Y="366" />
    </Transition>
    <Transition Name="User Edit Activity_Fail_1" To="Fail" From="User Edit Activity" Classifier="Direct" AllowConcatenationType="And" RestrictConcatenationType="And" ConditionsConcatenationType="And" IsFork="false" MergeViaSetState="false" DisableParentStateControl="false">
      <Restrictions>
        <Restriction Type="Allow" NameRef="User" />
      </Restrictions>
      <Triggers>
        <Trigger Type="Command" NameRef="Cancel" />
      </Triggers>
      <Conditions>
        <Condition Type="Always" />
      </Conditions>
      <Designer />
    </Transition>
  </Transitions>
</Process>', N'{}', N'r4ztHEDMTwYwDqoEyePFlg==', N'SimpleWF', 1, NULL, NULL, N'null', NULL)
INSERT [dbo].[WorkflowProcessScheme] ([Id], [Scheme], [DefiningParameters], [DefiningParametersHash], [SchemeCode], [IsObsolete], [RootSchemeCode], [RootSchemeId], [AllowedActivities], [StartingTransition]) VALUES (N'd339bf66-c6f2-4f11-8f2f-e0cc4d7bc870', N'<Process>
  <Designer />
  <Actors>
    <Actor Name="User" Rule="CheckRole" Value="User" />
    <Actor Name="ProjectManager" Rule="CheckRole" Value="ProjectManager" />
    <Actor Name="Director" Rule="CheckRole" Value="Director" />
  </Actors>
  <Commands>
    <Command Name="Submit" />
    <Command Name="Reject" />
    <Command Name="Confirm" />
    <Command Name="Approve" />
    <Command Name="Cancel" />
  </Commands>
  <Activities>
    <Activity Name="User Request Activity" State="OT Request Created" IsInitial="True" IsFinal="False" IsForSetState="True" IsAutoSchemeUpdate="True">
      <Implementation>
        <ActionRef Order="1" NameRef="LogHistory">
          <ActionParameter><![CDATA[TESTSSSSS]]></ActionParameter>
        </ActionRef>
      </Implementation>
      <Designer X="120" Y="180" />
    </Activity>
    <Activity Name="PM Activity" State="The PM Is Confirm of Reject" IsInitial="False" IsFinal="False" IsForSetState="True" IsAutoSchemeUpdate="True">
      <Implementation>
        <ActionRef Order="1" NameRef="LogHistory" />
      </Implementation>
      <Designer X="470" Y="180" />
    </Activity>
    <Activity Name="Director Activity" State="The Director Will Approve or Reject" IsInitial="False" IsFinal="False" IsForSetState="True" IsAutoSchemeUpdate="True">
      <Designer X="840" Y="180" />
    </Activity>
    <Activity Name="Done" State="The OT Request Is Approved" IsInitial="False" IsFinal="True" IsForSetState="True" IsAutoSchemeUpdate="True">
      <Designer X="1260" Y="180" />
    </Activity>
    <Activity Name="User Edit Activity" State="User Is Editing The OT Request" IsInitial="False" IsFinal="False" IsForSetState="True" IsAutoSchemeUpdate="True">
      <Designer X="480" Y="490" />
    </Activity>
    <Activity Name="Fail" IsInitial="False" IsFinal="True" IsForSetState="True" IsAutoSchemeUpdate="True">
      <Designer X="1280" Y="500" />
    </Activity>
  </Activities>
  <Transitions>
    <Transition Name="User Request Activity_PM Activity_1" To="PM Activity" From="User Request Activity" Classifier="Direct" AllowConcatenationType="And" RestrictConcatenationType="And" ConditionsConcatenationType="And" IsFork="false" MergeViaSetState="false" DisableParentStateControl="false">
      <Restrictions>
        <Restriction Type="Allow" NameRef="User" />
      </Restrictions>
      <Triggers>
        <Trigger Type="Command" NameRef="Submit" />
      </Triggers>
      <Conditions>
        <Condition Type="Always" />
      </Conditions>
      <Designer X="395" Y="213" />
    </Transition>
    <Transition Name="PM Activity_Director Activity_1" To="Director Activity" From="PM Activity" Classifier="Direct" AllowConcatenationType="And" RestrictConcatenationType="And" ConditionsConcatenationType="And" IsFork="false" MergeViaSetState="false" DisableParentStateControl="false">
      <Restrictions>
        <Restriction Type="Allow" NameRef="ProjectManager" />
      </Restrictions>
      <Triggers>
        <Trigger Type="Command" NameRef="Confirm" />
      </Triggers>
      <Conditions>
        <Condition Type="Always" />
      </Conditions>
      <Designer />
    </Transition>
    <Transition Name="Director Activity_Done_1" To="Done" From="Director Activity" Classifier="Direct" AllowConcatenationType="And" RestrictConcatenationType="And" ConditionsConcatenationType="And" IsFork="false" MergeViaSetState="false" DisableParentStateControl="false">
      <Restrictions>
        <Restriction Type="Allow" NameRef="Director" />
      </Restrictions>
      <Triggers>
        <Trigger Type="Command" NameRef="Approve" />
      </Triggers>
      <Conditions>
        <Condition Type="Always" />
      </Conditions>
      <Designer />
    </Transition>
    <Transition Name="Director Activity_User Edit Activity_1" To="User Edit Activity" From="Director Activity" Classifier="Reverse" AllowConcatenationType="And" RestrictConcatenationType="And" ConditionsConcatenationType="And" IsFork="false" MergeViaSetState="false" DisableParentStateControl="false">
      <Restrictions>
        <Restriction Type="Allow" NameRef="Director" />
      </Restrictions>
      <Triggers>
        <Trigger Type="Command" NameRef="Reject" />
      </Triggers>
      <Conditions>
        <Condition Type="Always" />
      </Conditions>
      <Designer X="948" Y="430" />
    </Transition>
    <Transition Name="PM Activity_User Edit Activity_1" To="User Edit Activity" From="PM Activity" Classifier="Reverse" AllowConcatenationType="And" RestrictConcatenationType="And" ConditionsConcatenationType="And" IsFork="false" MergeViaSetState="false" DisableParentStateControl="false">
      <Restrictions>
        <Restriction Type="Allow" NameRef="ProjectManager" />
      </Restrictions>
      <Triggers>
        <Trigger Type="Command" NameRef="Reject" />
      </Triggers>
      <Conditions>
        <Condition Type="Always" />
      </Conditions>
      <Designer X="528" Y="364" />
    </Transition>
    <Transition Name="User Edit Activity_PM Activity_1" To="PM Activity" From="User Edit Activity" Classifier="Direct" AllowConcatenationType="And" RestrictConcatenationType="And" ConditionsConcatenationType="And" IsFork="false" MergeViaSetState="false" DisableParentStateControl="false">
      <Restrictions>
        <Restriction Type="Allow" NameRef="User" />
      </Restrictions>
      <Triggers>
        <Trigger Type="Command" NameRef="Submit" />
      </Triggers>
      <Conditions>
        <Condition Type="Always" />
      </Conditions>
      <Designer X="600" Y="366" />
    </Transition>
    <Transition Name="User Edit Activity_Fail_1" To="Fail" From="User Edit Activity" Classifier="Direct" AllowConcatenationType="And" RestrictConcatenationType="And" ConditionsConcatenationType="And" IsFork="false" MergeViaSetState="false" DisableParentStateControl="false">
      <Triggers>
        <Trigger Type="Command" NameRef="Cancel" />
      </Triggers>
      <Conditions>
        <Condition Type="Always" />
      </Conditions>
      <Designer />
    </Transition>
  </Transitions>
  <CodeActions>
    <CodeAction Name="LogHistory" Type="Action" IsGlobal="False" IsAsync="True">
      <ActionCode><![CDATA[await "http://localhost:62001/api/demo/test".PostJsonAsync(new { parameter = parameter });]]></ActionCode>
      <Usings><![CDATA[LinqToSqlShared.Mapping;System;OptimaJet.Workflow.Core.Model;System.Data.Linq;System.Data.Linq.SqlClient;System.Data.Linq.Mapping;System.Collections;OptimaJet.Workflow;System.Data.Linq.SqlClient.Implementation;System.Linq;System.Threading;System.Threading.Tasks;System.Data.Linq.Provider;System.Collections.Generic;Flurl.Http;]]></Usings>
    </CodeAction>
  </CodeActions>
</Process>', N'{}', N'r4ztHEDMTwYwDqoEyePFlg==', N'SimpleWF', 1, NULL, NULL, N'null', NULL)
INSERT [dbo].[WorkflowProcessScheme] ([Id], [Scheme], [DefiningParameters], [DefiningParametersHash], [SchemeCode], [IsObsolete], [RootSchemeCode], [RootSchemeId], [AllowedActivities], [StartingTransition]) VALUES (N'9ea0c8f2-a6e1-44da-af81-e12ef7b3d5b0', N'<Process>
  <Designer />
  <Actors>
    <Actor Name="User" Rule="CheckRole" Value="User" />
    <Actor Name="ProjectManager" Rule="CheckRole" Value="ProjectManager" />
    <Actor Name="Director" Rule="CheckRole" Value="Director" />
  </Actors>
  <Commands>
    <Command Name="Submit" />
    <Command Name="Reject" />
    <Command Name="Confirm" />
    <Command Name="Approve" />
    <Command Name="Cancel" />
  </Commands>
  <Activities>
    <Activity Name="User Request Activity" State="OT Request Created" IsInitial="True" IsFinal="False" IsForSetState="True" IsAutoSchemeUpdate="True">
      <Designer X="120" Y="180" />
    </Activity>
    <Activity Name="PM Activity" State="The PM Is Confirm of Reject" IsInitial="False" IsFinal="False" IsForSetState="True" IsAutoSchemeUpdate="True">
      <Designer X="470" Y="180" />
    </Activity>
    <Activity Name="Director Activity" State="The Director Will Approve or Reject" IsInitial="False" IsFinal="False" IsForSetState="True" IsAutoSchemeUpdate="True">
      <Designer X="840" Y="180" />
    </Activity>
    <Activity Name="Done" State="The OT Request Is Approved" IsInitial="False" IsFinal="True" IsForSetState="True" IsAutoSchemeUpdate="True">
      <Designer X="1260" Y="180" />
    </Activity>
    <Activity Name="User Edit Activity" State="User Is Editing The OT Request" IsInitial="False" IsFinal="False" IsForSetState="True" IsAutoSchemeUpdate="True">
      <Designer X="480" Y="490" />
    </Activity>
    <Activity Name="Fail" IsInitial="False" IsFinal="True" IsForSetState="True" IsAutoSchemeUpdate="True">
      <Designer X="1280" Y="500" />
    </Activity>
  </Activities>
  <Transitions>
    <Transition Name="User Request Activity_PM Activity_1" To="PM Activity" From="User Request Activity" Classifier="Direct" AllowConcatenationType="And" RestrictConcatenationType="And" ConditionsConcatenationType="And" IsFork="false" MergeViaSetState="false" DisableParentStateControl="false">
      <Restrictions>
        <Restriction Type="Allow" NameRef="User" />
      </Restrictions>
      <Triggers>
        <Trigger Type="Command" NameRef="Submit" />
      </Triggers>
      <Conditions>
        <Condition Type="Always" />
      </Conditions>
      <Designer X="395" Y="213" />
    </Transition>
    <Transition Name="PM Activity_Director Activity_1" To="Director Activity" From="PM Activity" Classifier="Direct" AllowConcatenationType="And" RestrictConcatenationType="And" ConditionsConcatenationType="And" IsFork="false" MergeViaSetState="false" DisableParentStateControl="false">
      <Restrictions>
        <Restriction Type="Allow" NameRef="ProjectManager" />
      </Restrictions>
      <Triggers>
        <Trigger Type="Command" NameRef="Confirm" />
      </Triggers>
      <Conditions>
        <Condition Type="Always" />
      </Conditions>
      <Designer />
    </Transition>
    <Transition Name="Director Activity_Done_1" To="Done" From="Director Activity" Classifier="Direct" AllowConcatenationType="And" RestrictConcatenationType="And" ConditionsConcatenationType="And" IsFork="false" MergeViaSetState="false" DisableParentStateControl="false">
      <Restrictions>
        <Restriction Type="Allow" NameRef="Director" />
      </Restrictions>
      <Triggers>
        <Trigger Type="Command" NameRef="Approve" />
      </Triggers>
      <Conditions>
        <Condition Type="Always" />
      </Conditions>
      <Designer />
    </Transition>
    <Transition Name="Director Activity_User Edit Activity_1" To="User Edit Activity" From="Director Activity" Classifier="Reverse" AllowConcatenationType="And" RestrictConcatenationType="And" ConditionsConcatenationType="And" IsFork="false" MergeViaSetState="false" DisableParentStateControl="false">
      <Restrictions>
        <Restriction Type="Allow" NameRef="Director" />
      </Restrictions>
      <Triggers>
        <Trigger Type="Command" NameRef="Reject" />
      </Triggers>
      <Conditions>
        <Condition Type="Always" />
      </Conditions>
      <Designer X="948" Y="430" />
    </Transition>
    <Transition Name="PM Activity_User Edit Activity_1" To="User Edit Activity" From="PM Activity" Classifier="Reverse" AllowConcatenationType="And" RestrictConcatenationType="And" ConditionsConcatenationType="And" IsFork="false" MergeViaSetState="false" DisableParentStateControl="false">
      <Restrictions>
        <Restriction Type="Allow" NameRef="ProjectManager" />
      </Restrictions>
      <Triggers>
        <Trigger Type="Command" NameRef="Reject" />
      </Triggers>
      <Conditions>
        <Condition Type="Always" />
      </Conditions>
      <Designer X="528" Y="364" />
    </Transition>
    <Transition Name="User Edit Activity_PM Activity_1" To="PM Activity" From="User Edit Activity" Classifier="Direct" AllowConcatenationType="And" RestrictConcatenationType="And" ConditionsConcatenationType="And" IsFork="false" MergeViaSetState="false" DisableParentStateControl="false">
      <Restrictions>
        <Restriction Type="Allow" NameRef="User" />
      </Restrictions>
      <Triggers>
        <Trigger Type="Command" NameRef="Submit" />
      </Triggers>
      <Conditions>
        <Condition Type="Always" />
      </Conditions>
      <Designer X="600" Y="366" />
    </Transition>
    <Transition Name="User Edit Activity_Fail_1" To="Fail" From="User Edit Activity" Classifier="Direct" AllowConcatenationType="And" RestrictConcatenationType="And" ConditionsConcatenationType="And" IsFork="false" MergeViaSetState="false" DisableParentStateControl="false">
      <Triggers>
        <Trigger Type="Command" NameRef="Cancel" />
      </Triggers>
      <Conditions>
        <Condition Type="Always" />
      </Conditions>
      <Designer />
    </Transition>
  </Transitions>
</Process>', N'{}', N'r4ztHEDMTwYwDqoEyePFlg==', N'SimpleWF', 1, NULL, NULL, N'null', NULL)
INSERT [dbo].[WorkflowProcessScheme] ([Id], [Scheme], [DefiningParameters], [DefiningParametersHash], [SchemeCode], [IsObsolete], [RootSchemeCode], [RootSchemeId], [AllowedActivities], [StartingTransition]) VALUES (N'35faf432-a7e0-4b1d-9681-e143df742abe', N'<Process>
  <Designer />
  <Actors>
    <Actor Name="User" Rule="CheckRole" Value="User" />
    <Actor Name="ProjectManager" Rule="CheckRole" Value="ProjectManager" />
    <Actor Name="Director" Rule="CheckRole" Value="Director" />
  </Actors>
  <Commands>
    <Command Name="Submit" />
    <Command Name="Reject" />
    <Command Name="Confirm" />
    <Command Name="Approve" />
    <Command Name="Cancel" />
  </Commands>
  <Activities>
    <Activity Name="User Request Activity" State="OT Request Created" IsInitial="True" IsFinal="False" IsForSetState="True" IsAutoSchemeUpdate="True">
      <Designer X="120" Y="180" />
    </Activity>
    <Activity Name="PM Activity" State="The PM Is Confirm of Reject" IsInitial="False" IsFinal="False" IsForSetState="True" IsAutoSchemeUpdate="True">
      <Designer X="470" Y="180" />
    </Activity>
    <Activity Name="Director Activity" State="The Director Will Approve or Reject" IsInitial="False" IsFinal="False" IsForSetState="True" IsAutoSchemeUpdate="True">
      <Designer X="840" Y="180" />
    </Activity>
    <Activity Name="Done" State="The OT Request Is Approved" IsInitial="False" IsFinal="True" IsForSetState="True" IsAutoSchemeUpdate="True">
      <Designer X="1260" Y="180" />
    </Activity>
    <Activity Name="User Edit Activity" State="User Is Editing The OT Request" IsInitial="False" IsFinal="False" IsForSetState="True" IsAutoSchemeUpdate="True">
      <Designer X="480" Y="490" />
    </Activity>
    <Activity Name="Fail" IsInitial="False" IsFinal="True" IsForSetState="True" IsAutoSchemeUpdate="True">
      <Designer X="1280" Y="500" />
    </Activity>
  </Activities>
  <Transitions>
    <Transition Name="User Request Activity_PM Activity_1" To="PM Activity" From="User Request Activity" Classifier="Direct" AllowConcatenationType="And" RestrictConcatenationType="And" ConditionsConcatenationType="And" IsFork="false" MergeViaSetState="false" DisableParentStateControl="false">
      <Restrictions>
        <Restriction Type="Allow" NameRef="User" />
      </Restrictions>
      <Triggers>
        <Trigger Type="Command" NameRef="Submit" />
      </Triggers>
      <Conditions>
        <Condition Type="Always" />
      </Conditions>
      <Designer X="395" Y="213" />
    </Transition>
    <Transition Name="PM Activity_Director Activity_1" To="Director Activity" From="PM Activity" Classifier="Direct" AllowConcatenationType="And" RestrictConcatenationType="And" ConditionsConcatenationType="And" IsFork="false" MergeViaSetState="false" DisableParentStateControl="false">
      <Restrictions>
        <Restriction Type="Allow" NameRef="ProjectManager" />
      </Restrictions>
      <Triggers>
        <Trigger Type="Command" NameRef="Confirm" />
      </Triggers>
      <Conditions>
        <Condition Type="Always" />
      </Conditions>
      <Designer />
    </Transition>
    <Transition Name="Director Activity_Done_1" To="Done" From="Director Activity" Classifier="Direct" AllowConcatenationType="And" RestrictConcatenationType="And" ConditionsConcatenationType="And" IsFork="false" MergeViaSetState="false" DisableParentStateControl="false">
      <Restrictions>
        <Restriction Type="Allow" NameRef="Director" />
      </Restrictions>
      <Triggers>
        <Trigger Type="Command" NameRef="Approve" />
      </Triggers>
      <Conditions>
        <Condition Type="Always" />
      </Conditions>
      <Designer />
    </Transition>
    <Transition Name="Director Activity_User Edit Activity_1" To="User Edit Activity" From="Director Activity" Classifier="Reverse" AllowConcatenationType="And" RestrictConcatenationType="And" ConditionsConcatenationType="And" IsFork="false" MergeViaSetState="false" DisableParentStateControl="false">
      <Restrictions>
        <Restriction Type="Allow" NameRef="Director" />
      </Restrictions>
      <Triggers>
        <Trigger Type="Command" NameRef="Reject" />
      </Triggers>
      <Conditions>
        <Condition Type="Always" />
      </Conditions>
      <Designer X="948" Y="430" />
    </Transition>
    <Transition Name="PM Activity_User Edit Activity_1" To="User Edit Activity" From="PM Activity" Classifier="Reverse" AllowConcatenationType="And" RestrictConcatenationType="And" ConditionsConcatenationType="And" IsFork="false" MergeViaSetState="false" DisableParentStateControl="false">
      <Restrictions>
        <Restriction Type="Allow" NameRef="ProjectManager" />
      </Restrictions>
      <Triggers>
        <Trigger Type="Command" NameRef="Reject" />
      </Triggers>
      <Conditions>
        <Condition Type="Always" />
      </Conditions>
      <Designer X="528" Y="364" />
    </Transition>
    <Transition Name="User Edit Activity_PM Activity_1" To="PM Activity" From="User Edit Activity" Classifier="Direct" AllowConcatenationType="And" RestrictConcatenationType="And" ConditionsConcatenationType="And" IsFork="false" MergeViaSetState="false" DisableParentStateControl="false">
      <Restrictions>
        <Restriction Type="Allow" NameRef="User" />
      </Restrictions>
      <Triggers>
        <Trigger Type="Command" NameRef="Submit" />
      </Triggers>
      <Conditions>
        <Condition Type="Always" />
      </Conditions>
      <Designer X="600" Y="366" />
    </Transition>
    <Transition Name="User Edit Activity_Fail_1" To="Fail" From="User Edit Activity" Classifier="Direct" AllowConcatenationType="And" RestrictConcatenationType="And" ConditionsConcatenationType="And" IsFork="false" MergeViaSetState="false" DisableParentStateControl="false">
      <Triggers>
        <Trigger Type="Command" NameRef="Cancel" />
      </Triggers>
      <Conditions>
        <Condition Type="Always" />
      </Conditions>
      <Designer />
    </Transition>
  </Transitions>
</Process>', N'{}', N'r4ztHEDMTwYwDqoEyePFlg==', N'SimpleWF', 1, NULL, NULL, N'null', NULL)
INSERT [dbo].[WorkflowProcessScheme] ([Id], [Scheme], [DefiningParameters], [DefiningParametersHash], [SchemeCode], [IsObsolete], [RootSchemeCode], [RootSchemeId], [AllowedActivities], [StartingTransition]) VALUES (N'946a25b9-65d2-467f-9e52-f1a83626f555', N'<Process>
  <Designer />
  <Actors>
    <Actor Name="User" Rule="CheckRole" Value="User" />
    <Actor Name="ProjectManager" Rule="CheckRole" Value="ProjectManager" />
    <Actor Name="Director" Rule="CheckRole" Value="Director" />
  </Actors>
  <Commands>
    <Command Name="Submit" />
    <Command Name="Reject" />
    <Command Name="Confirm" />
    <Command Name="Approve" />
    <Command Name="Cancel" />
  </Commands>
  <Activities>
    <Activity Name="User Request Activity" State="OT Request Created" IsInitial="True" IsFinal="False" IsForSetState="True" IsAutoSchemeUpdate="True">
      <Designer X="90" Y="180" />
    </Activity>
    <Activity Name="PM Activity" State="The PM Is Confirm of Reject" IsInitial="False" IsFinal="False" IsForSetState="True" IsAutoSchemeUpdate="True">
      <Designer X="470" Y="180" />
    </Activity>
    <Activity Name="Director Activity" State="The Director Will Approve or Reject" IsInitial="False" IsFinal="False" IsForSetState="True" IsAutoSchemeUpdate="True">
      <Designer X="840" Y="180" />
    </Activity>
    <Activity Name="Done" State="The OT Request Is Approved" IsInitial="False" IsFinal="True" IsForSetState="True" IsAutoSchemeUpdate="True">
      <Designer X="1260" Y="180" />
    </Activity>
    <Activity Name="User Edit Activity" State="User Is Editing The OT Request" IsInitial="False" IsFinal="False" IsForSetState="True" IsAutoSchemeUpdate="True">
      <Designer X="480" Y="490" />
    </Activity>
    <Activity Name="Fail" State="User Cancelled" IsInitial="False" IsFinal="True" IsForSetState="True" IsAutoSchemeUpdate="True">
      <Designer X="1300" Y="490" />
    </Activity>
  </Activities>
  <Transitions>
    <Transition Name="User Request Activity_PM Activity_1" To="PM Activity" From="User Request Activity" Classifier="Direct" AllowConcatenationType="And" RestrictConcatenationType="And" ConditionsConcatenationType="And" IsFork="false" MergeViaSetState="false" DisableParentStateControl="false">
      <Restrictions>
        <Restriction Type="Allow" NameRef="User" />
      </Restrictions>
      <Triggers>
        <Trigger Type="Command" NameRef="Submit" />
      </Triggers>
      <Conditions>
        <Condition Type="Always" />
      </Conditions>
      <Designer />
    </Transition>
    <Transition Name="PM Activity_Director Activity_1" To="Director Activity" From="PM Activity" Classifier="Direct" AllowConcatenationType="And" RestrictConcatenationType="And" ConditionsConcatenationType="And" IsFork="false" MergeViaSetState="false" DisableParentStateControl="false">
      <Restrictions>
        <Restriction Type="Allow" NameRef="ProjectManager" />
      </Restrictions>
      <Triggers>
        <Trigger Type="Command" NameRef="Confirm" />
      </Triggers>
      <Conditions>
        <Condition Type="Always" />
      </Conditions>
      <Designer />
    </Transition>
    <Transition Name="Director Activity_Done_1" To="Done" From="Director Activity" Classifier="Direct" AllowConcatenationType="And" RestrictConcatenationType="And" ConditionsConcatenationType="And" IsFork="false" MergeViaSetState="false" DisableParentStateControl="false">
      <Restrictions>
        <Restriction Type="Allow" NameRef="Director" />
      </Restrictions>
      <Triggers>
        <Trigger Type="Command" NameRef="Approve" />
      </Triggers>
      <Conditions>
        <Condition Type="Always" />
      </Conditions>
      <Designer />
    </Transition>
    <Transition Name="Director Activity_User Edit Activity_1" To="User Edit Activity" From="Director Activity" Classifier="Reverse" AllowConcatenationType="And" RestrictConcatenationType="And" ConditionsConcatenationType="And" IsFork="false" MergeViaSetState="false" DisableParentStateControl="false">
      <Restrictions>
        <Restriction Type="Allow" NameRef="Director" />
      </Restrictions>
      <Triggers>
        <Trigger Type="Command" NameRef="Reject" />
      </Triggers>
      <Conditions>
        <Condition Type="Always" />
      </Conditions>
      <Designer X="948" Y="430" />
    </Transition>
    <Transition Name="PM Activity_User Edit Activity_1" To="User Edit Activity" From="PM Activity" Classifier="Reverse" AllowConcatenationType="And" RestrictConcatenationType="And" ConditionsConcatenationType="And" IsFork="false" MergeViaSetState="false" DisableParentStateControl="false">
      <Restrictions>
        <Restriction Type="Allow" NameRef="ProjectManager" />
      </Restrictions>
      <Triggers>
        <Trigger Type="Command" NameRef="Reject" />
      </Triggers>
      <Conditions>
        <Condition Type="Always" />
      </Conditions>
      <Designer X="528" Y="364" />
    </Transition>
    <Transition Name="User Edit Activity_PM Activity_1" To="PM Activity" From="User Edit Activity" Classifier="Direct" AllowConcatenationType="And" RestrictConcatenationType="And" ConditionsConcatenationType="And" IsFork="false" MergeViaSetState="false" DisableParentStateControl="false">
      <Restrictions>
        <Restriction Type="Allow" NameRef="User" />
      </Restrictions>
      <Triggers>
        <Trigger Type="Command" NameRef="Submit" />
      </Triggers>
      <Conditions>
        <Condition Type="Always" />
      </Conditions>
      <Designer X="600" Y="366" />
    </Transition>
    <Transition Name="User Edit Activity_Fail_1" To="Fail" From="User Edit Activity" Classifier="Direct" AllowConcatenationType="And" RestrictConcatenationType="And" ConditionsConcatenationType="And" IsFork="false" MergeViaSetState="false" DisableParentStateControl="false">
      <Restrictions>
        <Restriction Type="Allow" NameRef="User" />
      </Restrictions>
      <Triggers>
        <Trigger Type="Command" NameRef="Cancel" />
      </Triggers>
      <Conditions>
        <Condition Type="Always" NameRef="" ConditionInversion="false" />
      </Conditions>
      <Designer />
    </Transition>
  </Transitions>
</Process>', N'{}', N'r4ztHEDMTwYwDqoEyePFlg==', N'SimpleWF', 1, NULL, NULL, N'null', NULL)
INSERT [dbo].[WorkflowProcessScheme] ([Id], [Scheme], [DefiningParameters], [DefiningParametersHash], [SchemeCode], [IsObsolete], [RootSchemeCode], [RootSchemeId], [AllowedActivities], [StartingTransition]) VALUES (N'e4e4faf8-3419-4a38-8376-fad7a861b04b', N'<Process>
  <Designer />
  <Actors>
    <Actor Name="User" Rule="CheckRole" Value="User" />
    <Actor Name="ProjectManager" Rule="CheckRole" Value="ProjectManager" />
    <Actor Name="Director" Rule="CheckRole" Value="Director" />
  </Actors>
  <Parameters>
    <Parameter Name="Number" Type="Int16" Purpose="Persistence" InitialValue="1" />
    <Parameter Name="Text" Type="String" Purpose="Persistence" />
  </Parameters>
  <Commands>
    <Command Name="Submit">
      <InputParameters>
        <ParameterRef Name="NumberOfOtDays" IsRequired="false" DefaultValue="" NameRef="Number" />
        <ParameterRef Name="ForOTUser" IsRequired="false" DefaultValue="" NameRef="Text" />
      </InputParameters>
    </Command>
    <Command Name="Reject" />
    <Command Name="Confirm" />
    <Command Name="Approve" />
    <Command Name="Cancel" />
  </Commands>
  <Activities>
    <Activity Name="User Request Activity" State="OT Request Created" IsInitial="True" IsFinal="False" IsForSetState="True" IsAutoSchemeUpdate="True">
      <Implementation>
        <ActionRef Order="1" NameRef="LogHistory">
          <ActionParameter><![CDATA[TESTSSSSS]]></ActionParameter>
        </ActionRef>
      </Implementation>
      <Designer X="120" Y="180" />
    </Activity>
    <Activity Name="PM Activity" State="The PM Is Confirm of Reject" IsInitial="False" IsFinal="False" IsForSetState="True" IsAutoSchemeUpdate="True">
      <Implementation>
        <ActionRef Order="1" NameRef="LogHistory" />
      </Implementation>
      <Designer X="470" Y="180" />
    </Activity>
    <Activity Name="Director Activity" State="The Director Will Approve or Reject" IsInitial="False" IsFinal="False" IsForSetState="True" IsAutoSchemeUpdate="True">
      <Designer X="840" Y="180" />
    </Activity>
    <Activity Name="Done" State="The OT Request Is Approved" IsInitial="False" IsFinal="True" IsForSetState="True" IsAutoSchemeUpdate="True">
      <Designer X="1260" Y="180" />
    </Activity>
    <Activity Name="User Edit Activity" State="User Is Editing The OT Request" IsInitial="False" IsFinal="False" IsForSetState="True" IsAutoSchemeUpdate="True">
      <Designer X="480" Y="490" />
    </Activity>
    <Activity Name="Fail" IsInitial="False" IsFinal="True" IsForSetState="True" IsAutoSchemeUpdate="True">
      <Designer X="1280" Y="500" />
    </Activity>
  </Activities>
  <Transitions>
    <Transition Name="User Request Activity_PM Activity_1" To="PM Activity" From="User Request Activity" Classifier="Direct" AllowConcatenationType="And" RestrictConcatenationType="And" ConditionsConcatenationType="And" IsFork="false" MergeViaSetState="false" DisableParentStateControl="false">
      <Restrictions>
        <Restriction Type="Allow" NameRef="User" />
      </Restrictions>
      <Triggers>
        <Trigger Type="Command" NameRef="Submit" />
      </Triggers>
      <Conditions>
        <Condition Type="Always" />
      </Conditions>
      <Designer X="395" Y="213" />
    </Transition>
    <Transition Name="PM Activity_Director Activity_1" To="Director Activity" From="PM Activity" Classifier="Direct" AllowConcatenationType="And" RestrictConcatenationType="And" ConditionsConcatenationType="And" IsFork="false" MergeViaSetState="false" DisableParentStateControl="false">
      <Restrictions>
        <Restriction Type="Allow" NameRef="ProjectManager" />
      </Restrictions>
      <Triggers>
        <Trigger Type="Command" NameRef="Confirm" />
      </Triggers>
      <Conditions>
        <Condition Type="Always" />
      </Conditions>
      <Designer />
    </Transition>
    <Transition Name="Director Activity_Done_1" To="Done" From="Director Activity" Classifier="Direct" AllowConcatenationType="And" RestrictConcatenationType="And" ConditionsConcatenationType="And" IsFork="false" MergeViaSetState="false" DisableParentStateControl="false">
      <Restrictions>
        <Restriction Type="Allow" NameRef="Director" />
      </Restrictions>
      <Triggers>
        <Trigger Type="Command" NameRef="Approve" />
      </Triggers>
      <Conditions>
        <Condition Type="Always" />
      </Conditions>
      <Designer />
    </Transition>
    <Transition Name="Director Activity_User Edit Activity_1" To="User Edit Activity" From="Director Activity" Classifier="Reverse" AllowConcatenationType="And" RestrictConcatenationType="And" ConditionsConcatenationType="And" IsFork="false" MergeViaSetState="false" DisableParentStateControl="false">
      <Restrictions>
        <Restriction Type="Allow" NameRef="Director" />
      </Restrictions>
      <Triggers>
        <Trigger Type="Command" NameRef="Reject" />
      </Triggers>
      <Conditions>
        <Condition Type="Always" />
      </Conditions>
      <Designer X="948" Y="430" />
    </Transition>
    <Transition Name="PM Activity_User Edit Activity_1" To="User Edit Activity" From="PM Activity" Classifier="Reverse" AllowConcatenationType="And" RestrictConcatenationType="And" ConditionsConcatenationType="And" IsFork="false" MergeViaSetState="false" DisableParentStateControl="false">
      <Restrictions>
        <Restriction Type="Allow" NameRef="ProjectManager" />
      </Restrictions>
      <Triggers>
        <Trigger Type="Command" NameRef="Reject" />
      </Triggers>
      <Conditions>
        <Condition Type="Always" />
      </Conditions>
      <Designer X="528" Y="364" />
    </Transition>
    <Transition Name="User Edit Activity_PM Activity_1" To="PM Activity" From="User Edit Activity" Classifier="Direct" AllowConcatenationType="And" RestrictConcatenationType="And" ConditionsConcatenationType="And" IsFork="false" MergeViaSetState="false" DisableParentStateControl="false">
      <Restrictions>
        <Restriction Type="Allow" NameRef="User" />
      </Restrictions>
      <Triggers>
        <Trigger Type="Command" NameRef="Submit" />
      </Triggers>
      <Conditions>
        <Condition Type="Always" />
      </Conditions>
      <Designer X="600" Y="366" />
    </Transition>
    <Transition Name="User Edit Activity_Fail_1" To="Fail" From="User Edit Activity" Classifier="Direct" AllowConcatenationType="And" RestrictConcatenationType="And" ConditionsConcatenationType="And" IsFork="false" MergeViaSetState="false" DisableParentStateControl="false">
      <Triggers>
        <Trigger Type="Command" NameRef="Cancel" />
      </Triggers>
      <Conditions>
        <Condition Type="Always" />
      </Conditions>
      <Designer />
    </Transition>
  </Transitions>
  <CodeActions>
    <CodeAction Name="LogHistory" Type="Action" IsGlobal="False" IsAsync="True">
      <ActionCode><![CDATA[await "http://localhost:62001/api/demo/test".PostJsonAsync(new { parameter = parameter });]]></ActionCode>
      <Usings><![CDATA[LinqToSqlShared.Mapping;System;OptimaJet.Workflow.Core.Model;WF.Sample.Business.Workflow;System.Data.Linq;System.Data.Linq.SqlClient;System.Data.Linq.Mapping;System.Collections;WF.Sample.Business.Helpers;OptimaJet.Workflow;System.Data.Linq.SqlClient.Implementation;System.Linq;WF.Sample.Business;System.Threading;System.Threading.Tasks;System.Data.Linq.Provider;System.Collections.Generic;WF.Sample.Business.Properties;Flurl.Http;]]></Usings>
    </CodeAction>
  </CodeActions>
</Process>', N'{}', N'r4ztHEDMTwYwDqoEyePFlg==', N'SimpleWF', 1, NULL, NULL, N'null', NULL)
INSERT [dbo].[WorkflowProcessTransitionHistory] ([Id], [ProcessId], [ExecutorIdentityId], [ActorIdentityId], [FromActivityName], [ToActivityName], [ToStateName], [TransitionTime], [TransitionClassifier], [IsFinalised], [FromStateName], [TriggerName]) VALUES (N'ca3f33ae-43e5-4bf6-a539-1820911a242c', N'6a8a8d22-194b-4e90-8c62-baff9332c218', N'UserB', N'UserB', N'PM Activity', N'Director Activity', N'The Director Will Approve or Reject', CAST(N'2018-06-12T13:41:27.657' AS DateTime), N'Direct', 0, N'The PM Is Confirm of Reject', N'Confirm')
INSERT [dbo].[WorkflowProcessTransitionHistory] ([Id], [ProcessId], [ExecutorIdentityId], [ActorIdentityId], [FromActivityName], [ToActivityName], [ToStateName], [TransitionTime], [TransitionClassifier], [IsFinalised], [FromStateName], [TriggerName]) VALUES (N'26e0983a-63b8-47c1-aa25-1d392ce65bb8', N'e1a57d16-0f3b-4b81-b669-c53ba231163a', N'UserB', N'UserB', N'PM Activity', N'User Edit Activity', N'User Must Edit The Item', CAST(N'2018-06-12T22:20:27.387' AS DateTime), N'Reverse', 0, N'The PM Is Confirm of Reject', N'Reject')
INSERT [dbo].[WorkflowProcessTransitionHistory] ([Id], [ProcessId], [ExecutorIdentityId], [ActorIdentityId], [FromActivityName], [ToActivityName], [ToStateName], [TransitionTime], [TransitionClassifier], [IsFinalised], [FromStateName], [TriggerName]) VALUES (N'ecbec23c-5a5b-466e-87c6-20a43e3e702d', N'6b36c36c-5b8b-4c0e-a819-015e3ad2704d', N'UserB', N'UserB', N'PM Activity', N'User Edit Activity', N'User Is Editing The OT Request', CAST(N'2018-06-12T10:12:33.453' AS DateTime), N'Reverse', 0, N'The PM Is Confirm of Reject', N'Reject')
INSERT [dbo].[WorkflowProcessTransitionHistory] ([Id], [ProcessId], [ExecutorIdentityId], [ActorIdentityId], [FromActivityName], [ToActivityName], [ToStateName], [TransitionTime], [TransitionClassifier], [IsFinalised], [FromStateName], [TriggerName]) VALUES (N'84effc60-2123-4f1c-bad4-23f96a6b70e0', N'c1bba69a-f927-4ccc-887c-2a60012f43d2', N'91f2b4714a964ab7a41aea4293703d16', N'91f2b4714a964ab7a41aea4293703d16', N'Director Activity', N'User Request Activity', N'OT Request Created', CAST(N'2018-06-11T16:36:18.863' AS DateTime), N'NotSpecified', 0, N'The Director Will Approve or Reject', N'SetState')
INSERT [dbo].[WorkflowProcessTransitionHistory] ([Id], [ProcessId], [ExecutorIdentityId], [ActorIdentityId], [FromActivityName], [ToActivityName], [ToStateName], [TransitionTime], [TransitionClassifier], [IsFinalised], [FromStateName], [TriggerName]) VALUES (N'f1202d75-9e5b-4e69-826f-28ca9bf24e9f', N'4f38b710-c718-411f-8d67-69ab874aed0c', N'UserB', N'UserB', N'PM Activity', N'User Edit Activity', N'User Is Editing The OT Request', CAST(N'2018-06-12T13:56:53.553' AS DateTime), N'Reverse', 0, N'The PM Is Confirm of Reject', N'Reject')
INSERT [dbo].[WorkflowProcessTransitionHistory] ([Id], [ProcessId], [ExecutorIdentityId], [ActorIdentityId], [FromActivityName], [ToActivityName], [ToStateName], [TransitionTime], [TransitionClassifier], [IsFinalised], [FromStateName], [TriggerName]) VALUES (N'b5497e56-2aa8-443f-9b3c-2a4060c86a8b', N'dc66822a-7678-43bd-af07-da1d4aee1c7e', N'usera', N'usera', N'User Request Activity', N'PM Activity', N'The PM Is Confirm of Reject', CAST(N'2018-06-12T10:21:58.993' AS DateTime), N'Direct', 0, N'OT Request Created', N'Submit')
INSERT [dbo].[WorkflowProcessTransitionHistory] ([Id], [ProcessId], [ExecutorIdentityId], [ActorIdentityId], [FromActivityName], [ToActivityName], [ToStateName], [TransitionTime], [TransitionClassifier], [IsFinalised], [FromStateName], [TriggerName]) VALUES (N'f684ee9e-44e3-4da5-b715-2f9d6a6064c8', N'6a8a8d22-194b-4e90-8c62-baff9332c218', N'usera', N'usera', N'User Request Activity', N'PM Activity', N'The PM Is Confirm of Reject', CAST(N'2018-06-12T10:16:29.173' AS DateTime), N'Direct', 0, N'OT Request Created', N'Submit')
INSERT [dbo].[WorkflowProcessTransitionHistory] ([Id], [ProcessId], [ExecutorIdentityId], [ActorIdentityId], [FromActivityName], [ToActivityName], [ToStateName], [TransitionTime], [TransitionClassifier], [IsFinalised], [FromStateName], [TriggerName]) VALUES (N'e1bd4881-0e5f-41c8-a10e-2fb0134f432a', N'6b36c36c-5b8b-4c0e-a819-015e3ad2704d', N'usera', N'usera', N'User Request Activity', N'PM Activity', N'The PM Is Confirm of Reject', CAST(N'2018-06-12T10:11:48.050' AS DateTime), N'Direct', 0, N'OT Request Created', N'Submit')
INSERT [dbo].[WorkflowProcessTransitionHistory] ([Id], [ProcessId], [ExecutorIdentityId], [ActorIdentityId], [FromActivityName], [ToActivityName], [ToStateName], [TransitionTime], [TransitionClassifier], [IsFinalised], [FromStateName], [TriggerName]) VALUES (N'd22a9e5c-3023-46a1-afb9-3b52361c3ae6', N'c6e46058-0695-4cd4-8758-4d54865df14c', N'usera', N'usera', N'User Request Activity', N'PM Activity', N'The PM Is Confirm of Reject', CAST(N'2018-06-12T14:17:29.033' AS DateTime), N'Direct', 0, N'OT Request Created', N'Submit')
INSERT [dbo].[WorkflowProcessTransitionHistory] ([Id], [ProcessId], [ExecutorIdentityId], [ActorIdentityId], [FromActivityName], [ToActivityName], [ToStateName], [TransitionTime], [TransitionClassifier], [IsFinalised], [FromStateName], [TriggerName]) VALUES (N'032af797-6f8b-42d2-821c-3da824cada2f', N'6929dca1-d9ad-457a-8aed-059a0fb59db7', N'UserA', N'UserA', N'User Edit Activity', N'Fail', N'User Cancelled', CAST(N'2018-06-12T22:21:07.977' AS DateTime), N'Direct', 1, N'User Must Edit The Item', N'Cancel')
INSERT [dbo].[WorkflowProcessTransitionHistory] ([Id], [ProcessId], [ExecutorIdentityId], [ActorIdentityId], [FromActivityName], [ToActivityName], [ToStateName], [TransitionTime], [TransitionClassifier], [IsFinalised], [FromStateName], [TriggerName]) VALUES (N'95c4b851-5797-464a-a5d0-400c8b442544', N'eed2b05e-285e-491c-bc43-81a9b609568f', N'e41b48e3-c03d-484f-8764-1711248c4f8a', N'e41b48e3-c03d-484f-8764-1711248c4f8a', N'User Request Activity', N'PM Activity', N'The PM Is Confirm of Reject', CAST(N'2018-06-11T17:17:30.183' AS DateTime), N'Direct', 0, N'OT Request Created', N'Submit')
INSERT [dbo].[WorkflowProcessTransitionHistory] ([Id], [ProcessId], [ExecutorIdentityId], [ActorIdentityId], [FromActivityName], [ToActivityName], [ToStateName], [TransitionTime], [TransitionClassifier], [IsFinalised], [FromStateName], [TriggerName]) VALUES (N'd1962fa3-8069-47eb-a02b-441bc0987451', N'07afe990-812e-4eaf-ab9f-8627fd5aec32', N'UserB', N'UserB', N'PM Activity', N'Director Activity', N'The Director Will Approve or Reject', CAST(N'2018-06-12T13:41:15.940' AS DateTime), N'Direct', 0, N'The PM Is Confirm of Reject', N'Confirm')
INSERT [dbo].[WorkflowProcessTransitionHistory] ([Id], [ProcessId], [ExecutorIdentityId], [ActorIdentityId], [FromActivityName], [ToActivityName], [ToStateName], [TransitionTime], [TransitionClassifier], [IsFinalised], [FromStateName], [TriggerName]) VALUES (N'aef86d00-cfa0-44d2-883f-4959fc985f27', N'97bf28e1-081c-4808-a5ee-6b00bd02adb6', N'UserB', N'UserB', N'PM Activity', N'Director Activity', N'The Director Will Approve or Reject', CAST(N'2018-06-12T13:23:41.537' AS DateTime), N'Direct', 0, N'The PM Is Confirm of Reject', N'Confirm')
INSERT [dbo].[WorkflowProcessTransitionHistory] ([Id], [ProcessId], [ExecutorIdentityId], [ActorIdentityId], [FromActivityName], [ToActivityName], [ToStateName], [TransitionTime], [TransitionClassifier], [IsFinalised], [FromStateName], [TriggerName]) VALUES (N'1952ca0c-3f05-4f4a-ba84-4b4ffbb5ea6b', N'403f8d17-fb54-4154-97c1-38819da3d25b', N'UserA', N'UserA', N'User Request Activity', N'PM Activity', N'The PM Is Confirm of Reject', CAST(N'2018-06-12T13:47:59.313' AS DateTime), N'Direct', 0, N'OT Request Created', N'Submit')
INSERT [dbo].[WorkflowProcessTransitionHistory] ([Id], [ProcessId], [ExecutorIdentityId], [ActorIdentityId], [FromActivityName], [ToActivityName], [ToStateName], [TransitionTime], [TransitionClassifier], [IsFinalised], [FromStateName], [TriggerName]) VALUES (N'5bc246e4-0115-4958-9cd5-5c78585bc71b', N'6a8a8d22-194b-4e90-8c62-baff9332c218', N'UserC', N'UserC', N'Director Activity', N'Done', N'The OT Request Is Approved', CAST(N'2018-06-12T13:42:43.150' AS DateTime), N'Direct', 1, N'The Director Will Approve or Reject', N'Approve')
INSERT [dbo].[WorkflowProcessTransitionHistory] ([Id], [ProcessId], [ExecutorIdentityId], [ActorIdentityId], [FromActivityName], [ToActivityName], [ToStateName], [TransitionTime], [TransitionClassifier], [IsFinalised], [FromStateName], [TriggerName]) VALUES (N'3eefc87e-19bf-4269-8735-5ddf920d27d0', N'e1a57d16-0f3b-4b81-b669-c53ba231163a', N'usera', N'usera', N'User Request Activity', N'PM Activity', N'The PM Is Confirm of Reject', CAST(N'2018-06-12T22:08:38.830' AS DateTime), N'Direct', 0, N'OT Request Created', N'Submit')
INSERT [dbo].[WorkflowProcessTransitionHistory] ([Id], [ProcessId], [ExecutorIdentityId], [ActorIdentityId], [FromActivityName], [ToActivityName], [ToStateName], [TransitionTime], [TransitionClassifier], [IsFinalised], [FromStateName], [TriggerName]) VALUES (N'12900714-6514-4c29-aca5-5e3c3f583b61', N'c1bba69a-f927-4ccc-887c-2a60012f43d2', N'91f2b4714a964ab7a41aea4293703d16', N'91f2b4714a964ab7a41aea4293703d16', N'PM Activity', N'Director Activity', N'The Director Will Approve or Reject', CAST(N'2018-06-11T16:36:15.897' AS DateTime), N'NotSpecified', 0, N'The PM Is Confirm of Reject', N'SetState')
INSERT [dbo].[WorkflowProcessTransitionHistory] ([Id], [ProcessId], [ExecutorIdentityId], [ActorIdentityId], [FromActivityName], [ToActivityName], [ToStateName], [TransitionTime], [TransitionClassifier], [IsFinalised], [FromStateName], [TriggerName]) VALUES (N'f3abc1da-d81a-4fa0-9512-5f6cd95ae522', N'07afe990-812e-4eaf-ab9f-8627fd5aec32', N'usera', N'usera', N'User Request Activity', N'PM Activity', N'The PM Is Confirm of Reject', CAST(N'2018-06-12T13:21:22.430' AS DateTime), N'Direct', 0, N'OT Request Created', N'Submit')
INSERT [dbo].[WorkflowProcessTransitionHistory] ([Id], [ProcessId], [ExecutorIdentityId], [ActorIdentityId], [FromActivityName], [ToActivityName], [ToStateName], [TransitionTime], [TransitionClassifier], [IsFinalised], [FromStateName], [TriggerName]) VALUES (N'7d787cbd-b1d0-471a-8310-64f026a19f03', N'e8a744b6-67da-4134-849c-ac3b1e737f29', N'UserB', N'UserB', N'PM Activity', N'User Edit Activity', N'User Is Editing The OT Request', CAST(N'2018-06-12T17:31:02.060' AS DateTime), N'Reverse', 0, N'The PM Is Confirm of Reject', N'Reject')
INSERT [dbo].[WorkflowProcessTransitionHistory] ([Id], [ProcessId], [ExecutorIdentityId], [ActorIdentityId], [FromActivityName], [ToActivityName], [ToStateName], [TransitionTime], [TransitionClassifier], [IsFinalised], [FromStateName], [TriggerName]) VALUES (N'916e3196-eda6-4152-b08d-6864bcc37d79', N'6b36c36c-5b8b-4c0e-a819-015e3ad2704d', N'usera', N'usera', N'User Edit Activity', N'Fail', NULL, CAST(N'2018-06-12T10:12:48.130' AS DateTime), N'Direct', 1, N'User Is Editing The OT Request', N'Cancel')
INSERT [dbo].[WorkflowProcessTransitionHistory] ([Id], [ProcessId], [ExecutorIdentityId], [ActorIdentityId], [FromActivityName], [ToActivityName], [ToStateName], [TransitionTime], [TransitionClassifier], [IsFinalised], [FromStateName], [TriggerName]) VALUES (N'102fa591-d3af-44c6-8af2-6c011ded4757', N'dc66822a-7678-43bd-af07-da1d4aee1c7e', N'UserB', N'UserB', N'PM Activity', N'Director Activity', N'The Director Will Approve or Reject', CAST(N'2018-06-12T10:27:49.297' AS DateTime), N'Direct', 0, N'The PM Is Confirm of Reject', N'Confirm')
INSERT [dbo].[WorkflowProcessTransitionHistory] ([Id], [ProcessId], [ExecutorIdentityId], [ActorIdentityId], [FromActivityName], [ToActivityName], [ToStateName], [TransitionTime], [TransitionClassifier], [IsFinalised], [FromStateName], [TriggerName]) VALUES (N'd5c5cb4f-7793-42d1-a7ba-6d86001c7593', N'c1bba69a-f927-4ccc-887c-2a60012f43d2', N'e41b48e3c03d484f87641711248c4f8a', N'e41b48e3c03d484f87641711248c4f8a', N'PM Activity', N'Director Activity', N'The Director Will Approve or Reject', CAST(N'2018-06-11T16:37:05.873' AS DateTime), N'Direct', 0, N'The PM Is Confirm of Reject', N'Confirm')
INSERT [dbo].[WorkflowProcessTransitionHistory] ([Id], [ProcessId], [ExecutorIdentityId], [ActorIdentityId], [FromActivityName], [ToActivityName], [ToStateName], [TransitionTime], [TransitionClassifier], [IsFinalised], [FromStateName], [TriggerName]) VALUES (N'5ea5b8a4-77d7-4f20-a0ee-6db9ee15e267', N'6929dca1-d9ad-457a-8aed-059a0fb59db7', N'UserB', N'UserB', N'PM Activity', N'Director Activity', N'The Director Will Approve or Reject', CAST(N'2018-06-12T10:29:57.160' AS DateTime), N'Direct', 0, N'The PM Is Confirm of Reject', N'Confirm')
INSERT [dbo].[WorkflowProcessTransitionHistory] ([Id], [ProcessId], [ExecutorIdentityId], [ActorIdentityId], [FromActivityName], [ToActivityName], [ToStateName], [TransitionTime], [TransitionClassifier], [IsFinalised], [FromStateName], [TriggerName]) VALUES (N'2c352960-f3a5-4a6e-bceb-73f05ea319a0', N'97bf28e1-081c-4808-a5ee-6b00bd02adb6', N'usera', N'usera', N'User Request Activity', N'PM Activity', N'The PM Is Confirm of Reject', CAST(N'2018-06-12T13:23:23.920' AS DateTime), N'Direct', 0, N'OT Request Created', N'Submit')
INSERT [dbo].[WorkflowProcessTransitionHistory] ([Id], [ProcessId], [ExecutorIdentityId], [ActorIdentityId], [FromActivityName], [ToActivityName], [ToStateName], [TransitionTime], [TransitionClassifier], [IsFinalised], [FromStateName], [TriggerName]) VALUES (N'a178d271-174f-41db-ad35-76095e93745a', N'4f38b710-c718-411f-8d67-69ab874aed0c', N'UserC', N'UserC', N'User Edit Activity', N'Fail', N'User Cancelled', CAST(N'2018-06-12T14:18:26.433' AS DateTime), N'Direct', 1, N'User Is Editing The OT Request', N'Cancel')
INSERT [dbo].[WorkflowProcessTransitionHistory] ([Id], [ProcessId], [ExecutorIdentityId], [ActorIdentityId], [FromActivityName], [ToActivityName], [ToStateName], [TransitionTime], [TransitionClassifier], [IsFinalised], [FromStateName], [TriggerName]) VALUES (N'26e72027-501e-4502-bb68-79f07b43293d', N'c1bba69a-f927-4ccc-887c-2a60012f43d2', N'e41b48e3c03d484f87641711248c4f8a', N'e41b48e3c03d484f87641711248c4f8a', N'User Request Activity', N'PM Activity', N'The PM Is Confirm of Reject', CAST(N'2018-06-11T16:36:51.377' AS DateTime), N'Direct', 0, N'OT Request Created', N'Submit')
INSERT [dbo].[WorkflowProcessTransitionHistory] ([Id], [ProcessId], [ExecutorIdentityId], [ActorIdentityId], [FromActivityName], [ToActivityName], [ToStateName], [TransitionTime], [TransitionClassifier], [IsFinalised], [FromStateName], [TriggerName]) VALUES (N'be43bc46-8734-4453-8c87-7d7e6292e328', N'e1a57d16-0f3b-4b81-b669-c53ba231163a', N'UserA', N'UserA', N'User Edit Activity', N'Fail', N'User Cancelled', CAST(N'2018-06-12T22:21:10.107' AS DateTime), N'Direct', 1, N'User Must Edit The Item', N'Cancel')
INSERT [dbo].[WorkflowProcessTransitionHistory] ([Id], [ProcessId], [ExecutorIdentityId], [ActorIdentityId], [FromActivityName], [ToActivityName], [ToStateName], [TransitionTime], [TransitionClassifier], [IsFinalised], [FromStateName], [TriggerName]) VALUES (N'836a8858-ea92-44f1-8ae3-85f383184a46', N'e8a744b6-67da-4134-849c-ac3b1e737f29', N'usera', N'usera', N'User Edit Activity', N'Fail', N'User Cancelled', CAST(N'2018-06-12T22:08:43.513' AS DateTime), N'Direct', 1, N'User Is Editing The OT Request', N'Cancel')
INSERT [dbo].[WorkflowProcessTransitionHistory] ([Id], [ProcessId], [ExecutorIdentityId], [ActorIdentityId], [FromActivityName], [ToActivityName], [ToStateName], [TransitionTime], [TransitionClassifier], [IsFinalised], [FromStateName], [TriggerName]) VALUES (N'c408c999-6919-4d14-82ca-9097fd3f18df', N'403f8d17-fb54-4154-97c1-38819da3d25b', N'UserB', N'UserB', N'PM Activity', N'User Edit Activity', N'User Is Editing The OT Request', CAST(N'2018-06-12T13:48:37.190' AS DateTime), N'Reverse', 0, N'The PM Is Confirm of Reject', N'Reject')
INSERT [dbo].[WorkflowProcessTransitionHistory] ([Id], [ProcessId], [ExecutorIdentityId], [ActorIdentityId], [FromActivityName], [ToActivityName], [ToStateName], [TransitionTime], [TransitionClassifier], [IsFinalised], [FromStateName], [TriggerName]) VALUES (N'9c1bd73f-c4ce-4b76-9b52-940158c97359', N'6929dca1-d9ad-457a-8aed-059a0fb59db7', N'usera', N'usera', N'User Request Activity', N'PM Activity', N'The PM Is Confirm of Reject', CAST(N'2018-06-12T10:16:16.203' AS DateTime), N'Direct', 0, N'OT Request Created', N'Submit')
INSERT [dbo].[WorkflowProcessTransitionHistory] ([Id], [ProcessId], [ExecutorIdentityId], [ActorIdentityId], [FromActivityName], [ToActivityName], [ToStateName], [TransitionTime], [TransitionClassifier], [IsFinalised], [FromStateName], [TriggerName]) VALUES (N'b35d23b9-cd0c-4e0e-9572-980b61609168', N'403f8d17-fb54-4154-97c1-38819da3d25b', N'usera', N'usera', N'User Edit Activity', N'Fail', N'User Cancelled', CAST(N'2018-06-12T13:49:14.213' AS DateTime), N'Direct', 1, N'User Is Editing The OT Request', N'Cancel')
INSERT [dbo].[WorkflowProcessTransitionHistory] ([Id], [ProcessId], [ExecutorIdentityId], [ActorIdentityId], [FromActivityName], [ToActivityName], [ToStateName], [TransitionTime], [TransitionClassifier], [IsFinalised], [FromStateName], [TriggerName]) VALUES (N'c5d1b997-8196-4d37-bd50-9843b97c6ff9', N'dc66822a-7678-43bd-af07-da1d4aee1c7e', N'UserC', N'UserC', N'Director Activity', N'User Edit Activity', N'User Is Editing The OT Request', CAST(N'2018-06-12T22:09:02.967' AS DateTime), N'Reverse', 0, N'The Director Will Approve or Reject', N'Reject')
INSERT [dbo].[WorkflowProcessTransitionHistory] ([Id], [ProcessId], [ExecutorIdentityId], [ActorIdentityId], [FromActivityName], [ToActivityName], [ToStateName], [TransitionTime], [TransitionClassifier], [IsFinalised], [FromStateName], [TriggerName]) VALUES (N'ee289614-c37e-452d-ae46-ae354dc317b1', N'97bf28e1-081c-4808-a5ee-6b00bd02adb6', N'usera', N'usera', N'User Edit Activity', N'Fail', N'User Cancelled', CAST(N'2018-06-23T14:58:28.010' AS DateTime), N'Direct', 1, N'User Must Edit The Item', N'Cancel')
INSERT [dbo].[WorkflowProcessTransitionHistory] ([Id], [ProcessId], [ExecutorIdentityId], [ActorIdentityId], [FromActivityName], [ToActivityName], [ToStateName], [TransitionTime], [TransitionClassifier], [IsFinalised], [FromStateName], [TriggerName]) VALUES (N'b977ec2e-b687-4e48-ac6b-b6efd9d857e3', N'c731d909-8c32-44ad-bcd8-1a3a3da8d7ee', N'usera', N'usera', N'User Request Activity', N'PM Activity', N'The PM Is Confirm of Reject', CAST(N'2018-06-12T13:22:46.707' AS DateTime), N'Direct', 0, N'OT Request Created', N'Submit')
INSERT [dbo].[WorkflowProcessTransitionHistory] ([Id], [ProcessId], [ExecutorIdentityId], [ActorIdentityId], [FromActivityName], [ToActivityName], [ToStateName], [TransitionTime], [TransitionClassifier], [IsFinalised], [FromStateName], [TriggerName]) VALUES (N'd10e9aec-633e-422a-a941-bcd0af255be6', N'c731d909-8c32-44ad-bcd8-1a3a3da8d7ee', N'UserC', N'UserC', N'User Edit Activity', N'Fail', N'User Cancelled', CAST(N'2018-06-12T14:18:37.857' AS DateTime), N'Direct', 1, N'User Is Editing The OT Request', N'Cancel')
INSERT [dbo].[WorkflowProcessTransitionHistory] ([Id], [ProcessId], [ExecutorIdentityId], [ActorIdentityId], [FromActivityName], [ToActivityName], [ToStateName], [TransitionTime], [TransitionClassifier], [IsFinalised], [FromStateName], [TriggerName]) VALUES (N'4b063758-130f-4172-808b-bf3b9ef185d8', N'97bf28e1-081c-4808-a5ee-6b00bd02adb6', N'UserC', N'UserC', N'Director Activity', N'User Edit Activity', N'User Is Editing The OT Request', CAST(N'2018-06-12T22:08:58.513' AS DateTime), N'Reverse', 0, N'The Director Will Approve or Reject', N'Reject')
INSERT [dbo].[WorkflowProcessTransitionHistory] ([Id], [ProcessId], [ExecutorIdentityId], [ActorIdentityId], [FromActivityName], [ToActivityName], [ToStateName], [TransitionTime], [TransitionClassifier], [IsFinalised], [FromStateName], [TriggerName]) VALUES (N'3d80747c-5443-49d0-b2a9-d03d37ff4c89', N'07afe990-812e-4eaf-ab9f-8627fd5aec32', N'UserC', N'UserC', N'Director Activity', N'Done', N'The OT Request Is Approved', CAST(N'2018-06-12T13:43:18.380' AS DateTime), N'Direct', 1, N'The Director Will Approve or Reject', N'Approve')
INSERT [dbo].[WorkflowProcessTransitionHistory] ([Id], [ProcessId], [ExecutorIdentityId], [ActorIdentityId], [FromActivityName], [ToActivityName], [ToStateName], [TransitionTime], [TransitionClassifier], [IsFinalised], [FromStateName], [TriggerName]) VALUES (N'3b171fb8-7aba-4f3f-9225-dab74a0887d3', N'4f38b710-c718-411f-8d67-69ab874aed0c', N'usera', N'usera', N'User Request Activity', N'PM Activity', N'The PM Is Confirm of Reject', CAST(N'2018-06-12T13:22:32.517' AS DateTime), N'Direct', 0, N'OT Request Created', N'Submit')
INSERT [dbo].[WorkflowProcessTransitionHistory] ([Id], [ProcessId], [ExecutorIdentityId], [ActorIdentityId], [FromActivityName], [ToActivityName], [ToStateName], [TransitionTime], [TransitionClassifier], [IsFinalised], [FromStateName], [TriggerName]) VALUES (N'39835e62-1a33-48fa-a9d9-dec0afa78456', N'6929dca1-d9ad-457a-8aed-059a0fb59db7', N'UserC', N'UserC', N'Director Activity', N'User Edit Activity', N'User Is Editing The OT Request', CAST(N'2018-06-12T22:09:05.407' AS DateTime), N'Reverse', 0, N'The Director Will Approve or Reject', N'Reject')
INSERT [dbo].[WorkflowProcessTransitionHistory] ([Id], [ProcessId], [ExecutorIdentityId], [ActorIdentityId], [FromActivityName], [ToActivityName], [ToStateName], [TransitionTime], [TransitionClassifier], [IsFinalised], [FromStateName], [TriggerName]) VALUES (N'06b85634-e389-4e3b-9570-e49c21d56092', N'c1bba69a-f927-4ccc-887c-2a60012f43d2', N'91f2b4714a964ab7a41aea4293703d16', N'91f2b4714a964ab7a41aea4293703d16', N'User Request Activity', N'PM Activity', N'The PM Is Confirm of Reject', CAST(N'2018-06-11T16:35:55.790' AS DateTime), N'Direct', 0, N'OT Request Created', N'Submit')
INSERT [dbo].[WorkflowProcessTransitionHistory] ([Id], [ProcessId], [ExecutorIdentityId], [ActorIdentityId], [FromActivityName], [ToActivityName], [ToStateName], [TransitionTime], [TransitionClassifier], [IsFinalised], [FromStateName], [TriggerName]) VALUES (N'a0842a13-06fe-4499-8aa3-e5cd1e0ed3f3', N'c731d909-8c32-44ad-bcd8-1a3a3da8d7ee', N'UserB', N'UserB', N'PM Activity', N'User Edit Activity', N'User Is Editing The OT Request', CAST(N'2018-06-12T13:56:48.460' AS DateTime), N'Reverse', 0, N'The PM Is Confirm of Reject', N'Reject')
INSERT [dbo].[WorkflowProcessTransitionHistory] ([Id], [ProcessId], [ExecutorIdentityId], [ActorIdentityId], [FromActivityName], [ToActivityName], [ToStateName], [TransitionTime], [TransitionClassifier], [IsFinalised], [FromStateName], [TriggerName]) VALUES (N'c1f18990-b889-4844-8f1e-f35b68260c0e', N'e8a744b6-67da-4134-849c-ac3b1e737f29', N'UserE', N'UserE', N'User Request Activity', N'PM Activity', N'The PM Is Confirm of Reject', CAST(N'2018-06-12T17:30:50.597' AS DateTime), N'Direct', 0, N'OT Request Created', N'Submit')
INSERT [dbo].[WorkflowScheme] ([Code], [Scheme]) VALUES (N'SimpleWF', N'<Process>
  <Designer />
  <Actors>
    <Actor Name="User" Rule="CheckRole" Value="User" />
    <Actor Name="ProjectManager" Rule="CheckRole" Value="ProjectManager" />
    <Actor Name="Director" Rule="CheckRole" Value="Director" />
  </Actors>
  <Commands>
    <Command Name="Submit" />
    <Command Name="Reject" />
    <Command Name="Confirm" />
    <Command Name="Approve" />
    <Command Name="Cancel" />
  </Commands>
  <Activities>
    <Activity Name="User Request Activity" State="OT Request Created" IsInitial="True" IsFinal="False" IsForSetState="True" IsAutoSchemeUpdate="True">
      <Designer X="90" Y="180" />
    </Activity>
    <Activity Name="PM Activity" State="The PM Is Confirm of Reject" IsInitial="False" IsFinal="False" IsForSetState="True" IsAutoSchemeUpdate="True">
      <Designer X="470" Y="180" />
    </Activity>
    <Activity Name="Director Activity" State="The Director Will Approve or Reject" IsInitial="False" IsFinal="False" IsForSetState="True" IsAutoSchemeUpdate="True">
      <Designer X="840" Y="180" />
    </Activity>
    <Activity Name="Done" State="The OT Request Is Approved" IsInitial="False" IsFinal="True" IsForSetState="True" IsAutoSchemeUpdate="True">
      <Designer X="1320" Y="190" />
    </Activity>
    <Activity Name="User Edit Activity" State="User Must Edit The Item" IsInitial="False" IsFinal="False" IsForSetState="True" IsAutoSchemeUpdate="True">
      <Designer X="480" Y="490" />
    </Activity>
    <Activity Name="Fail" State="User Cancelled" IsInitial="False" IsFinal="True" IsForSetState="True" IsAutoSchemeUpdate="True">
      <Designer X="1300" Y="490" />
    </Activity>
    <Activity Name="Activity_1" IsInitial="False" IsFinal="False" IsForSetState="True" IsAutoSchemeUpdate="True">
      <Designer X="140" Y="380" />
    </Activity>
  </Activities>
  <Transitions>
    <Transition Name="User Request Activity_PM Activity_1" To="PM Activity" From="User Request Activity" Classifier="Direct" AllowConcatenationType="And" RestrictConcatenationType="And" ConditionsConcatenationType="And" IsFork="false" MergeViaSetState="false" DisableParentStateControl="false">
      <Restrictions>
        <Restriction Type="Allow" NameRef="User" />
      </Restrictions>
      <Triggers>
        <Trigger Type="Command" NameRef="Submit" />
      </Triggers>
      <Conditions>
        <Condition Type="Always" />
      </Conditions>
      <Designer />
    </Transition>
    <Transition Name="PM Activity_Director Activity_1" To="Director Activity" From="PM Activity" Classifier="Direct" AllowConcatenationType="And" RestrictConcatenationType="And" ConditionsConcatenationType="And" IsFork="false" MergeViaSetState="false" DisableParentStateControl="false">
      <Restrictions>
        <Restriction Type="Allow" NameRef="ProjectManager" />
      </Restrictions>
      <Triggers>
        <Trigger Type="Command" NameRef="Confirm" />
      </Triggers>
      <Conditions>
        <Condition Type="Always" />
      </Conditions>
      <Designer />
    </Transition>
    <Transition Name="Director Activity_Done_1" To="Done" From="Director Activity" Classifier="Direct" AllowConcatenationType="And" RestrictConcatenationType="And" ConditionsConcatenationType="And" IsFork="false" MergeViaSetState="false" DisableParentStateControl="false">
      <Restrictions>
        <Restriction Type="Allow" NameRef="Director" />
      </Restrictions>
      <Triggers>
        <Trigger Type="Command" NameRef="Approve" />
      </Triggers>
      <Conditions>
        <Condition Type="Always" />
      </Conditions>
      <Designer />
    </Transition>
    <Transition Name="Director Activity_User Edit Activity_1" To="User Edit Activity" From="Director Activity" Classifier="Reverse" AllowConcatenationType="And" RestrictConcatenationType="And" ConditionsConcatenationType="And" IsFork="false" MergeViaSetState="false" DisableParentStateControl="false">
      <Restrictions>
        <Restriction Type="Allow" NameRef="Director" />
      </Restrictions>
      <Triggers>
        <Trigger Type="Command" NameRef="Reject" />
      </Triggers>
      <Conditions>
        <Condition Type="Always" />
      </Conditions>
      <Designer X="948" Y="430" />
    </Transition>
    <Transition Name="PM Activity_User Edit Activity_1" To="User Edit Activity" From="PM Activity" Classifier="Reverse" AllowConcatenationType="And" RestrictConcatenationType="And" ConditionsConcatenationType="And" IsFork="false" MergeViaSetState="false" DisableParentStateControl="false">
      <Restrictions>
        <Restriction Type="Allow" NameRef="ProjectManager" />
      </Restrictions>
      <Triggers>
        <Trigger Type="Command" NameRef="Reject" />
      </Triggers>
      <Conditions>
        <Condition Type="Always" />
      </Conditions>
      <Designer X="528" Y="364" />
    </Transition>
    <Transition Name="User Edit Activity_PM Activity_1" To="PM Activity" From="User Edit Activity" Classifier="Direct" AllowConcatenationType="And" RestrictConcatenationType="And" ConditionsConcatenationType="And" IsFork="false" MergeViaSetState="false" DisableParentStateControl="false">
      <Restrictions>
        <Restriction Type="Allow" NameRef="User" />
      </Restrictions>
      <Triggers>
        <Trigger Type="Command" NameRef="Submit" />
      </Triggers>
      <Conditions>
        <Condition Type="Always" />
      </Conditions>
      <Designer X="600" Y="366" />
    </Transition>
    <Transition Name="User Edit Activity_Fail_1" To="Fail" From="User Edit Activity" Classifier="Direct" AllowConcatenationType="And" RestrictConcatenationType="And" ConditionsConcatenationType="And" IsFork="false" MergeViaSetState="false" DisableParentStateControl="false">
      <Restrictions>
        <Restriction Type="Allow" NameRef="User" />
      </Restrictions>
      <Triggers>
        <Trigger Type="Command" NameRef="Cancel" />
      </Triggers>
      <Conditions>
        <Condition Type="Always" />
      </Conditions>
      <Designer />
    </Transition>
  </Transitions>
</Process>')
ALTER TABLE [dbo].[WorkflowProcessInstance] ADD  DEFAULT ((0)) FOR [IsDeterminingParametersChanged]
GO
ALTER TABLE [dbo].[WorkflowProcessScheme] ADD  DEFAULT ((0)) FOR [IsObsolete]
GO
/****** Object:  StoredProcedure [dbo].[DropWorkflowInbox]    Script Date: 6/23/2018 3:08:41 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DropWorkflowInbox] 
		@processId uniqueidentifier
	AS
	BEGIN
		BEGIN TRAN	
		DELETE FROM dbo.WorkflowInbox WHERE ProcessId = @processId	
		COMMIT TRAN
	END
GO
/****** Object:  StoredProcedure [dbo].[DropWorkflowProcess]    Script Date: 6/23/2018 3:08:41 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DropWorkflowProcess] 
		@id uniqueidentifier
	AS
	BEGIN
		BEGIN TRAN
	
		DELETE FROM dbo.WorkflowProcessInstance WHERE Id = @id
		DELETE FROM dbo.WorkflowProcessInstanceStatus WHERE Id = @id
		DELETE FROM dbo.WorkflowProcessInstancePersistence  WHERE ProcessId = @id
	
		COMMIT TRAN
	END
GO
/****** Object:  StoredProcedure [dbo].[DropWorkflowProcesses]    Script Date: 6/23/2018 3:08:41 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DropWorkflowProcesses] 
		@Ids  IdsTableType	READONLY
	AS	
	BEGIN
		BEGIN TRAN
	
		DELETE dbo.WorkflowProcessInstance FROM dbo.WorkflowProcessInstance wpi  INNER JOIN @Ids  ids ON wpi.Id = ids.Id 
		DELETE dbo.WorkflowProcessInstanceStatus FROM dbo.WorkflowProcessInstanceStatus wpi  INNER JOIN @Ids  ids ON wpi.Id = ids.Id 
		DELETE dbo.WorkflowProcessInstanceStatus FROM dbo.WorkflowProcessInstancePersistence wpi  INNER JOIN @Ids  ids ON wpi.ProcessId = ids.Id 
	

		COMMIT TRAN
	END
GO
/****** Object:  StoredProcedure [dbo].[spWorkflowProcessResetRunningStatus]    Script Date: 6/23/2018 3:08:41 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spWorkflowProcessResetRunningStatus]
	AS
	BEGIN
		UPDATE [WorkflowProcessInstanceStatus] SET [WorkflowProcessInstanceStatus].[Status] = 2 WHERE [WorkflowProcessInstanceStatus].[Status] = 1
	END
GO
USE [master]
GO
ALTER DATABASE [WFTemp] SET  READ_WRITE 
GO
