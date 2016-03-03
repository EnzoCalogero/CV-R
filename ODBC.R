ReadODBCJobs<-function(){
  library(RODBC)
 # user <- readline("What is the User?")
  password <- readline("What is the Password?")
  
  DBconn <- odbcConnect("cs400",uid='backup-tools',pwd= '4vwnP5Bo')
  #DBconn <- odbcConnect("comm01_commserv",uid='sa',pwd='password')
  
  Jobs<-sqlQuery(DBconn,paste("SELECT [jobinitfrom],[clientname],[idataagent],[data_sp],[jobstatus],[backuplevel],[startdate],[enddate],[durationunixsec],[numstreams],[numbytesuncomp],[numbytescomp],[numobjects] FROM [commserv].[dbo].[CommCellBackupInfo] where [startdate] > '2015-12-12 00:00:00'")) 
  #where [commserv].[dbo].[CommCellBackupInfo].[startdate]")
  odbcClose(DBconn)
  View(Jobs)
  return(Jobs)
}
Read_ODBC_DDB<-function(){
  library(RODBC)
  # user <- readline("What is the User?")
  password <- readline("What is the Password?")
  #DBconn <- odbcConnect("cs400",uid='backup-tools',pwd= password)
  #DBconn <- odbcConnect("comm01_commserv",uid='sa',pwd='password')
   odbcClose(DBconn)
  DDB$ModifiedTime<-as.POSIXct(DDB$ModifiedTime, origin="1970-01-01")
  View(DDB)
  return(DDB)
}




library(RODBC)
dbhandle <- odbcDriverConnect('driver={SQL Server};server=mysqlhost;database=mydbname;trusted_connection=true')
res <- sqlQuery(dbhandle, 'select * from information_schema.tables')

DBconn <- odbcConnect("cs400",uid='backup-tools',pwd= '4vwnP5Bo')



dbhandle <- odbcDriverConnect('driver=SQL Server;server=LON301CS0400\\\\COMMVAULT;database=CommServ;uid=backup-tools;pwd=4vwnP5Bo')

                              


