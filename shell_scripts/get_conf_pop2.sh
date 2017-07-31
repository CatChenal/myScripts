#!/bin/bash
# returns most fav h3 conf terms + tot with res_pw
# if arg5 is given, so must arg4
if [[ $# -lt 3 ]]; then
   echo "1:FLD 2:ID=xnnnn 3:CRG=0(neutral)/1(ionized) [4:occ_point] [5:return_all_confs]"
# get_conf_pop2.sh CL_100_E-1 A0148 1 u
   echo "Function called from FLD parent"
   exit 0
fi
FLD=$1
ID=$2            # A0148, B0148
CRG=$3
OCC_PT="b"
ALL_CONFS=0

if [[ $# -ge 4 ]]; then # at least occ/mfe pt to return given
   OCC_PT=$4
   if [[ "$OCC_PT" != "b" && "$OCC_PT" != "u" ]]; then
      echo "OCC_PT must be either b (bound or first point) or u (unbound or last point); given was: "$OCC_PT
      exit 0
   fi
   if [[ $# -eq 5 ]]; then # ALL_CONFS is overwritten with given value
      ALL_CONFS=$5
      if [[ $ALL_CONFS -ne 1 && $ALL_CONFS -ne 0 ]]; then
         echo "ALL_CONFS must be either 1 or 0; given was: "$ALL_CONFS
         exit 0
      fi
   fi
fi
if [[ ! -d $FLD ]]; then
   echo $FLD" not found. Function must be called from FLD parent"
   exit 0
fi
if [[ ! -d $FLD"/sm_mfe" ]]; then
#   echo "Directory: "$FLD"/sm_mfe not found. Holds mfe++ of conformers."
#   read -p "Create "$FLD"/sm_mfe? (0/1)" do_sm_mfe
#   if [[ $do_sm_mfe -eq 0 ]]; then
#      exit 0
#   else
       mkdir $FLD"/sm_mfe"
#   fi
fi
if [[ ${#CRG} -ne 1 ]]; then
   echo "CRG must be either 0 or 1; given was: "$CRG
   exit 0
fi

fileout=$ID"_"$CRG"_"$OCC_PT".csv"
#............................
if [[ $CRG -eq 1 ]]; then
   conf="-1"$ID"_"
else
   conf="0."$ID"_"
fi
cd $FLD
   if [[ -f $fileout ]]; then
      /bin/rm -f $fileout tmp2
   fi
   touch tmp2
   dataline=""
   if [[ $do_sm_mfe -eq 1 ]]; then
      mkdir sm_mfe
   fi
   # h3 confs:
   awk -v crg="$conf" '$2 ~ crg {sum=$10+$11+$12+$13+$14; print $2, $10, $11, $12, $13, $14, sum}' head3.lst > tmp1

   while IFS=' ' read -r CONF vdw0 vdw1 tors epol dsolv sum
   do
      conf_id=$CONF

      resmfe="sm_mfe/"$conf_id".sm_mfe.csv"
      if [[ ! -f $resmfe ]]; then
         echo $FLD $resmfe not found. Calculated.
         get_sm_mfe.sh $conf_id
      fi
      # 1st output field= conf id
      dataline=$(echo $conf_id"@")

      # 2nd output fields=x,y,z
      conf_num=${conf_id:5:9}
      dataline=$dataline$(awk -v cnf="$conf_num" 'BEGIN{OFS="@"} ($3 ~ /CG/)&&($5 ~ cnf) { print $6, $7, $8"@" }' step2_out.pdb)

      # 3rd output occ dataline=occ
      dataline=$dataline$(awk -v pt="$OCC_PT" -v cnf="$conf_id" '($1 ~ cnf) { if (pt=="b") {print $2"@"} else {print $NF"@"} }' fort.38)

      # 4th output field=h3.mfe terms
      dataline=$dataline$vdw0"@"$vdw1"@"$tors"@"$epol"@"$dsolv"@"$sum"@"

      # get res_mfe & tot at given point :
      dataline=$dataline$(awk -v pt="$OCC_PT" -v tot="$sum" '/SUM/{ if (pt=="b") {print ($2*1.364)+tot"@"} else {print ($NF*1.364)+tot"@"} }' $resmfe)

      echo $dataline >> tmp2

   done < tmp1
   # ..........................
   strHeader="CONFORMER\tx\ty\tz\tocc_b\tvdw0\tvdw1\ttors\tepol\tdsolv\tsum\ttot_b"
   #          1          2  3  4  5      6     7     8     9     10     11   12
   if [[ "$OCC_PT" == "u" ]]; then
      strHeader="CONFORMER\tx\ty\tz\tocc_u\tvdw0\tvdw1\ttors\tepol\tdsolv\tsum\ttot_u"
   fi
   sedstr=" '1i "$strHeader"' "
   if [[ $ALL_CONFS -eq 0 ]]; then  # return 5 most favorable conf as:
      sed 's/@/\t/g' tmp2 |sort -k12n | head -5 | eval sed $sedstr  > $fileout
   else
      sed 's/@/\t/g' tmp2 |sort -k12n | eval sed $sedstr  > $fileout
   fi

  /bin/rm tmp*

cd ../
