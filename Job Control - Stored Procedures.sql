# Apex Common Scripting Environment
#
# Module - Splunk reporting
# ----------------------------------------------
# v001 - 04 Mar 2025 - UJ - Initial
# ----------------------------------------------

# Import python libraries
from datetime import datetime
import time

# Import local libraries
import os
import subprocess
from jobdatabase import databaseDirect
from jobutils import windows
import psutil


# -----------------------------------------------------
# Runs Create a log file to add Environment Versions Details
def runGenerateEnvironmentDetailsLog(env):

	environmentAndVersionDetailsFolderPath = env.config.get(env.currentTask, 'environmentAndVersionDetailsFolderPath', fallback='')
	environmentAndVersionDetailsfileName = env.config.get(env.currentTask, 'logFileName', fallback='')

	runAddEnvironmentAndVersionDataToLogFile(env,environmentAndVersionDetailsFolderPath,environmentAndVersionDetailsfileName )

	return

# -----------------------------------------------------
# Runs Create a log file to add Environment Versions Details
def runGenerateJobDetailsLog(env):

	jobDetailsFolderPath = env.config.get(env.currentTask, 'jobDetailsFolderPath', fallback='')
	jobDetailsfileName = env.config.get(env.currentTask, 'logFileName', fallback='')

	runJobDataToLogFile(env,jobDetailsFolderPath,jobDetailsfileName )

	return

