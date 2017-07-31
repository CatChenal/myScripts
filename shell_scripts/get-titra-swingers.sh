#!/bin/bash
# Cat Chenal @ Gunner lab - 2011-02-03
# Rev: 2011-02-11
# 
this="`basename $0`"
LINE1="   Call pattern: $this infile [threshold_value: optional]\n   Call example: $this sum_crg.out 0.5\n"
LINE2="   This script will return those conformers for which the end-points difference (last_titr_col - first-titr_col)\n"
LINE3="   is outside of the given threshold_value (or 0.5 if none provided).\nNote that the input file must be in fort.38\n"
LINE4="   or sum_crg format, and if the sum_crg format is used, the filename must contain 'sum' or 'crg'. 
The output is saved as infile.swingers."
Usage=`echo "$LINE2""$LINE3""$LINE4""$LINE1"`
if [ $# -lt 1 ]; then
    echo "$Usage";
    exit 0;
fi
if [ ! -f $1 ]; then
    echo "Could not locate $1. Exiting.";
    exit 0;
fi

lim=0.5
if [ $# -eq 2 ]; then
    lim=$2;
fi
max=0
pct=0
cnt=0
tot=0

# Assign given input to var:
in="$1"
extn=".swingers"
outfile=$in$extn
flag=0

# Output file header:
awk 'BEGIN{OFS="\t"}; NR == 1 {print} ' $1 | sed 's/..          /conf id   /' > $outfile

if [ `echo "$1" | egrep 'sum|crg'` ]; then
# Assume sum_crg.out like format:
    flag=1
    tail -4 $1 > tmpZlast4;            
    # Remove cofactors & keep the rest:
    grep -v '^_' $1 > tmpZ;   
    # Remove last 4 rows
    tot=`awk 'END {print NR}' tmpZ`
    tot=$[tot-4]; 
    head -$tot tmpZ > tmpZbody;   
    # Reset var with body only from sum_crg.out:
    in="tmpZbody";
fi
export lim
awk -v trsh=$lim 'BEGIN{OFS="\t"}; NR>1 { del=($NF-$2); { if ((del >= trsh) || (del <= -trsh)) print }}' $in | sort > tmpZ

if [ $flag -eq 1 ]; then
    cat tmpZ tmpZlast4 >> $outfile;
else
    cat tmpZ >> $outfile;
fi
/bin/rm tmpZ*
tail $outfile

echo; echo Above results saved in $outfile; echo
echo Residues statistics:  Outliers found vs. $1 count:
cnt=`grep -c ^ $outfile`
tot=`grep -c ^ $1`
pct=$(echo "scale=2; ($cnt/$tot)*100" |bc)
echo All ionizable residues: $pct% outliers found
pct=0

ioniz="ASP ARG CYS GLU HIS LYS THR TYR"
for res in `echo $ioniz`
do
    out=`grep -c $res $outfile`
    if [ $out != 0 ]; then
        max=`grep -c $res $1`;
        pct=$(echo "scale=2; ($out/$max)*100" |bc);
        echo $res: $out out of $max  \($pct%\);
        echo $res: $out out of $max  \($pct%\) >> $outfile.stat;
#        printf "%3s %3n out of %3n  \(%3.2d%%\)\n" "$res" "$out" "$max" "$pct"
    fi
done
echo; echo Above results saved in $outfile.stat; echo
echo End-point difference threshold used \(inclusively\): $lim
echo End of $this  -------------------
