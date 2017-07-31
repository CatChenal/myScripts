#!/bin/bash
if [[ $# -ne 1 ]]; then
  echo "Folder identifier need for output filename: [fld]_[A|B]_all_CL_Ex_occ.csv"
  exit 0
fi
fld=$1

egrep 'CL-1A|\-1A0148' CL_*/fort.38|grep -v '0.000 0.000 0.000 0.000 0.000 0.000 0.000 0.000 0.000 0.000 0.000 0.000 0.000 0.000 0.000'|sed 's/\/fort\.38:/ /'> tmp
if [[ $fld == "WT" ]]; then
   sed '/^CL_..1*/{/0468/d}; /^CL_.1.*/{/0467/d}; /^CL_1..*/{/0466/d}' tmp > $fld"_A_all_CL_Ex_occ.csv"
else
  mv tmp  $fld"_A_all_CL_Ex_occ.csv"
fi

egrep 'CL-1B|\-1B0148' CL_*/fort.38|grep -v '0.000 0.000 0.000 0.000 0.000 0.000 0.000 0.000 0.000 0.000 0.000 0.000 0.000 0.000 0.000'|sed 's/\/fort\.38:/ /'> tmp
if [[ $fld == "WT" ]]; then
  sed '/^CL_..1/{/0468/d}; /^CL_.1./{/0467/d}; /^CL_1..*/{/0466/d}' tmp > $fld"_B_all_CL_Ex_occ.csv"
else
  mv tmp $fld"_B_all_CL_Ex_occ.csv"
fi

if [[ $fld == "WT" ]]; then
  /bin/rm tmp
fi
