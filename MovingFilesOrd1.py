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
import win32wnet
# Hosts Dictionary
#global RedoFiles
#RedoFiles=list()

ORD={
#ord901
'CS901M01':'10.12.21.11','CS901M02':'10.12.21.12','CS901M03':'10.12.21.13','CS901M04':'10.12.21.14','CS901M05':'10.12.21.33',
'CS901M07':'10.12.21.58','CS901M08':'10.12.21.56','CS901M09':'10.12.21.36',
#cs902
'CS902M01':'10.12.21.16','CS902M02':'10.12.21.17','CS902M03':'10.12.21.18','CS902M04':'10.12.21.19','CS902M05':'10.12.21.20',
#CS903
'CS903M01':'10.12.21.121','CS903M02':'10.12.21.46','CS903M03':'10.12.21.37','CS903M04':'10.12.21.40','CS903M05':'10.12.21.41','CS903M06':'10.12.21.122',
'CS903M07':'10.12.21.123','CS903M08':'10.12.21.146','CS903M09':'10.12.21.148',
#ord904
'CS904M01':'10.12.21.81','CS904M02':'10.12.21.82','CS904M03':'10.12.21.38','CS904M04':'10.12.21.42','CS904M05':'10.12.21.147','CS904M06':'10.12.21.31',
'CS904M07':'10.12.21.32','CS904M08':'10.12.21.120',
#ord905
'CS905M02':'10.12.21.52','CS905M03':'10.12.21.53','CS905M04':'10.12.21.79','CS905M05':'10.12.21.43','CS905M06':'10.12.21.155',
'CS905M07':'10.12.21.156','CS905M08':'10.12.21.158',
#ord906
'CS906M01':'10.12.21.61','CS906M02':'10.12.21.39','CS906M03':'10.12.21.80','CS906M04':'10.12.21.34','CS906M05':'10.12.21.59','CS906M06':'10.12.21.63',
'CS906M07':'10.12.21.66','CS906M08':'10.12.21.63','CS906M09':'10.12.21.57',
}

src="C:/temp/ORD1/Ord1.txt"
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



text_fileOut = open("C:/temp/ord1/temp.csv", "w")
text_fileOut.writelines("Date"+", "+"DDBID" + ", " + "AFID"+ ", "+ "TimeSec"+", Host"+", DC"+ "\n")


folder='SIDBEngine'
inputFile=[folder+".log",folder+"_1.log",folder+"_2.log",folder+"_3.log",folder+"_4.log",folder+"_5.log",folder+"_6.log",folder+"_7.log",folder+"_8.log",folder+"_9.log",folder+"_10.log"]


DC=ORD.copy()

DC_NAME='ord1'
for Host in DC:
    for logfile in inputFile:
        try:
            os.remove("c:/temp/ord1/"+logfile)
        except OSError:
            pass

    print(Host)
    print(DC.get(Host))
    try:
           win32wnet.WNetAddConnection2(0, None, '\\\\'+ DC.get(Host), None, 'storage\enzo.calogero','N1cole84.')
    except OSError:
           print("Errore")
           print(Host)
           print(DC.get(Host))
           #pass
    except IOError as e:
        print('Error: %s' % e.strerror)
        print("enzo--Eccomi2")
        print(Host)   
 
    for logfile in inputFile:
        dest="C:/temp/ord1/"+logfile
        src='\\'+'\\'+DC.get(Host)+'/c$/Program Files/CommVault/Simpana/Log Files/'+ logfile
        print(dest)
 #       print(src)
        copyFile(src, dest)

 #       try:
        if os.path.exists(dest):            
            text_fileIn = open(dest, "r")
            for line in text_fileIn:
                    if(re.search( r"from.pending.list.", line, re.M|re.I)):
                              # print(Host)
                            #   print(line)
                               #text_fileOut.write(line)
                               date=line[12:17]+"/2016 "+line[18:26]
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
                               text_fileOut.writelines(date+","+DDBID + "," +  AFID+ ","+ Time + ","+ Host +","+ DC_NAME +" \n")
#        except OSError:
#            print("here I am")
#            pass        
        
    text_fileIn.close()
text_fileOut.close()               