# -----------------------------------------------------
# Generate Stats and append to the log file
def runAddEnvironmentAndVersionDataToLogFile(env, folderPath,fileName):

	environmentAndVersionDetailsFilePath = folderPath+fileName

	#Create file if it does not exist
	if os.path.isfile(environmentAndVersionDetailsFilePath) == False:
		print("file does not exists, creating new")
		#Create a New Log File and add Headers
		f = open(environmentAndVersionDetailsFilePath, "w")
		f.write('TIME,SERVERNAME,ENVIRONMENTTYPE,TIMEZONE,MEMORY SIZE,SFTC VERSION,JAVA VERSION,PYTHON VERSION,JOBCONTROL VERSION,ACTIVEMQ VERSION,SQL SERVER VERSION,SQL STUDIO VERSION,DB RECOVERY MODE,APEXCOLLATERAL DB SIZE,JOBCONTROL DB SIZE,APEXCOLLATERAL DB LOG SIZE,JOBCONTROL DB LOG SIZE,ARCHIVE RETENTION FOR MARGIN CALLS IN LIVE,ARCHIVE RETENTION FOR MARGIN CALLS IN ARCHIVE,ARCHIVE RETENTION FOR TRADES IN LIVE,ARCHIVE RETENTION FOR TRADES IN ARCHIVE,ARCHIVE RETENTION FOR WORKFLOWS IN LIVE,ARCHIVE RETENTION FOR WORKFLOWS IN ARCHIVE,ARCHIVE RETENTION FOR CORPORATE ACTIONS IN LIVE,ARCHIVE RETENTION FOR CORPORATE ACTIONS IN ARCHIVE,ARCHIVE RETENTION FOR EXPOSURES IN LIVE,ARCHIVE RETENTION FOR PRICES IN LIVE,ARCHIVE RETENTION FOR PROCESSES IN LIVE,ARCHIVE RETENTION FOR CORPORATE ACTIONS IN LIVE,FILE RETENTION FOR DROP FILES IN ARCHIVE,FILE RETENTION FOR LOG FILES IN ARCHIVE,FILE RETENTION FOR DAILY ARCHIVE,FILE RETENTION FOR USER REPORTS IN LIVE,FILE RETENTION FOR USER REPORTS IN ARCHIVE' + '\n')

		f.close()

	#Continue now as file created(if did not exist earlier)
 	#----------------------------------------------Get Data

	#Date
	dateAndTime = datetime.now().strftime("%Y-%m-%d %H:%M:%S")

	#SERVER NAME
	serverName = env.server

	#ENVironment type
	environmentType=env.environmentType
	#environmentType='POC'

	#Get Timezone
	timezone=get_server_timezone(env)
 
	#Get Ram Size
	memory_info = get_ram_size_windows(env)	

	#JAVA VERSION
	javaVersion = getVersionUsingCmd('java')

	#PYTHON VERSION
	pythonVersion = getVersionUsingCmd('python')

	#SFTC VERSION
	directory_path = os.path.join(env.rootDir, 'Apex', 'client','lib')
	file_prefix='client-'
	sftcVersion = getVersionFromJar(directory_path, file_prefix)

	#JobControlVersion
	jobControlVersion =	env.jobControlVersion

	#ActiveMQVersion
	directory_path = os.path.join(env.rootDir, 'Active MQ Artemis', 'lib')
	file_prefix = 'artemis-commons-'
	activeMQVersion = getVersionFromJar(directory_path, file_prefix)

	#SQL ServerVersion
	database = "ApexCollateral"
	sqlServerVersion=getSQLServerVersion(env,database)

	#SQL Studio Version
	sqlStudioVersion = getSQLStudioVersion(env,database)

 	#SQL Server Recovery Model
	sqlServerRecoveryModel=getSQLServerRecoveryModelData(env,database)

	#ApexCollateralDBSize
	database = "ApexCollateral"
	apexDatabaseSizeDataInMB=getDatabaseSize(env,database)

	#ApexCollateralJobCOntrol Size
	database = "JobControl"
	jobControlDatabaseSizeDataInMB=getDatabaseSize(env,database)

	#ApexCollateralJobCOntrolLog Size
	database = "JobControl"
	jobControlLogSize=getDatabaseLogSize(env,database)

	#ApexCollateral db log size
	database = "ApexCollateral"
	apexCollateralLogSize=getDatabaseLogSize(env,database)

	# Get Archive Retention for Margin Calls in Live (days)
	getRetentionForMarginCallsInLive = getArchiveRetention(env, 'keepLastxDaysOfMarginCallsInLive')


	# Get Archive Retention for Margin Calls in Archive (days)
	getRetentionForMarginCallsInArchive = getArchiveRetention(env, 'keepLastxDaysOfMarginCalls')


	# Get Archive Retention for Trades in Live (days)
	getRetentionForTradesInLive = getArchiveRetention(env, 'keepLastxDaysOfTradesInLive')


	# Get Archive Retention for Trades in Archive (days)
	getRetentionForTradesInArchive = getArchiveRetention(env, 'keepLastxDaysOfTrades')


	# Get Archive Retention for Workflows in Live (days)
	getRetentionForWorkflowsInLive = getArchiveRetention(env, 'keepLastxDaysOfSimpleWorkItemsInLive')


	# Get Archive Retention for Workflows in Archive (days)
	getRetentionForWorkflowsInArchive = getArchiveRetention(env, 'keepLastxDaysOfSimpleWorkItems')


	# Get Archive Retention for Corporate Actions in Live (days)
	getRetentionForCorpActionsInLive = getArchiveRetention(env, 'keepLastxDaysOfCorpActionsInLive')


	# Get Archive Retention for Corporate Actions in Archive (days)
	getRetentionForCorpActionsInArchive = getArchiveRetention(env, 'keepLastxDaysOfCorpActions')


	# Get Archive Retention for Exposures in Live (days)
	getRetentionForExposuresInLive = getArchiveRetention(env, 'keepLastxDaysOfExposures')


	# Get Archive Retention for Prices in Live (days)
	getRetentionForPricesInLive = getArchiveRetention(env, 'keepLastxDaysOfPrices')


	# Get Archive Retention for Processes in Live (days)
	getRetentionForProcessesInLive = getArchiveRetention(env, 'keepLastxDaysOfProcesses')



	# Get Archive Retention for Corporate Actions in Live (days)
	getRetentionForCorpActionsInLive = getArchiveRetention(env, 'keepLastxDaysOfCorpActions')


	# Get File Retention for Drop Files in Archive (newest x files)
	getRetentionForDropFilesInArchive = getArchiveRetention(env, 'dropKeepTopNewestFiles')


	# Get File Retention for Log Files in Archive (newest x files)
	getRetentionForLogFilesInArchive = getArchiveRetention(env, 'logsKeepTopNewestFiles')


	# Get File Retention for Daily Archive (newest x files)
	getRetentionForDailyArchive = getArchiveRetention(env, 'dailyArchiveKeepTopNewestFiles')


	# Get File Retention for User Reports in Live (days)
	getRetentionForReportFilesInLive = getArchiveRetention(env, 'keepLastxDaysOfReportFiles')


	# Get File Retention for User Reports in Archive (newest x files)
	getRetentionForReportFilesInArchive = getArchiveRetention(env, 'reportsKeepTopNewestArchiveFiles')


	#get hash of all the files
	#directoryCheckSum=generate_directory_checksum(env,)

	f = open(environmentAndVersionDetailsFilePath, "a")
	f.write(f"{dateAndTime},{serverName},{environmentType},{timezone},{memory_info},{sftcVersion},{javaVersion},{pythonVersion},{jobControlVersion},{activeMQVersion},{sqlServerVersion},{sqlStudioVersion},{sqlServerRecoveryModel},{apexDatabaseSizeDataInMB},{jobControlDatabaseSizeDataInMB},{apexCollateralLogSize},{jobControlLogSize},{getRetentionForMarginCallsInLive},{getRetentionForMarginCallsInArchive},{getRetentionForTradesInLive},{getRetentionForTradesInArchive},{getRetentionForWorkflowsInLive},{getRetentionForWorkflowsInArchive},{getRetentionForCorpActionsInLive},{getRetentionForCorpActionsInArchive},{getRetentionForExposuresInLive},{getRetentionForPricesInLive},{getRetentionForProcessesInLive},{getRetentionForCorpActionsInLive},{getRetentionForDropFilesInArchive},{getRetentionForLogFilesInArchive},{getRetentionForDailyArchive},{getRetentionForReportFilesInLive},{getRetentionForReportFilesInArchive}" + '\n')

	f.close()


	return


