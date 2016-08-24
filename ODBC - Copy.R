ReadODBC_Jobs<-function(){
  library(RODBC)
  library(lubridate) 
  library(xts)
  library(dygraphs)
  library(dplyr)
   library(ggplot2)
  library(tidyr)
  library(reshape2)
  DBconn <- odbcConnect("cs401",uid='backup-tools',pwd= '4vwnP5Bo')

  Jobs<-sqlQuery(DBconn,paste("SELECT [jobinitfrom],[clientname],[idataagent],[data_sp],[jobstatus],[backuplevel],[startdate],[enddate],[durationunixsec],[numstreams],[numbytesuncomp],[numbytescomp],[numobjects],[totalBackupSize] FROM [commserv].[dbo].[CommCellBackupInfo] where [startdate] > '2016-03-01 00:00:00'")) 
 # Jobs<-sqlQuery(DBconn,paste("SELECT * FROM [commserv].[dbo].[CommCellBackupInfo] where [startdate] > '2016-03-01 00:00:00'")) 
  
  #where [commserv].[dbo].[CommCellBackupInfo].[startdate]")
  odbcClose(DBconn)
  
  View(Jobs)
  Jobs$numbytesuncomp<-(Jobs$numbytesuncomp/1024^4)
  Jobs$numbytescomp<-(Jobs$numbytescomp/1024^4)
  Jobs$startdate<-ymd_hms(Jobs$startdate)
  print("222")
  Jobs$startdate<-floor_date(Jobs$startdate, "hour")
  View(Jobs)
  jobs_AGG_h<-Jobs%>%group_by(startdate,data_sp)%>%summarise(numbytesuncomp=sum(numbytesuncomp),durationunixsec=sum(durationunixsec),numbytescomp=sum(numbytescomp),totalBackupSize=sum(totalBackupSize))
 # jobs_AGG_h$startdate<-(numbytesuncomp$startdate/1024^3)
  numbytesuncomp <- dcast(jobs_AGG_h, startdate  ~ `data_sp`,max, value.var="numbytesuncomp")
  View(numbytesuncomp)
  numbytesuncomp<-xts(numbytesuncomp[,-1],order.by=numbytesuncomp$startdate)
 # numbytesuncomp$numbytesuncomp<-(numbytesuncomp$numbytesuncomp/1024^3)
  dygraph(numbytesuncomp,main="numbytesuncomp",group = "LON3")%>% dyRangeSelector()#%>%
 # return(jobs_AGG_h)
  #comp
  numbytescomp <- dcast(jobs_AGG_h, startdate  ~ `data_sp`,max, value.var="numbytescomp")
  View(numbytescomp)
  numbytescomp<-xts(numbytescomp[,-1],order.by=numbytescomp$startdate)
  # numbytesuncomp$numbytesuncomp<-(numbytesuncomp$numbytesuncomp/1024^3)
  dygraph(numbytescomp,main="numbytescomp",group = "LON3")%>% dyRangeSelector()#%>%
  # return(jobs_AGG_h)
  
}

ReadODBC_DDB<-function(){
  library(RODBC)
  library(lubridate) 
  library(xts)
  library(dygraphs)
  # user <- readline("What is the User?")
  #  password <- readline("What is the Password?")
  
  DBconn <- odbcConnect("cs401",uid='backup-tools',pwd= '4vwnP5Bo')
  #DBconn <- odbcConnect("comm01_commserv",uid='sa',pwd='password')
  
#  Jobs<-sqlQuery(DBconn,paste("SELECT [jobinitfrom],[clientname],[idataagent],[data_sp],[jobstatus],[backuplevel],[startdate],[enddate],[durationunixsec],[numstreams],[numbytesuncomp],[numbytescomp],[numobjects] FROM [commserv].[dbo].[CommCellBackupInfo] where [startdate] > '2015-12-12 00:00:00'")) 
  
  query="SELECT  [SIDBStoreId],[SubStoreId],[HistoryType],[ModifiedTime],
[PrimaryEntries],[SecondaryEntries],[AvgQITime],[AvgQITimeSampleCount],[NumOfConnections],[ZeroRefCount],
[DataSizeToPrune],[SizeOccupied],[DDBManagedSize],  [DeleteChunkCount]
FROM [commserv].[dbo].[IdxSIDBUsageHistory]"
  
  DDB<-sqlQuery(DBconn,query)  
  
  #where [commserv].[dbo].[CommCellBackupInfo].[startdate]")
  odbcClose(DBconn)
  View(DDB)
  DDB$ModifiedTime<-as.POSIXlt(as.numeric(DDB$ModifiedTime),origin="1970-01-01",tz="GMT")
  View(DDB)
  DDB$ModifiedTime<-ymd_hms(DDB$ModifiedTime)
  
  
  
  DDB<-subset(DDB,DDB$SIDBStoreId==30)
  DDB<-subset(DDB,DDB$ModifiedTime>ymd_hms(now()- days(30)))
  DDB$AvgQITimeL<-log(DDB$AvgQITime+1)
 # hr.means <- aggregate(DDB$AvgQITimeL, format(time(xts_Insert),"%y-%m-%d %H"), mean) 
  
  
  xts_Insert<-xts(DDB$AvgQITimeL,order.by=DDB$ModifiedTime)
  View(xts_Insert)
  dygraph(xts_Insert,main="CS401 Insert")%>% dyRangeSelector()
  
  --------------
    X2<-xts_Insert
    hr.mean<-period.apply(X2, endpoints(X2, "hours"), mean)
    aa<-ts(hr.mean,frequency = 24)
    fit<-stl(aa[,1],s.window=24)
    plot(fit)
    
    
    xts_Insert_h<-xts(hr.means[,1],order.by=hr.means[,0])
  
  dygraph(hr.means,main="CS401 Insert hour")%>% dyRangeSelector()
  
    
---------------    
  
  xts_zeroRef<-xts(DDB$ZeroRefCount,order.by=DDB$ModifiedTime)
  View(xts_zeroRef)
  dygraph(xts_zeroRef,main="Insert")%>% dyRangeSelector()
  
  xts_dataProne<-xts(DDB$DataSizeToPrune,order.by=DDB$ModifiedTime)
  View(xts_dataProne)
  dygraph(xts_dataProne,main="data to Prone")%>% dyRangeSelector()
  
  DDB$ratio<-100*DDB$ZeroRefCount/DDB$PrimaryEntries
  xts_ratio<-xts(DDB$ratio,order.by=DDB$ModifiedTime)
  View(xts_ratio)
  dygraph(xts_ratio,main="Ratio")%>% dyRangeSelector()
  
  DDB$DEDUPratio<-DDB$SecondaryEntries/DDB$PrimaryEntries  
  xts_DEdupratio<-xts(DDB$DEDUPratio,order.by=DDB$ModifiedTime)
  View(xts_DEdupratio)
  dygraph(xts_DEdupratio,main="DEDUPRatio")%>% dyRangeSelector()
  return(DDB)
}