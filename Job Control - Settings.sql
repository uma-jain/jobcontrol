-- =============================================
-- This is a special file with substitution values to be
-- used with the SFTC automated installation process
-- =============================================

USE [[[JobControlDatabaseName]]]
GO


SET IDENTITY_INSERT [dbo].[SETTINGS] ON 
GO

INSERT [dbo].[SETTINGS] ([ID], [KEY], [VALUE], [DESCRIPTION]) VALUES (1, N'Client', N'Internal', N'Client nane')
GO
INSERT [dbo].[SETTINGS] ([ID], [KEY], [VALUE], [DESCRIPTION]) VALUES (3, N'JobControlServer', N'<server>.client.local:5000', N'URL of the Job Conrol server')
GO
INSERT [dbo].[SETTINGS] ([ID], [KEY], [VALUE], [DESCRIPTION]) VALUES (4, N'UrlSchema', N'http', N'The URL schema for the Job Control Server')
GO
INSERT [dbo].[SETTINGS] ([ID], [KEY], [VALUE], [DESCRIPTION]) VALUES (5, N'RestTimeout', N'60', N'Timeout in seconds for waiting for data on the Rest API - Default is  60 seconds')
GO
INSERT [dbo].[SETTINGS] ([ID], [KEY], [VALUE], [DESCRIPTION]) VALUES (6, N'RestUsername', N'apex', N'Username for the Job Control REST API')
GO
INSERT [dbo].[SETTINGS] ([ID], [KEY], [VALUE], [DESCRIPTION]) VALUES (7, N'RestPassword', N'C0LLateraL', N'Password for the Job Control REST API')
GO
INSERT [dbo].[SETTINGS] ([ID], [KEY], [VALUE], [DESCRIPTION]) VALUES (8, N'EnableAlerting', N'Y', N'Y = Enabled, N = Disabled.  Indicates if a stored procedure should generate an alert record on failure')
GO
INSERT [dbo].[SETTINGS] ([ID], [KEY], [VALUE], [DESCRIPTION]) VALUES (9, N'ApexDatabaseName', N'ApexCollateral_xxx', N'Database name for backup purposes (e.g ApexCollateral_PROD)')
GO
INSERT [dbo].[SETTINGS] ([ID], [KEY], [VALUE], [DESCRIPTION]) VALUES (10, N'DatabaseBackupLocation', N'Z:\SQL_Backup\Adhoc', N'Database backup location on database server (e.g. Z:\SQL_Backup\Adhoc)')
GO
INSERT [dbo].[SETTINGS] ([ID], [KEY], [VALUE], [DESCRIPTION]) VALUES (11, N'DatabaseBackupDaysToKeep', N'30', N'No of days to keep database backups (default is 30)')
GO
INSERT [dbo].[SETTINGS] ([ID], [KEY], [VALUE], [DESCRIPTION]) VALUES (12, N'JobPrefix', N'', N'Used when multiple environments are on the same database server.  e.g. UAT_ or DEV_ will be prefixed to each Job')
GO
SET IDENTITY_INSERT [dbo].[SETTINGS] OFF
GO
