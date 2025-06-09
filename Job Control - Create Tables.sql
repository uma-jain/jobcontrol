-- =============================================
-- This is a special file with substitution values to be
-- used with the SFTC automated installation process
-- =============================================

USE [[[JobControlDatabaseName]]]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SETTINGS]') AND type in (N'U'))
DROP TABLE [dbo].[SETTINGS]
GO

CREATE TABLE [dbo].[SETTINGS](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[KEY] [varchar](200) NOT NULL,
	[VALUE] [nvarchar](max) NULL,
	[DESCRIPTION] [text] NULL,
 CONSTRAINT [PK_Settings] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO



IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[JOB_TRACKING]') AND type in (N'U'))
DROP TABLE [dbo].[JOB_TRACKING]
GO

CREATE TABLE [dbo].[JOB_TRACKING](
	[ID] [nvarchar](50) NOT NULL,
	[START_TIME] [datetime] NOT NULL,
	[JOB_NAME] [nvarchar](200) NOT NULL,
	[END_TIME] [datetime] NULL,
	[STATUS] [nvarchar](20) NOT NULL,
	[DURATION] [decimal](18, 2) NULL,
	[JOB_TYPE] [nvarchar](50) NULL,
	[JOB_DESCRIPTION] [nvarchar](max) NULL,
	[EXECUTION_SUMMARY] [nvarchar](max) NULL,
	[ENVIRONMENT] [nvarchar](50) NULL,
	[USERNAME] [nvarchar](50) NULL,
	[SERVER] [nvarchar](50) NULL,
	[EXECUTION_ID] [nvarchar](max) NULL,
	[FAILURE_REASON] [nvarchar](max) NULL,
	[ADDITIONAL_INFORMATION] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [IX_JOB_TRACKING_00] ON [dbo].[JOB_TRACKING]
(
	[START_TIME] ASC,
	[JOB_NAME] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HEARTBEAT]') AND type in (N'U'))
DROP TABLE [dbo].[HEARTBEAT]
GO

CREATE TABLE [dbo].[HEARTBEAT](
	[SERVICE_NAME] [nvarchar](50) NOT NULL,
	[PING_TIME] [datetime] NOT NULL,
	[START_TIME] [datetime] NOT NULL,
	[STOP_TIME] [datetime] NULL,
	[ACTIVITY_COUNT] [nvarchar](50) NULL,
	[ENVIRONMENT] [nvarchar](50) NOT NULL,
	[USERNAME] [nvarchar](50) NULL,
	[SERVER] [nvarchar](50) NULL
) ON [PRIMARY]
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[BATCH_TRACKING]') AND type in (N'U'))
DROP TABLE [dbo].[BATCH_TRACKING]
GO

CREATE TABLE [dbo].[BATCH_TRACKING](
	[ID] [nvarchar](50) NOT NULL,
	[START_DATE] [date] NOT NULL,
	[START_TIME] [datetime] NOT NULL,
	[JOB_NAME] [nvarchar](200) NOT NULL,
	[END_TIME] [datetime] NOT NULL,
	[STATUS] [nvarchar](20) NOT NULL,
	[DURATION] [decimal](18, 2) NOT NULL,
	[JOB_TYPE] [nvarchar](50) NULL,
	[BATCH] [nvarchar](max) NULL,
	[FILENAME] [nvarchar](max) NULL,
	[CONNECTIVITY_JOB] [nvarchar](max) NULL,
	[EXECUTION_ID] [nvarchar](50) NULL,
	[MESSAGE] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [IX_BATCH_TRACKING_00] ON [dbo].[BATCH_TRACKING]
(
	[START_DATE] ASC,
	[START_TIME] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO




IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[APEX_CONNECTIVTY_ERRORS]') AND type in (N'U'))
DROP TABLE [dbo].[APEX_CONNECTIVTY_ERRORS]
GO




IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ALERT_TRACKING]') AND type in (N'U'))
DROP TABLE [dbo].[ALERT_TRACKING]
GO

CREATE TABLE [dbo].[ALERT_TRACKING](
	[ID] [nvarchar](50) NOT NULL,
	[RAISED_TIME] [datetime] NULL,
	[PROCESSED] [bit] NOT NULL,
	[PROCESSED_TIME] [datetime] NULL,
	[JOB_NAME] [nvarchar](200) NOT NULL,
	[START_TIME] [datetime] NOT NULL,
	[JOB_TYPE] [nvarchar](50) NULL,
	[JOB_DESCRIPTION] [nvarchar](max) NULL,
	[FAILURE_REASON] [nvarchar](max) NULL,
	[EXECUTION_SUMMARY] [nvarchar](max) NULL,
	[ENVIRONMENT] [nvarchar](50) NULL,
	[USERNAME] [nvarchar](50) NULL,
	[SERVER] [nvarchar](50) NULL,
	[ADDITIONAL_INFORMATION] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [IX_ALERT_TRACKING_00] ON [dbo].[ALERT_TRACKING]
(
	[PROCESSED] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO




IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[METRIC_DEFINITIONS]') AND type in (N'U'))
DROP TABLE [dbo].[METRIC_DEFINITIONS]
GO

CREATE TABLE [dbo].[METRIC_DEFINITIONS](
	[ID] [smallint] NOT NULL,
	[NAME] [nvarchar](100) NOT NULL,
	[METRIC_TYPE] [nvarchar](50) NULL,
	[SCRIPT] [nvarchar](max) NOT NULL,
	[DATABASE_TYPE] [nvarchar](50) NULL,
	[DATABASE_SOURCE] [nvarchar](50) NULL,
	[ENABLED] [bit] NULL,
	[SLA_METRIC] [bit] NULL,
	[COMMENT] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO




IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[METRIC_DATA]') AND type in (N'U'))
DROP TABLE [dbo].[METRIC_DATA]
GO

CREATE TABLE [dbo].[METRIC_DATA](
	[ENTRY_DATE] [date] NOT NULL,
	[ENTRY_TIME] [datetime] NOT NULL,
	[ID] [smallint] NOT NULL,
	[NAME] [nvarchar](50) NOT NULL,
	[TYPE] [nvarchar](50) NOT NULL,
	[SINGLE_NUMBER] [numeric](18, 0) NULL,
	[SINGLE_DATE] [datetime] NULL,
	[SINGLE_STRING] [nvarchar](max) NULL,
	[MULTI_DATA] [nvarchar](max) NULL,
	[SLA_METRIC] [bit] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO




IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DISABLED_JOBS]') AND type in (N'U'))
DROP TABLE [dbo].[DISABLED_JOBS]
GO

CREATE TABLE [dbo].[DISABLED_JOBS](
    [JOB_NAME] [nvarchar](255) NOT NULL,
	[ENTRY_TIME] [datetime] NULL,
	[USERNAME] [nvarchar](100) NULL	
)ON [PRIMARY]
GO





IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PERFORMANCE_REPORT]') AND type in (N'U'))
DROP TABLE [dbo].[PERFORMANCE_REPORT]
GO

CREATE TABLE [dbo].[PERFORMANCE_REPORT](
	[BATCH_ID] [nvarchar](255) NOT NULL,
	[TYPE] [nvarchar](255) NOT NULL,
	[BATCH_TIME_ADDED] [datetime] NOT NULL,
	[LAST_DATA_FETCH] [datetime2](7) NULL
) ON [PRIMARY]
GO



IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PERFORMANCE_REPORT_DETAILS]') AND type in (N'U'))
DROP TABLE [dbo].[PERFORMANCE_REPORT_DETAILS]
GO

CREATE TABLE [dbo].[PERFORMANCE_REPORT_DETAILS](
	[BATCH_ID] [nvarchar](255) NOT NULL,
	[NAME] [nvarchar](255) NOT NULL,
	[COUNT] [int] NULL,
	[FAILED_COUNT] [int] NULL,
	[FIRST_OCCURRENCE] [datetime2](7) NULL,
	[LAST_OCCURRENCE] [datetime2](7) NULL,
	[SHORTEST_DURATION] [int] NOT NULL,
	[LONGEST_DURATION] [int] NOT NULL,
	[AVERAGE_DURATION] [int] NOT NULL,
	[TOTAL_DURATION] [int] NOT NULL
) ON [PRIMARY]
GO


