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

import win32wnet
import glob

def copyFile(src, dest,Host):
    try:
        win32wnet.WNetAddConnection2(0, None, '\\\\'+ Host, None, 'storage\enzo.calogero','N1cole84.')
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

CSs={"CS401":"10.9.10.40","CS411":"10.9.10.90","cs402":"10.9.10.41"}

#cs401
#Host="10.9.10.40"
#host="CS401"
for CS in CSs:
 print(CS)
 print(CSs[CS])
 dest="c:/dati/RepSpaceUsed/"+CS+ "CopyProperties.csv"
 print(dest) 
 src="//"+CSs[CS]+"/c$/Program Files/CommVault/Simpana/Reports/*CopyProperties.csv"
 print(src) 
 for name in glob.glob(src):
     print(name)
     copyFile(name,dest,CSs[CS])

 dest="c:/dati/RepSpaceUsed/"+CS+ "DedupStoreInfo.csv"
 src="//"+CSs[CS]+"/c$/Program Files/CommVault/Simpana/Reports/*DedupStoreInfo.csv"
 for name in glob.glob(src):
    print(name)
    copyFile(name,dest,CSs[CS])    
    
#Host="10.9.10.90"
#host="CS411"

#dest="c:/dati/RepSpaceUsed/"+host+ "CopyProperties.csv"
#src="//"+Host+"/c$/Program Files/CommVault/Simpana/Reports/*CopyProperties.csv"
#print(os.listdir(src))
#for name in glob.glob(src):
#    print(name)
#    copyFile(name,dest,Host)
#dest="c:/dati/RepSpaceUsed/"+host+ "DedupStoreInfo.csv"
#src="//"+Host+"/c$/Program Files/CommVault/Simpana/Reports/*DedupStoreInfo.csv"
#print(os.listdir(src))
#for name in glob.glob(src):
#    print(name)
#    copyFile(name,dest,Host)       
    


#copyFile(src,dest,Host)    
#cs402
#Host="10.9.10.41"
#host="CS402"
#dest="c:/dati/Jobs_Analisis/"+host+ "Pre.txt"
#src="//10.9.10.41/c$/rs-pkgs/Drivers/MM81.txt"
#copyFile(src,dest,Host)  
#cs403
#Host="10.9.10.42"
#host="CS403"
#dest="c:/dati/Jobs_Analisis/"+host+ "Pre.txt"
#src="//10.9.10.42/c$/rs-pkgs/Drivers/MM81.txt"
#copyFile(src,dest,Host)  

#cs404
#Host="10.9.10.43"
#host="CS404"
#dest="c:/dati/Jobs_Analisis/"+host+ "Pre.txt"
#src="//10.9.10.43/i$/AuxCopyStats/MM81.txt"
#copyFile(src,dest,Host)    

#cs406
#Host="10.9.10.60"
#host="CS406"
#dest="c:/dati/Jobs_Analisis/"+host+ "Pre.txt"
#src="//10.9.10.60/c$/rs-pkgs/Drivers/MM81.txt"
#copyFile(src,dest,Host)  


#cs410
#Host="10.9.10.80"
#host="CS410"
#dest="c:/dati/Jobs_Analisis/"+host+ "Pre.txt"
#src="//10.9.10.80/c$/rs-pkgs/Drivers/MM81.txt"
#copyFile(src,dest,Host)

#cs411
#Host="10.9.10.90"
#host="CS411"
#dest="c:/dati/Jobs_Analisis/"+host+ "Pre.txt"
#src="//10.9.10.90/c$/rs-pkgs/Drivers/MM81.txt"
#copyFile(src,dest,Host)


#CS498
#Host="10.9.10.140"
#host="CS498"
#dest="c:/dati/Jobs_Analisis/"+host+ "Pre.txt"
#src="//10.9.10.140/c$/rs-pkgs/Drivers/MM81.txt"    
#copyFile(src,dest,Host)    

#CS499
#Host="10.9.10.45"
#host="CS499"
#dest="c:/dati/Jobs_Analisis/"+host+ "Pre.txt"
#src="//10.9.10.45/c$/rs-pkgs/Drivers/MM81.txt"    
#copyFile(src,dest,Host)    


#CSITIS
#Host="10.9.10.70"
#host="CSITS"
#dest="c:/dati/Jobs_Analisis/"+host+ "Pre.txt"
#src="//10.9.10.70/c$/rs-pkgs/Drivers/MM81.txt"    
#copyFile(src,dest,Host)    

#############################################
#            Convertition
############################################

#CommCells=["CS401","CS402","CS403","CS404","CS406","CS410","CS411","CS497","CS498","CS499","CSITS"]    

