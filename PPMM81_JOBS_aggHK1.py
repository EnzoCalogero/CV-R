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
import tempfile
import win32wnet

def copyFile(src, dest,Host):
    try:
        #print('\\\\'+ Host, None, 'storage\enzo.calogero','N1cole84.')
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
#cs001
Host="10.11.10.30"
host="CS701"
dest="c:/dati/Jobs_Analisis/HK/"+host+ "Pre.txt"
src="//10.11.10.30/c$/rs-pkgs/OMSA/MM81.txt"
#print(src)
#print(dest)
copyFile(src,dest,Host)    


#############################################
#            Convertition
############################################

CommCells=["CS701"]    

for host in CommCells:
#  os.system('sox input.wav -b 24 output.aiff rate -v -L -b 90 48k')  
  cmd1="cmd.exe /a /c TYPE c:\dati\Jobs_Analisis\HK\\"+host+ "Pre.txt > c:\dati\Jobs_Analisis\HK\\"+host+ ".txt"
#  print(cmd1)
  os.system(cmd1)


#############################################
#   create the excel File
############################################



text_fileOut = open("C:/dati/Jobs_Analisis/HK/globalJobsHK.csv", "w")
#text_fileOut.writelines("Date and Time"+", "+"Storage Policy" + ", " + "Copy"+ ", "+ "Residual Size, CS"+"\n")
text_fileOut.writelines("Date and Time"+", "+"Storage Policy" + ", " + "Status"+ ", "+ "Number, CS"+"\n")    


for CS in CommCells:
    
    inputFile="C:/dati/Jobs_Analisis/HK/"+CS+".txt"
    
     
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
                                     # print (Status)
 
    
                                      Number=line[401:423]
                                      #print (Number)
                                      #stip() remove space both sides, rstrip only on the right side...
                                      text_fileOut.writelines(CurTime+','+StoraPolicy.rstrip()+','+Status.strip() +','+Number.strip()+','+ CS + "\n")
    
    
    
    
 
    
    
    filin.close()
text_fileOut.close()