# -*- coding: utf-8 -*-
"""
Created on Thu Nov 05 09:23:29 2015

@author: enzo7311
"""
import subprocess
import shutil
import re
import os
# Hosts Dictionary
Hosts={'CSITISM01':'10.9.10.64',
'CS411M07':'10.9.10.129','CS411M08':'10.9.10.113','CS411M01':'10.9.10.91','CS411M02':'10.9.10.92','CS411M03':'10.9.10.93','CS411M04':'10.9.10.94',
'CS411M05':'10.9.10.48','CS411M06':'10.9.10.49',
'CS401M03':'10.9.10.34','CS401M04':'10.9.10.16','CS401M05':'10.9.10.54','CS401M06':'10.9.10.55','CS401M07':'10.9.10.56','CS401M08':'10.9.10.57',
'CS401M09':'10.9.10.28',
'CS402M05':'10.9.10.66','CS402M06':'10.9.10.67','CS402M07':'10.9.10.68','CS402M08':'10.9.10.69','CS402M09':'10.9.10.52','CS402M10':'10.9.10.53',
#'CS402M04':'10.9.10.71',
'CS403M05':'10.9.10.86','CS403M06':'10.9.10.87','CS403M07':'10.9.10.88','CS403M08':'10.9.10.89',

'CS0404D02':'10.9.10.85','CS0404MA22':'10.9.10.31','CS0404HC07':'10.9.10.74','CS0404MA20':'10.9.10.76','CS0404HC05':'10.9.10.78',
'CS0404HC06':'10.9.10.79','CS0404MA21':'10.9.10.75','CS0404MA23':'10.9.10.51','CS0404MA18':'10.9.10.130','LON301CS0404M09':'10.9.10.15',
'LON301CS0404M10':'10.9.10.20','LON301CS0404M11':'10.9.10.25','LON301CS0404M12':'10.9.10.62','LON301CS0404M13':'10.9.10.39','LON301CS0404M14':'10.9.10.44',
'LON301CS0404M15':'10.9.10.47','CS0404MA16':'10.9.10.73','CS0404MA17':'10.9.10.131','CS0404HC04':'10.9.10.132','CS0404MA19':'10.9.10.133',
'CS0404HC03':'10.9.10.134','LON301CS0404M07':'10.9.10.17','LON301CS0404M08':'10.9.10.18','CS0404HC01':'10.9.10.19','CS0404HC02':'10.9.10.33',
'CS0404HC08':'10.9.10.35','CS0404HC09':'10.9.10.36','CS0404MA06':'10.9.10.126'
}


src="C:/temp/test.txt"
dest="C:/temp2/"
def copyFile(src, dest):
    try:
        shutil.copy(src, dest)
    # eg. src and dest are the same file
    except shutil.Error as e:
        print('Error: %s' % e)
    # eg. source or destination doesn't exist
    except IOError as e:
        print('Error: %s' % e.strerror)

print("\nLooping through the file, line by line.")
text_fileOut = open("C:/temp/temp.csv", "w")
text_fileOut.writelines("Date"+", "+"DDBID" + ", " + "AFID"+ ", "+ "TimeSec"+", Host"+"\n")

#print(Hosts.keys())
#print(Hosts.get('CSITISM01'))
folder='SIDBEngine'
inputFile=[folder+".log",folder+"_1.log",folder+"_2.log",folder+"_3.log"]#,folder+"_4.log",folder+"_5.log",folder+"_6.log",folder+"_7.log",folder+"_8.log",folder+"_9.log",folder+"_10.log"]



for Host in Hosts:
    for logfile in inputFile:
        try:
            os.remove("c:/temp/"+logfile)
        except OSError:
            pass
        
    winCMD = 'NET USE ' +'\\'+'\\'+ Hosts.get(Host)+'\\'+'c$' + ' /User:' + 'storage\enzo.calogero' + ' ' + 'N1cole83.'
    print(Host)
    print (Hosts.get(Host))
    subprocess.Popen(winCMD, stdout=subprocess.PIPE, shell=True)
    for logfile in inputFile:
        dest="C:/temp/"+logfile
        src='\\'+'\\'+Hosts.get(Host)+'/c$/Program Files/CommVault/Simpana/Log Files/'+ logfile
        print(dest)
        print(src)
        
        try:
            copyFile(src, dest) 
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
                           text_fileOut.writelines(date+", "+DDBID + ", " +  AFID+ ", "+ Time + ", "+ Host + "\n")
        except OSError:
            pass        
    text_fileIn.close()
text_fileOut.close()               