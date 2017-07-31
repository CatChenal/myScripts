#!/bin/bash
# In given units
#
if [[ $# -eq 0 ]]; then
   read -p "Enter an id for this data set: " setID
else
  setID=$1
fi
do_h3_terms=1
do_CL_mfe=0
do_phu=0
ok_go=0
ok_reset=0
bad="Reply must be either 0 or 1. Exiting."

read -p "Current settings: do_h3_terms="$do_h3_terms"; do_CL_mfe="$do_CL_mfe"; do_phu="$do_phu" :: OK? (0/1)" ok_go

if [[ $ok_go -eq 0 ]]; then
   read -p "Reset params? (0/1)" ok_reset
   if [[ $ok_reset -eq 1 ]]; then
     read -p "1. do_CL_mfe = (0/1)" do_CL_mfe
     read -p "2. do_h3_terms = (0/1)" do_h3_terms
     read -p "3. do_phu = (0/1)" do_phu

     read -p "Reset to: do_h3_terms="$do_h3_terms"; do_CL_mfe="$do_CL_mfe"; do_phu="$do_phu" :: OK? (0/1)" ok_go
   fi
fi
if [[ $do_phu -ne 1 && $do_phu -ne 0 ]]; then
  echo $bad
  exit 0
fi

out=$setID

for each in $(echo "0466|f00 0467|0f0 0468|00f")
do
   id=${each%%|*}
   fld=${each##*|}

   if [[ $do_h3_terms -eq 1 ]]; then

      outfile=$out"_"$fld"_h3_terms.csv"
      nawk -v phu="$do_phu" -v CL="$id" 'BEGIN{ OFS="\t"; this="CL-1[A|B]"CL;units=1; U="(kcm)"; if (phu==1){units=0.733; U="(phu)"};
                                              prtFMT="%s\t%s\t%s\t%s\t%5.2f\t%5.2f\t%5.2f\n"; print U,"run", "conf","vdw","epol","dsolv","Res" }
                                      { if ($2 ~ this)
                                        {
                                           dir=substr(FILENAME,1, index(FILENAME,"/")-1); len_dir=length(dir);
                                           filepath=substr(FILENAME,len_dir+2); run=substr(filepath,4,3);
                                           vdw1=($10+$11)*units;  vdw=sprintf("%5.2f", vdw1);
                                           printf(prtFMT, dir, run, substr($2,6,9), vdw, $13*units, $14*units, 0)
                                        }
                                      }' */CL_$fld/head3.lst > $outfile
   fi
   if [[ $do_CL_mfe -eq 1 ]]; then

      # NOTE: mfe++ data is in ph units
      # Need to run get_CL_energies in subfolders to obtain input files

      infile="CL_"$fld"/_CL-1*"$id"_00*.sm_mfe.csv"
      outfile=$out"_"$fld"_"$id"_mfeSUM_b.csv"

      nawk -v phu="$do_phu" 'BEGIN{ OFS="\t"; units=1; U="(phu)"; if (phu==0){units=1.364; U="(kcm)"}; print U, "run", "conf","SUMb"; prtFMT="%s\t%s\t%s\t%5.2f\n" }
                            /SUM/ { dir=substr(FILENAME,1, index(FILENAME,"/")-1); len_dir=length(dir); filepath=substr(FILENAME,len_dir+2);
                                    run=substr(filepath,4,3); conf=substr(filepath,13,9)
                                    printf(prtFMT, dir, run, conf, $2*units)
                                  }' */$infile > $outfile

      if [[ $id != "0468" ]]; then # gather data from Ex fixed neutral runs:

         infile="CL_"$fld"_E01/_CL-1*"$id"_00*.sm_mfe.csv"
         outfile=$out"_"$fld"E01_"$id"_mfeSUM_b.csv"

         nawk -v phu="$do_phu" 'BEGIN{ OFS="\t"; units=1; U="(phu)"; if (phu==0){units=1.364; U="(kcm)"}; print U, "run", "conf","SUMb"; prtFMT="%s\t%s\t%s\t%5.2f\n" }
                               /SUM/ { dir=substr(FILENAME,1, index(FILENAME,"/")-1); len_dir=length(dir); filepath=substr(FILENAME,len_dir+2);
                               run=substr(filepath,4,7); conf=substr(filepath,17,9)
              printf(prtFMT, dir, run, conf, $2) }' */$infile > $outfile
      fi

   fi

done

