
-- Need to be a sysadmin to run this script


-- Set OLE Automation on the whole database server

sp_configure 'show advanced options', 1 
GO 
RECONFIGURE; 
GO 
sp_configure 'Ole Automation Procedures', 1 
GO 
RECONFIGURE; 
GO 
sp_configure 'show advanced options', 1 
GO 
RECONFIGURE;


-- Set db_executor role on both ApexCollateral and JobControl databases

PRINT 'Creating db_executor roles on ApexCollateral_[[EnvironmentName]]'

USE ApexCollateral_[[EnvironmentName]]

IF DATABASE_PRINCIPAL_ID('db_executor') IS NULL
	CREATE ROLE db_executor
	
GRANT EXECUTE TO db_executor
GO

PRINT 'Creating db_executor roles on JobControl_[[EnvironmentName]]'

USE JobControl_[[EnvironmentName]]

IF DATABASE_PRINCIPAL_ID('db_executor') IS NULL
	CREATE ROLE db_executor

GRANT EXECUTE TO db_executor
GO


-- Set Read Committed Snapshot on Collateral database

PRINT 'Set Read Committed Snapshot on [[collateralDatabaseName]]'

USE [master]
GO
ALTER DATABASE [[[collateralDatabaseName]]] SET READ_COMMITTED_SNAPSHOT ON WITH NO_WAIT
GO


-- Drop all existing users on ApexCollateral database

USE [[[CollateralDatabaseName]]]
GO

PRINT 'Dropping users on [[collateralDatabaseName]]'

DECLARE @username VARCHAR(255)  
DECLARE @cmd NVARCHAR(500)  

DECLARE UserCursor CURSOR FOR  
	SELECT name FROM sys.database_principals  
	WHERE (type='S' or type = 'U' or type = 'G')
	AND name NOT IN ('dbo', 'INFORMATION_SCHEMA', 'sys', 'guest')
	
OPEN UserCursor  
FETCH NEXT FROM UserCursor INTO @username  
WHILE @@FETCH_STATUS = 0  
BEGIN 
	PRINT 'Dropping user: ' + @username
	SET @cmd = 'DROP USER ['  + @username + ']'  
	EXEC (@cmd)  
	-- Next user
	FETCH NEXT FROM UserCursor INTO @username  
END 

CLOSE UserCursor  
DEALLOCATE UserCursor 
GO	


-- Drop all existing users on Job Control database

USE [[[jobControlDatabaseName]]]
GO

PRINT 'Dropping users on [[jobControlDatabaseName]]'

DECLARE @username VARCHAR(255)  
DECLARE @cmd NVARCHAR(500)  

DECLARE UserCursor CURSOR FOR  
	SELECT name FROM sys.database_principals  
	WHERE (type='S' or type = 'U' or type = 'G')
	AND name NOT IN ('dbo', 'INFORMATION_SCHEMA', 'sys', 'guest')
	
OPEN UserCursor  
FETCH NEXT FROM UserCursor INTO @username  
WHILE @@FETCH_STATUS = 0  
BEGIN 
	PRINT 'Dropping user: ' + @username
	SET @cmd = 'DROP USER ['  + @username + ']'  
	EXEC (@cmd)  
	-- Next user
	FETCH NEXT FROM UserCursor INTO @username  
END 

CLOSE UserCursor  
DEALLOCATE UserCursor 
GO	


-- Drop users on msdb

USE [msdb]
GO

PRINT 'Dropping User [[DatabaseApexUser]] on msdb'

IF DATABASE_PRINCIPAL_ID(N'[[DatabaseApexUser]]') IS NOT NULL
	DROP USER [[[DatabaseApexUser]]]
GO

PRINT 'Dropping User [[GroupDomain]]\[[GroupAppAdm]] on msdb'

IF DATABASE_PRINCIPAL_ID(N'[[GroupDomain]]\[[GroupAppAdm]]') IS NOT NULL
	DROP USER [[[GroupDomain]]\[[GroupAppAdm]]]
