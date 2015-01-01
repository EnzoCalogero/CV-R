#-------------------------------------------------------------------------------
# Name:        Import Jobs
# Purpose:
#
# Author:      enzo7311
#
# Created:     31/12/2014
# Copyright:   (c) enzo7311 2014
# Licence:     <your licence>
#-------------------------------------------------------------------------------
import csv
import sqlite3


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
inizialeDay=15
inizialeMonth=10
matrice= [[1 for j in range(24)] for i in range(7)]



#Definizioni iniziali...
# Create a database in RAM
db = sqlite3.connect(':memory:')
    # Creates or opens a file called mydb with a SQLite3 DB
    #db = sqlite3.connect('mydb')
cursor = db.cursor()

csv_path = "C:\Users\enzo7311\Desktop\dati\cs499jobs0411.csv"
with open(csv_path, "rb") as f_obj:
 csv_reader(f_obj)

 for day in range(0,7):
     for hour in range(24):
        #print(day*24+hour)
        matrice[day][hour]=day*24+hour
        print("ora")
        print(hour)
        print("day")
        print(day+inizialeDay)
        print(24* (day+inizialeDay)+hour)
        print "\nResults from a LIKE query:\n"
        sql = "SELECT * FROM Jobs where startSTANDART<="+ str(24* (day+inizialeDay)+hour) + " and endSTANDART>="
        sql =sql+ str( 24*(day+inizialeDay)+hour)+ " and startdateMese=" + str((inizialeMonth))


        cursor.execute(sql)
        print cursor.fetchall()



#print(matrice)

