#!/bin/bash
# 2012-Feb-16 to filter respair.lst
# for rendering in pymol: entries are mostly <0.5 + 
# reformatted so that it's the same as hb.txt

for fldr in `ls -l | grep '^d' | awk '{print $NF}'| grep -v 'err' | grep -v '^Script' |grep -v '^all-pK'|grep -v 'subf*'`
do
# 1st folder level=fixed CLDM
  cd $fldr
  if [ -f "respair.lst" ]; then
    echo $fldr
    getnon0rows.sh respair.lst 0.99
    sed -e '/residue/d' -e 's/\([A-Z]\)[+|-]/\1/'  -e 's/\([0-9]\)_/\1/g' respair.lst.non0 | awk '{print $1"\t"$2"\t"$5}' > $fldr-fix-new-respair.lst
#  else
#    echo $fldr": respair.lst missing"
  fi
  if [ -d "withCLDM" ]; then
    if [ -f "withCLDM/fort.38" ]; then
      if [ -f "withCLDM/pK.out" ]; then
#        echo $fldr" : withCLDM completed"
        cd 'withCLDM/'
        if [ -f "respair.lst" ]; then
          echo $fldr"-withCLDM"
          getnon0rows.sh respair.lst 0.99
          sed -e '/residue/d' -e 's/\([A-Z]\)[+|-]/\1/'  -e 's/\([0-9]\)_/\1/g' respair.lst.non0 | awk '{print $1"\t"$2"\t"$5}' > $fldr-fre-new-respair.lst
 #       else
 #         echo $fldr": respair.lst missing"
        fi

        cd ../
      fi
    fi
  fi

  cd ../
done

