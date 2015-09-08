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

if __name__ == '__main__':
    main()
text_fileOut = open("C:/Users/enzo7311/Desktop/timeseries/MM82_cs499.csv", "w")
text_fileOut.writelines("Date and Time"+", "+"Storage Policy" + ", " + "Copy"+ ", "+ "Residual Size"+"\n")


inputFile="C:/Users/enzo7311/Desktop/timeseries/MM82-cs499.txt"
#inputFile="C:/Users/enzo7311/Desktop/timeseries/Daily_Report_1055_old.csv"
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
  if(re.search( r"Off.(.*)", line, re.M|re.I)):
                              # print(line)
                               #text_fileOut.write(line)
                               #date=line[12:17]+"/2014 "+line[18:26]
                               #   print(date)
                               # print (m.group(0))
                                  StoraPolicy=line[0:143]
                                  print (StoraPolicy)
                                  CopySP=line[144:200]
                                  print (CopySP)
                                  StoraPolicySize=line[201:223]
                                  print (StoraPolicySize)


                                  #stip() remove space both sides, rstrip only on the right side...
                                  print(CurTime+';'+StoraPolicy.rstrip()+';'+CopySP.strip() +';'+StoraPolicySize.strip())
                                  text_fileOut.writelines(CurTime+','+StoraPolicy.rstrip()+','+CopySP.strip() +','+StoraPolicySize.strip()+"\n")



filin.close()
text_fileOut.close()