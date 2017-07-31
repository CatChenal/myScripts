#!/bin/bash
this=$(basename $0)
# To get small mfe++ file for occupied confs of given res in given dir/fld

if [[ $# -ne 3 ]]; then
  echo $this":: Required arguments(3): DIR FLD RESid (Xnnnn, X:1 letter res code, eg E0422) "
  exit 0
fi
DIR=$1
FLD=$2
RES=$3
id=${RES:1:4}
echo res: $RES id: $id

lim=1

do_test=0

for dir in $(ls -l $DIR*/$FLD/fort.38| awk '{print substr($NF, 1, index($NF, "/")-1)}' )
do
   cd $dir/$FLD
   echo $dir/$FLD

   if [[ ! -f fort.38.non0 ]]; then
      getnon0rows.sh fort.38 0.6
   fi
   awk -v ID="$id" 'substr($1,7,4) ~ ID' fort.38.non0 | grep -v DM > $RES"_occ.csv"

  if [[ $do_test -eq 0 ]]; then

   for conf in $(awk '{print $1}' $RES"_occ.csv" )
   do
     echo $conf

     mfe++ $conf -x $lim -t $lim | sed -e 's/-0\.0/ 0\.0/g' > sm_mfe/$conf".sm_mfe.csv"

     /bin/rm -f $conf".mfe"

   done
  fi

   cd ../../

done
