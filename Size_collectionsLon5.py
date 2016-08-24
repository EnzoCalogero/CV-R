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
        win32wnet.WNetAddConnection2(0, None, '\\\\'+ Host, None, 'storage\enzo.calogero','N1cole85.')
        #os.system ("copy %s %s" % (src, dest))
        for path in glob.iglob(src):
            print("prima")            
            print(path)
            shutil.copy(path, dest)
            print("dopo")
             #shutil.copy(path, 'out_folder/%s' % path)
 
#      shutil.copy(src, dest)
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

CSs={"CS301":"10.9.10.40","CS302":"10.18.20.80"}

#cs401
#Host="10.9.10.40"
#host="CS401"
for CS in CSs:
   print(CS)
   print(CSs[CS])
   dest="c:/dati/RapSpaceUsed/"+CS+ "CopyProperties.csv"
   print(dest) 
   src="//"+CSs[CS]+"/c$/Program Files/CommVault/Simpana/Reports/*CopyProperties.csv"
   #print(src) 
   #print(glob.glob(src))
   copyFile(src,dest,CSs[CS])   
################################## 
 #for name in glob.glob(src):
 #    print(name)
 #    copyFile(name,dest,CSs[CS])
#################################
   dest="c:/dati/RapSpaceUsed/"+CS+ "DedupStoreInfo.csv"
   src="//"+CSs[CS]+"/c$/Program Files/CommVault/Simpana/Reports/*DedupStoreInfo.csv"
# for name in glob.glob(src):
 #   print(name)
   copyFile(src,dest,CSs[CS])    
#    
