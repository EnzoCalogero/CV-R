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
import time
import tempfile
import win32wnet


def main():
    pass

if __name__ == '__main__':
    main()

###########################################################    
#                                                         #  
# Collect the files                                       #
#                                                         #
###########################################################    
#cs401

text_fileOut = open("C:/dati/dbmaintenace/dbmaintenace.csv", "w")
#text_fileOut.writelines("Date and Time"+", "+"Storage Policy" + ", " + "Copy"+ ", "+ "Residual Size, CS"+"\n")
text_fileOut.writelines("DC"+", "+"CS" + ", " + "Date"+"\n")    

LON5={"CS301":"10.18.20.50","CS302":"10.18.20.80"}
print ("-------------LON5------------------------")
DC="LON5"
for CS in LON5:
  Host=LON5[CS]
  host=CS
  src="//"+Host+"/c$/Program Files/CommVault/Simpana/Log Files/DBMaintenance.log"
  print(host)
  #print(src)
  win32wnet.WNetAddConnection2(0, None, '\\\\'+ Host, None, 'storage\enzo.calogero','N1cole84.')
  print "Last time DBMaintenace Ran: %s" % time.ctime(os.path.getmtime(src))
  text_fileOut.writelines(DC+", "+CS + ", " + time.ctime(os.path.getmtime(src))+"\n") 
DC="LON3"
LON3={"CS401":"10.9.10.40","CS402":"10.9.10.41","CS403":"10.9.10.42"
,"CS404":"10.9.10.43","CS406":"10.9.10.60","CS410":"10.9.10.80",
"CS411":"10.9.10.90","CS497":"10.8.38.140","CS498":"10.9.10.140",
"CS499":"10.9.10.45","CSITS":"10.9.10.70"}

print("-------------LON3------------------------")
for CS in LON3:
  Host=LON3[CS]
  host=CS
  src="//"+Host+"/c$/Program Files/CommVault/Simpana/Log Files/DBMaintenance.log"
  print(host)
  #print(src)
  win32wnet.WNetAddConnection2(0, None, '\\\\'+ Host, None, 'storage\enzo.calogero','N1cole84.')
  print "Last time DBMaintenace Ran: %s" % time.ctime(os.path.getmtime(src))
  text_fileOut.writelines(DC+", "+CS + ", " + time.ctime(os.path.getmtime(src))+"\n") 

DC="ORD1"
ORD1={"CS901":"ord101cs0901.storage.rackspace.com","CS902":"ord101cs0902.storage.rackspace.com",
 "CS903":"ord101cs0903.storage.rackspace.com","CS904":"ord101cs0904.storage.rackspace.com",
"CS905":"ord101cs0905.storage.rackspace.com","CS906":"ord101cs0906.storage.rackspace.com"}
    
print("-------------ORD1------------------------")
for CS in ORD1:
  Host=ORD1[CS]
  host=CS
  src="//"+Host+"/c$/Program Files/CommVault/Simpana/Log Files/DBMaintenance.log"
  print(host)
  #print(src)
  win32wnet.WNetAddConnection2(0, None, '\\\\'+ Host, None, 'storage\enzo.calogero','N1cole84.')
  print "Last time DBMaintenace Ran: %s" % time.ctime(os.path.getmtime(src))
  text_fileOut.writelines(DC+", "+CS + ", " + time.ctime(os.path.getmtime(src))+"\n") 
DC="IAD"
IAD1={"CS801":"IAD201cs0801.storage.rackspace.com","CS802":"IAD201cs0802.storage.rackspace.com","CS803":"IAD201cs0803.storage.rackspace.com",
"CS804":"IAD301cs0804.storage.rackspace.com","CS805":"IAD301cs0805.storage.rackspace.com"}  
#cs802

print("-------------IAD1------------------------")
for CS in IAD1:
  Host=IAD1[CS]
  host=CS
  src="//"+Host+"/c$/Program Files/CommVault/Simpana/Log Files/DBMaintenance.log"
  print(host)
  #print(src)
  win32wnet.WNetAddConnection2(0, None, '\\\\'+ Host, None, 'storage\enzo.calogero','N1cole84.')
  print "Last time DBMaintenace Ran: %s" % time.ctime(os.path.getmtime(src))
  text_fileOut.writelines(DC+", "+CS + ", " + time.ctime(os.path.getmtime(src))+"\n") 

#"CS16":"DFW101CS0016.storage.rackspace.com",
DC="DFW"
DFW={"CS01":"10.5.19.90","CS07":"DFW101CS0007.storage.rackspace.com","CS12":"DFW101CS0012.storage.rackspace.com",
"CS20":"DFW102CS0020.storage.rackspace.com","CS21":"DFW102CS0021.storage.rackspace.com",
"AONCS":"10.5.110.150","CS41":"DFW103CS0041.storage.rackspace.com"}

print("-------------DFW------------------------")
for CS in DFW:
  Host=DFW[CS]
  host=CS
  src="//"+Host+"/c$/Program Files/CommVault/Simpana/Log Files/DBMaintenance.log"
  print(host)
  #print(src)
  win32wnet.WNetAddConnection2(0, None, '\\\\'+ Host, None, 'storage\enzo.calogero','N1cole84.')
  print "Last time DBMaintenace Ran: %s" % time.ctime(os.path.getmtime(src))
  text_fileOut.writelines(DC+", "+CS + ", " + time.ctime(os.path.getmtime(src))+"\n") 

DC="SYD"
SYD={"CS501":"10.16.20.20","CS502":"10.18.20.80"}

print("-------------SYD------------------------")
for CS in SYD:
  Host=SYD[CS]
  host=CS
  src="//"+Host+"/c$/Program Files/CommVault/Simpana/Log Files/DBMaintenance.log"
  print(host)
  #print(src)
  win32wnet.WNetAddConnection2(0, None, '\\\\'+ Host, None, 'storage\enzo.calogero','N1cole84.')
  print "Last time DBMaintenace Ran: %s" % time.ctime(os.path.getmtime(src))
  text_fileOut.writelines(DC+", "+CS + ", " + time.ctime(os.path.getmtime(src))+"\n") 
 
DC="HK"
HK= {"CS701":"10.11.10.30"}

print("-------------HK------------------------")
for CS in HK:
  Host=HK[CS]
  host=CS
  src="//"+Host+"/c$/Program Files/CommVault/Simpana/Log Files/DBMaintenance.log"
  print(host)
  #print(src)
  win32wnet.WNetAddConnection2(0, None, '\\\\'+ Host, None, 'storage\enzo.calogero','N1cole84.')
  print "Last time DBMaintenace Ran: %s" % time.ctime(os.path.getmtime(src))
  text_fileOut.writelines(DC+", "+CS + ", " + time.ctime(os.path.getmtime(src))+"\n") 


text_fileOut.close()