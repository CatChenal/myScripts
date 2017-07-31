#!/bin/bash
# for all runs

  out=CL_f00_CLx_occ.csv
 if [[ -f  $out ]]; then
  /bin/rm  $out
 fi
 awk '/CLDM[A|B]0466/{if(index(FILENAME,"_E")==0){print substr(FILENAME,1,index(FILENAME,"/fort")-1), $0}}'   */CL_f00*/fort.38 >> $out
 awk '/CLDM[A|B]0466/{if(index(FILENAME,"_E")==0){print substr(FILENAME,1,index(FILENAME,"/fort")-1), $0}}' */*/CL_f00*/fort.38 >> $out
 sed -i 's/ch_ph4.5\///; s/_ch//; /ph_/d' $out


   out="CL_000_Ex_TOT.csv"
   if [[ -f  $out ]]; then
     /bin/rm  $out
   fi
   # apo ioniz E for Ex:
   awk '/TOT/{ if(index(FILENAME,"_E")==0){ idx=index(FILENAME,"_m");dir=substr(FILENAME,1,idx-1); print dir,$NF} }' APO*/*0148_mfeps.csv >> $out
   awk '/TOT/{ if(index(FILENAME,"_E")==0){ idx=index(FILENAME,"_m");dir=substr(FILENAME,1,idx-1); print dir,$NF} }'   */CL_000*/*0148_mfeps.csv >> $out
   awk '/TOT/{ if(index(FILENAME,"_E")==0){ idx=index(FILENAME,"_m");dir=substr(FILENAME,1,idx-1); print dir,$NF} }' */*/CL_000*/*0148_mfeps.csv >> $out
   # last dir: for wt ed runs:
   awk '/TOT/{ if(index(FILENAME,"_E")==0){ idx=index(FILENAME,"_m");dir=substr(FILENAME,1,idx-1); print dir,$NF} }' */*/*/CL_000*/*0148_mfeps.csv >> $out
   sed -i 's/ch_ph4.5\///; s/_ch//; s/_Ef//; s/\/\([A|B]\)0/ \1/; /ph_/d' $out

   out="CL_000_Ei_TOT.csv"
   if [[ -f  $out ]]; then
     /bin/rm  $out
   fi
   # apo ioniz E for Ei:
   awk '/TOT/{ if(index(FILENAME,"_E")==0){ idx=index(FILENAME,"_m");dir=substr(FILENAME,1,idx-1); print dir,$NF} }' APO*/*0203_mfeps.csv >> $out
   awk '/TOT/{ if(index(FILENAME,"_E")==0){ idx=index(FILENAME,"_m");dir=substr(FILENAME,1,idx-1); print dir,$NF} }'   */CL_000*/*0203_mfeps.csv >> $out
   awk '/TOT/{ if(index(FILENAME,"_E")==0){ idx=index(FILENAME,"_m");dir=substr(FILENAME,1,idx-1); print dir,$NF} }' */*/CL_000*/*0203_mfeps.csv >> $out
   # last dir: for wt ed runs:
   awk '/TOT/{ if(index(FILENAME,"_E")==0){ idx=index(FILENAME,"_m");dir=substr(FILENAME,1,idx-1); print dir,$NF} }' */*/*/CL_000*/*0203_mfeps.csv >> $out
   sed -i 's/ch_ph4.5\///; s/_ch//; s/_Ef//; s/\/\([A|B]\)0/ \1/; /ph_/d' $out


