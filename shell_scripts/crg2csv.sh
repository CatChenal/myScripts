#!/bin/bash
# To get sum_crg.out in csv format and:
#	 tab-separated
#	 without blank or total lines
# => can be used in R using read.csv
# ARG1 = filter for folder filter
#
if [[ $# -eq 0 ]]; then
  read -p "Enter a string to filter the subdirectories of this folder: " filt
else
  filt=$1
fi

for fldr in $( ls -l|awk -v lim="$filt" '/^d/ {if($NF ~ lim) {print $NF}}')
do
  if [[ ! -f $fldr/sum_crg.out ]]; then
    echo "No crg.out"
  else
    cd $fldr
    echo $fldr

    awk 'BEGIN{OFS="\t"; line=""}
         NR>1{ res=$1"_"$2;
               { for (i=3;i<=NF;i++) {line=sprintf("%s%5.2f\t",line,$i)}};
               print res,line; line=""}' sum_crg.out > sum_crg.csv
    sed -i '/^_	$/d; /Tot/d; /Net/d' sum_crg.csv

    hdr=$(head -1 fort.38|awk 'BEGIN{OFS="\t"}{ for (i=2;i<=NF;i++) { line=sprintf("%s%5.1f\t",line,$i) }} {print $1,line}')

    strSED=" '1i "$hdr"' "
    eval sed -i "$strSED" sum_crg.csv
    # Remove trailing tab:
    sed -i 's/\(\t\)$//' sum_crg.csv
    cd ../
  fi
done
