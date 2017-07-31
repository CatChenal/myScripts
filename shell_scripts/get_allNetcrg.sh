#!/bin/bash

# Collate all
here=$(basename $(pwd))
if [[ $here != "def-cl-comp4" ]]; then
  echo Go to def-cl-comp4 folder to run
  exit 0
fi

#for dir in $( ls -l | awk '/^d/{ if ($NF!~/^[c|d|p]/) {print $NF} }')
#do
#   get_Netcrg.sh $dir
#done

 out="def4_apo_Net_sum_crg.csv"
 if [[ -f  $out ]]; then
  /bin/rm  $out
 fi
 # apo ioniz E for Ei: APO_R0.1/Net_sum_crg.csv
 awk '{ if(index(FILENAME,"_E")==0){ idx=index(FILENAME,"/N");dir=substr(FILENAME,1,idx-1); print dir,$0} }' APO*/Net_sum_crg.csv >> $out
 awk '{ if(index(FILENAME,"_E")==0){ idx=index(FILENAME,"/N");dir=substr(FILENAME,1,idx-1); print dir,$0} }'   */CL_000*/Net_sum_crg.csv >> $out
 awk '{ if(index(FILENAME,"_E")==0){ idx=index(FILENAME,"/N");dir=substr(FILENAME,1,idx-1); print dir,$0} }' */*/CL_000*/Net_sum_crg.csv >> $out
 awk '{ if(index(FILENAME,"_E")==0){ idx=index(FILENAME,"/N");dir=substr(FILENAME,1,idx-1); print dir,$0} }' */*/*/CL_000*/Net_sum_crg.csv >> $out
 sed -i 's/ch_ph4.5\///; s/_ch//; s/_Ef//; s/\/\([A|B]\)0/ \1/; /ph_/d' $out

# intra cl:
 out="def4_00f_Net_sum_crg.csv"
 if [[ -f  $out ]]; then
  /bin/rm  $out
 fi
 awk '{ if(index(FILENAME,"_E")==0){ idx=index(FILENAME,"/N");dir=substr(FILENAME,1,idx-1); print dir,$0} }'   */CL_00f*/Net_sum_crg.csv >> $out
 awk '{ if(index(FILENAME,"_E")==0){ idx=index(FILENAME,"/N");dir=substr(FILENAME,1,idx-1); print dir,$0} }' */*/CL_00f*/Net_sum_crg.csv >> $out
 awk '{ if(index(FILENAME,"_E")==0){ idx=index(FILENAME,"/N");dir=substr(FILENAME,1,idx-1); print dir,$0} }' */*/*/CL_00f*/Net_sum_crg.csv >> $out
 sed -i 's/ch_ph4.5\///; s/_ch//; s/_Ef//; s/\/\([A|B]\)0/ \1/; /ph_/d' $out

# central cl:
 out="def4_0f0_Net_sum_crg.csv"
 if [[ -f  $out ]]; then
  /bin/rm  $out
 fi
 awk '{ if(index(FILENAME,"_E")==0){ idx=index(FILENAME,"/N");dir=substr(FILENAME,1,idx-1); print dir,$0} }'   */CL_0f0*/Net_sum_crg.csv >> $out
 awk '{ if(index(FILENAME,"_E")==0){ idx=index(FILENAME,"/N");dir=substr(FILENAME,1,idx-1); print dir,$0} }' */*/CL_0f0*/Net_sum_crg.csv >> $out
 awk '{ if(index(FILENAME,"_E")==0){ idx=index(FILENAME,"/N");dir=substr(FILENAME,1,idx-1); print dir,$0} }' */*/*/CL_0f0*/Net_sum_crg.csv >> $out
 sed -i 's/ch_ph4.5\///; s/_ch//; s/_Ef//; s/\/\([A|B]\)0/ \1/; /ph_/d' $out

# external cl:
 out="def4_f00_Net_sum_crg.csv"
 if [[ -f  $out ]]; then
  /bin/rm  $out
 fi
 awk '{ if(index(FILENAME,"_E")==0){ idx=index(FILENAME,"/N");dir=substr(FILENAME,1,idx-1); print dir,$0} }'   */CL_f00*/Net_sum_crg.csv >> $out
 awk '{ if(index(FILENAME,"_E")==0){ idx=index(FILENAME,"/N");dir=substr(FILENAME,1,idx-1); print dir,$0} }' */*/CL_f00*/Net_sum_crg.csv >> $out
 # last dir: for wt ed runs:
 awk '{ if(index(FILENAME,"_E")==0){ idx=index(FILENAME,"/N");dir=substr(FILENAME,1,idx-1); print dir,$0} }' */*/*/CL_f00*/Net_sum_crg.csv >> $out
 sed -i 's/ch_ph4.5\///; s/_ch//; s/_Ef//; s/\/\([A|B]\)0/ \1/; /ph_/d' $out

# fixed wuns in WT and QE
 out="def4_fixed_Net_sum_crg.csv"
 if [[ -f  $out ]]; then
  /bin/rm  $out
 fi
 awk '{ if(index(FILENAME,"_E")==0){ idx=index(FILENAME,"/N");dir=substr(FILENAME,1,idx-1); print dir,$0} }' QE*/QE_*/Net_sum_crg.csv >> $out
 awk '{ if(index(FILENAME,"_E")==0){ idx=index(FILENAME,"/N");dir=substr(FILENAME,1,idx-1); print dir,$0} }' WT*/*/WT_*/Net_sum_crg.csv >> $out
 sed -i 's/ch_ph4.5\///; s/_ch//; s/_Ef//; s/\/\([A|B]\)0/ \1/; /ph_/d' $out