GO

PRINT 'Dropping User [[GroupDomain]]\[[GroupReadOnly]] on msdb'

IF DATABASE_PRINCIPAL_ID(N'[[GroupDomain]]\[[GroupReadOnly]]') IS NOT NULL
	DROP USER [[[GroupDomain]]\[[GroupReadOnly]]]
GO


-- Drop logins

USE [master]
GO

PRINT 'Dropping Login [[DatabaseApexUser]] on server'

IF SUSER_ID(N'[[DatabaseApexUser]]') IS NOT NULL
	DROP LOGIN [[[DatabaseApexUser]]]
GO


-- Create apex user with passwords

USE [master]
GO

PRINT 'Creating Login [[DatabaseApexUser]] on server'

IF SUSER_ID(N'[[DatabaseApexUser]]') IS NULL
	CREATE LOGIN [[[DatabaseApexUser]]] WITH PASSWORD=N'[[DatabaseApexPassword]]', DEFAULT_DATABASE=[[[CollateralDatabaseName]]], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO


-- Create AppAdm and ReadOnly users

USE [master]
GO

PRINT 'Creating Login [[GroupDomain]]\[[GroupAppAdm]] on server'

IF SUSER_ID(N'[[GroupDomain]]\[[GroupAppAdm]]') IS NULL
	CREATE LOGIN [[[GroupDomain]]\[[GroupAppAdm]]] FROM WINDOWS WITH DEFAULT_DATABASE=[master]
GO

PRINT 'Creating Login [[GroupDomain]]\[[GroupReadOnly]] on server'

IF SUSER_ID(N'[[GroupDomain]]\[[GroupReadOnly]]') IS NULL
	CREATE LOGIN [[[GroupDomain]]\[[GroupReadOnly]]] FROM WINDOWS WITH DEFAULT_DATABASE=[master]
GO


-- Link Apex users to Collateral database

USE [[[CollateralDatabaseName]]]
GO

PRINT 'Creating User [[databaseApexUser]] on [[CollateralDatabaseName]]'

IF DATABASE_PRINCIPAL_ID(N'[[databaseApexUser]]') IS NULL
	CREATE USER [[[databaseApexUser]]] FOR LOGIN [[[databaseApexUser]]] WITH DEFAULT_SCHEMA=[[[databaseApexSchema]]]

PRINT 'Altering Roles for [[databaseApexUser]]'

ALTER ROLE [db_datareader] ADD MEMBER [[[databaseApexUser]]]
ALTER ROLE [db_datawriter] ADD MEMBER [[[databaseApexUser]]]
ALTER ROLE [db_ddladmin] ADD MEMBER [[[databaseApexUser]]]
ALTER ROLE [db_executor] ADD MEMBER [[[databaseApexUser]]]
GO

PRINT 'Creating User [[GroupDomain]]\[[GroupAppAdm]] on [[CollateralDatabaseName]]'

IF DATABASE_PRINCIPAL_ID(N'[[GroupDomain]]\[[GroupAppAdm]]') IS NULL
	CREATE USER [[[GroupDomain]]\[[GroupAppAdm]]] FOR LOGIN [[[GroupDomain]]\[[GroupAppAdm]]]

PRINT 'Altering Roles for [[GroupDomain]]\[[GroupAppAdm]]'

ALTER ROLE [db_datareader] ADD MEMBER [[[GroupDomain]]\[[GroupAppAdm]]]
ALTER ROLE [db_datawriter] ADD MEMBER [[[GroupDomain]]\[[GroupAppAdm]]]
ALTER ROLE [db_ddladmin] ADD MEMBER [[[GroupDomain]]\[[GroupAppAdm]]]
ALTER ROLE [db_executor] ADD MEMBER [[[GroupDomain]]\[[GroupAppAdm]]]
GO

