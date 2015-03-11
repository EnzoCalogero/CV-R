#-------------------------------------------------------------------------------
# Name:        module1
# Purpose:
#
# Author:      Enzo
#
# Created:     10/08/2014
# Copyright:   (c) cv 2014
# Licence:     <your licence>
#-------------------------------------------------------------------------------
#from win_unc import UncCredentials, UncDirectory, UncDirectoryConnection
# Info on the Library....
#http://developer.covenanteyes.com/unc-paths-with-python/

import re
import os
def get_subdirectories(a_dir):
    return [name for name in os.listdir(a_dir)
            if os.path.isdir(os.path.join(a_dir, name))]

def main():
    pass

if __name__ == '__main__':
    main()
#text_fileOut = open("C:\Users\enzo7311\Desktop\sealing\sidengine\CS903_15_11.csv", "w")
#text_fileOut = open("C:\Users\enzo7311\Desktop\sealing\sidengine\CS903_20_11.csv", "w")
#text_fileOut = open("C:\Users\enzo7311\Desktop\sealing\sidengine\CS903_28_11.csv", "w")
#text_fileOut = open("C:\Users\enzo7311\Desktop\sealing\sidengine\CS901_23_12.csv", "w")
text_fileOut = open("C:\Users\enzo7311\Desktop\sealing\sidengine\CS406_30_01.csv", "w")

#folder="C:\Users\enzo7311\Desktop\sealing\sidengine\SIDBEngine"
#inputFile=[folder+".log",folder+"_1.log",folder+"_2.log",folder+"_3.log",folder+"_4.log",folder+"_5.log",folder+"_6.log",folder+"_7.log",folder+"_8.log",folder+"_9.log",folder+"_10.log"]
#folder1="C:\Users\enzo7311\Desktop\Prune Impact\903\\20_11\logs_1416477732\\"
#folder1="C:\Users\enzo7311\Desktop\Prune Impact\cs902\logs_1416991606\\"
#folder1="C:\Users\enzo7311\Desktop\Prune Impact\cs903\logs_1417183912\\"
#folder1="C:\Users\enzo7311\Desktop\Prune Impact\cs404\logs_1415968039\\"
#folder1="C:\Users\enzo7311\Desktop\Prune Impact\cs901\logs_1419350644\\"
folder1="C:\Users\enzo7311\Desktop\Prune Impact\cs406\day1\logs_1422651434\\"

folder="SIDBEngine"

imputfolder=get_subdirectories(folder1)
print(imputfolder)
#input()
#["ord101cs0903ma1.storage.rackspace.com","ord101cs0903ma2.storage.rackspace.com","ord101cs0903ma3.storage.rackspace.com","ord101cs0903ma4.storage.rackspace.com","ord101cs0903ma5.storage.rackspace.com","ord101cs0903ma6","ord101cs0903ma7","ord101cs0903ma8","ord101cs0903ma9"]
inputFile=[folder+".log",folder+"_1.log",folder+"_2.log",folder+"_3.log",folder+"_4.log",folder+"_5.log",folder+"_6.log",folder+"_7.log",folder+"_8.log",folder+"_9.log",folder+"_10.log"]

print("Creating a text file with the write() method.")


text_fileOut.writelines("Date"+", "+"DDBID" + ", " + "AFID"+ ", "+ "TimeSec"+"\n")
print("\nLooping through the file, line by line.")
#for a in inputFile:
# text_fileIn = open(a, "r")
# for line in text_fileIn:
for b in imputfolder:
        print b
        folder=folder1+b
        for a in inputFile:
            aa=folder1+b+"\\"+a
            if(os.path.exists(aa)):
                print aa
                text_fileIn = open(aa, "r")
                for line in text_fileIn:
                    if(re.search( r"from.pending.list.", line, re.M|re.I)):
                              # print(line)
                               #text_fileOut.write(line)
                               date=line[12:17]+"/2014 "+line[18:26]
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
                               text_fileOut.writelines(date+", "+DDBID + ", " +  AFID+ ", "+ Time+"\n")
text_fileIn.close()
text_fileOut.close()
