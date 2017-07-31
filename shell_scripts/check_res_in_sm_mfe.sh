#!/bin/bash
if [[ $# < 2 ]]; then
   echo "Missing args(2): 5 digit res id (Cnnnn: A0123); conf name (GLU_1A0123) [; file prefix ] "
   exit 0
fi
show=0
res=$1
conf=$2

# If conf not ligand(CL) then small mfe file is in the sm_mfe folder
first=${conf:0:1}
if [[ $first == "_" ]]; then
   file_in="*/"$conf"*.sm_mfe.csv"
else
   file_in="*/sm_mfe/"$conf"*.sm_mfe.csv"
fi
if [[ $# -eq 3 ]]; then
   file_out=$3"_"$res"_"$conf"sm_mfe.csv"
else
   file_out=$res"_"$conf"sm_mfe.csv"
fi

strAWK=' /'$res'/{name=substr(FILENAME,1,index(FILENAME, "/")-1); d=$2-$NF; print name,$1, $2, $NF, d} '
awk "$strAWK" $file_in > $file_out

if [[ $show -ne 0 ]]; then
   echo "Output:  "$file_out; echo
   cat $file_out
fi
