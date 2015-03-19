#-------------------------------------------------------------------------------
# Name:        Extract information from the AuxCopyMgr.log
#               To anlyse the AUX copy trend.....
# Purpose:
#
# Author:      Enzo
#
# Created:     10/03/2015
# Copyright:   (c) cv 2015
# Licence:     <your licence>
#-------------------------------------------------------------------------------

import re
import os
def get_subdirectories(a_dir):
 #   print("inside the def...")
 #   print(a_dir)
    return os.listdir(a_dir)

def main():
    pass

if __name__ == '__main__':
    main()
folder1="C:\Users\enzo7311\Desktop\AUXA\\"
folder="AuxCopyMgr"

inputFile=[folder+".log",folder+"_1.log",folder+"_2.log",folder+"_3.log",folder+"_4.log",folder+"_5.log",folder+"_6.log",folder+"_7.log",folder+"_8.log",folder+"_9.log",folder+"_10.log",folder+"_11.log"]
inputFile=inputFile+[folder+"_12.log",folder+"_13.log",folder+"_14.log",folder+"_15.log",folder+"_16.log",folder+"_17.log",folder+"_18.log",folder+"_19.log",folder+"_20.log",folder+"_21.log",folder+"_22.log",folder+"_23.log"]

jobid_SP={} # ....define the dictionaries to associates the jobid to the storage policy.....
jobid_MA={} # ....define the dictionaries to associates the jobid to the Media Agent.....
print("....Starts.....")


########################################################################################
###We craete the date jobid storag epolicy table########################################
########################################################################################
text_fileOut = open("C:\Users\enzo7311\Desktop\AUXA\\auxcopyST_POL.csv", "w")
text_fileOut.writelines("Date,jobid, Storage Policy\n")
print("\nLooping through the file, line by line.")
#print(inputFile)
for a in inputFile:
            aa=folder1+a
           # print(aa)
            if(os.path.exists(aa)):
                print aa
                text_fileIn = open(aa, "r")
                for line in text_fileIn:
                     #print(line)
                     if(re.search( r"AuxCopyReserve::getJobParameters.Copy properties", line, re.M|re.I)):
                              # print(line)
                               #text_fileOut.write(line)
                               date=line[12:17]+"/2014 "+line[18:26]
                              # print(date)
                               jobid=line[27:34]
                              # print(jobid)

                               m = re.search(r'.Policy.\[(.+?)\]', line,re.M|re.I)
                               if m:
                                   STPol=m.group(1)
                               #    print(m.group(1))

                               text_fileOut.writelines(date+", "+jobid + ", " +  STPol+"\n")
                               jobid_SP[jobid]=STPol
                text_fileIn.close()

#text_fileIn.close()
text_fileOut.close()
print(jobid_SP)

########################################################################################
###We craete the date jobid Media agents table########################################
########################################################################################
text_fileOut = open("C:\Users\enzo7311\Desktop\AUXA\\auxMediaAgents_POL.csv", "w")
text_fileOut.writelines("Date,jobid, Media Agent\n")
print("\nLooping through the file, line by line.")
#print(inputFile)
for a in inputFile:
            aa=folder1+a
           # print(aa)
            if(os.path.exists(aa)):
                print aa
                text_fileIn = open(aa, "r")
                for line in text_fileIn:
                     #print(line)
                     if(re.search( r"AuxCopyManager::sendFreeStreamRequest FREE STREAM Request for readerId ", line, re.M|re.I)):
                              # print(line)
                               #text_fileOut.write(line)
                               date=line[12:17]+"/2014 "+line[18:26]
                              # print(date)
                               jobid=line[27:34]
                              # print(jobid)

                               m = re.search(r'.media.agent.\[(.+?)\]', line,re.M|re.I)
                               if m:
                                   MAgent=m.group(1)
                               #    print(m.group(1))

                               text_fileOut.writelines(date+", "+jobid + ", " +  MAgent+"\n")
                               jobid_MA[jobid]=MAgent
                text_fileIn.close()

#text_fileIn.close()
text_fileOut.close()
print(jobid_MA)

########################################################################################
###We craete the date jobid storage policy table########################################
########################################################################################
text_fileOut = open("C:\Users\enzo7311\Desktop\AUXA\\auxcopySourceDest.csv", "w")
text_fileOut.writelines("date,jobid,Storage_Policy,MediaAget,source,target,Bytes,time\n")
print("\nLooping through the file, line by line.")
#print(inputFile)
for a in inputFile:
            aa=folder1+a
          #  print(aa)
            if(os.path.exists(aa)):
                print aa
                text_fileIn = open(aa, "r")
                for line in text_fileIn:
                     #print(line)
                     if(re.search( r"AuxCopyManager::updateProgressToJM.", line, re.M|re.I)):
                              # print(line)
                               #text_fileOut.write(line)
                               date=line[12:17]+"/2014 "+line[18:26]
                               #print(date)
                               jobid=line[27:34]
                               #print(jobid)

                               m = re.search(r'.Source.\<(.+?)\>', line,re.M|re.I)
                               if m:
                                   source=m.group(1)
                               #    print(m.group())
                               m = re.search(r'.Target.\<(.+?)\>', line,re.M|re.I)
                               if m:
                                   target=m.group(1)
                                #   print(m.group())
                               m = re.search(r'.Throughput parameters:.\[(.+?)\]', line,re.M|re.I)
                               if m:
                                   Bytes=m.group(1)
                                 #  print(m.group())
                               m = re.search(r'.read in.\[(.+?)\]', line,re.M|re.I)
                               if m:
                                   time=m.group(1)
                                  # print(m.group())
                               if(jobid_SP.has_key(jobid) and jobid_MA.has_key(jobid)): {
                                    text_fileOut.writelines(date + ", "+jobid + ", " + jobid_SP[jobid]+ ", " + jobid_MA[jobid]+ ", "+  source+", " + target+", " +Bytes+", " + time +"\n")
                                    }
                text_fileIn.close()

text_fileIn.close()
text_fileOut.close()

