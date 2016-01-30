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

DFW={
#dfwcs01
'CS001M01':'10.5.19.91','CS001M02':'10.5.19.92','CS001M03':'10.5.19.93','CS001M04':'10.5.19.94','CS0M05':'10.5.19.105','CS001M06':'10.5.19.106',
'CS001M07':'10.5.110.76','CS001M08':'10.12.21.56','CS001M09':'10.12.21.57',
#dfwcs07
'CS007M01':'10.5.110.56','CS007M03':'10.5.110.61','CS007M04':'10.5.19.59','CS007M05':'10.5.110.171',
'CS007M06':'10.5.110.172','CS007M07':'10.5.110.76','CS007M08':'10.5.19.56','CS007M09':'10.5.19.57',
#dfwcs12
'CS012M05':'10.5.110.72','CS012M06':'10.5.110.73',#'CS012M08':'10.5.110.40',
'CS012M01':'10.5.110.86','CS012M03':'10.5.110.88','CS012M04':'10.5.110.89',#'CS012M07':'10.5.110.58'

#dfwcs20
'CS020M01':'dfw102cs0020ma1.storage.rackspace.com','CS020M02':'dfw102cs0020ma2.storage.rackspace.com',
'CS020M03':'dfw102cs0020ma3.storage.rackspace.com','CS020M04':'dfw102cs0020ma4.storage.rackspace.com',
'CS020M05':'dfw102cs0020ma5.storage.rackspace.com','CS020M06':'dfw102cs0020ma6.storage.rackspace.com',

#dfwcs21

'CS021M01':'dfw102cs0021ma1.storage.rackspace.com','CS021M02':'dfw102cs0021ma2.storage.rackspace.com',
'CS021M03':'dfw102cs0021ma3.storage.rackspace.com','CS021M04':'dfw102cs0021ma4.storage.rackspace.com',
'CS021M05':'dfw102cs0021ma5.storage.rackspace.com','CS021M06':'dfw102cs0021ma6.storage.rackspace.com',
'CS021M07':'dfw102cs0021ma7.storage.rackspace.com','CS021M08':'dfw102cs0021ma8.storage.rackspace.com',
'CS021M09':'dfw102cs0021ma9.storage.rackspace.com',

#dfwoacs

#dfwcs41
'CS041M05':'dfw103cs0041ma5.storage.rackspace.com',
'CS041M06':'dfw103cs0041ma6.storage.rackspace.com','CS041M07':'dfw103cs0041ma7.storage.rackspace.com',
'CS041M08':'dfw103cs0041ma8.storage.rackspace.com',


}





src="C:/temp/DFW/DFW1.txt"
dest="C:/temp2/"
def copyFile(src, dest):
    try:
        #os.system ("copy %s %s" % (src, dest))
        shutil.copy(src, dest)
      #  print(src, dest)
    # eg. src and dest are the same file
    except shutil.Error as e:
        print('Error: %s' % e)
        print("enzo--Eccomi")
    # eg. source or destination doesn't exist
    except IOError as e:
        print('Error: %s' % e.strerror)
       # print("enzo--Eccomi2")
        print(src)



text_fileOut = open("C:/temp/dfw1/temp.csv", "w")
text_fileOut.writelines("Date"+", "+"DDBID" + ", " + "AFID"+ ", "+ "TimeSec"+", Host"+", DC"+ "\n")


folder='SIDBEngine'
inputFile=[folder+".log",folder+"_1.log",folder+"_2.log",folder+"_3.log",folder+"_4.log",folder+"_5.log",folder+"_6.log",folder+"_7.log",folder+"_8.log",folder+"_9.log",folder+"_10.log"]


DC=DFW.copy()

DC_NAME='DFW1'
for Host in DC:
    for logfile in inputFile:
        try:
            os.remove("c:/temp/dfw1/"+logfile)
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
        dest="C:/temp/dfw1/"+logfile
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