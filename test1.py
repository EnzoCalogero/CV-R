#-------------------------------------------------------------------------------
# Name:        module1
# Purpose:
#
# Author:      enzo7311
#
# Created:     06/06/2015
# Copyright:   (c) enzo7311 2015
# Licence:     <your licence>
#-------------------------------------------------------------------------------

def main():
    pass

if __name__ == '__main__':
    main()
import os
def renameFile():
    fileList= os.listdir(r"C:\Users\enzo7311\Desktop\temp\prank")
    print(fileList)
    os.chdir("C:/Users/enzo7311/Desktop/temp/prank")

    for filess in fileList:
        os.rename(filess,filess.translate(None,"0123456789"))


renameFile()
