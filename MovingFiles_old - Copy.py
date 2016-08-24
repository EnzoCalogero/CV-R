# -*- coding: utf-8 -*-
"""
Created on Thu Nov 05 09:23:29 2015

@author: enzo7311
"""
import subprocess
import shutil
import re
import os
import os
import tempfile
# Hosts Dictionary
#global RedoFiles
#RedoFiles=list()
Hosts={
#cs902
#'CS902M01':'10.12.21.16','CS902M02':'10.12.21.17','CS902M03':'10.12.21.18','CS902M04':'10.12.21.19','CS902M05':'10.12.21.20',
#CS903
#'CS903M01':'10.12.21.121','CS903M02':'10.12.21.46','CS903M03':'10.12.21.37','CS903M04':'10.12.21.40','CS903M05':'10.12.21.41','CS903M06':'10.12.21.122',
#'CS903M07':'10.12.21.123','CS903M08':'10.12.21.146','CS903M09':'10.12.21.148',

#}
#Hosts={
#CSITIS
#'CSITISM01':'10.9.10.64',
#CS411
#'CS411M07':'10.9.10.129','CS411M08':'10.9.10.113','CS411M01':'10.9.10.91','CS411M02':'10.9.10.92','CS411M03':'10.9.10.93','CS411M04':'10.9.10.94',
#'CS411M05':'10.9.10.48','CS411M06':'10.9.10.49',
#CS401
#'CS401M03':'10.9.10.34','CS401M04':'10.9.10.16','CS401M05':'10.9.10.54','CS401M06':'10.9.10.55','CS401M07':'10.9.10.56','CS401M08':'10.9.10.57',
#'CS401M09':'10.9.10.28',
##CS402
#'CS402M05':'10.9.10.66','CS402M06':'10.9.10.67','CS402M07':'10.9.10.68','CS402M08':'10.9.10.69','CS402M09':'10.9.10.52','CS402M10':'10.9.10.53',
#'CS402M04':'10.9.10.71',
#CS403
#'CS403M05':'10.9.10.86','CS403M06':'10.9.10.87','CS403M07':'10.9.10.88','CS403M08':'10.9.10.89',
#CS404
'CS404D02':'10.9.10.85','CS404HC7':'10.9.10.74','CS404HC5':'10.9.10.78',
'CS404HC6':'10.9.10.79','CS404M09':'10.9.10.15',
'CS404M10':'10.9.10.20','CS404M11':'10.9.10.25','CS404M12':'10.9.10.62','CS404M13':'10.9.10.39','CS404M14':'10.9.10.44',
'CS404M15':'10.9.10.47','CS404HC4':'10.9.10.132',
'CS404HC3':'10.9.10.134','CS404M07':'10.9.10.17','CS404M08':'10.9.10.18','CS404HC1':'10.9.10.19','CS404HC2':'10.9.10.33',
'CS404HC8':'10.9.10.35','CS404HC9':'10.9.10.36','CS404M06':'10.9.10.126'

#cs406
#'CS406M10':'10.9.10.114','CS406M11':'10.9.10.115','CS406M12':'10.9.10.116','CS406M13':'10.9.10.22','CS406M14':'10.9.10.23','CS406M15':'10.9.10.24','CS406M16':'10.9.10.27',
#CS410
#'CS410M01':'10.9.10.135','CS410M02':'10.9.10.137','CS410M03':'10.9.10.21','CS410M04':'10.9.10.32'
#CS498

#CS499


}


src="C:/temp/test.txt"
dest="C:/temp2/"
def copyFile(src, dest):
    try:
        #os.system ("copy %s %s" % (src, dest))
        shutil.copy(src, dest)
   #     print(src, dest)
    # eg. src and dest are the same file
    except shutil.Error as e:
        print('Error: %s' % e)
        print("enzo--Eccomi")
    # eg. source or destination doesn't exist
    except IOError as e:
        print('Error: %s' % e.strerror)
       # print("enzo--Eccomi2")
        print(src)

print("\nLooping through the file, line by line.")
text_fileOut = open("C:/temp/temp.csv", "w")
text_fileOut.writelines("Date"+", "+"DDBID" + ", " + "AFID"+ ", "+ "TimeSec"+", Host"+"\n")

#print(Hosts.keys())
#print(Hosts.get('CSITISM01'))
folder='SIDBEngine'
inputFile=[folder+".log",folder+"_1.log",folder+"_2.log",folder+"_3.log",folder+"_4.log",folder+"_5.log",folder+"_6.log",folder+"_7.log",folder+"_8.log",folder+"_9.log",folder+"_10.log"]



for Host in Hosts:
    for logfile in inputFile:
        try:
            os.remove("c:/temp/"+logfile)
        except OSError:
            pass
    winCMD = 'NET USE * \delete \y'
    subprocess.Popen(winCMD, stdout=subprocess.PIPE, shell=True)  
     
    winCMD = 'NET USE ' +'\\'+'\\'+ Hosts.get(Host)+'\\'+'c$' + ' /User:' + 'storage\cvadmin' + ' ' + 'G00dpa$$'
   # print(winCMD)
   # print(Host)
   # print (Hosts.get(Host))
    subprocess.Popen(winCMD, stdout=subprocess.PIPE, shell=True)
    for logfile in inputFile:
        dest="C:/temp/"+logfile
        src='\\'+'\\'+Hosts.get(Host)+'/c$/Program Files/CommVault/Simpana/Log Files/'+ logfile
       # print(dest)
 #       print(src)
        copyFile(src, dest)
#        winCMD = 'Net use * /delete /y '

 #       try:
        if os.path.exists(dest):            
            text_fileIn = open(dest, "r")
            for line in text_fileIn:
                    if(re.search( r"from.pending.list.", line, re.M|re.I)):
                             #  print(Host)
                            #   print(line)
                               #text_fileOut.write(line)
                               date=line[12:17]+"/2015 "+line[18:26]
                            #   print(date)
                               m = re.search('#+.(.+?)-', line)
                               if m:
                                   DDBID = m.group(1)
                                #   print DDBID
                #----
                               m = re.search('list..\[(.+?)\]', line)
                               if m:
                                   AFID = m.group(1)
                                 #  print AFID
                               m = re.search('taken.\[(.+?)\]', line)
                               if m:
                                   Time = m.group(1)
                                   #Time=float(Time)
                                  # print Time
                             #  print( DDBID + "  "+ "  "+  AFID+ "  "+ Time)
                               text_fileOut.writelines(date+","+DDBID + "," +  AFID+ ","+ Time + ","+ Host + "\n")
#        except OSError:
#            print("here I am")
#            pass        
        
    text_fileIn.close()
text_fileOut.close()               