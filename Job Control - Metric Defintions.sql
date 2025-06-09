-- =============================================
-- This is a special file with substitution values to be
-- used with the SFTC automated installation process
-- =============================================

USE [[[JobControlDatabaseName]]]
GO


INSERT [dbo].[METRIC_DEFINITIONS] ([ID], [NAME], [METRIC_TYPE], [SCRIPT], [DATABASE_TYPE], [DATABASE_SOURCE], [ENABLED], [SLA_METRIC], [COMMENT]) VALUES (1, N'Environment', N'Database', N'SELECT SETTING_VALUE AS Environment FROM SYSTEM_SETTING WHERE SETTING_KEY = ''Environment''', N'ALL', N'ApexCollateral', 1, NULL, NULL)
GO
INSERT [dbo].[METRIC_DEFINITIONS] ([ID], [NAME], [METRIC_TYPE], [SCRIPT], [DATABASE_TYPE], [DATABASE_SOURCE], [ENABLED], [SLA_METRIC], [COMMENT]) VALUES (3, N'Generated Time', N'Database', N'SELECT GETDATE() AS N', N'ALL', N'ApexCollateral', 1, NULL, NULL)
GO
INSERT [dbo].[METRIC_DEFINITIONS] ([ID], [NAME], [METRIC_TYPE], [SCRIPT], [DATABASE_TYPE], [DATABASE_SOURCE], [ENABLED], [SLA_METRIC], [COMMENT]) VALUES (2, N'Base Ccy', N'Database', N'SELECT SETTING_VALUE AS BaseCcy FROM SYSTEM_SETTING WHERE SETTING_KEY = ''BaseCurrency''', N'ALL', N'ApexCollateral', 1, NULL, NULL)
GO
INSERT [dbo].[METRIC_DEFINITIONS] ([ID], [NAME], [METRIC_TYPE], [SCRIPT], [DATABASE_TYPE], [DATABASE_SOURCE], [ENABLED], [SLA_METRIC], [COMMENT]) VALUES (101, N'Active Agreement Count', N'Database', N'SELECT COUNT(1) AS AgrCount FROM AGREEMENT WHERE IS_ACTIVE = 1', N'ALL', N'ApexCollateral', 1, 1, NULL)
GO
INSERT [dbo].[METRIC_DEFINITIONS] ([ID], [NAME], [METRIC_TYPE], [SCRIPT], [DATABASE_TYPE], [DATABASE_SOURCE], [ENABLED], [SLA_METRIC], [COMMENT]) VALUES (102, N'Active Users (Non FIS)', N'Database', N'SELECT COUNT(1) AS ActiveUsersCount FROM USERS WHERE DISABLED = 0 AND DEPARTMENT NOT LIKE ''%FIS%''', N'ALL', N'ApexCollateral', 1, 1, NULL)
GO
INSERT [dbo].[METRIC_DEFINITIONS] ([ID], [NAME], [METRIC_TYPE], [SCRIPT], [DATABASE_TYPE], [DATABASE_SOURCE], [ENABLED], [SLA_METRIC], [COMMENT]) VALUES (103, N'Active Users List (Non FIS)', N'Database', N'SELECT USER_NAME, CASE WHEN ADMINISTRATOR = 1 THEN ''Yes'' ELSE '''' END AS IS_ADMINISTRATOR FROM USERS WHERE DISABLED = 0 AND DEPARTMENT NOT LIKE ''%FIS%'' ORDER BY USER_NAME', N'ALL', N'ApexCollateral', 1, 1, NULL)
GO
INSERT [dbo].[METRIC_DEFINITIONS] ([ID], [NAME], [METRIC_TYPE], [SCRIPT], [DATABASE_TYPE], [DATABASE_SOURCE], [ENABLED], [SLA_METRIC], [COMMENT]) VALUES (104, N'Margin Call Today Count', N'Database', N'SELECT COUNT(1) AS MarginCallsDone FROM MARGIN_CALL WHERE CONVERT(date, CREATION_DAY_TIME) = GETDATE()', N'ALL', N'ApexCollateral', 1, 1, NULL)
GO
INSERT [dbo].[METRIC_DEFINITIONS] ([ID], [NAME], [METRIC_TYPE], [SCRIPT], [DATABASE_TYPE], [DATABASE_SOURCE], [ENABLED], [SLA_METRIC], [COMMENT]) VALUES (200, N'Counterparty Count', N'Database', N'SELECT COUNT(1) AS CptyCount FROM BUSINESS_PARTNER WHERE TYPE = 1', N'ALL', N'ApexCollateral', 1, NULL, NULL)
GO
INSERT [dbo].[METRIC_DEFINITIONS] ([ID], [NAME], [METRIC_TYPE], [SCRIPT], [DATABASE_TYPE], [DATABASE_SOURCE], [ENABLED], [SLA_METRIC], [COMMENT]) VALUES (201, N'Issuer Count', N'Database', N'SELECT COUNT(1) AS IssuerCount FROM BUSINESS_PARTNER WHERE TYPE = 19', N'ALL', N'ApexCollateral', 1, NULL, NULL)
GO
INSERT [dbo].[METRIC_DEFINITIONS] ([ID], [NAME], [METRIC_TYPE], [SCRIPT], [DATABASE_TYPE], [DATABASE_SOURCE], [ENABLED], [SLA_METRIC], [COMMENT]) VALUES (202, N'Trading Book Count', N'Database', N'SELECT COUNT(1) AS TradingBookCount FROM BUSINESS_PARTNER WHERE TYPE = 12', N'ALL', N'ApexCollateral', 1, NULL, NULL)
GO
INSERT [dbo].[METRIC_DEFINITIONS] ([ID], [NAME], [METRIC_TYPE], [SCRIPT], [DATABASE_TYPE], [DATABASE_SOURCE], [ENABLED], [SLA_METRIC], [COMMENT]) VALUES (203, N'Legal Entity Count', N'Database', N'SELECT COUNT(1) AS LegalEntityCount FROM BUSINESS_PARTNER WHERE TYPE = 18', N'ALL', N'ApexCollateral', 1, NULL, NULL)
GO
INSERT [dbo].[METRIC_DEFINITIONS] ([ID], [NAME], [METRIC_TYPE], [SCRIPT], [DATABASE_TYPE], [DATABASE_SOURCE], [ENABLED], [SLA_METRIC], [COMMENT]) VALUES (210, N'Position Security Count', N'Database', N'SELECT COUNT(1) AS PositionSecurityCount FROM ACCOUNT WHERE TYPE IN (10,1)', N'ALL', N'ApexCollateral', 1, NULL, NULL)
GO
INSERT [dbo].[METRIC_DEFINITIONS] ([ID], [NAME], [METRIC_TYPE], [SCRIPT], [DATABASE_TYPE], [DATABASE_SOURCE], [ENABLED], [SLA_METRIC], [COMMENT]) VALUES (211, N'Position Cash Count', N'Database', N'SELECT COUNT(1) AS PositionCashCount FROM ACCOUNT WHERE TYPE IN (9)', N'ALL', N'ApexCollateral', 1, NULL, NULL)
GO
INSERT [dbo].[METRIC_DEFINITIONS] ([ID], [NAME], [METRIC_TYPE], [SCRIPT], [DATABASE_TYPE], [DATABASE_SOURCE], [ENABLED], [SLA_METRIC], [COMMENT]) VALUES (220, N'Security Bond Count', N'Database', N'SELECT COUNT(1) AS SecurityBondCount FROM FINANCIAL_INSTRUMENT WHERE INSTRUMENT_TYPE = 110', N'ALL', N'ApexCollateral', 1, NULL, NULL)
GO
INSERT [dbo].[METRIC_DEFINITIONS] ([ID], [NAME], [METRIC_TYPE], [SCRIPT], [DATABASE_TYPE], [DATABASE_SOURCE], [ENABLED], [SLA_METRIC], [COMMENT]) VALUES (221, N'Security Equity Count', N'Database', N'SELECT COUNT(1) AS SecurityEquityCount FROM FINANCIAL_INSTRUMENT WHERE INSTRUMENT_TYPE = 109', N'ALL', N'ApexCollateral', 1, NULL, NULL)
GO
INSERT [dbo].[METRIC_DEFINITIONS] ([ID], [NAME], [METRIC_TYPE], [SCRIPT], [DATABASE_TYPE], [DATABASE_SOURCE], [ENABLED], [SLA_METRIC], [COMMENT]) VALUES (230, N'Payment Instruction Count', N'Database', N'SELECT COUNT(1) AS PaymentInstructionCount FROM PAYMENT_INSTRUCTION', N'ALL', N'ApexCollateral', 1, NULL, NULL)
GO
INSERT [dbo].[METRIC_DEFINITIONS] ([ID], [NAME], [METRIC_TYPE], [SCRIPT], [DATABASE_TYPE], [DATABASE_SOURCE], [ENABLED], [SLA_METRIC], [COMMENT]) VALUES (231, N'Counterparty Settlement Instruction Count', N'Database', N'SELECT COUNT(1) AS SettlementInstructionCount FROM CP_SETTLEMENT_INSTRUCTION', N'ALL', N'ApexCollateral', 1, NULL, NULL)
GO
INSERT [dbo].[METRIC_DEFINITIONS] ([ID], [NAME], [METRIC_TYPE], [SCRIPT], [DATABASE_TYPE], [DATABASE_SOURCE], [ENABLED], [SLA_METRIC], [COMMENT]) VALUES (232, N'Settlement Instruction Count', N'Database', N'SELECT COUNT(1) AS SettlementInstructionCount FROM SETTLEMENT_INSTRUCTION', N'ALL', N'ApexCollateral', 1, NULL, NULL)
GO
INSERT [dbo].[METRIC_DEFINITIONS] ([ID], [NAME], [METRIC_TYPE], [SCRIPT], [DATABASE_TYPE], [DATABASE_SOURCE], [ENABLED], [SLA_METRIC], [COMMENT]) VALUES (240, N'Margin Call Done Count', N'Database', N'SELECT COUNT(1) AS MarginCallDoneCount FROM MARGIN_CALL WHERE PARENT IS NULL AND ACTIVITY = 1000', N'ALL', N'ApexCollateral', 1, NULL, NULL)
GO
INSERT [dbo].[METRIC_DEFINITIONS] ([ID], [NAME], [METRIC_TYPE], [SCRIPT], [DATABASE_TYPE], [DATABASE_SOURCE], [ENABLED], [SLA_METRIC], [COMMENT]) VALUES (241, N'Margin Call Open Count', N'Database', N'SELECT COUNT(1) AS MarginCallOpenCount FROM MARGIN_CALL WHERE PARENT IS NULL AND ACTIVITY <> 1000', N'ALL', N'ApexCollateral', 1, NULL, NULL)
GO
INSERT [dbo].[METRIC_DEFINITIONS] ([ID], [NAME], [METRIC_TYPE], [SCRIPT], [DATABASE_TYPE], [DATABASE_SOURCE], [ENABLED], [SLA_METRIC], [COMMENT]) VALUES (250, N'Exposure Active Count', N'Database', N'SELECT COUNT(1) AS ExposureActiveCount FROM EXTERNAL_EXPOSURE WHERE IS_ACTIVE = 1', N'ALL', N'ApexCollateral', 1, NULL, NULL)
GO
INSERT [dbo].[METRIC_DEFINITIONS] ([ID], [NAME], [METRIC_TYPE], [SCRIPT], [DATABASE_TYPE], [DATABASE_SOURCE], [ENABLED], [SLA_METRIC], [COMMENT]) VALUES (251, N'Exposure Active Assigned Count', N'Database', N'SELECT COUNT(1) AS ExposureActiveAssignedCount FROM EXTERNAL_EXPOSURE WHERE IS_ACTIVE = 1 AND IS_ASSIGNED = 1', N'ALL', N'ApexCollateral', 1, NULL, NULL)
GO
INSERT [dbo].[METRIC_DEFINITIONS] ([ID], [NAME], [METRIC_TYPE], [SCRIPT], [DATABASE_TYPE], [DATABASE_SOURCE], [ENABLED], [SLA_METRIC], [COMMENT]) VALUES (252, N'Exposure Active Not Assigned Count', N'Database', N'SELECT COUNT(1) AS ExposureActiveNotAssignedCount FROM EXTERNAL_EXPOSURE WHERE IS_ACTIVE = 1 AND IS_ASSIGNED = 0', N'ALL', N'ApexCollateral', 1, NULL, NULL)
GO
INSERT [dbo].[METRIC_DEFINITIONS] ([ID], [NAME], [METRIC_TYPE], [SCRIPT], [DATABASE_TYPE], [DATABASE_SOURCE], [ENABLED], [SLA_METRIC], [COMMENT]) VALUES (253, N'Exposure Not Active Count', N'Database', N'SELECT COUNT(1) AS ExposureNotActiveCount FROM EXTERNAL_EXPOSURE WHERE IS_ACTIVE = 0', N'ALL', N'ApexCollateral', 1, NULL, NULL)
GO
INSERT [dbo].[METRIC_DEFINITIONS] ([ID], [NAME], [METRIC_TYPE], [SCRIPT], [DATABASE_TYPE], [DATABASE_SOURCE], [ENABLED], [SLA_METRIC], [COMMENT]) VALUES (500, N'Month Details', N'String', N'Start of Month:  [[resetdate]][[startofmonth]][[fullenglishdate]]
End of Month:    [[resetdate]][[endofmonth]][[fullenglishdate]]', NULL, NULL, 1, NULL, NULL)
GO
INSERT [dbo].[METRIC_DEFINITIONS] ([ID], [NAME], [METRIC_TYPE], [SCRIPT], [DATABASE_TYPE], [DATABASE_SOURCE], [ENABLED], [SLA_METRIC], [COMMENT]) VALUES (150, N'Active Users List (FIS)', N'Database', N'SELECT USER_NAME, CASE WHEN ADMINISTRATOR = 1 THEN ''Yes'' ELSE '''' END AS IS_ADMINISTRATOR FROM USERS WHERE DISABLED = 0 AND DEPARTMENT LIKE ''%FIS%'' ORDER BY USER_NAME', N'ALL', N'ApexCollateral', 1, NULL, NULL)
GO
INSERT [dbo].[METRIC_DEFINITIONS] ([ID], [NAME], [METRIC_TYPE], [SCRIPT], [DATABASE_TYPE], [DATABASE_SOURCE], [ENABLED], [SLA_METRIC], [COMMENT]) VALUES (300, N'Exposures (7 day)', N'Database', N'WITH dates_CTE (DATE) AS (
		SELECT GETDATE() - 7 
	UNION ALL
		SELECT DATEADD(day, 1, DATE)
		FROM dates_CTE
		WHERE DATE < GETDATE()
)
SELECT CONVERT(nvarchar(MAX), DATE, 107) AS CHECK_DATE,
		DATENAME(weekday, DATE) AS WEEKDAY,
		ISNULL(opt.SUCCESS_COUNT, ''0'') AS SUCCESS_COUNT,
		ISNULL(opt.FAILED_COUNT, ''0'') AS FAILED_COUNT
