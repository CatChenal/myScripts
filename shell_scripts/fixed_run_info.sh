#!/bin/bash
# PRE: need to run get_rowstdv.sh in each folder to get hi_stdv_confs.csv

#[catalys@sibyl def-cl-comp4]> cat Fixed_runs_hi_stdv.csv
#QE_R0/QE_00.1

ls -l */hi_stdv_confs.csv|awk '{print substr($NF, 1, index($NF, "/h")-1)}' > Fixed_runs_hi_stdv.csv
ls -l */*/hi_stdv_confs.csv| egrep '\/WT|\/QE'|awk '{print substr($NF, 1, index($NF, "/h")-1)}' >> Fixed_runs_hi_stdv.csv
ls -l */*/*/hi_stdv_confs.csv| egrep '\/WT|\/QE'|awk '{print substr($NF, 1, index($NF, "/h")-1)}' >> Fixed_runs_hi_stdv.csv

this="Fixed_runs_info.csv"
echo -e RUN  '\t'TYPE' \t'MFE_POINT' \t'MONTE_ADV_OPT > $this

for dir in $(cat Fixed_runs_hi_stdv.csv)
do
   if [[ ! -f $dir/run.trace ]]; then
      echo $dir": run.trace missing" >>  $this
   else
      echo $dir $( egrep 'TITR_TYPE|MFE_P|ADV' $dir/run.trace |tail -3|awk '{print "\t"$2}') >>  $this
   fi


#get file with ionizE in kcal/mol from  mfe files:

  awk '/TOT/{idx1=index(FILENAME,"/"); dir=substr(FILENAME,1,idx1-1);res=substr(FILENAME,idx1+1,5); print dir,res,$NF}' $dir/*_mfeps.csv


done