PRINT 'Creating User [[GroupDomain]]\[[GroupReadOnly]] on [[CollateralDatabaseName]]'

IF DATABASE_PRINCIPAL_ID(N'[[GroupDomain]]\[[GroupReadOnly]]') IS NULL
	CREATE USER [[[GroupDomain]]\[[GroupReadOnly]]] FOR LOGIN [[[GroupDomain]]\[[GroupReadOnly]]]

PRINT 'Altering Roles for [[GroupDomain]]\[[GroupReadOnly]]'

ALTER ROLE [db_datareader] ADD MEMBER [[[GroupDomain]]\[[GroupReadOnly]]]
GO


-- Link Apex user to JobControl database

USE [[[jobControlDatabaseName]]]
GO

PRINT 'Creating User [[databaseApexUser]] on [[jobControlDatabaseName]]'

IF DATABASE_PRINCIPAL_ID(N'[[databaseApexUser]]') IS NULL
	CREATE USER [[[databaseApexUser]]] FOR LOGIN [[[databaseApexUser]]]

PRINT 'Altering Roles for [[databaseApexUser]]'

ALTER ROLE [db_datareader] ADD MEMBER [[[databaseApexUser]]]
ALTER ROLE [db_datawriter] ADD MEMBER [[[databaseApexUser]]]
ALTER ROLE [db_ddladmin] ADD MEMBER [[[databaseApexUser]]]
ALTER ROLE [db_executor] ADD MEMBER [[[databaseApexUser]]]
GO

PRINT 'Creating User [[GroupDomain]]\[[GroupAppAdm]] on [[jobControlDatabaseName]]'

IF DATABASE_PRINCIPAL_ID(N'[[GroupDomain]]\[[GroupAppAdm]]') IS NULL
	CREATE USER [[[GroupDomain]]\[[GroupAppAdm]]] FOR LOGIN [[[GroupDomain]]\[[GroupAppAdm]]]

PRINT 'Altering Roles for [[GroupDomain]]\[[GroupAppAdm]]'

ALTER ROLE [db_datareader] ADD MEMBER [[[GroupDomain]]\[[GroupAppAdm]]]
ALTER ROLE [db_datawriter] ADD MEMBER [[[GroupDomain]]\[[GroupAppAdm]]]
ALTER ROLE [db_ddladmin] ADD MEMBER [[[GroupDomain]]\[[GroupAppAdm]]]
ALTER ROLE [db_executor] ADD MEMBER [[[GroupDomain]]\[[GroupAppAdm]]]
GO

PRINT 'Creating User [[GroupDomain]]\[[GroupReadOnly]] on [[jobControlDatabaseName]]'

IF DATABASE_PRINCIPAL_ID(N'[[GroupDomain]]\[[GroupReadOnly]]') IS NULL
	CREATE USER [[[GroupDomain]]\[[GroupReadOnly]]] FOR LOGIN [[[GroupDomain]]\[[GroupReadOnly]]]

PRINT 'Altering Roles for [[GroupDomain]]\[[GroupReadOnly]]'

ALTER ROLE [db_datareader] ADD MEMBER [[[GroupDomain]]\[[GroupReadOnly]]]
GO


-- Provide access for AppAdm and ReadOnly groups to SQL Server Agent Jobs

USE [msdb]
GO

PRINT 'Creating User [[GroupDomain]]\[[GroupAppAdm]] on msdb'

IF DATABASE_PRINCIPAL_ID(N'[[GroupDomain]]\[[GroupAppAdm]]') IS NULL
	CREATE USER [[[GroupDomain]]\[[GroupAppAdm]]] FOR LOGIN [[[GroupDomain]]\[[GroupAppAdm]]]

PRINT 'Altering Roles for [[GroupDomain]]\[[GroupAppAdm]]'