FROM dates_CTE 
LEFT OUTER JOIN (
		SELECT CAST(TIME_STARTED AS DATE) AS OPTDATE,
				COUNT(CASE WHEN STATUS = 3 THEN 1 END) AS SUCCESS_COUNT,
				COUNT(CASE WHEN STATUS = 4 THEN 1 END) AS FAILED_COUNT
		FROM apex.PROCESS_RUN
		WHERE  PROCESS IN (428,430)
		GROUP BY CAST(TIME_STARTED AS DATE)
	) opt ON opt.OPTDATE = CAST(dates_CTE.DATE AS DATE)', N'SQL Server', N'ApexCollateral', 1, NULL, NULL)
GO
INSERT [dbo].[METRIC_DEFINITIONS] ([ID], [NAME], [METRIC_TYPE], [SCRIPT], [DATABASE_TYPE], [DATABASE_SOURCE], [ENABLED], [SLA_METRIC], [COMMENT]) VALUES (301, N'Margin Calls (7 day)', N'Database', N'WITH dates_CTE (DATE) AS (
		SELECT GETDATE() - 7 
	UNION ALL
		SELECT DATEADD(day, 1, DATE)
		FROM dates_CTE
		WHERE DATE < GETDATE()
) 
SELECT CONVERT(nvarchar(MAX), DATE, 107) AS CHECK_DATE,
		DATENAME(weekday, DATE) AS WEEKDAY,
		ISNULL(exo.TOTAL_COUNT, ''0'') AS TOTAL_COUNT,
		CAST(ISNULL(exo.ASSIGNED_COUNT, ''0'') AS INT) AS ASSIGNED_COUNT,
		CAST(ISNULL(exo.ACTIVE_COUNT, ''0'') AS INT) AS ACTIVE_COUNT
