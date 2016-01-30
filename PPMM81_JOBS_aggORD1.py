#-------------------------------------------------------------------------------
# Name:        Extract information from the MM82.txt
#               To anlyse the pruning trend
# Purpose:
#
# Author:      Enzo
#
# Created:     28/8/2015
# Copyright:   (c) cv 2015
# Licence:     <your licence>
#-------------------------------------------------------------------------------
#from win_unc import UncCredentials, UncDirectory, UncDirectoryConnection
# Info on the Library....
#http://developer.covenanteyes.com/unc-paths-with-python/
import shutil
import re
import os
import os
import tempfile
import win32wnet

def copyFile(src, dest,Host):
    try:
        win32wnet.WNetAddConnection2(0, None, '\\\\'+ Host, None, 'storage\enzo.calogero','N1cole84.')
        #os.system ("copy %s %s" % (src, dest))
        shutil.copy(src, dest)
        print(src, dest)
    # eg. src and dest are the same file
    except shutil.Error as e:
        print('Error: %s' % e)
        print("enzo--Eccomi")
    # eg. source or destination doesn't exist
    except IOError as e:
        print('Error: %s' % e.strerror)
       # print("enzo--Eccomi2")
        print(src)





def main():
    pass

if __name__ == '__main__':
    main()
inc=0 # flag for one time relate...
SPLIST=[] # Storage policy list on the logs.
TimeDList=[] # Date and time list   
###########################################################    
#                                                         #  
# Collect the files                                       #
#                                                         #
###########################################################    
#cs901
Host="ord101cs0901.storage.rackspace.com"
host="CS901"
dest="c:/dati/Jobs_Analisis/ORD1/"+host+ "Pre.txt"
src="//ord101cs0901.storage.rackspace.com/c$/rs-pkgs/OMSA/MM81.txt"
copyFile(src,dest,Host)    

#cs902
Host="ord101cs0902.storage.rackspace.com"
host="CS902"
dest="c:/dati/Jobs_Analisis/ORD1/"+host+ "Pre.txt"
src="//ord101cs0902.storage.rackspace.com/c$/rs-pkgs/OMSA/MM81.txt"
copyFile(src,dest,Host)    
#cs903
Host="ord101cs0903.storage.rackspace.com"
host="CS903"
dest="c:/dati/Jobs_Analisis/ORD1/"+host+ "Pre.txt"
src="//ord101cs0903.storage.rackspace.com/c$/rs-pkgs/OMSA/MM81.txt"
copyFile(src,dest,Host)  
#cs904
Host="ord101cs0904.storage.rackspace.com"
host="CS904"
dest="c:/dati/Jobs_Analisis/ORD1/"+host+ "Pre.txt"
src="//ord101cs0904.storage.rackspace.com/c$/rs-pkgs/OMSA/MM81.txt"
copyFile(src,dest,Host) 
#cs905
Host="ord101cs0905.storage.rackspace.com"
host="CS905"
dest="c:/dati/Jobs_Analisis/ORD1/"+host+ "Pre.txt"
src="//ord101cs0905.storage.rackspace.com/c$/rs-pkgs/OMSA/MM81.txt"
copyFile(src,dest,Host) 
#cs906
Host="ord101cs0906.storage.rackspace.com"
host="CS906"
dest="c:/dati/Jobs_Analisis/ORD1/"+host+ "Pre.txt"
src="//ord101cs0906.storage.rackspace.com/c$/rs-pkgs/OMSA/MM81.txt"
copyFile(src,dest,Host) 

#############################################
#            Convertition
############################################

CommCells=["CS901","CS902","CS903","CS904","CS905","CS906"]    

for host in CommCells:
#  os.system('sox input.wav -b 24 output.aiff rate -v -L -b 90 48k')  
  cmd1="cmd.exe /a /c TYPE c:\dati\Jobs_Analisis\ORD1\\"+host+ "Pre.txt > c:\dati\Jobs_Analisis\ORD1\\"+host+ ".txt"
#  print(cmd1)
  os.system(cmd1)


#############################################
#   create the excel File
############################################



text_fileOut = open("C:/dati/Jobs_Analisis/ORD1/globalJobsORD1.csv", "w")
#text_fileOut.writelines("Date and Time"+", "+"Storage Policy" + ", " + "Copy"+ ", "+ "Residual Size, CS"+"\n")
text_fileOut.writelines("Date and Time"+", "+"Storage Policy" + ", " + "Status"+ ", "+ "Number, CS"+"\n")    


for CS in CommCells:
    
    inputFile="C:/dati/Jobs_Analisis/ORD1/"+CS+".txt"
    
     
    filin= open(inputFile, "r")
    
    #print(filin)
    for line in filin:
      #print(line)
      #Get the date and time
      if(re.search( r"Began.Executing.(.*)", line, re.M|re.I)):
    
                                   # print(line)
                                   #text_fileOut.write(line)
                                   #date=line[12:17]+"/2014 "+line[18:26]
                                   #   print(date)
                                   m = re.search('Began.Executing.(.*)', line)
                                   if m:
                                      #print (m.group(0))
                                      CurTime=m.group(1)
                                     # print (CurTime)
                                      if((CurTime not in TimeDList)):
                                        TimeDList.append( CurTime );
                                        #SPLIST=set(SPLIST)
                                     #   print("TimeDList")
                                      #  print(TimeDList)
      #Get storag epolicy
      if(re.search( r"eek.(.*)", line, re.M|re.I)):
                                  # print(line)
                                   #text_fileOut.write(line)
                                   #date=line[12:17]+"/2014 "+line[18:26]
                                   #   print(date)
                                   # print (m.group(0))
                                      StoraPolicy=line[0:143].rstrip()
                                     # print(StoraPolicy)
                                      if((StoraPolicy not in SPLIST)):
                                        SPLIST.append( StoraPolicy.rstrip() );
                                        #SPLIST=set(SPLIST)
                                       # print("SPLIST")
                                      #  print(SPLIST)
    
    
    
                                      Status=line[144:200]
                                      #print (Status)
 
    
                                      Number=line[401:423]
                                     # print (Number)
                                      #stip() remove space both sides, rstrip only on the right side...
                                      text_fileOut.writelines(CurTime+','+StoraPolicy.rstrip()+','+Status.strip() +','+Number.strip()+','+ CS + "\n")
    
    
    
    
  #  print("TimeDList")
  #  print(TimeDList)
  #  print("SPLIST")
   # print(SPLIST)
##### ##############################
#  Per aggiungere i valori nulli   #
####################################    
    
    #populate with zero value
  #  for dt in TimeDList:
  #      for SP_ in SPLIST:
  #         text_fileOut.writelines(dt+','+SP_+','+ "Running"+','+"0,"+CS+"\n")
  #         text_fileOut.writelines(dt+','+SP_+','+ "Pending"+','+"0,"+CS+"\n")
  #         text_fileOut.writelines(dt+','+SP_+','+ "Queued"+','+"0,"+CS+"\n")
  #         text_fileOut.writelines(dt+','+SP_+','+ "Waiting"+','+"0,"+CS+"\n")
    
    
    filin.close()
text_fileOut.close()