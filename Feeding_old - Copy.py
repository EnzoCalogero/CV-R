import re
def main():
    pass

if __name__ == '__main__':
    main()
folder1="C:\Users\enzo7311\Desktop\Prune Impact\903\logs_1415967650\\"
folder="SIDBEngine"
imputfolder=["ord101cs0903ma1.storage.rackspace.com","ord101cs0903ma2.storage.rackspace.com","ord101cs0903ma3.storage.rackspace.com","ord101cs0903ma4.storage.rackspace.com","ord101cs0903ma5.storage.rackspace.com","ord101cs0903ma6","ord101cs0903ma7","ord101cs0903ma8","ord101cs0903ma9"]
inputFile=[folder+".log",folder+"_1.log",folder+"_2.log",folder+"_3.log",folder+"_4.log",folder+"_5.log",folder+"_6.log",folder+"_7.log",folder+"_8.log",folder+"_9.log",folder+"_10.log"]

print("Creating a text file with the write() method.")
text_fileOut = open("C:\Users\enzo7311\Desktop\sealing\sidengine\Feeding.csv", "w")
text_fileOut.writelines("Date"+", "+"DDBID" + ", " + "AFID"+ ", "+ "TimeSec"+"\n")
print("\nLooping through the file, line by line.")
for b in imputfolder:
        print b
        folder=folder1+b
        for a in inputFile:
            aa=folder1+b+"\\"+a
            print aa
            text_fileIn = open(aa, "r")

            #4560  eb4   11/06 12:21:35 ### 62-0-#-#  OnSubmitAfiles    190  Recvd afid [12354983] for pruning. Summary [00000001], Priority [0], Afs currently pending [62]
            for line in text_fileIn:
                 if(re.search( r"Recvd.afid", line, re.M|re.I)):
                          # print(line)
                         #  text_fileOut.write(line)
                           date=line[12:17]+"/2014 "+line[18:26]
                        #   print(date)
                           m = re.search('#+.(.+?)-', line)
                           if m:
                               DDBID = m.group(1)
                            #   print DDBID
            #----
                           m = re.search('currently.pending.\[(.+?)\]', line)
                           if m:
                               AFID = m.group(1)
                             #  print AFID
             #              m = re.search('taken.\[(.+?)\]', line)
             #              if m:
             #                  Time = m.group(1)
                               #Time=float(Time)
                              # print Time
                           #print( DDBID + "  "+ "  "+  AFID+ "  ")
                           if AFID=='0':
                              print("OKKKKKKKKKKKKKKKKKKKKKKKKKKKK")
                              print(date+";  "+line )
                              text_fileOut.writelines(date+", "+ DDBID + ", " +  AFID+";  " +line+ "\n")

text_fileIn.close()
text_fileOut.close()
