#-------------------------------------------------------------------------------
# Name:        module1
# Purpose:
#
# Author:      enzo7311
#
# Created:     02/05/2015
# Copyright:   (c) enzo7311 2015
# Licence:     <your licence>
#-------------------------------------------------------------------------------
import pandas as pd
from pylab import *
def main():
    pass

if __name__ == '__main__':
    main()
a=pd.read_csv("C:\Users\enzo7311\Desktop\Ipotesi\output.csv")
print(a)
#a["Duration"].hist()
print(a.groupby("Day").mean())
grouped_by_type = a.groupby("Day")
print(grouped_by_type)
print(pd.crosstab(a.Day, a.DurationOver))
pd.crosstab(a.Day, a.GlobalTroughput_AS).hist()
