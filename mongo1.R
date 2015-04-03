mongoDBInsert<-function(file='C:/Users/enzo7311/Desktop/Dati/cs403ddb11_28.csv', sidb=11,Mo=11){
  library(rmongodb)
  library(lubridate)
  dati<-DedupRead_TS(file='C:/Users/enzo7311/Desktop/Dati/cs403ddb11_28.csv', sidb=11,Mo=11)
 #View(dati) 
 mongo <- mongo.create()
 print( mongo.get.databases(mongo))
 mongo.get.database.collections(mongo, "test")
 buf <- mongo.bson.buffer.create()
 mongo.bson.buffer.append(buf, "name", "Joe")
 mongo.bson.buffer.append(buf, "age", 22L)
 mongo.bson.from.JSON('{"city":"COLORADO CITY", "loc":[-112.952427, 36.976266]}')
 
 json <- '{"a":1, "b":2, "c": {"d":3, "e":4}}'
 bson <- mongo.bson.from.JSON(json)
 mongo.insert(mongo, "COPYPERFORMANCES.test", bson)
 for (index in 1:600){
 
 json <- paste('{\"date\":','\"',day(dati[index,]),'-',hour(dati[index,]),'\", \"secondary\":',dati[index,]$secondaryR,'}',sep="")#,"PrimaryR":dati[index,]$PrimaryR}'
 print (json)
 bson <- mongo.bson.from.JSON(json)
 mongo.insert(mongo, "COPYPERFORMANCES.test", bson)
 }
 
 #mongo.insert(mongo,'COPYPERFORMANCES.prima_prova',{a:10})
}