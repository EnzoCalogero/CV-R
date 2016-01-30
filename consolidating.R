consolidating<-function(){
  load("C:\\Users\\enzo7311\\Desktop\\cv_R\\CV-R\\Jobs_RAW")
  View(Jobs_RAW)
  
  file='C:/dati/Jobs_Analisis/globalJobs.csv'
  Jobs_RAWN <- fread(file, header = T, sep = ',')
  Jobs_RAWN$Date.and.Time<-ymd_hms(Jobs_RAWN$Date)
  Jobs_RAWN$Storage.Policy<-Jobs_RAWN$Storage
  Jobs_RAWN[,1:2]<-NULL
  Jobs_RAWN$Date.and.Time<-floor_date(Jobs_RAWN$Date.and.Time, "hour")
  
}