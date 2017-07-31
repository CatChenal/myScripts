#!/bin/bash
# For each conf, get occ->sum->calc sum-> find interval containing 0.5+-e=> get pH (extrapolate)
#tpl_with_path=$1
#for conf in $(grep CONFLIST $tpl_with_path | awk '{for(i=3;i<=NF;i++){out=out$i"\n"}}{print out}'|sed '/^$/d' | egrep -v 'BK|DM|#')
#do
#done
#.........................................
# ARG= one single conf
# pKa calculated on increasing side of curve
# pKa2=(0.5-Y1)/(Y2-Y1/X2-X1)+ X1
#
if [ ! -f "fort.38" ]; then
  echo "fort.38 not found"
  exit 0
else
  head -1 fort.38 > hdr.38
fi
if [ ! -f "fort.38.non0" ]; then
  getnon0rows.sh fort.38 0.005
fi
grepARG=" '$1' fort.38.non0"
$(eval grep -q "$grepARG" &> /dev/null)
if [ $? -gt 0 ]; then	  # not found
  echo $1" not found in fort.38.non0"
  exit 0
fi
eval grep "$grepARG" > $1.occ
sum_all_cols.sh $1.occ > $1.occ.sum
sed -i 's/sum_occ//' $1.occ.sum
# Get flanking points around 0.5, then extrapolate:
values=$(awk 'BEGIN{m=0; pK=0; Y1=0; Y2=0; foundCol=0}
     { for (i=1; i<=NF; i++)
       {
         if ( $(i+1)>=$i )
         {
           if ($i<=0.5) {foundCol=i; Y1=$i; Y2=$(i+1)}
         }
       }
     }
     END{ printf "%s %d %s %5.3f %s %5.3f\n","col: ", foundCol, "Y1: ", Y1,"Y2: ", Y2 }' $1.occ.sum )
#col:  8 Y1:  0.144 Y2:  0.833
Col=$(echo $values|awk '{print $2}')
Y1=$(echo $values|awk '{print $4}')
Y2=$(echo $values|awk '{print $6}')
awkscript='{print $c, $(c+1)}'
X1X2=$(nawk -v c="$Col" " $awkscript " hdr.38)
echo $X1X2
X1=$(echo $X1X2|awk '{print $1}')
X2=$(echo $X1X2|awk '{print $2}')

#  END{ m=(Y2-Y1)/(X2-X1); pK=(X1 + (0.5-Y1)/m);
pK=$(echo "scale=2; ($X1 + (0.5-$Y1)/(($Y2-$Y1)/($X2-$X1)))" | bc)
echo $1" pKa: " $pK

/bin/rm $1.occ
