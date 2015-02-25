#-------------------------------------------------------------------------------
# Name:        Import Jobs
#
# Purpose: estract the number of running jobs on a CommCell for each hour of one week.
#          Then create a csv file with the matix + time of this information.
#
# Author:      enzo7311
#
# Created:     31/12/2014
# Copyright:   (c) enzo7311 2014
# Licence:     <your licence>
#-------------------------------------------------------------------------------
import csv
import sqlite3
def writeAll(Ppath,CS, DAY, month, year):

    path=Ppath +"\\"+ CS +"\\"+ str(DAY) +"_"+ str(month) +"_"+ str(year) +"\\"+ "All.csv"
    print(Ppath)
    fout=open(path,'w')
    fout.write("h_24, h_1, h_2, h_3,h_4,h_5,h_6,h_7,h_8,h_9,h_10,h_11,h_12,h_13,h_14,h_15,h_16,h_17,h_18,h_19,h_20,h_21,h_22,h_23,day, month,year")
    #fout.write("test")
    for d in range(0,7):
          fout.write('\n')
          for h in range(0,25):
               if(h>0) :fout.write(",")
               fout.write(str(matriceNumJob[d][h]))
    fout.close()





def writeSP(Ppath,CS, DAY, month, year,StoragePolicy):

    path=Ppath +"\\"+ CS +"\\"+ str(DAY) +"_"+ str(month) +"_"+ str(year) +"\\"+ StoragePolicy + ".csv"
    print(Ppath)
    fout=open(path,'w')
    fout.write("h_24, h_1, h_2, h_3,h_4,h_5,h_6,h_7,h_8,h_9,h_10,h_11,h_12,h_13,h_14,h_15,h_16,h_17,h_18,h_19,h_20,h_21,h_22,h_23,day, month,year")
    #fout.write("test")
    for d in range(0,7):
          fout.write('\n')
          for h in range(0,25):
               if(h>0) :fout.write(",")
               fout.write(str(matriceNumJob[d][h]))
    fout.close()

def readDB(SPolicy):
     matriceNumJob= [[1 for j in range(25)] for i in range(7)]
 #    matriceTime= [[1 for j in range(24)] for i in range(7)]
     for day in range(0,7):
         for hour in range(24):
 #           matriceTime[day][hour]=day*24+hour
            if(str(SPolicy) !="All"):
                sql = "SELECT count (*) FROM Jobs where data_sp= \'" + str(SPolicy) +"\' and startSTANDART<="+ str(24* (day+inizialeDay)+hour+timezone) + " and endSTANDART>="
                sql =sql+ str( 24*(day+inizialeDay)+hour+timezone)+ " and startdateMese=" + str((inizialeMonth))
            else:
                sql = "SELECT count (*) FROM Jobs where startSTANDART<="+ str(24* (day+inizialeDay)+hour+timezone) + " and endSTANDART>="
                sql =sql+ str( 24*(day+inizialeDay)+hour+timezone)+ " and startdateMese=" + str((inizialeMonth))

            print (sql)
            ai=cursor.execute(sql)
    ##   Popolate the time
            if(hour==1):
                sql = "SELECT  startdateDay,startdateMese,startdateAnno FROM Jobs where startSTANDART=="+ str(24* (day+inizialeDay)+hour+timezone)
                timestamp=cursor.execute(sql)
                for row in timestamp:
                    #print(row)
                    #matriceTimeStampDay[day]=row

                    matriceNumJob[day][24]=row

            for row in ai:
                a=row[0]
                #print(a)
                matriceNumJob[day][hour]=a
     print("matrice")
     print("############")
     print(matriceNumJob)
     return(matriceNumJob)


def storagePolicy():
    "###Extract the Storage Policy list from the DB####"


    sql = "SELECT data_sp FROM Jobs group by data_sp " # where startSTANDART=="+ str(24* (day+inizialeDay)+hour+timezone)
    Storage=list()
    timestamp=cursor.execute(sql)
    for [sp] in timestamp:
        Storage.append(str(sp))
        print(str(sp))
    print(Storage)
    return(Storage)


