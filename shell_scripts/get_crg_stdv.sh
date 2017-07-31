#!/bin/bash
# Returns rows with non 0 standard deviation
this=$(basename $0)
here=$(pwd)
dir=$(basename $here)

USAGE="---->  Call: "$this" [file_in: def=sum_crg.out] [threshold_value]"
# Example:  getrowstdv.sh afile 0.25
#  This script can be called without a threshold value, then 0.1 is used by default
#  and is applied to the stdev of values in all numerical columns exluding column 1

File_in="sum_crg.out"
start_col=3 # GLU B0414 -1.00 -1.00 :: output using yifan MC v251 & col3 may be ignore due to "1st point kink"

if [[ $# -gt 0 ]]; then
   File_in=$1
   if [[ ! -f $File_in ]]; then
      echo $this" ----> "$File_in" not found"
      exit 0
   fi
   if [[ "$File_in" != "sum_crg.out" ]]; then

      echo "Top of file:"
      head -3 $File_in
      read -p "Number of the first numerical column: " start_col
   else
      sed -i 's/ extra /ex  ex/' sum_crg.out; head sum_crg.out
   fi
fi

Min=0.01        # default cutoff for stdev
if [ $# -eq 3 ]; then
    Min=$(printf "%5.2f" $3)
fi

File_out=${File_in%.*}"_rowstdv.csv"

### awk '{ A=0; V=0; for(N=1; N<=NF; N++) A+=$N ; A/=NF ; for(N=1; N<=NF; N++) V+=(($N-A)*($N-A))/(NF-1); print sqrt(V) }' 

awk -v c1="$start_col" -v lim="$Min" '{ A=0; V=0; range=(NF-c1+1);
                                        for(i=3; i<=NF; i++) A+=$i; A/=range ;
                                        for(n=3; n<=NF; n++) V+=(($n-A)*($n-A))/(range-1); sqr=sqrt(V);
                                        if (sqr > lim){ $(NF+1)=sprintf("%5.2f",sqr); print $1, $2,$NF }
                                      }' sum_crg.out > > $File_out

if [[ ! -s $File_out ]]; then
  echo $this "over --- No result within threshold: > " $Min
  /bin/rm $File_out
fi
