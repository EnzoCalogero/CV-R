ReadODBCJobs<-function(){
  library(RODBC)
 # user <- readline("What is the User?")
  password <- readline("What is the Password?")
  DBconn <- odbcConnect("cs400",uid='backup-tools',pwd= password)
  #DBconn <- odbcConnect("comm01_commserv",uid='sa',pwd='password')
  
  Jobs<-sqlQuery(DBconn,paste("SELECT [jobinitfrom],[clientname],[idataagent],[data_sp],[jobstatus],[backuplevel],[startdate],[enddate],[durationunixsec],[numstreams],[numbytesuncomp],[numbytescomp],[numobjects] FROM [commserv].[dbo].[CommCellBackupInfo] where [startdate] > '2014-07-01 00:00:00'")) 
  #where [commserv].[dbo].[CommCellBackupInfo].[startdate]")
  odbcClose(DBconn)
  View(Jobs)
  return(Jobs)
}
Read_ODBC_DDB<-function(){
  library(RODBC)
  # user <- readline("What is the User?")
  password <- readline("What is the Password?")
  DBconn <- odbcConnect("cs400",uid='backup-tools',pwd= password)
  #DBconn <- odbcConnect("comm01_commserv",uid='sa',pwd='password')
  
  DDB<-sqlQuery(DBconn,paste("SELECT  [SIDBStoreId],[SubStoreId],[HistoryType],[ModifiedTime],[PrimaryEntries],[SecondaryEntries],[AvgQITime],[AvgQITimeSampleCount],[NumOfConnections],[ZeroRefCount],[DataSizeToPrune],[SizeOccupied],[DDBManagedSize],[DeleteChunkCount]  FROM [commserv].[dbo].[IdxSIDBUsageHistory]"))   #where [commserv].[dbo].[CommCellBackupInfo].[startdate]")
  odbcClose(DBconn)
  DDB$ModifiedTime<-as.POSIXct(DDB$ModifiedTime, origin="1970-01-01")
  View(DDB)
  return(DDB)
}