# ----------------------------------------------
# Get Server RAM Size
def get_ram_size_windows(env):
	stream = os.popen('wmic computersystem get TotalPhysicalMemory')
	output = stream.read().strip().split()
	if output and output[-1].isdigit():
		ram_bytes = int(output[-1])
		ram_gb = ram_bytes / (1024 ** 3)
		return f"{ram_gb:.2f} GB"
	return "NA."

# ----------------------------------------------------
# get Server TimeZone
def get_server_timezone(env):
    if time.daylight and time.localtime().tm_isdst:
        tz_name = time.tzname[1]  # Daylight Saving Time zone name
        offset = -time.altzone
    else:
        tz_name = time.tzname[0]  # Standard Time zone name
        offset = -time.timezone

    hours = offset // 3600
    minutes = (offset % 3600) // 60
    sign = '+' if hours >= 0 else '-'
    offset_str = f"UTC{sign}{abs(hours):02d}:{abs(minutes):02d}"

    return f"{tz_name} ({offset_str})"



# -----------------------------------------------------
# Generate Stats and append to the log file
def runJobDataToLogFile(env, folderPath,fileName):

	jobDetailsFilePath = folderPath+fileName

	#Create file if it does not exist
	if os.path.isfile(jobDetailsFilePath) == False:
		print("file does not exists, creating new")
		#Create a New Log File and add Headers
		f = open(jobDetailsFilePath, "w")
		f.write('TIME,SERVER_NAME,ENVIRONMENT_TYPE,JOB_NAME,SCHEDULE_NAME,JOB_ENABLED,FREQUENCY,INTERVAL,START_TIME,DAILY_FREQUENCY,END_TIME,NextRunDate,NEXT_RUN_TIME,SCHEDULE_ENABLED,OWNER_SID,JOB_CATEGORY,SCHEDULE_OWNER_SID')

		f.close()

	#Continue now as file created(if did not exist earlier)
 	#----------------------------------------------Get Data

	#Date
	dateAndTime = datetime.now().strftime("%Y-%m-%d %H:%M:%S")

	#SERVER NAME
	serverName = env.server

 	#ENVironment type
	environmentType=env.environmentFullName
	database = "JobControl"

	jobDetails=getJobDetails(env,database)
	f = open(jobDetailsFilePath, "a")

	for job in jobDetails:
		jobName = job[0]
		scheduleName = job[1]
		jobEnabled = job[2]
		frequency = job[3]
		interval = job[4]
		startTime = job[5]
		dailyFrequency = job[6]
		endTime = job[7]
		nextRunDate = job[8]
		nextRunTime = job[9]
		scheduleEnabled = job[10]
		ownerSid = job[11]
		jobCategory = job[12]
		scheduleOwnerSid = job[13]

		f.write(f"{dateAndTime},{serverName},{environmentType},{jobName},{scheduleName},{jobEnabled},{frequency},{interval},{startTime},{dailyFrequency},{endTime},{nextRunDate},{nextRunTime},{scheduleEnabled},{ownerSid},{jobCategory},{scheduleOwnerSid}"+ '\n')
	f.close()

	return


