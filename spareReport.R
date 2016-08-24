
rmarkdown::render("C:/Users/enzo7311/Dropbox/Public/cv_R/CV-R/CV_Job_V2_details.Rmd", params = list(
  CS= "CS404",
  Days= 21,                
  file= "C:/Users/enzo7311/Desktop/globalJobspandav4.csv"))

file.copy("C:/Users/enzo7311/Dropbox/Public/cv_R/CV-R/CV_Job_V2_details.html", "C:/Users/enzo7311/Dropbox/Public/cv_R/CV-R/CV.html")

#http://rmarkdown.rstudio.com/developer_parameterized_reports.html#overview
LON3=c("CS401","CS402","CS403","CS404","CS406","CS410","CS411","CS498","CSITS")

for (CS in LON3) {
  rmarkdown::render('C:/Users/enzo7311/Dropbox/Public/cv_R/CV-R/CV_Job_V2_details.Rmd',  
                    output_file =  paste( CS, ".html", sep=''), 
                    output_dir = 'C:/Users/enzo7311/Dropbox/Public/cv_R/',params = list(
                      CS= CS,
                      Days= 21,                
                      file= "C:/Users/enzo7311/Desktop/globalJobspandav4.csv"))
                    
}
