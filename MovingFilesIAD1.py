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

IAD1={
#Iad1cs801
'CS801M01':'iad201cs0801ma1.storage.rackspace.com','CS801M02':'iad201cs0801ma2.storage.rackspace.com','CS801M03':'iad201cs0801ma3.storage.rackspace.com','CS801M04':'iad201cs0801ma4.storage.rackspace.com',
'CS80M05':'iad201cs0801ma5.storage.rackspace.com',
'CS801M10':'cs0801ma10.storage.rackspace.com','CS801M11':'cs0801ma11.storage.rackspace.com','CS801M12':'cs0801ma12.storage.rackspace.com',
'CS801M13':'cs0801ma13.storage.rackspace.com','CS801M14':'cs0801ma14.storage.rackspace.com',
#Iad1cs802
'CS802M01':'iad201cs0802ma1.storage.rackspace.com','CS802M02':'iad201cs0802ma2.storage.rackspace.com','CS802M03':'iad201cs0803ma1.storage.rackspace.com',
'CS802M04':'iad201cs0802ma4.storage.rackspace.com','CS802M05':'10.4.219.86',

#Iad1cs803
'CS803M01':'IAD201CS0803MA1.storage.rackspace.com','CS803M02':'IAD201CS0803MA2.storage.rackspace.com',
'CS803M03':'IAD201CS0803MA3.storage.rackspace.com','CS803M04':'IAD201CS0803MA4.storage.rackspace.com',
'CS803M05':'IAD201CS0803MA5.storage.rackspace.com','CS803M06':'IAD201CS0803MA6.storage.rackspace.com',
'CS803M07':'CS0803MA07.storage.rackspace.com','CS803M08':'CS0803MA08.storage.rackspace.com',
'CS803M09':'CS0803MA09.storage.rackspace.com',

#Iad1cs804
'CS803M01':'CS0804MA01.storage.rackspace.com','CS803M02':'CS0804MA02.storage.rackspace.com','CS803M03':'CS0804MA03.storage.rackspace.com',
'CS803M04':'CS0804MA04.storage.rackspace.com','CS803M05':'CS0804MA05.storage.rackspace.com','CS803M06':'CS0804MA06.storage.rackspace.com',
'CS803M07':'CS0804MA07.storage.rackspace.com',
#Iad1cs805
'CS805M01':'CS0805MA01.storage.rackspace.com','CS805M02':'CS0805MA02.storage.rackspace.com',
'CS805M03':'CS0805MA03.storage.rackspace.com','CS805M04':'CS0805MA04.storage.rackspace.com',
'CS805M05':'CS0805MA05.storage.rackspace.com',

}


src="C:/temp/IAD1/IAD1.txt"
dest="C:/temp2/"
def copyFile(src, dest):
    try:
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



text_fileOut = open("C:/temp/iad1/temp.csv", "w")
text_fileOut.writelines("Date"+", "+"DDBID" + ", " + "AFID"+ ", "+ "TimeSec"+", Host"+", DC"+ "\n")


folder='SIDBEngine'
inputFile=[folder+".log",folder+"_1.log",folder+"_2.log",folder+"_3.log",folder+"_4.log",folder+"_5.log",folder+"_6.log",folder+"_7.log",folder+"_8.log",folder+"_9.log",folder+"_10.log"]


DC=IAD1.copy()

DC_NAME='IAD1'
for Host in DC:
    for logfile in inputFile:
        try:
            os.remove("c:/temp/iad1/"+logfile)
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
        dest="C:/temp/iad1/"+logfile
        src='\\'+'\\'+DC.get(Host)+'/c$/Program Files/CommVault/Simpana/Log Files/'+ logfile
        src1='\\'+'\\'+DC.get(Host)+'/c$/Program Files/CommVault/Galaxy/Log Files/'+ logfile
        print(dest)
 #       print(src)
        copyFile(src, dest)
        copyFile(src1, dest)

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