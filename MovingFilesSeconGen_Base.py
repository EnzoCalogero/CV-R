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


#
#src="C:/temp/ORD1/SIDBEngine_1.log"
#dest="C:/temp/"
#def copyFile(src, dest):
#    try:
#        #os.system ("copy %s %s" % (src, dest))
#        shutil.copy(src, dest)
#   #     print(src, dest)
#    # eg. src and dest are the same file
#    except shutil.Error as e:
#        print('Error: %s' % e)
#        print("enzo--Eccomi")
#    # eg. source or destination doesn't exist
#    except IOError as e:
#        print('Error: %s' % e.strerror)
#       # print("enzo--Eccomi2")
#        print(src)
#
#
#
dest="C:/temp/ord1/SIDBEngine_6.log"
text_fileOutquantum = open("C:/temp/ord1/QuantumTemp.csv", "w")
#text_fileOutquantum.writelines("Date"+", "+"DDBID" + ", " + "AFID"+ ", "+ "TimeSec"+", Host"+", DC"+ "\n")
text_fileOutquantum.writelines("Date"+","+"DDBID" + "," +  "PrimaryRecords"+ ","+ "PrimaryRecordsSize" + ","+ "PrimaryRecordsAdd" +","+ "PrimaryRecordsSizeAdd" +","+"PrimaryRecordRemoved"+ "," +"PrimaryRecordRemovedSize"+ "," +"SecondaryRecords"+ "," +"SecondaryRecordsSize"+ ","+"SecondaryRecordsAdd" +","+"SecondaryRecordsSizeAdd"+ "," +"SecondaryRecordRemoved"+ "," +"SecondaryRecordRemovedSize"+ "," +"PendingDelRecords"+ "," +"PendingDelRecordsSize"+ "," +"PendingDelRecordsAdd"+ "," +"PendingDelRecordsSizeAdd"+ "," +"PendingDelRecordRemoved"+ "," +"PendingDelRecordRemovedSize"+ "\n")
#                  
#
#
#folder='SIDBEngine'
##inputFile=[folder+".log",folder+"_1.log",folder+"_2.log",folder+"_3.log",folder+"_4.log",folder+"_5.log",folder+"_6.log",folder+"_7.log",folder+"_8.log",folder+"_9.log",folder+"_10.log"]
#inputFile
#
#DC=ORD.copy()
#
#DC_NAME='ord1'
#for Host in DC:
#    for logfile in inputFile:
#        try:
#            os.remove("c:/temp/ord1/"+logfile)
#        except OSError:
#            pass
#
#    print(Host)
#    print(DC.get(Host))
#    try:
#           win32wnet.WNetAddConnection2(0, None, '\\\\'+ DC.get(Host), None, 'storage\enzo.calogero','N1cole84.')
#    except OSError:
#           print("Errore")
#           print(Host)
#           print(DC.get(Host))
#           #pass
#    except IOError as e:
#        print('Error: %s' % e.strerror)
#        print("enzo--Eccomi2")
#        print(Host)   
# 
#    for logfile in inputFile:
#        dest="C:/temp/ord1/"+logfile
#        src='\\'+'\\'+DC.get(Host)+'/c$/Program Files/CommVault/Simpana/Log Files/'+ logfile
#        print(dest)
# #       print(src)
#        copyFile(src, dest)
#
# #       try:
#        if os.path.exists(dest):            
text_fileIn = open(dest, "r")
Host="Temp"
DC_NAME="Temp"
for line in text_fileIn:
        if(re.search( r"..\[0\]\[.+?Total\]", line, re.M|re.I)):
                  # print(Host)
                   print(line)
                   #text_fileOut.write(line)
                   date=line[12:17]+"/2016 "+line[18:26]
                   print(date)
                   m = re.search('#+.(.+?)-', line)
                   if m:
                       DDBID = m.group(1)
                       print DDBID
    #----
                   list = re.findall('\[\d+', line)
                   #print(list)
                   #Primary
                   PrimaryRecords=(list[1].replace('[',''))
                   print("PrimaryRecords")
                   print(PrimaryRecords)
                   PrimaryRecordsSize=(list[2].replace('[',''))
                   print("PrimiryRecordsSize")
                   print(PrimaryRecordsSize)
                   PrimaryRecordsAdd=(list[3].replace('[',''))
                   print("PrimaryRecordsAdd")
                   print(PrimaryRecordsAdd)
                   PrimaryRecordsSizeAdd=(list[4].replace('[',''))
                   print("PrimiryRecordsSizeAdd")
                   print(PrimaryRecordsSize)
                   PrimaryRecordRemoved=(list[5].replace('[',''))
                   print("PrimaryRecordRemoved")
                   print(PrimaryRecordRemoved)
                   PrimaryRecordRemovedSize=(list[6].replace('[',''))
                   print("PrimaryRecordRemovedSize")
                   print(PrimaryRecordRemovedSize)
                   #Secondary
                   SecondaryRecords=(list[7].replace('[',''))
                   print("SecondaryRecords")
                   print(SecondaryRecords)
                   SecondaryRecordsSize=(list[8].replace('[',''))
                   print("PrimiryRecordsSize")
                   print(SecondaryRecordsSize)
                   SecondaryRecordsAdd=(list[9].replace('[',''))
                   print("SecondaryRecordsAdd")
                   print(SecondaryRecordsAdd)
                   SecondaryRecordsSizeAdd=(list[10].replace('[',''))
                   print("PrimiryRecordsSizeAdd")
                   print(SecondaryRecordsSize)
                   SecondaryRecordRemoved=(list[11].replace('[',''))
                   print("SecondaryRecordRemoved")
                   print(SecondaryRecordRemoved)
                   SecondaryRecordRemovedSize=(list[12].replace('[',''))
                   print("SecondaryRecordRemovedSize")
                   print(SecondaryRecordRemovedSize)
                   #deleted pending
                   PendingDelRecords=(list[13].replace('[',''))
                   print("PendingDelRecords")
                   print(PendingDelRecords)
                   PendingDelRecordsSize=(list[14].replace('[',''))
                   print("PrimiryRecordsSize")
                   print(PendingDelRecordsSize)
                   PendingDelRecordsAdd=(list[15].replace('[',''))
                   print("PendingDelRecordsAdd")
                   print(PendingDelRecordsAdd)
                   PendingDelRecordsSizeAdd=(list[16].replace('[',''))
                   print("PrimiryRecordsSizeAdd")
                   print(PendingDelRecordsSize)
                   PendingDelRecordRemoved=(list[17].replace('[',''))
                   print("PendingDelRecordRemoved")
                   print(PendingDelRecordRemoved)
                   PendingDelRecordRemovedSize=(list[18].replace('[',''))
                   print("PendingDelRecordRemovedSize")
                   print(PendingDelRecordRemovedSize)
                  
                  #
                  #
                  # StartIndex=list.index('8084')
                  # print(StartIndex)
                   
               #    m = re.search('\[.*?\]*', line)
               #    if m:
               #        #AFID = m.group()
               #        print m.group()
               #        print m.group(0)
               #        print m.group(1)
                   text_fileOutquantum.writelines(date+","+DDBID + "," +  PrimaryRecords+ ","+ PrimaryRecordsSize + ","+ PrimaryRecordsAdd +","+ PrimaryRecordsSizeAdd +","+PrimaryRecordRemoved+ "," +PrimaryRecordRemovedSize+ "," +SecondaryRecords+ "," +SecondaryRecordsSize+ ","+SecondaryRecordsAdd +","+SecondaryRecordsSizeAdd+ "," +SecondaryRecordRemoved+ "," +SecondaryRecordRemovedSize+ "," +PendingDelRecords+ "," +PendingDelRecordsSize+ "," +PendingDelRecordsAdd+ "," +PendingDelRecordsSizeAdd+ "," +PendingDelRecordRemoved+ "," +PendingDelRecordRemovedSize+ "\n")
#                   text_fileOut.writelines(date+","+DDBID + "," +  AFID+ ","+ Time + ","+ Host +","+ DC_NAME +" \n")
#        except OSError:
#            print("here I am")
#            pass        
        
text_fileIn.close()
#text_fileOut.close()
text_fileOutquantum.close()               