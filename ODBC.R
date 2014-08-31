ReadODBCJobs<-function(){
  library(RODBC)
  user <- readline("What is the User?")
  password <- readline("What is the Password?")
  #DBconn <- odbcConnect("cs400",uid='sa',pwd='N1cole72.')
  DBconn <- odbcConnect("comm01_commserv",uid='sa',pwd='password')
  
  Jobs<-sqlQuery(DBconn,paste("SELECT [jobinitfrom],[clientname],[idataagent],[data_sp],[jobstatus],[backuplevel],[startdate],[enddate],[durationunixsec],[numstreams],[numbytesuncomp],[numbytescomp],[numobjects] FROM [commserv].[dbo].[CommCellBackupInfo]")) 
  #where [commserv].[dbo].[CommCellBackupInfo].[startdate]")
  odbcClose(DBconn)
#  View(Jobs)
  return(Jobs)
}
#SELECT [jobinitfrom],[clientname],[idataagent],[data_sp],[jobstatus],[startdate],[enddate],[durationunixsec],[numstreams],[numbytesuncomp],[numbytescomp],[numobjects]FROM [commserv].[dbo].[CommCellBackupInfo] where [commserv].[dbo].[CommCellBackupInfo].[startdate] > '2014-05-01'

