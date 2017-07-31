#!/bin/bash
this=$(basename $0)

if [[ $# -ne 3 ]]; then
   echo $this":: FLD ID=xnnnn CRG=0(:neutral)/1(:ionized)"
   echo $this":: Function called from FLD parent"
   exit 0
fi
FLD=$1
ID=$2      # A0148, B0148
CRG=$3
if [[ ! -d $FLD ]]; then
   echo $this":: "$FLD" not found. Function must be called from FLD parent"
   exit 0
fi
if [[ ${#CRG} -ne 1 ]]; then
   echo $this":: CRG must be either 0 or 1; given was: "$CRG
   exit 0
fi
#............................
dataline=""
do_sm_mfe=0
do_use_prev_mfefile=0

if [[ ! -d "$FLD/sm_mfe" ]]; then
   echo $this":: Directory: "$FLD"/sm_mfe not found. Holds mfe++ of conformers."
   read -p "Create "$FLD"/sm_mfe? (0/1)" do_sm_mfe
   if [[ $do_sm_mfe -eq 0 ]]; then
      exit 0
   else
       mkdir $FLD"/sm_mfe"
   fi
fi
if [[ $CRG -eq 1 ]]; then
   conf="-1"$ID"_"
else
   conf="0."$ID"_"
fi
#echo $conf
fileout=$ID"_"$CRG".csv"

cd $FLD
   if [[ -f $fileout ]]; then
      /bin/rm $fileout
   fi
   touch $fileout

   conf_line=$( awk -v id="$conf" '$1 ~ id {print $1, $2}' fort.38 | sort -k2n|tail -1)
   if [[ ${#conf_line} -eq 0 ]]; then
      echo $this":: no occupied conformer found for: "$conf
      exit 0
   fi
   conf_id=${conf_line% *}
   conf_occ=${conf_line#* }

   resmfe="sm_mfe/"$conf_id".sm_mfe.csv"
   if [[ $do_use_prev_mfefile -eq 0 ]]||[[ ! -f $resmfe ]]; then
      #echo $resmfe not found. Calculated.
      get_sm_mfe.sh $conf_id
   fi

   # 1 output field= conf_id conf_occ
   dataline=$(echo $conf_id"@"$conf_occ"@")

   # 2nd output field=h3.mfe
   dataline=$dataline$(awk -v id="$conf_id" 'BEGIN{OFS="@"} $2 ~ id {sum=$10+$11+$12+$13+$14; print $10, $11, $12, $13, $14, sum"@"}' head3.lst)

   # get res_mfe at first point (bound) and last point (unbound)
   dataline=$dataline$(awk '/SUM/{print $2*1.364"@"$NF*1.364"@"}' $resmfe)

   echo $dataline >> $fileout

   strHeader="CONFORMER@occ@vdw0@vdw1@tors@epol@dsolv@h3_tot@res_b@res_u"
   sedstr=" -i '1i "$strHeader"' "
   eval sed $sedstr $fileout
   sed -i 's/@/\t/g' $fileout

cd ../
