#/bin/bash
if [[ $# -lt 2 ]]; then
   echo "ARGS: [1] Conf num (format: nnnn) [2] conf crg:neg/neu"
   exit 0
fi

conf_num=$1
conf_crg=$2
out=$conf_num"_"$conf_crg"_occ.csv"

# Return 1st col of f38:

awk -v id="$conf_num" -v crg="$conf_crg" 'BEGIN{OFS="\t"; first=id"_001"; if (crg=="neg") {comp="-1."id} else {comp="0.."id} } { if (($1 ~ comp)||($1 ~ first)) { print $1, $2} }' fort.38 > $out
cat $out
# GLU01A0148_001
# 12345678901234
#      123456789

grepline=$(awk 'BEGIN{OFS="|"; str="\047"} {str=str"CG  ... "substr($1,6,9)OFS} END{ print substr(str,1, length(str)-1)"\047"}' $out)
echo Grepline:
echo "$grepline"

out=$conf_num"_"$conf_crg"_CGxyz.csv"

grep -v MEM step2_out.pdb | eval egrep "$grepline" | awk 'BEGIN {OFS="\t"} { print $3, $5, $6, $7, $8 }'  > $out

cat $out


