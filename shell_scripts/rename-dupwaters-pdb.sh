#!/bin/bash
# Called by rename-slices.sh
#
if [ $# -lt 2 ]; then
  echo "Missing input: pdb file needed and water chain letter."
  exit 0
elif [ ! -f "$1" ]; then
  echo "Input not a file."
  exit 0
fi
prt12="%-6s%5d %-4s %3s %1s%04d    %8.3f%8.3f%8.3f%6.2f%6.2f%12s\n"

# Find dup waters:
#cp $1 $1.bkp
new=$1
newdups=$new".hohdups"
ltr=$2
strGrep=" 'O   HOH "$ltr"' "
# consider only the O atom:
eval grep "$strGrep" $new| awk '{ if (NF==11) { chn=substr($5,1,1); seq=substr($5,2,4) } else { chn=$5; seq=$6 }; \
       id[seq]++; if (id[seq]>1) { printf("%s %04d_%3s_%1d\n",chn,seq,$NF,id[seq]) } }' | sed 's/ /@/g' > $newdups
# Result: all fields concatenated bc of need for only one field in the next cat of for-loop: 
# W@2574_@W6_2; # W@5506_W17_2

if [[ -s $newdups ]]; then
  for dup in $(cat $newdups)
  do
    toolarge=0

    hoh=${dup:0:1}${dup:2:4}
    wire=${dup:7:3}; wire=${wire/@/}
    cnt=${dup:11:2}
    #echo "hoh; wire; count: "$hoh"; "$wire"; "$cnt

    # Run sed cmd to change chain letter from W -> w in line with wire and hoh:
    if [[ $cnt -eq 2 ]]; then
      # duplicates ltr->X:
      sedARG=" '/"$wire"$/ { /"$hoh"/ { s/"$ltr"/X/ } }' "
    elif [[ $cnt -eq 3 ]]; then
      # triplicates ltr->Y:
      sedARG=" '/"$wire"$/ { /"$hoh"/ { s/"$ltr"/Y/ } }' "
    elif [[ $cnt -eq 4 ]]; then
      # quadriplicates ltr->Z:
      sedARG=" '/"$wire"$/ { /"$hoh"/ { s/"$ltr"/Z/ } }' "
    elif [[ $cnt -eq 5 ]]; then
      # quadriplicates ltr->V:
      sedARG=" '/"$wire"$/ { /"$hoh"/ { s/"$ltr"/V/ } }' "
    else
      echo $hoh" :: "$dup" - "$hoh", "$wire", "$cnt": too large, skipped"
      toolarge=1
    fi

    if [[ $toolarge -eq 0 ]]; then
      # echo $sedARG
      eval sed -i "$sedARG" $new
#    else
#      cp $1 tmp
    fi
  done
  mv $new tmp
else
  echo $1 ": no dups found"
  cp $1 tmp
fi

awk -v fmt12="$prt12" '{ if ( length($3)< 4 ) { atm=sprintf(" %-3s",$3) } else { atm=$3 }; \
                         if (NF==11) { chn=substr($5,1,1); seq=substr($5,2,4) } else { chn=$5; seq=$6 }; \
                         { if (NF==11) { printf(fmt12,$1,$2,atm,$4,chn,seq,$6,$7,$8,$9,$10,$11) } else \
                                       { printf(fmt12,$1,$2,atm,$4,chn,seq,$7,$8,$9,$10,$11,$12) } } }' tmp > $new

/bin/rm -f $newdups tmp
