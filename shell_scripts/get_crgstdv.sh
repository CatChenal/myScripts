#!/bin/bash
# Returns rows with non 0 standard deviation
this=$(basename $0)
here=$(pwd)
dir=$(basename $here)

USAGE="---->  Call: "$this" [file_in, def=sum_crg.out] [threshold_value]"
# Example:  getrowstdv.sh afile 0.25
#  This script can be called without a threshold value, then 0.1 is used by default
#  and is applied to the stdev of values in all numerical columns exluding column 1

File_in="sum_crg.out"
start_col=2

cols=$(awk 'NR==2 {print NF}' $File_in)
if [[ $cols -eq 17 ]]||[[ $cols -eq 7 ]]; then
  start_col=3
fi

if [[ $# -gt 0 ]]; then
  File_in=$1
  if [[ ! -f $File_in ]]; then
     echo $this" ----> "$File_in" not found"
     exit 0
  fi
  echo "Top of file:"
  head -3 $File_in
  read -p "Number of the first numerical column: " start_col
fi

Min=0.05        # default cutoff for stdev
if [ $# -eq 2 ]; then
    Min=$(printf "%5.2f" $2)
fi

File_out=${File_in%.*}"_rowstdv.csv"

# Create tmp file with aver in last col:
awk -v col1="$start_col" 'BEGIN{OFS="\t"}
     { sum=0; for(n=col1; n<=NF; n++){ sum+=$n };
       N=(NF-1); $(NF+1)=sprintf("%5.2f",sum/N); print $0 }' $File_in > tmp

# create new file with additional col=stdv => last 2 cols = Aver | Stdev
awk -v lim="$Min" -v col1="$start_col" 'BEGIN{ OFS="\t"; { if(lim==0){len=4} else {len=length(lim)+1}} }
                  { var=0; nf=(NF-2); aver=$NF;
                  for(n=col1; n<=nf; n++)
                  { var+=($n-aver)*($n-aver) };
                  stdv=sqrt(var/nf);
                  { if ( (substr(stdv,1,len)*1) > lim ){ $(NF+1)=sprintf("%5.2f",stdv); print $0 } }
                  }' tmp > $File_out
/bin/rm tmp

if [[ ! -s $File_out ]]; then
  echo $this "over --- No result within threshold: > " $Min
  /bin/rm $File_out
fi
