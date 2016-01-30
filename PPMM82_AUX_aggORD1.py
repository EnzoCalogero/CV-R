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
    
###########################################################    
#                                                         #  
# Collect the files                                       #
#                                                         #
###########################################################    

#CS902
Host="10.12.21.15"
host="CS902"
dest="c:/dati/AUX_Analisis/ORD1/"+host+ "Pre.txt"
src="//10.12.21.15/c$/rs-pkgs/OMSA/MM82.txt"    
copyFile(src,dest,Host)    



#############################################
#            Convertition
############################################

CommCells=["CS902"]    

for host in CommCells:
#  os.system('sox input.wav -b 24 output.aiff rate -v -L -b 90 48k')  
  cmd1="cmd.exe /a /c TYPE c:\dati\AUX_Analisis\ORD1\\"+host+ "Pre.txt > c:\dati\AUX_Analisis\ORD1\\"+host+ ".txt"
#  print(cmd1)
  os.system(cmd1)


#############################################
#   create the excel File
############################################



text_fileOut = open("C:/dati/AUX_Analisis/ORD1/globalOrd1.csv", "w")
text_fileOut.writelines("Date and Time"+", "+"Storage Policy" + ", " + "Copy"+ ", "+ "Residual Size, CS"+"\n")
    

for CS in CommCells:
    
    inputFile="C:/dati/AUX_Analisis/ORD1/"+CS+".txt"
    
         
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
                                     # print (CurTime)
      #Get storag epolicy
      if(re.search( r"Off.(.*)", line, re.M|re.I)):
                                  # print(line)
                                   #text_fileOut.write(line)
                                   #date=line[12:17]+"/2014 "+line[18:26]
                                   #   print(date)
                                   # print (m.group(0))
                                      StoraPolicy=line[0:143]
                                    #  print (StoraPolicy)
                                      CopySP=line[144:200]
                                    #  print (CopySP)
                                      StoraPolicySize=line[201:223]
                                     # print (StoraPolicySize)
    
                                     #stip() remove space both sides, rstrip only on the right side...
                                     # print(CurTime+';'+StoraPolicy.rstrip()+';'+CopySP.strip() +';'+StoraPolicySize.strip())
                                      text_fileOut.writelines(CurTime+','+StoraPolicy.rstrip()+','+CopySP.strip() +','+StoraPolicySize.strip()+','+ CS +"\n")

filin.close()
text_fileOut.close()