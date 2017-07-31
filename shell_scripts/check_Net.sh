#~/bin/bash

awk '/Net/{
           dir=substr(FILENAME,1, index(FILENAME,"/")-1);
           file=substr(FILENAME,length(dir)+2);
           print dir, substr(file, 1, index(file,"/")-1), $1,$3,$4, $4-$3}' */*/sum_crg.out > Net_check.csv

sed -i 's/Net_Charge/Net/' Net_check.csv

awk '$NF !~ /-1/' Net_check.csv > Net_check_not-1.csv
