USE [master]
GO
/****** Object:  Database [DemoWF_Distribute_Database]    Script Date: 6/23/2018 3:07:46 PM ******/
CREATE DATABASE [DemoWF_Distribute_Database]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'DemoWF_Distribute_Database', FILENAME = N'/var/DemoWF_Distribute_Database.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'DemoWF_Distribute_Database_log', FILENAME = N'/var/DemoWF_Distribute_Database_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
GO
ALTER DATABASE [DemoWF_Distribute_Database] SET COMPATIBILITY_LEVEL = 140
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [DemoWF_Distribute_Database].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [DemoWF_Distribute_Database] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [DemoWF_Distribute_Database] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [DemoWF_Distribute_Database] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [DemoWF_Distribute_Database] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [DemoWF_Distribute_Database] SET ARITHABORT OFF 
GO
ALTER DATABASE [DemoWF_Distribute_Database] SET AUTO_CLOSE ON 
GO
ALTER DATABASE [DemoWF_Distribute_Database] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [DemoWF_Distribute_Database] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [DemoWF_Distribute_Database] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [DemoWF_Distribute_Database] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [DemoWF_Distribute_Database] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [DemoWF_Distribute_Database] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [DemoWF_Distribute_Database] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [DemoWF_Distribute_Database] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [DemoWF_Distribute_Database] SET  ENABLE_BROKER 
GO
ALTER DATABASE [DemoWF_Distribute_Database] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [DemoWF_Distribute_Database] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [DemoWF_Distribute_Database] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [DemoWF_Distribute_Database] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [DemoWF_Distribute_Database] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [DemoWF_Distribute_Database] SET READ_COMMITTED_SNAPSHOT ON 
GO
ALTER DATABASE [DemoWF_Distribute_Database] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [DemoWF_Distribute_Database] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [DemoWF_Distribute_Database] SET  MULTI_USER 
GO
ALTER DATABASE [DemoWF_Distribute_Database] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [DemoWF_Distribute_Database] SET DB_CHAINING OFF 
GO
ALTER DATABASE [DemoWF_Distribute_Database] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [DemoWF_Distribute_Database] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [DemoWF_Distribute_Database] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [DemoWF_Distribute_Database] SET QUERY_STORE = OFF
GO
USE [DemoWF_Distribute_Database]
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
USE [DemoWF_Distribute_Database]
GO
/****** Object:  Table [dbo].[__EFMigrationsHistory]    Script Date: 6/23/2018 3:07:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[__EFMigrationsHistory](
	[MigrationId] [nvarchar](150) NOT NULL,
	[ProductVersion] [nvarchar](32) NOT NULL,
 CONSTRAINT [PK___EFMigrationsHistory] PRIMARY KEY CLUSTERED 
(
	[MigrationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[OTItemHistories]    Script Date: 6/23/2018 3:07:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OTItemHistories](
	[Id] [uniqueidentifier] NOT NULL,
	[Comment] [nvarchar](max) NULL,
	[Created] [datetime2](7) NOT NULL,
	[NumberOfRequestDays] [nvarchar](max) NULL,
	[RequestForUser] [nvarchar](max) NULL,
	[Requester] [nvarchar](max) NULL,
	[StartDate] [nvarchar](max) NULL,
	[WorkflowId] [uniqueidentifier] NOT NULL,
	[Executor] [nvarchar](max) NULL,
	[CurrentState] [nvarchar](max) NULL,
 CONSTRAINT [PK_OTItemHistories] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Users]    Script Date: 6/23/2018 3:07:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Users](
	[Id] [uniqueidentifier] NOT NULL,
	[UserName] [nvarchar](max) NULL,
	[UserRoles] [nvarchar](max) NULL,
 CONSTRAINT [PK_Users] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
INSERT [dbo].[__EFMigrationsHistory] ([MigrationId], [ProductVersion]) VALUES (N'20180611112449_init', N'2.0.2-rtm-10011')
INSERT [dbo].[__EFMigrationsHistory] ([MigrationId], [ProductVersion]) VALUES (N'20180611120534_init2', N'2.0.2-rtm-10011')
INSERT [dbo].[__EFMigrationsHistory] ([MigrationId], [ProductVersion]) VALUES (N'20180612014511_code2', N'2.0.2-rtm-10011')
INSERT [dbo].[OTItemHistories] ([Id], [Comment], [Created], [NumberOfRequestDays], [RequestForUser], [Requester], [StartDate], [WorkflowId], [Executor], [CurrentState]) VALUES (N'6d998dbe-e626-4174-ac7e-10656b910bb5', N'No Comment', CAST(N'2018-06-12T13:23:23.9848612' AS DateTime2), N'4', N'UserB', N'usera', N'12/6', N'97bf28e1-081c-4808-a5ee-6b00bd02adb6', N'usera', N'The PM Is Confirm of Reject')
INSERT [dbo].[OTItemHistories] ([Id], [Comment], [Created], [NumberOfRequestDays], [RequestForUser], [Requester], [StartDate], [WorkflowId], [Executor], [CurrentState]) VALUES (N'299fb6b2-e171-45fb-8a8a-1371df3f097c', N'tttttttttttttttttttttuuu', CAST(N'2018-06-12T14:17:25.8098964' AS DateTime2), N'1212', N'', N'usera', N'23', N'c6e46058-0695-4cd4-8758-4d54865df14c', NULL, N'OT Request Created')
INSERT [dbo].[OTItemHistories] ([Id], [Comment], [Created], [NumberOfRequestDays], [RequestForUser], [Requester], [StartDate], [WorkflowId], [Executor], [CurrentState]) VALUES (N'c17da7c6-e69e-4a5d-bf57-15e53b402ed8', N'44444', CAST(N'2018-06-12T22:09:03.0002868' AS DateTime2), N'12', N'', N'usera', N'12', N'dc66822a-7678-43bd-af07-da1d4aee1c7e', N'UserC', N'User Is Editing The OT Request')
INSERT [dbo].[OTItemHistories] ([Id], [Comment], [Created], [NumberOfRequestDays], [RequestForUser], [Requester], [StartDate], [WorkflowId], [Executor], [CurrentState]) VALUES (N'6482d92c-0369-495a-ad72-163ce405b3f8', N'hello comment', CAST(N'2018-06-12T22:09:05.4439572' AS DateTime2), N'2', NULL, N'diepnv4', N'12-5', N'6929dca1-d9ad-457a-8aed-059a0fb59db7', N'UserC', N'User Is Editing The OT Request')
INSERT [dbo].[OTItemHistories] ([Id], [Comment], [Created], [NumberOfRequestDays], [RequestForUser], [Requester], [StartDate], [WorkflowId], [Executor], [CurrentState]) VALUES (N'1a080d01-7629-4f65-bc1f-2847eb80588b', N'', CAST(N'2018-06-12T22:21:10.1437174' AS DateTime2), N'1212', N'', N'usera', N'23', N'e1a57d16-0f3b-4b81-b669-c53ba231163a', N'UserA', N'User Cancelled')
INSERT [dbo].[OTItemHistories] ([Id], [Comment], [Created], [NumberOfRequestDays], [RequestForUser], [Requester], [StartDate], [WorkflowId], [Executor], [CurrentState]) VALUES (N'24bb0744-6759-4164-b4e2-2ca22e86e30b', N'statttttttt', CAST(N'2018-06-12T14:15:58.5440458' AS DateTime2), N'12345', N'UserB', N'UserB :: Role: ProjectManager', N'startx', N'36f7db48-77a5-40ec-9d96-3d0a3c75efe6', NULL, N'OT Request Created')
INSERT [dbo].[OTItemHistories] ([Id], [Comment], [Created], [NumberOfRequestDays], [RequestForUser], [Requester], [StartDate], [WorkflowId], [Executor], [CurrentState]) VALUES (N'c839065a-b541-4679-bb61-2ce9cfab442f', N'No comment', CAST(N'2018-06-23T14:58:48.0898999' AS DateTime2), N'4', N'', N'usera', N'1', N'e13232c3-dd6a-447a-ae1e-90f2022e32c9', NULL, N'OT Request Created')
INSERT [dbo].[OTItemHistories] ([Id], [Comment], [Created], [NumberOfRequestDays], [RequestForUser], [Requester], [StartDate], [WorkflowId], [Executor], [CurrentState]) VALUES (N'dab6e718-6f32-4c5a-afc1-2dc550f0bd14', N'', CAST(N'2018-06-12T17:30:31.6810479' AS DateTime2), N'0', N'UserE', N'UserE :: Role: User;Director', N'', N'e8a744b6-67da-4134-849c-ac3b1e737f29', NULL, N'OT Request Created')
INSERT [dbo].[OTItemHistories] ([Id], [Comment], [Created], [NumberOfRequestDays], [RequestForUser], [Requester], [StartDate], [WorkflowId], [Executor], [CurrentState]) VALUES (N'426c1793-1858-4263-904e-2f5fc4f5175f', N'hello comment', CAST(N'2018-06-12T22:21:08.0112722' AS DateTime2), N'2', NULL, N'diepnv4', N'12-5', N'6929dca1-d9ad-457a-8aed-059a0fb59db7', N'UserA', N'User Cancelled')
INSERT [dbo].[OTItemHistories] ([Id], [Comment], [Created], [NumberOfRequestDays], [RequestForUser], [Requester], [StartDate], [WorkflowId], [Executor], [CurrentState]) VALUES (N'6e7b6902-57cb-442e-94a4-3032d9c6fc25', N'hello comment', CAST(N'2018-06-12T13:41:27.7330655' AS DateTime2), N'2', N'diepnv4', N'diepnv4', N'12-5', N'6a8a8d22-194b-4e90-8c62-baff9332c218', N'UserB', N'The Director Will Approve or Reject')
INSERT [dbo].[OTItemHistories] ([Id], [Comment], [Created], [NumberOfRequestDays], [RequestForUser], [Requester], [StartDate], [WorkflowId], [Executor], [CurrentState]) VALUES (N'30177c2b-f0f0-459a-94c0-3760ae696ea4', N'44444', CAST(N'2018-06-12T13:47:59.4322666' AS DateTime2), N'12', N'', N'usera', N'12', N'403f8d17-fb54-4154-97c1-38819da3d25b', N'UserA', N'The PM Is Confirm of Reject')
INSERT [dbo].[OTItemHistories] ([Id], [Comment], [Created], [NumberOfRequestDays], [RequestForUser], [Requester], [StartDate], [WorkflowId], [Executor], [CurrentState]) VALUES (N'e10fef4e-3cab-474b-a214-38ac397f94c5', N'hello comment', CAST(N'2018-06-11T19:07:38.4734176' AS DateTime2), N'2', N'diepnv4', NULL, N'12-5', N'6b36c36c-5b8b-4c0e-a819-015e3ad2704d', N'OT Request Created', NULL)
INSERT [dbo].[OTItemHistories] ([Id], [Comment], [Created], [NumberOfRequestDays], [RequestForUser], [Requester], [StartDate], [WorkflowId], [Executor], [CurrentState]) VALUES (N'1b26cb06-5935-4cd4-9cb9-3c7a3c79a1d5', N'No Comment', CAST(N'2018-06-23T14:58:28.2594976' AS DateTime2), N'4', N'UserB', N'usera', N'12/6', N'97bf28e1-081c-4808-a5ee-6b00bd02adb6', N'usera', N'User Cancelled')
INSERT [dbo].[OTItemHistories] ([Id], [Comment], [Created], [NumberOfRequestDays], [RequestForUser], [Requester], [StartDate], [WorkflowId], [Executor], [CurrentState]) VALUES (N'71dda9cd-d4af-4653-a7ab-3d340e48eb91', N'hello comment', CAST(N'2018-06-11T19:08:42.4506173' AS DateTime2), N'2', NULL, N'diepnv4', N'12-5', N'6929dca1-d9ad-457a-8aed-059a0fb59db7', N'OT Request Created', NULL)
INSERT [dbo].[OTItemHistories] ([Id], [Comment], [Created], [NumberOfRequestDays], [RequestForUser], [Requester], [StartDate], [WorkflowId], [Executor], [CurrentState]) VALUES (N'1b20a219-cd99-446c-9627-3e9ebad759ce', N'', CAST(N'2018-06-12T22:20:27.4301260' AS DateTime2), N'1212', N'', N'usera', N'23', N'e1a57d16-0f3b-4b81-b669-c53ba231163a', N'UserB', N'User Must Edit The Item')
INSERT [dbo].[OTItemHistories] ([Id], [Comment], [Created], [NumberOfRequestDays], [RequestForUser], [Requester], [StartDate], [WorkflowId], [Executor], [CurrentState]) VALUES (N'0084d7b8-b2dd-4678-aaa6-3efe43e13407', N'tesesst fpt', CAST(N'2018-06-12T13:57:53.6526655' AS DateTime2), N'12', N'', N'UserB :: Role: ProjectManager', N'Stater', N'935ef8e7-e5e1-4406-b57b-2d41b8732d99', NULL, N'OT Request Created')
INSERT [dbo].[OTItemHistories] ([Id], [Comment], [Created], [NumberOfRequestDays], [RequestForUser], [Requester], [StartDate], [WorkflowId], [Executor], [CurrentState]) VALUES (N'1067c231-7fb2-4b16-b73c-4408090ecec6', N'tttttttttttttttttttttuuu', CAST(N'2018-06-12T14:17:29.0722810' AS DateTime2), N'1212', N'', N'usera', N'23', N'c6e46058-0695-4cd4-8758-4d54865df14c', N'usera', N'The PM Is Confirm of Reject')
INSERT [dbo].[OTItemHistories] ([Id], [Comment], [Created], [NumberOfRequestDays], [RequestForUser], [Requester], [StartDate], [WorkflowId], [Executor], [CurrentState]) VALUES (N'b20fa567-2b10-4fc3-84ea-451e9ce4cc6b', N'1', CAST(N'2018-06-12T10:07:54.4382311' AS DateTime2), N'01', N'UserB', N'UserB :: Role: ProjectManager', N'1', N'4f38b710-c718-411f-8d67-69ab874aed0c', NULL, N'OT Request Created')
INSERT [dbo].[OTItemHistories] ([Id], [Comment], [Created], [NumberOfRequestDays], [RequestForUser], [Requester], [StartDate], [WorkflowId], [Executor], [CurrentState]) VALUES (N'3deb431a-78f8-4b5c-8525-478a518716d1', N'44444', CAST(N'2018-06-12T10:19:34.6239279' AS DateTime2), N'12', N'', N'usera', N'12', N'403f8d17-fb54-4154-97c1-38819da3d25b', NULL, N'OT Request Created')
INSERT [dbo].[OTItemHistories] ([Id], [Comment], [Created], [NumberOfRequestDays], [RequestForUser], [Requester], [StartDate], [WorkflowId], [Executor], [CurrentState]) VALUES (N'25eb237f-6a04-4c27-aa49-540a8c725600', N'', CAST(N'2018-06-12T22:08:38.9050345' AS DateTime2), N'1212', N'', N'usera', N'23', N'e1a57d16-0f3b-4b81-b669-c53ba231163a', N'usera', N'The PM Is Confirm of Reject')
INSERT [dbo].[OTItemHistories] ([Id], [Comment], [Created], [NumberOfRequestDays], [RequestForUser], [Requester], [StartDate], [WorkflowId], [Executor], [CurrentState]) VALUES (N'a5ecba94-e64c-4012-8471-5b6b35dcdd13', N'44444', CAST(N'2018-06-12T10:19:52.1502089' AS DateTime2), N'12', N'', N'usera', N'12', N'dc66822a-7678-43bd-af07-da1d4aee1c7e', NULL, N'OT Request Created')
INSERT [dbo].[OTItemHistories] ([Id], [Comment], [Created], [NumberOfRequestDays], [RequestForUser], [Requester], [StartDate], [WorkflowId], [Executor], [CurrentState]) VALUES (N'5bd8efaf-9335-4f5c-9ec3-5dd4c934bf58', N'', CAST(N'2018-06-12T14:17:18.1097565' AS DateTime2), N'1212', N'', N'usera', N'23', N'e1a57d16-0f3b-4b81-b669-c53ba231163a', NULL, N'OT Request Created')
INSERT [dbo].[OTItemHistories] ([Id], [Comment], [Created], [NumberOfRequestDays], [RequestForUser], [Requester], [StartDate], [WorkflowId], [Executor], [CurrentState]) VALUES (N'342fc413-785a-45dd-a1e6-6a384322528d', N'âsasasaaaaaaaaaaa', CAST(N'2018-06-12T13:57:40.7622884' AS DateTime2), N'12', N'', N'UserB :: Role: ProjectManager', N'Stater', N'4d4ec185-a4d8-4b40-930e-c56f9bed229a', NULL, N'OT Request Created')
INSERT [dbo].[OTItemHistories] ([Id], [Comment], [Created], [NumberOfRequestDays], [RequestForUser], [Requester], [StartDate], [WorkflowId], [Executor], [CurrentState]) VALUES (N'3dfe267f-78dc-4e2c-ada6-6d2557aea24d', N'aaaaaaaaaaaaaaaaaa', CAST(N'2018-06-12T13:21:30.3685310' AS DateTime2), N'0', N'UserB', N'usera', N'', N'07afe990-812e-4eaf-ab9f-8627fd5aec32', N'usera', N'The PM Is Confirm of Reject')
INSERT [dbo].[OTItemHistories] ([Id], [Comment], [Created], [NumberOfRequestDays], [RequestForUser], [Requester], [StartDate], [WorkflowId], [Executor], [CurrentState]) VALUES (N'd0f0f0b8-ed80-44c1-b1f4-73a7e7749857', N'1', CAST(N'2018-06-12T13:22:32.7384027' AS DateTime2), N'01', N'UserB', N'UserB :: Role: ProjectManager', N'1', N'4f38b710-c718-411f-8d67-69ab874aed0c', N'usera', N'The PM Is Confirm of Reject')
INSERT [dbo].[OTItemHistories] ([Id], [Comment], [Created], [NumberOfRequestDays], [RequestForUser], [Requester], [StartDate], [WorkflowId], [Executor], [CurrentState]) VALUES (N'59f3dfff-b4f6-4961-8533-74e9d794d819', N'No Comment', CAST(N'2018-06-12T22:08:58.5467105' AS DateTime2), N'4', N'UserB', N'usera', N'12/6', N'97bf28e1-081c-4808-a5ee-6b00bd02adb6', N'UserC', N'User Is Editing The OT Request')
INSERT [dbo].[OTItemHistories] ([Id], [Comment], [Created], [NumberOfRequestDays], [RequestForUser], [Requester], [StartDate], [WorkflowId], [Executor], [CurrentState]) VALUES (N'9cd86e57-a872-47f3-8ac3-797c193d302e', N'aaaaaaaaaaaaaaaaaa', CAST(N'2018-06-12T10:18:46.8312307' AS DateTime2), N'0', N'UserB', N'usera', N'', N'07afe990-812e-4eaf-ab9f-8627fd5aec32', NULL, N'OT Request Created')
INSERT [dbo].[OTItemHistories] ([Id], [Comment], [Created], [NumberOfRequestDays], [RequestForUser], [Requester], [StartDate], [WorkflowId], [Executor], [CurrentState]) VALUES (N'4b50a918-9eae-4ea1-8e3b-79fe4f933bf7', N'44444', CAST(N'2018-06-12T10:27:49.6287467' AS DateTime2), N'12', N'', N'usera', N'12', N'dc66822a-7678-43bd-af07-da1d4aee1c7e', N'UserB', N'The Director Will Approve or Reject')
INSERT [dbo].[OTItemHistories] ([Id], [Comment], [Created], [NumberOfRequestDays], [RequestForUser], [Requester], [StartDate], [WorkflowId], [Executor], [CurrentState]) VALUES (N'560ecf0e-4b3b-435d-ad9b-7b4921984288', N'aaaaaaaaaaaaaaaaaa', CAST(N'2018-06-12T13:41:21.1053488' AS DateTime2), N'0', N'UserB', N'usera', N'', N'07afe990-812e-4eaf-ab9f-8627fd5aec32', N'UserB', N'The Director Will Approve or Reject')
INSERT [dbo].[OTItemHistories] ([Id], [Comment], [Created], [NumberOfRequestDays], [RequestForUser], [Requester], [StartDate], [WorkflowId], [Executor], [CurrentState]) VALUES (N'b835176b-c481-496b-b74e-7b76ab00dac5', N'44444', CAST(N'2018-06-12T13:49:14.3249418' AS DateTime2), N'12', N'', N'usera', N'12', N'403f8d17-fb54-4154-97c1-38819da3d25b', N'usera', N'User Cancelled')
INSERT [dbo].[OTItemHistories] ([Id], [Comment], [Created], [NumberOfRequestDays], [RequestForUser], [Requester], [StartDate], [WorkflowId], [Executor], [CurrentState]) VALUES (N'a159015f-6999-4484-839b-7be2537d0092', N'hello comment', CAST(N'2018-06-11T18:45:35.5758985' AS DateTime2), N'2', N'diepnv4', N'diepnv4', N'12-5', N'6a8a8d22-194b-4e90-8c62-baff9332c218', NULL, NULL)
INSERT [dbo].[OTItemHistories] ([Id], [Comment], [Created], [NumberOfRequestDays], [RequestForUser], [Requester], [StartDate], [WorkflowId], [Executor], [CurrentState]) VALUES (N'42ec5ebb-32c4-484e-b29a-82356b6e55cd', N'aaaaaaaaaaaaaaaaaa', CAST(N'2018-06-12T13:43:18.4517955' AS DateTime2), N'0', N'UserB', N'usera', N'', N'07afe990-812e-4eaf-ab9f-8627fd5aec32', N'UserC', N'The OT Request Is Approved')
INSERT [dbo].[OTItemHistories] ([Id], [Comment], [Created], [NumberOfRequestDays], [RequestForUser], [Requester], [StartDate], [WorkflowId], [Executor], [CurrentState]) VALUES (N'ced4d3b2-b404-48cd-a12f-83c9242c3c33', N'', CAST(N'2018-06-12T22:08:43.5479886' AS DateTime2), N'0', N'UserE', N'UserE :: Role: User;Director', N'', N'e8a744b6-67da-4134-849c-ac3b1e737f29', N'usera', N'User Cancelled')
INSERT [dbo].[OTItemHistories] ([Id], [Comment], [Created], [NumberOfRequestDays], [RequestForUser], [Requester], [StartDate], [WorkflowId], [Executor], [CurrentState]) VALUES (N'a28bc44f-4f0a-4bb6-a191-83d172a8d77c', N'No Comment', CAST(N'2018-06-12T10:17:45.9890086' AS DateTime2), N'4', N'UserB', N'usera', N'12/6', N'97bf28e1-081c-4808-a5ee-6b00bd02adb6', NULL, N'OT Request Created')
INSERT [dbo].[OTItemHistories] ([Id], [Comment], [Created], [NumberOfRequestDays], [RequestForUser], [Requester], [StartDate], [WorkflowId], [Executor], [CurrentState]) VALUES (N'3e620152-4814-43f3-aeb3-8603cc1fa3ca', N'string', CAST(N'2018-06-11T23:21:30.8928115' AS DateTime2), N'8', N'string', N'string', N'string', N'c731d909-8c32-44ad-bcd8-1a3a3da8d7ee', N'OT Request Created', NULL)
INSERT [dbo].[OTItemHistories] ([Id], [Comment], [Created], [NumberOfRequestDays], [RequestForUser], [Requester], [StartDate], [WorkflowId], [Executor], [CurrentState]) VALUES (N'ffc04dd2-cc4f-462a-b1f7-a14dce18bea3', N'No comment', CAST(N'2018-06-23T14:58:59.1864745' AS DateTime2), N'4', N'', N'usera', N'1', N'74c59b87-7aa4-4c37-a653-bc7f76edf772', NULL, N'OT Request Created')
INSERT [dbo].[OTItemHistories] ([Id], [Comment], [Created], [NumberOfRequestDays], [RequestForUser], [Requester], [StartDate], [WorkflowId], [Executor], [CurrentState]) VALUES (N'5b8e694f-9768-429e-b5ab-a4a00f2d5087', N'44444', CAST(N'2018-06-12T13:48:37.3043725' AS DateTime2), N'12', N'', N'usera', N'12', N'403f8d17-fb54-4154-97c1-38819da3d25b', N'UserB', N'User Is Editing The OT Request')
INSERT [dbo].[OTItemHistories] ([Id], [Comment], [Created], [NumberOfRequestDays], [RequestForUser], [Requester], [StartDate], [WorkflowId], [Executor], [CurrentState]) VALUES (N'eb5c44d9-f687-4655-8ed6-a6988367e238', N'', CAST(N'2018-06-12T17:31:02.1022188' AS DateTime2), N'0', N'UserE', N'UserE :: Role: User;Director', N'', N'e8a744b6-67da-4134-849c-ac3b1e737f29', N'UserB', N'User Is Editing The OT Request')
INSERT [dbo].[OTItemHistories] ([Id], [Comment], [Created], [NumberOfRequestDays], [RequestForUser], [Requester], [StartDate], [WorkflowId], [Executor], [CurrentState]) VALUES (N'816e1bc2-bb6c-4b5c-b6d9-b4b84470c756', N'hello comment', CAST(N'2018-06-11T19:09:29.9605383' AS DateTime2), N'2', N'diepnv4', N'diepnv4', N'12-5', N'cd154f8a-c0d4-4f8d-b955-eb658692e9ff', N'OT Request Created', NULL)
INSERT [dbo].[OTItemHistories] ([Id], [Comment], [Created], [NumberOfRequestDays], [RequestForUser], [Requester], [StartDate], [WorkflowId], [Executor], [CurrentState]) VALUES (N'16878216-74dd-43d2-a66c-b4be74146375', N'1', CAST(N'2018-06-12T14:18:26.4666394' AS DateTime2), N'01', N'UserB', N'UserB :: Role: ProjectManager', N'1', N'4f38b710-c718-411f-8d67-69ab874aed0c', N'UserC', N'User Cancelled')
INSERT [dbo].[OTItemHistories] ([Id], [Comment], [Created], [NumberOfRequestDays], [RequestForUser], [Requester], [StartDate], [WorkflowId], [Executor], [CurrentState]) VALUES (N'd3194fb6-f916-4eb3-9189-c3b6f5dd129a', N'string', CAST(N'2018-06-12T14:18:37.8906274' AS DateTime2), N'8', N'string', N'string', N'string', N'c731d909-8c32-44ad-bcd8-1a3a3da8d7ee', N'UserC', N'User Cancelled')
INSERT [dbo].[OTItemHistories] ([Id], [Comment], [Created], [NumberOfRequestDays], [RequestForUser], [Requester], [StartDate], [WorkflowId], [Executor], [CurrentState]) VALUES (N'5d7bae01-edd7-4f75-a35c-c57e17377f49', N'', CAST(N'2018-06-12T17:30:50.6329663' AS DateTime2), N'0', N'UserE', N'UserE :: Role: User;Director', N'', N'e8a744b6-67da-4134-849c-ac3b1e737f29', N'UserE', N'The PM Is Confirm of Reject')
INSERT [dbo].[OTItemHistories] ([Id], [Comment], [Created], [NumberOfRequestDays], [RequestForUser], [Requester], [StartDate], [WorkflowId], [Executor], [CurrentState]) VALUES (N'5142c04c-7f3b-4f07-ad70-c65100333330', N'1', CAST(N'2018-06-12T13:56:53.6764760' AS DateTime2), N'01', N'UserB', N'UserB :: Role: ProjectManager', N'1', N'4f38b710-c718-411f-8d67-69ab874aed0c', N'UserB', N'User Is Editing The OT Request')
INSERT [dbo].[OTItemHistories] ([Id], [Comment], [Created], [NumberOfRequestDays], [RequestForUser], [Requester], [StartDate], [WorkflowId], [Executor], [CurrentState]) VALUES (N'b2fa0251-2ee8-4a63-8328-cec8c8315ec6', N'No Comment', CAST(N'2018-06-12T13:23:41.6198772' AS DateTime2), N'4', N'UserB', N'usera', N'12/6', N'97bf28e1-081c-4808-a5ee-6b00bd02adb6', N'UserB', N'The Director Will Approve or Reject')
INSERT [dbo].[OTItemHistories] ([Id], [Comment], [Created], [NumberOfRequestDays], [RequestForUser], [Requester], [StartDate], [WorkflowId], [Executor], [CurrentState]) VALUES (N'ff0aee4b-3ad4-45e6-8d6e-d60ffff6e73c', N'string', CAST(N'2018-06-12T13:56:48.5728352' AS DateTime2), N'8', N'string', N'string', N'string', N'c731d909-8c32-44ad-bcd8-1a3a3da8d7ee', N'UserB', N'User Is Editing The OT Request')
INSERT [dbo].[OTItemHistories] ([Id], [Comment], [Created], [NumberOfRequestDays], [RequestForUser], [Requester], [StartDate], [WorkflowId], [Executor], [CurrentState]) VALUES (N'f89845b7-122c-4a66-af9c-e515eafef4e8', N'string', CAST(N'2018-06-12T13:23:16.8991968' AS DateTime2), N'8', N'string', N'string', N'string', N'c731d909-8c32-44ad-bcd8-1a3a3da8d7ee', N'usera', N'The PM Is Confirm of Reject')
INSERT [dbo].[OTItemHistories] ([Id], [Comment], [Created], [NumberOfRequestDays], [RequestForUser], [Requester], [StartDate], [WorkflowId], [Executor], [CurrentState]) VALUES (N'3c4097a8-c4fc-47b1-928b-f632b27c102e', N'hello comment', CAST(N'2018-06-12T13:42:43.2664086' AS DateTime2), N'2', N'diepnv4', N'diepnv4', N'12-5', N'6a8a8d22-194b-4e90-8c62-baff9332c218', N'UserC', N'The OT Request Is Approved')
INSERT [dbo].[Users] ([Id], [UserName], [UserRoles]) VALUES (N'dfdfe802-e2bc-45ba-8cbc-1241f99991b2', N'UserF', N'ProjectManager;Director')
INSERT [dbo].[Users] ([Id], [UserName], [UserRoles]) VALUES (N'c4a96ff0-91ba-4eb7-ab63-323b557e263f', N'UserE', N'User;Director')
INSERT [dbo].[Users] ([Id], [UserName], [UserRoles]) VALUES (N'dd617680-3c89-4f88-bc48-4da0cf6ca9bc', N'UserA', N'User')
INSERT [dbo].[Users] ([Id], [UserName], [UserRoles]) VALUES (N'9de0fbf6-a406-433b-b8ef-9abde4c1b47f', N'UserD', N'User;ProjectManager')
INSERT [dbo].[Users] ([Id], [UserName], [UserRoles]) VALUES (N'4b778172-faea-47c5-aa44-9b28b0196021', N'UserB', N'ProjectManager')
INSERT [dbo].[Users] ([Id], [UserName], [UserRoles]) VALUES (N'fb6291e6-de33-40e1-a835-ff8c2af1605d', N'UserC', N'Director')
USE [master]
GO
ALTER DATABASE [DemoWF_Distribute_Database] SET  READ_WRITE 
GO
