#!/bin/bash
if [[ $# -ne 3 ]]; then
   echo "FLD ID=xnnnn CRG=0(:neutral)/1(:ionized)"
   echo "Function called from FLD parent"
   exit 0
fi
FLD=$1
ID=$2            # A0148, B0148
CRG=$3
if [[ ! -d $FLD ]]; then
   echo $FLD" not found. Function must be called from FLD parent"
   exit 0
fi
if [[ ! -d $FLD"/sm_mfe" ]]; then
   echo "Directory: "$FLD"/sm_mfe not found. Holds mfe++ of conformers."
   read -p "Create "$FLD"/sm_mfe? (0/1)" do_sm_mfe
   if [[ $do_sm_mfe -eq 0 ]]; then
      exit 0
   else
       mkdir $FLD"/sm_mfe"
   fi
fi
if [[ ${#CRG} -ne 1 ]]; then
   echo "CRG must be either 0 or 1; given was: "$CRG
   exit 0
fi
fileout=$ID"_"$CRG".csv"
#............................
if [[ $CRG -eq 1 ]]; then
   conf="-1"$ID"_"
else
   conf="0."$ID"_"
fi
cd $FLD
   if [[ -f $fileout ]]; then
      /bin/rm $fileout
   fi
   touch $fileout
   dataline=""
   if [[ $do_sm_mfe -eq 1 ]]; then
      mkdir sm_mfe
   fi

   /bin/rm -f $ID"_"$CRG"_fav_h3.csv"

   # most h3 fav:
   awk -v crg="$conf" '$2 ~ crg {sum=$10+$11+$12+$13+$14; print $2, $10, $11, $12, $13, $14, sum}' head3.lst > tmp1

   while IFS=' ' read -r CONF vdw0 vdw1 tors epol dsolv sum
   do
      conf_id=$CONF

      resmfe="sm_mfe/"$conf_id".sm_mfe.csv"
      if [[ ! -f $resmfe ]]; then
         echo $resmfe not found. Calculated.
         get_sm_mfe.sh $conf_id
      fi
      # 1st output field= conf id
      dataline=$(echo $conf_id"@")
      # 2nd output field=x,y,z
      conf_num=${conf_id:5:9}
      dataline=$dataline$(awk -v cnf="$conf_num" 'BEGIN{OFS="@"} ($3 ~ /CG/)&&($5 ~ cnf) { print $6, $7, $8"@" }' step2_out.pdb)
      # 3rd output occ dataline=occ, 1st and last
      dataline=$dataline$(awk -v cnf="$conf_id" 'BEGIN{OFS="@"} ($1 ~ cnf) { print $2, $NF"@" }' fort.38)
      # 4rd output field=h3.mfe terms
      dataline=$dataline$vdw0"@"$vdw1"@"$tors"@"$epol"@"$dsolv"@"$sum"@"

      # get res_mfe at first point (bound) and last points (unbound):
      dataline=$dataline$(awk -v tot="$sum" '/SUM/{print ($2*1.364)+tot"@"($NF*1.364)+tot"@"}' $resmfe)

      echo $dataline >> $fileout

   done < tmp1	#$ID"_"$CRG"_fav_h3.csv"
   # ..........................

   strHeader="CONFORMER@x@y@z@occ_b@occ_u@vdw0@vdw1@tors@epol@dsolv@sum@tot_b@tot_u"
 #                    1 2 3 4 5     6     7    8    9     10   11   12   13
   sedstr=" '1i "$strHeader"' "
   sort $fileout | eval sed $sedstr > tmp2
   sed 's/@/\t/g'  tmp2 > $fileout

   /bin/rm tmp*

cd ../
