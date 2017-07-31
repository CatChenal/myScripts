#!/bin/bash
# to collate TOT line from *0148_mfeps.csv file ("small mfepy file")
if [[ $# -eq 1 ]]; then
   dir=$1	#assume directory (instead of all if not arg.)
fi
do_tot=0

if [[ $do_tot -eq 1 ]]; then
   # apo Ex ionization
   awk '/TOT/{ dir=substr(FILENAME,1, index(FILENAME,"/")-1); len_dir=length(dir);
              filepath=substr(FILENAME,len_dir+2); run=substr(filepath,1,index(filepath,"/")-1); len_run=length(run); res=substr(filepath,len_run+2,5);
              print dir, run, res,$NF}' */CL_000/*0148_mfeps.csv > all_apo_Ex_TotE.csv
fi # do_tot

# collate DM occ for Kd:
if [[ $# -eq 0 ]]; then
   file="all_cldm_occ.csv"

   if [[ -f $file ]]; then
      /bin/mv $file $file".prev"
   fi
   awk '/ex|CLDM/{ dir=substr(FILENAME,1,index(FILENAME,"/")-1);len_dir=length(dir);
                   path=substr(FILENAME,len_dir+2); run=substr(path,1, index(path, "/")-1)
                   print dir, run, $0
                 }' */CL_*/fort.38 | sed '/CL_000/d; /CL_..0/{/CLDM[A|B]0468/d}; /CL_.0./{/CLDM[A|B]0467/d}; /CL_0../{/CLDM[A|B]0466/d}' > $file

else
   file=$dir"_cldm_occ.csv"

   if [[ -f $file ]]; then
      /bin/mv $file $file".prev"
   fi
   awk '/ex|CLDM/{ dir=substr(FILENAME,1,index(FILENAME,"/")-1);len_dir=length(dir);
                   path=substr(FILENAME,len_dir+2); run=substr(path,1, index(path, "/")-1)
                   print dir, run, $0
                 }' $dir/CL_*/fort.38 | sed '/CL_000/d; /CL_..0/{/CLDM[A|B]0468/d}; /CL_.0./{/CLDM[A|B]0467/d}; /CL_0../{/CLDM[A|B]0466/d}' > $file
fi

sed -i '/CL_1../{/0466/d}; /CL_.1./{/0467/d}; /CL_..1/{/0468/d}; s/_CLDM\(.\)0468/i_\1/; s/_CLDM\(.\)0467/c_\1/; s/_CLDM\(.\)0466/x_\1/; s/_00[2|3]//' $file

