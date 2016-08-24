---
title: "ODBC Report"
author: "Enzo"
date: "6 March 2016"
output: html_document
---



```{r}
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
```

You can also embed plots, for example:

```{r, echo=FALSE}
plot(cars)
```

Note that the `echo = FALSE` parameter was added to the code chunk to prevent printing of the R code that generated the plot.