ALTER ROLE [SQLAgentOperatorRole] ADD MEMBER [[[GroupDomain]]\[[GroupAppAdm]]]
ALTER ROLE [SQLAgentReaderRole] ADD MEMBER [[[GroupDomain]]\[[GroupAppAdm]]]
ALTER ROLE [SQLAgentUserRole] ADD MEMBER [[[GroupDomain]]\[[GroupAppAdm]]]
GO


PRINT 'Creating User [[GroupDomain]]\[[GroupReadOnly]] on msdb'

IF DATABASE_PRINCIPAL_ID(N'[[GroupDomain]]\[[GroupReadOnly]]') IS NULL
	CREATE USER [[[GroupDomain]]\[[GroupReadOnly]]] FOR LOGIN [[[GroupDomain]]\[[GroupReadOnly]]]

PRINT 'Altering Roles for [[GroupDomain]]\[[GroupReadOnly]]'

ALTER ROLE [SQLAgentReaderRole] ADD MEMBER [[[GroupDomain]]\[[GroupReadOnly]]]
ALTER ROLE [SQLAgentUserRole] ADD MEMBER [[[GroupDomain]]\[[GroupReadOnly]]]
GO

-- Provide access for apex user to SQL Server Agent Jobs

USE [msdb]
GO

PRINT 'Creating User [[databaseApexUser]] on msdb'

IF DATABASE_PRINCIPAL_ID(N'[[databaseApexUser]]') IS NULL
	CREATE USER [[[databaseApexUser]]] FOR LOGIN [[[databaseApexUser]]]

PRINT 'Altering Roles for [[databaseApexUser]]'

ALTER ROLE [SQLAgentOperatorRole] ADD MEMBER [[[databaseApexUser]]]
ALTER ROLE [SQLAgentReaderRole] ADD MEMBER [[[databaseApexUser]]]
ALTER ROLE [SQLAgentUserRole] ADD MEMBER [[[databaseApexUser]]]
GO

PRINT 'Grant Select for [[databaseApexUser]]'

GRANT SELECT ON sysjobhistory to [[[databaseApexUser]]]
GRANT SELECT ON sysjobs to [[[databaseApexUser]]]
GO


-- Allow login to SSMS for interactive accounts

USE master
GO
GRANT EXECUTE ON [sys].[xp_msver] to [[[GroupDomain]]\[[GroupAppAdm]]]
GRANT EXECUTE ON [sys].[xp_msver] to [[[GroupDomain]]\[[GroupReadOnly]]]

GRANT EXECUTE ON [sys].[xp_instance_regwrite] to [[[GroupDomain]]\[[GroupAppAdm]]]
GRANT EXECUTE ON [sys].[xp_instance_regread] to [[[GroupDomain]]\[[GroupAppAdm]]]
GRANT EXECUTE ON [sys].[xp_instance_regread] to [[[GroupDomain]]\[[GroupReadOnly]]]

GRANT EXECUTE ON [sys].[xp_qv] to [[[GroupDomain]]\[[GroupAppAdm]]]
GRANT EXECUTE ON [sys].[xp_qv] to [[[GroupDomain]]\[[GroupReadOnly]]]
GO


-- Give showplan and access to server state

USE [[[CollateralDatabaseName]]]
GO

PRINT 'Grant SHOWPLAN for [[GroupDomain]]\[[GroupAppAdm]]'

GRANT SHOWPLAN TO [[[GroupDomain]]\[[GroupAppAdm]]]
GO

USE master 

PRINT 'Grant VIEW SERVER STATE for [[GroupDomain]]\[[GroupAppAdm]]'

GRANT VIEW SERVER STATE TO [[[GroupDomain]]\[[GroupAppAdm]]]
GO


-- Create Apex scheme on ApexCollateral database to allow installer to create a new DATABASE

USE [[[CollateralDatabaseName]]]
GO

IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'apex')
  BEGIN
    EXEC ('CREATE SCHEMA [apex]')
  END;
GO

-- END