def csv_reader(file_obj):

    cursor.execute(''' CREATE TABLE Jobs(
                       data_sp TEXT,jobstatus TEXT,backuplevel TEXT,
                       startdateDay INTEGER,startdateMese INTEGER,
                       startdateAnno INTEGER,startdateOra INTEGER,
                       startSTANDART INTEGER,
                       enddateDay INTEGER,enddateMese INTEGER,
                       enddateAnno INTEGER,enddateOra INTEGER,
                       endSTANDART INTEGER,
                       durationunixsec INTEGER,
                       numbytesuncomp DOUBLE,numbytescomp DOUBLE,
                       numobjects INTEGER)
                    ''')
    db.commit()


    #cursor.execute(insert)  #("INSERT INTO Jobs VALUES (10,'mio')")

    #Read a csv file
    reader = csv.DictReader(file_obj, delimiter=',')
    for row in reader:
      #print(row["durationunixsec"])
      #print(row["clientname"])
      insert="INSERT INTO Jobs VALUES ("+ "'"+ str(row["data_sp"]) + "'"+ ","+ "'"
      insert=insert+str(row["jobstatus"]) + "'"+ ","+ "'"+str(row["backuplevel"]) + "'"+ ","+ "'"
      insert=insert +str(row["startdate"])[0:2] + "'"+ ","+ "'"  #giorno
      insert=insert +str(row["startdate"])[3:5] + "'"+ ","+ "'"  #mese
      insert=insert +str(row["startdate"])[8:10] + "'"+ ","+ "'" #anno
      insert=insert +str(row["startdate"])[11:13] + "'"+ ","+ "'" #Ora
      insert=insert +str((24*int((row["startdate"])[0:2]))+int((row["startdate"])[11:13]))+ "'"+ ","+ "'" #start standard time
      insert=insert +str(row["enddate"])[0:2] + "'"+ ","+ "'"  #giorno
      insert=insert +str(row["enddate"])[3:5] + "'"+ ","+ "'"  #mese
      insert=insert +str(row["enddate"])[8:10] + "'"+ ","+ "'" #anno
      insert=insert +str(row["enddate"])[11:13] + "'"+ ","+ "'" #Ora
      insert=insert +str((24*int((row["enddate"])[0:2]))+int((row["enddate"])[11:13]))+ "'"+ ","+ "'" #start standard time
      insert=insert +str(row["durationunixsec"]) + "'"+ ","+ "'"
      insert=insert +str(row["numbytesuncomp"]) + "'"+ ","+ "'"
      insert=insert +str(row["numbytescomp"]) + "'"+ ","+ "'"
      insert=insert +str(row["numobjects"]) + "'" +")"
     # print(insert)
      cursor.execute(insert)


def main():
    pass
if __name__ == '__main__':
    main()

#Definizioni iniziali...
inizialeDay=15
inizialeMonth=10
CS='CS499'
DAY=inizialeDay
month=inizialeMonth
year=2014

timezone=-1  #-1-->UK

# where to save the output files

Ppath='C:\\Users\\enzo7311\\Desktop\\dati\\heatmap'

#############################
### Create a database in RAM #####
##################################
db = sqlite3.connect(':memory:')
    # Creates or opens a file called mydb with a SQLite3 DB
    #db = sqlite3.connect('mydb')
cursor = db.cursor()
##################################

##################################
##Open Source File################
##################################
csv_path = "C:\Users\enzo7311\Desktop\dati\cs499jobs0411.csv"
with open(csv_path, "rb") as f_obj:
   csv_reader(f_obj)

####Extract the Storage policy list##

SP=storagePolicy()
print("SP")
print(SP)
#.....Add the loop for create an file for each storage policy....
for SPolicy in SP:
    #SPolicy='52WeekOffsite_MA02_A'
    matriceNumJob=readDB(SPolicy)
    writeSP(Ppath,CS,DAY,month,year,SPolicy)
print("~~~~~~~~~~~~~~~~~~~~ECOCI ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
matriceNumJob=readDB("All")
writeAll(Ppath,CS,DAY,month,year)