# Function to get the version number from a command
def getVersionUsingCmd(name):
	try:
		# Run the command
		if name =='python':
			result = subprocess.run([name,'--version'],stdout=subprocess.PIPE, text=True)
			output = result.stdout
			version= output.split()[1]

		elif name =='java':
			result = subprocess.run([name,'-version'], stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
			output = result.stderr
			# Extract the version number
			if 'version' in output:
				version_line = output.splitlines()[0]
				version = version_line.split('"')[1]
			else:
				version = 'Error'

	except FileNotFoundError:
		version = f"Error"

	return version

# Function to get the version number from a file name in a directory
def getVersionFromJar(directory_path, file_prefix):

	if os.path.exists(directory_path):
		# List all files in the directory
		files = os.listdir(directory_path)
		versionNumber = ''

		for file_name in files:
			# Check if the file name starts with the given prefix
			if file_name.startswith(file_prefix):
				# Remove the prefix and '.jar' from the file name
				versionNumber = file_name.replace(file_prefix, '').replace('.jar', '')
	else:
		versionNumber = f'{file_prefix} does not exist'

	return versionNumber

# Function to get SQL Server Version
def getSQLServerVersion(env,database):
	sqlQueryString = """DECLARE @VersionInfo VARCHAR(128);
	SET @VersionInfo = (SELECT @@VERSION);

	SELECT
		SUBSTRING(
			@VersionInfo,
			CHARINDEX('Microsoft SQL Server', @VersionInfo),
			CHARINDEX(' - ', @VersionInfo, CHARINDEX('Microsoft SQL Server', @VersionInfo)) - CHARINDEX('Microsoft SQL Server', @VersionInfo)
		) AS [SQL Server Version];

	"""
	sqlParameters = ()
	# Execute SQL statement without any results
	sqlServerVersionData = databaseDirect.executeSQLStatementWithResult(env, database, sqlQueryString, sqlParameters)
	sqlServerVersion=sqlServerVersionData[0][0]
	return sqlServerVersion

# Function to get SQL Studio Version
def getSQLStudioVersion(env,database):
	# Create SQL Statement and assign parameters
	sqlQueryString = '''DECLARE @VersionInfo VARCHAR(128);
	SET @VersionInfo = (SELECT @@VERSION);

	SELECT
	SUBSTRING(
		@VersionInfo,
		CHARINDEX(' - ', @VersionInfo) + 3,
		CHARINDEX(' ', @VersionInfo, CHARINDEX(' - ', @VersionInfo) + 3) - CHARINDEX(' - ', @VersionInfo) - 3
	) AS SQLServer_Version;'''

	sqlParameters = ()
	# Execute SQL statement without any results
	sqlStudioVersionData = databaseDirect.executeSQLStatementWithResult(env, database, sqlQueryString, sqlParameters)
	sqlStudioVersion=sqlStudioVersionData[0][0]
	return sqlStudioVersion

# Function to get Recovery Model
def getSQLServerRecoveryModelData(env,database):

	#SQL Server Recovery Model

	sqlQueryString=""" SELECT
	name AS DatabaseName,
	recovery_model_desc AS RecoveryModel
	FROM
		sys.databases
	WHERE
	name = ? """

	apexdbName=env.config.get('ApexCollateralDatabase', 'databasename')
	sqlParameters = (apexdbName)
	# Execute SQL statement without any results
	sqlServerRecoveryModelData = databaseDirect.executeSQLStatementWithResult(env, database, sqlQueryString, sqlParameters)
	sqlServerRecoveryModel=sqlServerRecoveryModelData[0][1]
	return sqlServerRecoveryModel

# Function to get Database Size in MB
def getDatabaseSize(env,database):
	sqlQueryString = '''SELECT
	DB_NAME() AS [database_name],
	CONCAT(CAST(SUM(
		CAST( (size * 8.0/1024) AS DECIMAL(15,2) )
	) AS VARCHAR(20)),' MB') AS [database_size]
	FROM sys.database_files
	where type_desc = 'ROWS';'''

	sqlParameters = ()
	# Execute SQL statement without any results
	databaseSizeData = databaseDirect.executeSQLStatementWithResult(env, database, sqlQueryString, sqlParameters)

	databaseSizeDataInMB=databaseSizeData[0][1]
	return databaseSizeDataInMB

# Function to get Database Log Size in MB
def getDatabaseLogSize(env,database):  # Work out lookup string for database in config
	# databaseConfig = database + 'Database'
	# dbName = env.config.get(databaseConfig, 'databasename')
	sqlQueryString = '''SELECT DB_NAME() AS [database_name],CONCAT(CAST(SUM(
		CAST( (size * 8.0/1024) AS DECIMAL(15,2) )
	) AS VARCHAR(20)),' MB') AS [log_size]
	FROM sys.database_files
	where type_desc = 'LOG';'''

	sqlParameters = ()
	# Execute SQL statement without any results
	databaseLogSizeData = databaseDirect.executeSQLStatementWithResult(env, database, sqlQueryString, sqlParameters)
	# print(databaseLogSizeData)
	databaseSizeLogDataInMB=databaseLogSizeData[0][1]
	return databaseSizeLogDataInMB

# Function to get Service Status
def getServiceStatus(env,serviceName):
	try:
		serviceData = psutil.win_service_get(serviceName)
		# Get enum of service information
		serviceData = serviceData.as_dict()
		serviceStatus= serviceData['status'].lower()

	except Exception as e:
		base_message = str(e).split(')')[0]
		#serviceStatus = (f"An error occurred: {base_message}")
		serviceStatus = 'Error'

	return serviceStatus

# Function to get Archive Retention Value
def getArchiveRetention(env,archiveRetentionFor):
	retentionValue = env.config.get('ArchiveRetention', archiveRetentionFor, fallback='NA')

	return retentionValue

# Function to get SQL Studio Version
def getJobDetails(env,database):
	print(database)

	# Create SQL Statement and assign parameters
	sqlQueryString = '''
DECLARE @JobPrefix Varchar(255)

	SELECT @JobPrefix = [VALUE] FROM SETTINGS WHERE [KEY] = 'JobPrefix';

	IF @JobPrefix IS NULL
	BEGIN
		SELECT @JobPrefix = ''
	END;
	
	
			
			
 
SELECT
    S.name AS JOB_NAME,
    SS.name AS SCHEDULE_NAME,
    S.enabled AS JOB_ENABLED,
    CASE(SS.freq_type)
        WHEN 1   THEN 'Once'
        WHEN 4   THEN 'Daily'
        WHEN 8   THEN (CASE WHEN (SS.freq_recurrence_factor > 1) THEN 'Every ' + convert(varchar(3),SS.freq_recurrence_factor) + ' Weeks'  ELSE 'Weekly'  END)
        WHEN 16  THEN (CASE WHEN (SS.freq_recurrence_factor > 1) THEN 'Every ' + convert(varchar(3),SS.freq_recurrence_factor) + ' Months' ELSE 'Monthly' END)
        WHEN 32  THEN 'Every ' + convert(varchar(3),SS.freq_recurrence_factor) + ' Months' -- RELATIVE
        WHEN 64  THEN 'SQL Startup'
        WHEN 128 THEN 'SQL Idle'
    ELSE ''
    END AS FREQUENCY,
    CASE
        WHEN (freq_type = 1)                       THEN 'One time only'
        WHEN (freq_type = 4 AND freq_interval = 1) THEN 'Every Day'
        WHEN (freq_type = 4 AND freq_interval > 1) THEN 'Every ' + convert(varchar(10),freq_interval) + ' Days'
        WHEN (freq_type = 8) THEN
            (   SELECT 'Weekly Schedule' = MIN(D1+D2+D3+D4+D5+D6+D7)
                FROM (
                    SELECT SS.schedule_id, freq_interval,
                        'D2' = CASE WHEN (freq_interval & 2  <> 0) then 'Mon ' ELSE '' END,
                        'D3' = CASE WHEN (freq_interval & 4  <> 0) then 'Tue ' ELSE '' END,
                        'D4' = CASE WHEN (freq_interval & 8  <> 0) then 'Wed ' ELSE '' END,
                        'D5' = CASE WHEN (freq_interval & 16 <> 0) then 'Thu ' ELSE '' END,
                        'D6' = CASE WHEN (freq_interval & 32 <> 0) then 'Fri ' ELSE '' END,
                        'D7' = CASE WHEN (freq_interval & 64 <> 0) then 'Sat ' ELSE '' END,
                        'D1' = CASE WHEN (freq_interval & 1  <> 0) then 'Sun ' ELSE '' END
                    FROM msdb..sysschedules ss
                    WHERE freq_type = 8
                    ) AS F
                WHERE schedule_id = SJ.schedule_id
            )
        WHEN (freq_type = 16) THEN 'Day ' + convert(varchar(2),freq_interval)
        WHEN (freq_type = 32) THEN
            (   SELECT  freq_rel + WDAY
                FROM
                    (   SELECT SS.schedule_id,
                            'freq_rel' = CASE(freq_relative_interval)
                                WHEN 1 THEN 'First'
                                WHEN 2 THEN 'Second'
                                WHEN 4 THEN 'Third'
                                WHEN 8 THEN 'Fourth'
                                WHEN 16 THEN 'Last'
                                ELSE ''
                            END,
                            'WDAY' = CASE (freq_interval)
                                WHEN 1 THEN ' Sun'
                                WHEN 2 THEN ' Mon'
                                WHEN 3 THEN ' Tue'
                                WHEN 4 THEN ' Wed'
                                WHEN 5 THEN ' Thu'
                                WHEN 6 THEN ' Fri'
                                WHEN 7 THEN ' Sat'
                                WHEN 8 THEN ' Day'
                                WHEN 9 THEN ' Weekday'
                                WHEN 10 THEN ' Weekend'
                                ELSE ''
                            END
                        FROM msdb..sysschedules SS
                        WHERE SS.freq_type = 32
                        ) AS WS
                WHERE WS.schedule_id = SS.schedule_id
                )
    END AS INTERVAL,
    LEFT(stuff((stuff((replicate('0', 6 - len(active_start_time)))+ convert(varchar(6),active_start_time),3,0,':')),6,0,':'),8) AS START_TIME,
    CASE (freq_subday_type)
        WHEN 1 THEN 'Once'
        WHEN 2 THEN 'Every ' + convert(varchar(10),freq_subday_interval) + ' seconds'
        WHEN 4 THEN 'Every ' + convert(varchar(10),freq_subday_interval) + ' minutes'
        WHEN 8 THEN 'Every ' + convert(varchar(10),freq_subday_interval) + ' hours'
        ELSE ''
    END AS DAILY_FREQUENCY,
    LEFT(stuff((stuff((replicate('0', 6 - len(active_end_time)))+ convert(varchar(6),active_end_time),3,0,':')),6,0,':'),8) AS END_TIME,
    LEFT(CAST(next_run_date AS VARCHAR),4)+ '-'
        + SUBSTRING(CAST(next_run_date AS VARCHAR),5,2)+'-'
        + SUBSTRING(CAST(next_run_date AS VARCHAR),7,2) NextRunDate,
    CASE SJ.NEXT_RUN_DATE
        WHEN 0 THEN cast('n/a' as char(10))
        ELSE left(stuff((stuff((replicate('0', 6 - len(next_run_time)))
            + convert(varchar(6),next_run_time),3,0,':')),6,0,':'),8)
    END AS NEXT_RUN_TIME,
    SS.enabled AS SCHEDULE_ENABLED,
    SUSER_SNAME(S.owner_sid) AS OWNER_SID,
    SC.name AS JOB_CATEGORY,
    SUSER_SNAME(SS.owner_sid) AS SCHEDULE_OWNER_SID
FROM msdb.dbo.sysjobs S
    LEFT JOIN msdb.dbo.sysjobschedules SJ ON S.job_id = SJ.job_id
    LEFT JOIN msdb.dbo.sysschedules SS ON SS.schedule_id = SJ.schedule_id
    LEFT JOIN msdb.dbo.syscategories SC ON S.category_id = SC.category_id
WHERE S.name NOT IN ('syspolicy_purge_history', 'Revoke access') 
    AND S.name NOT LIKE '000%'
    AND S.name NOT LIKE 'DBA%'
    AND S.name NOT LIKE 'DatabaseIntegrityCheck%'
    AND S.name NOT LIKE 'IndexOptimize%'
    AND S.name NOT LIKE 'Admin%'
    AND S.name NOT LIKE 'sp_%'
    AND S.name NOT LIKE 'CommandLog%'
    AND S.name NOT LIKE 'Log Drive%'
    AND S.name NOT LIKE 'Output File%'
    AND (
        S.name LIKE @JobPrefix  + 'APEX%'
        OR S.name LIKE @JobPrefix + 'Monitor%'
        OR S.name LIKE @JobPrefix + 'Application_%'
        OR S.name LIKE @JobPrefix + 'SLA_%'
		OR S.name LIKE  '%Admin%'
		OR S.name LIKE  '%Break%'
    )
ORDER BY S.name, SS.name;'''

	sqlParameters = ()
	# Execute SQL statement without any results
	jobDetails = databaseDirect.executeSQLStatementWithResult(env, database, sqlQueryString, sqlParameters)
	print(jobDetails)
	return jobDetails


def generate_directory_checksum(env,directory_path):


	checksum = 0

	# Iterate over all files in the directory and subdirectories
	for root, dirs, files in os.walk(directory_path):
		for file in files:
			if file.endswith('.py'):
				file_path = os.path.join(root, file)
				with open(file_path, 'r', encoding='utf-8') as f:
					file_contents = f.read()
					checksum += sum(ord(char) for char in file_contents)

	# Return the checksum as a hexadecimal string
	return hex(checksum)