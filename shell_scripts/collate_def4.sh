#~/bin/bash
# to collate TOT line from *0148_mfeps.csv file ("small mfepy file"
#
if [[ -f def4_Ex_TotE.csv ]]; then
   /bin/rm def4_Ex_TotE.csv
fi

## first APO dirs (different struc)
awk '/TOT/{
            dir=substr(FILENAME,1,index(FILENAME,"/")-1);len_dir=length(dir); 
            res=substr(FILENAME,len_dir+2,5) ;print dir,res, $NF}' APO*/*0148_mfeps.csv > def4_Ex_TotE.csv

awk '/TOT/{ dir=substr(FILENAME,1, index(FILENAME,"/")-1); len_dir=length(dir);
           filepath=substr(FILENAME,len_dir+2); run=substr(filepath,1,index(filepath,"/")-1); len_run=length(run); res=substr(filepath,len_run+2,5);
           print dir, run, res,$NF}' */CL_*/*0148_mfeps.csv >> def4_Ex_TotE.csv


if [[ -f def4_cldm_occ.csv ]]; then
   /bin/rm def4_cldm_occ.csv
fi

# collate DM occ for Kd:
 awk '/CLDM/{
            dir=substr(FILENAME,1,index(FILENAME,"/")-1);len_dir=length(dir);
            path=substr(FILENAME,len_dir+2); run=substr(path,1, index(path, "/")-1)
            print dir, run, $0}' */CL_*/fort.38.non0 | sed '/CL_..0/{/CLDM[A|B]0468/d}; /CL_.0./{/CLDM[A|B]0467/d}; /CL_0../{/CLDM[A|B]0466/d}' > def4_cldm_occ.csv

sed -i 's/_CLDMA0468/dm_i_A/;s/_CLDMB0468/dm_i_B/; s/_CLDMA0467/dm_c_A/;s/_CLDMB0467/dm_c_B/; s/_CLDMA0466/dm_x_A/;s/_CLDMB0466/dm_x_B/'  def4_cldm_occ.csv

# Ei crg from fixed runs:
awk '/0203/{ dir=substr(FILENAME,1, index(FILENAME,"/")-1); len_dir=length(dir);
             filepath=substr(FILENAME,len_dir+2); run=substr(filepath,1,index(filepath,"/")-1);
             print dir, run, $0}' */*/sum_crg.out | sed 's/GLU-//;s/GLU//'|egrep 'WT_[0|1]|QE_[0|1]' > def4_Ei_crg.csv

