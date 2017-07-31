#!/bin/bash
# Purpose:  To run mfe.py of given residue at a given pH in all filtered subfolders
#   ARG1: residue
#   ARG2: ph/ch/eh column: i.e. mfe at bound (presumably) column in a ch titration:
#       2nd point in apo state
# [ ARG3: folder_filter_str ; ARG4: f38_pt_as_value; ARG5: f38_pt_value_file ]
# ---------------------------------------------------------------------------------
debug_on=0

this=$(basename $0)
bypass_for_qsub=1
col_format_out=0

special_fld="CL_000"
dir_subset=""

filt=""
col=2
f38_pt_as_value=0

# file of equilibrium energies or ph/eh/ch points format:
# QE_R1/CL_ff0/B0467      not_b
# WT3CL_R0_gold/CL_f00_E01/A0466  -17.0
# => fldr/subfldr/res_id	value or 'not_b'

if [[ $bypass_for_qsub -eq 1 ]];then
   res='0466'
   dir_subset=""
   filt="CL_f00"
   col=2
   f38_pt_as_value=0
   f38_pt_value_file=""	## "runs_CL_dGb.csv"

   echo $this":: SGE used: bypassing in-line arguments: hard-coded inputs are:"
   echo $this"::    id: "$res"; f38_pt: "$col"; filter: "$filt"; f38_pt_as_value: "$f38_pt_as_value"; f38_pt_value_file: "$f38_pt_value_file
else
   if [[ $# -lt 2 ]]; then
      echo "Missing arguments: residue (4 digit number); fort.38 column [; filter for subfolders; f38_pt_as_value; f38_pt_value_file ]"
      exit 0
   fi
   res=$1
   if [[ ${#res} != 4 ]]; then
      echo "The 1st argument is the residue number in 4 digit format, e.g. 0123"
      exit 0
   fi
   col=$2
   if [[ $# -eq 3 ]]; then
      filt=$3
   fi
   if [[ $# -eq 4 ]]; then
      f38_pt_as_value=$4
      if [[ ${#f38_pt_as_value} -ne 1 ]]; then
         echo $this":: f38_pt_as_value must be either 0 or 1; given was: "$f38_pt_as_value
         exit 0
      fi
   fi
fi

if [[ $f38_pt_as_value -eq 1 ]]; then
   if [[ ${#f38_pt_value_file} -ne 0 ]]; then  # use a file, else use the given value for all subfolders
      if [[ ! -f $f38_pt_value_file ]]; then
         echo $f38_pt_value_file" not found in "basename $(pwd)
         exit 0
      fi
      grep $res $f38_pt_value_file > res_file	# reduced file for given res
   fi
fi

# mfe.py needs sum_crg.out, so select dir that have it
for fld in $(ls -l $dir_subset*/$filt*/sum_crg.out | awk ' { print substr($NF, 1, index($NF, "/s")-1) }'| egrep -v '_en|\.1|EQ')
do
   # fld==folder/subfolder

   # Check if energies.opp has been unziped:
#   if [[ ! -d $fld/energies ]]; then
#      echo $fld": No unzipped energies.opp. Skipped."
#      continue
#   fi
   if [ ! -f $fld/fort.38 ]; then
      echo $fld": No fort.38. Skipped."
      continue
   fi
echo $fld
   cd $fld

#   res_id=$(awk -v Res="$res" '$1 ~ Res {print $1\}' pK.out)   # format: _CL-A0466_
#echo "res_id from pK.out: "$res_id

      for id in $(awk -v Res="$res" '$1 ~ Res {print $1}' pK.out)
      do
         ch=${id:4:1}

         if [[ ${#f38_pt_value_file} -ne 0 ]]; then # extract the value from res_file
            fld2=$fld"/"$ch
            col=$(awk -v dir="$fld2" '$1 ~ dir { c=($NF=="not_b" ? 2 : $NF); print c }' ../../$f38_pt_value_file)
         fi
#       echo $fld" res> "$res" ch> "$ch" col> "$col

         if [[ $col_format_out -eq 1 ]]; then

            if [[ $debug_on -eq 0 ]]; then
               get_mfeps_col.sh $id $col 1 $f38_pt_as_value
            fi
               #  get_mfeps_col.sh ARGs: conf_id; f38_pt; cutoff; f38_pt_as_value
               # get_mfeps_col.sh returns the transposed data of the usual mfe.py output => ready for mutli-folder collating
               # file name ends with cmfeps.csv if mfe was calculated at a given column in f38 for all subfolders
               # if the mfe was done at a specific value for each res, then the filename is: res_id"_cmfeps_Kx.csv"

         else
            # get_mfeps function gets the value of the column to pass to mfe.py:
            # conf_id (pK.out format); f38_pt; cutoff

            if [[ $debug_on -eq 0 ]]; then
               get_mfeps.sh $id $col
            fi
         fi
      done

   if [[ ${#filt} ]]; then
      cd ../../
   else
      cd ../
   fi
done

if [[ $debug_on -eq 0 ]]; then

# to collate:
if [[ $col_format_out -eq 1 ]]; then

   if [[ $f38_pt_as_value -eq 1 ]]; then

      out_collated="def4_"$filt"_"$res"_cmfeps_Kx.csv"

      if [[ $filt==$special_fld ]]; then
         awk '{print substr(FILENAME, 1, index(FILENAME, "/")-1), $0}' */$filt*/*$res"_cmfeps_Kx.csv" |awk '/vdw/&&c++ {next} 1' | sed '/EQ/d; s/WD/ED/; s/-TS/TS-/' > $out_collated
      else
         awk '{print substr(FILENAME, 1, index(FILENAME, "/")-1), $0}' */$filt*/*$res"_cmfeps_Kx.csv" |awk '/vdw/&&c++ {next} 1' | sed 's/WD/ED/; s/-TS/TS-/' > $out_collated
      fi
   else
      out_collated="def4_"$filt"_"$res"_cmfeps.csv"

      if [[ $filt==$special_fld ]]; then
         awk '{print substr(FILENAME, 1, index(FILENAME, "/")-1), $0}' */$filt*/*$res"_cmfeps.csv" |awk '/vdw/&&c++ {next} 1' | sed '/EQ/d; s/WD/ED/; s/-TS/TS-/' > $out_collated
      else
         awk '{print substr(FILENAME, 1, index(FILENAME, "/")-1), $0}' */$filt*/*$res"_cmfeps.csv" |awk '/vdw/&&c++ {next} 1' | sed 's/WD/ED/; s/-TS/TS-/' > $out_collated
      fi
   fi
else

   out_collated="def4_"$filt"_"$res"_mfeps.csv"
   awk '/TOTAL/{ print substr(FILENAME, 1, length(FILENAME)-10), $1, $NF}' */$filt*/*$res"_mfeps.csv" |awk '/vdw/&&c++ {next} 1' | sed 's/WD/ED/; s/-TS/TS-/' > $out_collated



fi

fi