FROM dates_CTE 
LEFT OUTER JOIN (
		SELECT CAST(eev.INSERT_DATE_TIME AS DATE) AS OPTDATE,
				COUNT(ex.ID) AS TOTAL_COUNT,
				SUM(ex.IS_ASSIGNED) AS ASSIGNED_COUNT,
				SUM(ex.IS_ACTIVE) AS ACTIVE_COUNT
		FROM apex.[EXTERNAL_EXPOSURE_VALUATION] eev
		JOIN apex.[EXTERNAL_EXPOSURE] ex ON eev.EXTERNAL_EXPOSURE = ex.ID
		JOIN apex.[EXTERNAL_EXPOSURE_TYPE] eet ON ex.[EXTERNAL_EXPOSURE_TYPE] = eet.ID					
		GROUP BY CAST(eev.INSERT_DATE_TIME AS DATE)
	) exo ON exo.OPTDATE = CAST(dates_CTE.DATE AS DATE)
', N'SQL Server', N'ApexCollateral', 1, NULL, NULL)
GO
INSERT [dbo].[METRIC_DEFINITIONS] ([ID], [NAME], [METRIC_TYPE], [SCRIPT], [DATABASE_TYPE], [DATABASE_SOURCE], [ENABLED], [SLA_METRIC], [COMMENT]) VALUES (400, N'Database Usage', N'Database', N'SELECT TOP(20)
	t.NAME AS Table_Name,
	s.Name AS Schema_Name,
	p.rows AS Rows,
	SUM(a.total_pages) * 8 AS Total_Space_KB, 
	SUM(a.used_pages) * 8 AS Used_Space_KB, 
	(SUM(a.total_pages) - SUM(a.used_pages)) * 8 AS Unused_Space_KB
FROM sys.tables t
INNER JOIN sys.indexes i ON t.OBJECT_ID = i.object_id
INNER JOIN sys.partitions p ON i.object_id = p.OBJECT_ID AND i.index_id = p.index_id
INNER JOIN sys.allocation_units a ON p.partition_id = a.container_id
LEFT OUTER JOIN sys.schemas s ON t.schema_id = s.schema_id
WHERE t.NAME NOT LIKE ''dt%'' AND t.is_ms_shipped = 0 AND i.OBJECT_ID > 255 
GROUP BY t.Name, s.Name, p.Rows
ORDER BY Total_Space_KB DESC, t.Name
', N'SQL Server', N'ApexCollateral', 1, NULL, NULL)
GO
INSERT [dbo].[METRIC_DEFINITIONS] ([ID], [NAME], [METRIC_TYPE], [SCRIPT], [DATABASE_TYPE], [DATABASE_SOURCE], [ENABLED], [SLA_METRIC], [COMMENT]) VALUES (401, N'Job Schedues', N'Database', N'SELECT
	S.name AS JOB_NAME,
	SS.name AS SCHEDULE_NAME,
	CASE(SS.freq_type)
		WHEN 1   THEN ''Once''
		WHEN 4   THEN ''Daily''
		WHEN 8   THEN (CASE WHEN (SS.freq_recurrence_factor > 1) THEN ''Every '' + convert(varchar(3),SS.freq_recurrence_factor) + '' Weeks''  ELSE ''Weekly''  END)
		WHEN 16  THEN (CASE WHEN (SS.freq_recurrence_factor > 1) THEN ''Every '' + convert(varchar(3),SS.freq_recurrence_factor) + '' Months'' ELSE ''Monthly'' END)
		WHEN 32  THEN ''Every '' + convert(varchar(3),SS.freq_recurrence_factor) + '' Months'' -- RELATIVE
		WHEN 64  THEN ''SQL Startup''
		WHEN 128 THEN ''SQL Idle''
	ELSE ''''
	END AS FREQUENCY,  
	CASE
		WHEN (freq_type = 1)                       THEN ''One time only''
		WHEN (freq_type = 4 AND freq_interval = 1) THEN ''Every Day''
		WHEN (freq_type = 4 AND freq_interval > 1) THEN ''Every '' + convert(varchar(10),freq_interval) + '' Days''
		WHEN (freq_type = 8) THEN 
			(	SELECT ''Weekly Schedule'' = MIN(D1+D2+D3+D4+D5+D6+D7)
				FROM (
					SELECT SS.schedule_id, freq_interval, 
						''D2'' = CASE WHEN (freq_interval & 2  <> 0) then ''Mon '' ELSE '''' END,
						''D3'' = CASE WHEN (freq_interval & 4  <> 0) then ''Tue '' ELSE '''' END,
						''D4'' = CASE WHEN (freq_interval & 8  <> 0) then ''Wed '' ELSE '''' END,
						''D5'' = CASE WHEN (freq_interval & 16 <> 0) then ''Thu '' ELSE '''' END,
						''D6'' = CASE WHEN (freq_interval & 32 <> 0) then ''Fri '' ELSE '''' END,
						''D7'' = CASE WHEN (freq_interval & 64 <> 0) then ''Sat '' ELSE '''' END,
						''D1'' = CASE WHEN (freq_interval & 1  <> 0) then ''Sun '' ELSE '''' END
					FROM msdb..sysschedules ss
					WHERE freq_type = 8
					) AS F
				WHERE schedule_id = SJ.schedule_id
			)
		WHEN (freq_type = 16) THEN ''Day '' + convert(varchar(2),freq_interval) 
		WHEN (freq_type = 32) THEN 
			(	SELECT  freq_rel + WDAY 
				FROM 
					(	SELECT SS.schedule_id,
							''freq_rel'' = CASE(freq_relative_interval)
								WHEN 1 THEN ''First''
								WHEN 2 THEN ''Second''
								WHEN 4 THEN ''Third''
								WHEN 8 THEN ''Fourth''
								WHEN 16 THEN ''Last''
								ELSE ''''
							END,
							''WDAY'' = CASE (freq_interval)
								WHEN 1 THEN '' Sun''
								WHEN 2 THEN '' Mon''
								WHEN 3 THEN '' Tue''
								WHEN 4 THEN '' Wed''
								WHEN 5 THEN '' Thu''
								WHEN 6 THEN '' Fri''
								WHEN 7 THEN '' Sat''
								WHEN 8 THEN '' Day''
								WHEN 9 THEN '' Weekday''
								WHEN 10 THEN '' Weekend''
								ELSE ''''
							END
						FROM msdb..sysschedules SS
						WHERE SS.freq_type = 32
						) AS WS 
				WHERE WS.schedule_id = SS.schedule_id
				) 
	END AS INTERVAL,
	LEFT(stuff((stuff((replicate(''0'', 6 - len(active_start_time)))+ convert(varchar(6),active_start_time),3,0,'':'')),6,0,'':''),8) AS START_TIME,
	CASE (freq_subday_type)
		WHEN 1 THEN ''Once''
		WHEN 2 THEN ''Every '' + convert(varchar(10),freq_subday_interval) + '' seconds''
		WHEN 4 THEN ''Every '' + convert(varchar(10),freq_subday_interval) + '' minutes''
		WHEN 8 THEN ''Every '' + convert(varchar(10),freq_subday_interval) + '' hours''
		ELSE ''''
	END AS DAILY_FREQUENCY,
	LEFT(stuff((stuff((replicate(''0'', 6 - len(active_end_time)))+ convert(varchar(6),active_end_time),3,0,'':'')),6,0,'':''),8) AS END_TIME,
	LEFT(CAST(next_run_date AS VARCHAR),4)+ ''-''
		+ SUBSTRING(CAST(next_run_date AS VARCHAR),5,2)+''-''
		+ SUBSTRING(CAST(next_run_date AS VARCHAR),7,2) NextRunDate,
	CASE SJ.NEXT_RUN_DATE
		WHEN 0 THEN cast(''n/a'' as char(10))
		ELSE left(stuff((stuff((replicate(''0'', 6 - len(next_run_time)))
			+ convert(varchar(6),next_run_time),3,0,'':'')),6,0,'':''),8)
	END AS NEXT_RUN_TIME,
	SS.enabled AS SCHEDULE_ENABLED
FROM msdb.dbo.sysjobs S
	LEFT JOIN msdb.dbo.sysjobschedules SJ ON S.job_id = SJ.job_id  
	LEFT JOIN msdb.dbo.sysschedules SS ON SS.schedule_id = SJ.schedule_id
WHERE S.name NOT IN (''syspolicy_purge_history'', ''Revoke access'') AND S.name NOT LIKE ''000%'' AND S.name NOT LIKE ''DBA%''
ORDER BY S.name, SS.name
', N'SQL Server', N'ApexCollateral', 0, NULL, NULL)
GO
INSERT [dbo].[METRIC_DEFINITIONS] ([ID], [NAME], [METRIC_TYPE], [SCRIPT], [DATABASE_TYPE], [DATABASE_SOURCE], [ENABLED], [SLA_METRIC], [COMMENT]) VALUES (501, N'Apex Environment Configuration', N'JSON', N'[
{"Metric": "Servers - Database", "Value": "${Servers:databaseServer}"},
{"Metric": "Servers - Connectivity", "Value": "${Servers:connectivityServer}"},
{"Metric": "Servers - Application", "Value": "${Servers:applicationServer}"},
{"Metric": "Servers - Citrix", "Value": "${Servers:terminalServer}"},
{"Metric": "EMail - SMTP Server", "Value": "${Email:server}"},
{"Metric": "EMail - External Status Address", "Value": "${EmailGroups:externalStatusReport}"},
{"Metric": "Alert - EMail Address", "Value": "${Alerting:toAddress}"},
{"Metric": "SLA - EMail Address", "Value": "${SLA:toAddress}"},
{"Metric": "SLA - Exclusions", "Value": "${SLA:exclusions}"},
{"Metric": "Holiday statement", "Value": "[[listodayaholidaystatement]]"},
{"Metric": "Is today a holiday", "Value": "[[istodayaholiday]]"},
{"Metric": "Archive Retention - Margin Calls in Live (days)", "Value": "${ArchiveRetention:keepLastxDaysOfMarginCallsInLive}"},
{"Metric": "Archive Retention - Margin Calls in Archive (days)", "Value": "${ArchiveRetention:keepLastxDaysOfMarginCalls}"},
{"Metric": "Archive Retention - Trades in Live (days)", "Value": "${ArchiveRetention:keepLastxDaysOfTradesInLive}"},
{"Metric": "Archive Retention - Trades in Archive (days)", "Value": "${ArchiveRetention:keepLastxDaysOfTrades}"},
{"Metric": "Archive Retention - Workflows in Live (days)", "Value": "${ArchiveRetention:keepLastxDaysOfSimpleWorkItemsInLive}"},
{"Metric": "Archive Retention - Workflows in Archive (days)", "Value": "${ArchiveRetention:keepLastxDaysOfSimpleWorkItems}"},
{"Metric": "Archive Retention - Corporate Actions in Live (days)", "Value": "${ArchiveRetention:keepLastxDaysOfCorpActionsInLive}"},
{"Metric": "Archive Retention - Corporate Actions in Archive (days)", "Value": "${ArchiveRetention:keepLastxDaysOfCorpActions}"},
{"Metric": "Archive Retention - Exposures in Live (days)", "Value": "${ArchiveRetention:keepLastxDaysOfExposures}"},
{"Metric": "Archive Retention - Prices in Live (days)", "Value": "${ArchiveRetention:keepLastxDaysOfPrices}"},
{"Metric": "Archive Retention - Processes in Live (days)", "Value": "${ArchiveRetention:keepLastxDaysOfProcesses}"},
{"Metric": "Archive Retention - Corporate Actions in Live (days)", "Value": "${ArchiveRetention:keepLastxDaysOfCorpActions}"},
{"Metric": "File Retention - Drop Files in Archive (newest x files)", "Value": "${ArchiveRetention:dropKeepTopNewestFiles}"},
{"Metric": "File Retention - Log Files in Archive (newest x files)", "Value": "${ArchiveRetention:logsKeepTopNewestFiles}"},
{"Metric": "File Retention - Daily Archive (newest x files)", "Value": "${ArchiveRetention:dailyArchiveKeepTopNewestFiles}"},
{"Metric": "File Retention - User Reports in Live (days)", "Value": "${ArchiveRetention:keepLastxDaysOfReportFiles}"},
{"Metric": "File Retention - User Reports in Archive (newest x files)", "Value": "${ArchiveRetention:reportsKeepTopNewestArchiveFiles}"}
]', NULL, NULL, 1, NULL, NULL)
GO
