# -*- coding: utf-8 -*-
"""
Created on Fri Dec 04 09:24:55 2015

@author: enzo7311
"""
import codecs

dest="C:/dati/temp/Daily_Report.txt"
text_fileIn = codecs.open(dest, "r")


for line in text_fileIn:

    print(line.dencode("UTF-8"))