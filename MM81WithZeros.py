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
#import sqlite3
import codecs



def main():
    pass
inc=0 # flag for one time relate...
SPLIST=[] # Storage policy list on the logs.
TimeDList=[] # Date and time list
if __name__ == '__main__':
    main()



text_fileOut = open("C:/Users/enzo7311/Desktop/timeseries/temp.csv", "w")
text_fileOut.writelines("Date and Time"+", "+"Storage Policy" + ", " + "Status"+ ", "+ "Number"+"\n")


inputFile="C:/Users/enzo7311/Desktop/timeseries/mm82.txt"

print("\nLooping through the file, line by line.")
#filin=codecs.open(inputFile, encoding='utf-8')
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
                                  if((CurTime not in TimeDList)):
                                    TimeDList.append( CurTime );
                                    #SPLIST=set(SPLIST)
                                    print("TimeDList")
                                    print(TimeDList)
  #Get storag epolicy
  if(re.search( r"eek.(.*)", line, re.M|re.I)):
                              # print(line)
                               #text_fileOut.write(line)
                               #date=line[12:17]+"/2014 "+line[18:26]
                               #   print(date)
                               # print (m.group(0))
                                  StoraPolicy=line[0:143].rstrip()
                                  print(StoraPolicy)
                                  if((StoraPolicy not in SPLIST)):
                                    SPLIST.append( StoraPolicy.rstrip() );
                                    #SPLIST=set(SPLIST)
                                    print("SPLIST")
                                    print(SPLIST)



                                  Status=line[144:200]
                                  print (Status)
##                                  if(Status.strip()=="Running"):
##                                           print(inc)
##                                           StatusRun=inc
##                                  if(Status.strip()=="Pending"):
##                                           print(inc)
##                                           StatusPen=inc
##                                  if(Status.strip()=="Queued"):
##                                           print(inc)
##                                           StatusQue=inc
##                                  if(Status.strip()=="Waiting"):
##                                           print(inc)
##                                           StatusWai=inc

                                  Number=line[401:423]
                                  print (Number)
                                  #stip() remove space both sides, rstrip only on the right side...
                                  text_fileOut.writelines(CurTime+','+StoraPolicy.rstrip()+','+Status.strip() +','+Number.strip()+"\n")




print("TimeDList")
print(TimeDList)
print("SPLIST")
print(SPLIST)
#populate with zero value
for dt in TimeDList:
    for SP_ in SPLIST:
       text_fileOut.writelines(dt+','+SP_+','+ "Running"+','+"0\n")
       text_fileOut.writelines(dt+','+SP_+','+ "Pending"+','+"0\n")
       text_fileOut.writelines(dt+','+SP_+','+ "Queued"+','+"0\n")
       text_fileOut.writelines(dt+','+SP_+','+ "Waiting"+','+"0\n")


filin.close()
text_fileOut.close()