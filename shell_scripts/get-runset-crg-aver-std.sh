#!/bin/bash
# For dimer with chains A, B
# To be called in the folder where the n... folders of runset of CL combo folders reside.
#
if [ $# -lt 2 ]; then
  echo "Missing ARG: prefix (str) of output file names; 4 digit residue id(s)"
  exit 0
elif [[ ! -d n1 ]]; then
  echo $1 ": The set of clxxx runs must be stored in folders starting with n; e.g. n1, n2..."
  exit 0
fi

hdr_sum="clnnn    RES ID    "$(head -1 sum_crg.out | sed 's/ph        //')

for res in ${@:2}
do
  # echo $res
  for chn in $(echo "A B")
  do
    grepARG=$chn$res

    outpK="c"$chn"-"$1"-"$res"-pk.csv"
    eval egrep "$grepARG" n*/cl*/pK.out|sed 's/\// /g; s/pK.out://' | sort -k3 > $outpK
    if [[ ! -s $outpK ]]; then
      /bin/rm $outpK
    fi

    out="c"$chn"-"$1"-"$res"_crg_av.csv"
    if [[ -f $out ]]; then
     /bin/rm $out
    fi
    touch tmp2

    eval egrep "$grepARG" n*/cl*/sum_crg.out|sed 's/\// /g; s/sum_crg.out://'|sort -k2 -k1 >tmp1
    # n1 cl000 GLU A0148 -1.00 -1.00 -1.00 -1.00 -1.00 -1.00 -1.00 -1.00 -1.00 -1.00 -1.00 -1.00 -1.00 -1.00 -1.00
    # c1 c2    c3  c4    c5 -> col=5
    # awk '{delta = $1 - avg; avg += delta / NR; mean2 += delta * ($1 - avg); } END { print sqrt(mean2 / NR); }'

#    for combo in $(echo cl000 cl001 cl010 cl011 cl100 cl101 cl110 cl111)
#    if [[ $(ls -l n1|grep cl|grep ^d|awk '{print $NF}'|wc -l ) -lt 2 ]]; then

#    else
      for combo in $( ls -l n1|grep cl|grep ^d|awk '{print $NF}' )
      do
        grep $combo tmp1 > tmp

        nawk -v fldr="$combo" -v col="5" -v hdr="$hdr_sum" ' BEGIN{ OFS="\t" }
            $2 == fldr {
                       for (i=col; i<=NF; i++)
                       {
                        sum[i] += $i;
                        delta = $i - avg; 
                        avg += delta / NR; 
                        mean2[i] += delta * ($i - avg)
                       }
                     } END {
                            for (i=col; i<=NF; i++)
                            {
                               prtline1=sprintf("%s %5.2f",prtline1, sum[i] / NR);
                               prtline2=sprintf("%s %5.2f",prtline2, mean2[i] / NR);
                            }
                            print fldr,"avg",$4,prtline1"\n"fldr,"std",$4,prtline2
                           }' tmp >> tmp2
      done

      sort -k2 -k1 tmp2 > $out
      /bin/rm tmp*

#    fi
  done
done
