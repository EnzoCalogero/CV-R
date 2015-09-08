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

import re
import os



def main():
    pass
inc=0 # flag for one time relate...
if __name__ == '__main__':
    main()
text_fileOut = open("C:/Users/enzo7311/Desktop/timeseries/MM81.csv", "w")
text_fileOut.writelines("Date and Time"+", "+"Storage Policy" + ", " + "Status"+ ", "+ "Number"+"\n")


inputFile="C:/Users/enzo7311/Desktop/timeseries/mm81.txt"

print("\nLooping through the file, line by line.")

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
                                  print (CurTime)
  #Get storag epolicy
  if(re.search( r"eek.(.*)", line, re.M|re.I)):
                              # print(line)
                               #text_fileOut.write(line)
                               #date=line[12:17]+"/2014 "+line[18:26]
                               #   print(date)
                               # print (m.group(0))
                                  StoraPolicy=line[0:143]
                                  print (StoraPolicy)
                                  Status=line[144:200]
                                  print (Status)
                                  if(Status.strip()=="Running"):
                                           print(inc)
                                           StatusRun=inc
                                  if(Status.strip()=="Pending"):
                                           print(inc)
                                           StatusPen=inc
                                  if(Status.strip()=="Queued"):
                                           print(inc)
                                           StatusQue=inc
                                  if(Status.strip()=="Waiting"):
                                           print(inc)
                                           StatusWai=inc

                                  Number=line[401:423]
                                  print (Number)



                                  #stip() remove space both sides, rstrip only on the right side...
                                #  print(CurTime+';'+StoraPolicy.rstrip()+';'+CopySP.strip() +';'+StoraPolicySize.strip())
                                  text_fileOut.writelines(CurTime+','+StoraPolicy.rstrip()+','+Status.strip() +','+Number.strip()+"\n")



filin.close()
text_fileOut.close()

#populate with zero value
