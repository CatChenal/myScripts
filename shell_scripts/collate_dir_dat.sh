#!/bin/bash
if [[ $# -lt 2 ]]; then
  read -p "Enter an identifier for this (parent) folder: " fld_id
  read -p "Enter a directory name identifier (for filtering folders): " filter
else
  fld_id=$1
  filter=$2
fi

   awk '$1!="extra"{print substr(FILENAME, 1, index(FILENAME, "/")-1), $0}' $filter*/$filter*_CLDM-Ex_occ.csv | \
         sed '/CL_..0/{/CLDM[A|B]0468/d}; /CL_.0./{/CLDM[A|B]0467/d}; /CL_0../{/CLDM[A|B]0466/d}' > $fld_id"_"$filter"_CLDM-Ex_occ.csv"

   if [[ ! ($filter == "QE") || ($filter == "WT") ]]; then
     egrep 'fff|ff0|f00|0f0|00f|f10|1f0'  $fld_id"_"$filter"_CLDM-Ex_occ.csv" | egrep -v '_S107|_E148|_R28' > $fld_id"_"$filter"_CLDM-Ex_occ_cycle.csv"
   fi

   # output ionizE in kcal/mol from small mfepy file:
   awk '/TOT/{idx1=index(FILENAME,"/"); dir=substr(FILENAME,1,idx1-1);res=substr(FILENAME,idx1+1,5); print dir,res,$NF}' $filter*/*_mfeps.csv|sort -k2 > $fld_id"_"$filter"_Ex_TOT.csv"

   awk '/A0203/{idx=index(FILENAME, "/f"); {print substr(FILENAME, 1, idx-1), $0} }' $filter*/fort.38.non0 > $fld_id"_"$filter"_A0203_occ.csv"
   awk '/B0203/{idx=index(FILENAME, "/f"); {print substr(FILENAME, 1, idx-1), $0} }' $filter*/fort.38.non0 > $fld_id"_"$filter"_B0203_occ.csv"

#   get_203_occ.sh $fld_id $filter
