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
import shutil
import re
import os
import os
import tempfile
import win32wnet

def copyFile(src, dest,Host):
    try:
        win32wnet.WNetAddConnection2(0, None, '\\\\'+ Host, None, 'storage\enzo.calogero','N1cole85.')
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




def main():
    pass

if __name__ == '__main__':
    main()
    
###########################################################    
#                                                         #  
# Collect the files                                       #
#                                                         #
###########################################################    
#cs901
Host="ord101cs0901.storage.rackspace.com"
host="CS901"
dest="c:/dati/deleteAF/ORD1/"+host+ "Pre.txt"
src="//ord101cs0901.storage.rackspace.com/c$/rs-pkgs/OMSA/MM84.txt"
copyFile(src,dest,Host)    

#cs902
Host="ord101cs0902.storage.rackspace.com"
host="CS902"
dest="c:/dati/deleteAF/ORD1/"+host+ "Pre.txt"
src="//ord101cs0902.storage.rackspace.com/c$/rs-pkgs/OMSA/MM84.txt"
copyFile(src,dest,Host)    


#cs903
Host="ord101cs0903.storage.rackspace.com"
host="CS903"
dest="c:/dati/deleteAF/ORD1/"+host+ "Pre.txt"
src="//ord101cs0903.storage.rackspace.com/c$/rs-pkgs/OMSA/MM84.txt"
copyFile(src,dest,Host)  
#cs904
Host="ord101cs0904.storage.rackspace.com"
host="CS904"
dest="c:/dati/deleteAF/ORD1/"+host+ "Pre.txt"
src="//ord101cs0904.storage.rackspace.com/c$/rs-pkgs/OMSA/MM84.txt"
copyFile(src,dest,Host) 
#cs905
Host="ord101cs0905.storage.rackspace.com"
host="CS905"
dest="c:/dati/deleteAF/ORD1/"+host+ "Pre.txt"
src="//ord101cs0905.storage.rackspace.com/c$/rs-pkgs/OMSA/MM84.txt"
copyFile(src,dest,Host) 
#cs906
Host="ord101cs0906.storage.rackspace.com"
host="CS906"
dest="c:/dati/deleteAF/ORD1/"+host+ "Pre.txt"
src="//ord101cs0906.storage.rackspace.com/c$/rs-pkgs/OMSA/MM84.txt"
copyFile(src,dest,Host) 


#############################################
#            Convertition
############################################

CommCells=["CS901","CS902","CS903","CS904","CS905","CS906"] 
#
for host in CommCells:
#  os.system('sox input.wav -b 24 output.aiff rate -v -L -b 90 48k')  
   cmd1="cmd.exe /a /c TYPE c:\dati\deleteAF\ORD1\\"+host+ "Pre.txt > c:\dati\deleteAF\ORD1\\"+host+ ".txt"
   #print(cmd1)
   os.system(cmd1)


#############################################
#   create the excel File
############################################



   text_fileOut = open("C:/dati/deleteAF/ORD1/globalOrd1AF.csv", "a")
   #text_fileOut.writelines("DAY"+", "+"DDB-ID" + ", " + "Record_Count"+ ", "+ "Size_on_Disk, Application_Size, CommCell"+"\n")
    

#CommCells=["CS404","CS498","CS499","CSITS"]    

for CS in CommCells:
    inputFile="C:/dati/deleteAF/ORD1/"+CS+".txt"
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
                                      CurTime=m.group(1)[0:10]
                                      #print (CurTime)
      #Get storag epolicy
         if(re.search( r"^[0-9]+", line, re.M|re.I)):
                                  # print(line)
                                   #text_fileOut.write(line)
                                   #date=line[12:17]+"/2014 "+line[18:26]
                                   #   print(date)
                                   # print (m.group(0))
                                      DDB=line[0:5]
                                      #print (DDB)
                                      Records=line[6:23]
                                      #print (Records)
                                      Capacity_Free=line[23:44]
                                      #print (Capacity_Free)
                                      Appsize=line[44:60]
                                      #print (Appsize)
    
    
                                      #stip() remove space both sides, rstrip only on the right side...
                                      #print(CurTime+','+DDB.rstrip()+','+Records.strip() +','+Capacity_Free.strip()+','+ Appsize.strip() +"\n")
                                      text_fileOut.writelines(CurTime+','+DDB.rstrip()+','+Records.strip() +','+Capacity_Free.strip()+','+ Appsize.strip() +','+CS+"\n")



filin.close()
text_fileOut.close()