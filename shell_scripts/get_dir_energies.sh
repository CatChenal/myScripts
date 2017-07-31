#!/bin/bash
# To setup calc for CL and Ex enrgies in subfolders
#
if [[ $# -lt 2 ]]; then
  read -p "Enter an identifier for this (parent) folder: " fld_id
  read -p "Enter a directory name identifier (for filtering folders): " filter
else
  fld_id=$1
  filter=$2
fi
#... Preset pH and delphi opp file format ........................
pH_col=2
cutoff=1
#... Preset pH and delphi opp file format ........................
read -p "Preset pH_col and mfe cutoff: "$pH_col"; cutoff= "$cutoff" :: OK? (0/1)" ok_go
if [[ $ok_go -eq 0 ]]; then
  echo "Modify get_dir_energies.sh"
  exit 0
fi

do_prep=0
del_fort_non0=0
do_CLs=1
do_Ex=0
do_Ei=0
do_overwrite=1
read -p "Current set: do_prep="$do_prep"; del_fort_non0="$del_fort_non0"; do_CLs="$do_CLs"; do_Ex="$do_Ex"; do_Ei="$do_Ei" :: OK? (0/1)" ok_go
if [[ $ok_go -eq 0 ]]; then
   read -p "Reset params? (0/1)" ok_reset
   if [[ $ok_reset -eq 1 ]]; then
     read -p "1. do_prep= (0/1)" do_prep
     read -p "2. del_fort_non0= (0/1)" del_38_non0
     read -p "3. do_CLs= (0/1)" do_CLs
     read -p "4. do_Ex= (0/1)" do_Ex
     read -p "5. do_Ei= (0/1)" do_Ei
     read -p "Reset to: do_prep="$do_prep"; del_fort_non0="$del_fort_non0"; do_CLs="$do_CLs"; do_Ex="$do_Ex"; do_Ei="$do_Ei" :: OK? (0/1)" ok_go
   fi
fi
read -p "Overwrite existing mfeps.csv files?. do_overwrite = (0/1)" do_overwrite

if [[ $ok_go -eq 1 ]]; then

for subfldr in $( ls -l|awk '/^d/ {print $NF}'|grep $filter )
do
  if [[ ! -f $subfldr/run.prm ]]; then
     echo $subfldr": missing run.prm"
     break
  fi
  if [[ $del_fort_non0 -eq 1 ]]; then
    /bin/rm -f $subfldr/fort.38.non0
  fi
  if [[ -f $subfldr/~temp.dbm.* ]]; then  #maybe running
    echo $subfldr" possibly running; skipped"
    break
  fi

  cd $subfldr
    if [[ ! -f fort.38.rowstdv.csv ]]; then
       get_row_stdv.sh fort.38   #: outputs a 'high' stdev conf = hi_stdv_confs.csv for stdev >=0.05
    fi

    if [[ $do_prep -eq 1 ]]; then
       if [[ ! -d energies ]]; then
          ln -s ../energies .
       fi
    fi #do_prep
    if [[ $do_CLs -eq 1 ]]; then
       get_CL_energies.sh
    fi

    #check pK.out format: res id should have no space
    $(grep -q 'GLU ' pK.out &> /dev/null)
    if [ $? -eq 0 ]; then # found => not amended
       amend_pKout.sh
    fi

    # get value of given column in fort.38
    pH_col=$2
    pH=$(nawk -v Col="$pH_col" 'NR==1 { for(n=2; n<=NF; n++) {if ( n == Col ) print $n} }' fort.38)

    ## check pH in range:
    #pHnew=$(awk -v pHin="$pH" -v col_out="$def_col"  'NR==1 { if ( ($2>=pHin*1)&&($NF<=pHin*1) ) {print pHin} else { print $col_out} }' fort.38)
    #pH=$pHnew

    if [[ $do_Ex -eq 1 ]]; then
         RES="0148"
         if [[ $do_overwrite -eq 1 ]]; then
               res=$(awk '/A0148/{print $1}' pK.out)
               mymfe.py $res $pH $cutoff > tmp; sed '/TOTAL/q' tmp | awk 'BEGIN{IFS="\t"; OFS="\t"}{print $1, $2, $NF}' > "A0148_mfeps.csv"

               res=$(awk '/B0148/{print $1}' pK.out)
               mymfe.py $res $pH $cutoff > tmp; sed '/TOTAL/q' tmp | awk 'BEGIN{IFS="\t"; OFS="\t"}{print $1, $2, $NF}' > "B0148_mfeps.csv"
         fi
      fi
      if [[ $do_Ei -eq 1 ]]; then
         RES="0203"
         if [[ $do_overwrite -eq 1 ]]; then
               res=$(awk '/A0203/{print $1}' pK.out)
               mymfe.py $res $pH $cutoff > tmp; sed '/TOTAL/q' tmp | awk 'BEGIN{IFS="\t"; OFS="\t"}{print $1, $2, $NF}' > "A0203_mfeps.csv"
               res=$(awk '/B0203/{print $1}' pK.out)
               mymfe.py $res $pH $cutoff > tmp; sed '/TOTAL/q' tmp | awk 'BEGIN{IFS="\t"; OFS="\t"}{print $1, $2, $NF}' > "B0203_mfeps.csv"
         fi
      fi
      /bin/rm tmp
   cd ../

done
do_collate=0

if [[ $do_collate -eq 1 ]]; then

# collate_dir_dat.sh $fld_id $filter
   awk '$1!="extra"{print substr(FILENAME, 1, index(FILENAME, "/")-1), $0}' $filter*/$filter*_CLDM-Ex_occ.csv | \
         sed '/CL_..0/{/CLDM[A|B]0468/d}; /CL_.0./{/CLDM[A|B]0467/d}; /CL_0../{/CLDM[A|B]0466/d}' > $fld_id"_"$filter"_CLDM-Ex_occ.csv"

#   if [[ ! ($filter == "QE") || ($filter == "WT") ]]; then
     egrep 'fff|ff0|f00|0f0|00f|f10|1f0'  $fld_id"_"$filter"_CLDM-Ex_occ.csv" | egrep -v '_S107|_E148|_R28' > $fld_id"_"$filter"_CLDM-Ex_occ_cycle.csv"
#   fi

   # output ionizE in kcal/mol from small mfepy file:
   awk '/TOT/{idx1=index(FILENAME,"/"); dir=substr(FILENAME,1,idx1-1);res=substr(FILENAME,idx1+1,5); print dir,res,$NF}' $filter*/*_mfeps.csv|sort -k2 > $fld_id"_"$filter"_Ex_TOT.csv"

   awk '/A0203/{idx=index(FILENAME, "/f"); {print substr(FILENAME, 1, idx-1), $0} }' $filter*/fort.38.non0 > $fld_id"_"$filter"_A0203_occ.csv"
   awk '/B0203/{idx=index(FILENAME, "/f"); {print substr(FILENAME, 1, idx-1), $0} }' $filter*/fort.38.non0 > $fld_id"_"$filter"_B0203_occ.csv"

fi


fi #ok_go

