#!/bin/bash
# To get the first and last points of chem titration in mfe file

# get mfe sum:
pre="CL_fx"

# chain A:
ch="A"

get_mfe=0
get_occ=1
last=$(awk 'END{print NF}' fort.38|sed 's/^$//')
echo "Last col: "$last

for ch in $(echo A B)
do
   for stat in $(echo apo holo)
   do
      if [[ $stat == "apo" ]]; then
         column=$last
      else
         column=2
      fi

    if [[ $get_mfe -eq 1 ]]; then

      #... 1. mfe SUM from files < get_CLenergies and get_Exenergies
      fileout=$pre$ch"_"$stat"_mfesum.csv"
      fixedCLi_fileout=$pre"1"$ch"_"$stat"_mfesum.csv"
      #echo $fileout

      awk -v col="$column" -v state="$stat" -v chn="$ch" 'BEGIN{OFS="\t"}
                                           NR==1 {print state, $col};
                                           (FILENAME ~ chn)&&($1 ~ /SUM/) { print substr(FILENAME,1,6), substr(FILENAME,8,14), $col }' CL_f*/*mfesm.csv > $fileout
      sed '/CL_f.0/d' $fileout  > $fixedCLi_fileout
     fi

     if [[ $get_occ -eq 1 ]]; then
      #... 2. occupancy from fort.38 after chem titration
      occout=$pre$ch"_"$stat"_ch-occ.csv"

      strAWK=' $1~/ex|CL-1'$ch'|'$ch'0148/ { if(NR==1) {print "run", state, $col} else { if ( ($1!="extra")&&($col!=0) ) {print substr(FILENAME,1,6), $1, $col} } }'
#      echo $strAWK
      nawk -v col="$column" -v state="$stat" -v chn="$ch" "$strAWK" CL_f*/fort.38 > $occout
     fi

   done
done

