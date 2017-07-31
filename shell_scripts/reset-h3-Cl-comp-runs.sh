#!/bin/bash

ext='0466'
cen='0467'
int='0468'
conf=
pre="-1[A|B]"

DO_Setup=1
DO_YMC=0  #  setup for Yifan's MC: need unzipped energies folder to be name step3_out.pdb (really)

if [[ $# -ne 1 ]]; then
  echo "Expected: start of folder name to process [additional filter str]. Exiting."
  exit 0
fi
start_with=$1
if [[ $# -eq 2 ]]; then
  other_str=$2
  fldr_list=$(ls -l |grep $start_with |grep ^d |awk '{print $NF}'|grep $other_str)
else
  fldr_list=$(ls -l |grep $start_with |grep ^d |awk '{print $NF}')
fi
echo "Folders: "$fldr_list

# Process folders:
for fldr in $(echo $fldr_list)
do
  cd $fldr

  if [ $DO_YMC -eq 1 ]; then
    if [ ! -d energies ]; then
      echo "Folder missing: energies. Unzip energies.opp as energies. Exiting"
      exit 0
    fi
  fi
  if [ $DO_Setup -eq 1 ]; then ## 3 cl combination folders setup
##    cp -f ../head3.lst .

    #for subfldr in $(echo cl*)
    for subfldr in $(echo 'cl000 cl001 cl010 cl011 cl100 cl101 cl110 cl111')
    do
      if [ ! -d "$subfldr" ]; then
        mkdir $subfldr
      fi
      cd $subfldr

      if [ $DO_YMC -eq 1 ]; then
        ln -s ../energies .
        ln -s ../energies step3_out.pdb
      fi

      if [ ! -f submit.sh ]; then
        #/bin/rm -f run.prm step*_out.pdb energies*
        ln -s ../submit.sh .
        ln -s ../run.prm .
        ln -s ../step2_out.pdb .
      fi

      cd ../
    done
  fi

  cd cl000     # No Cl = 100% dummies
  /bin/rm head3.lst
## Modify parent folder's head3.lst:
  sed '/_CL/ {s/ f 0.00/ t 0.00/}' ../head3.lst >head3.lst.new
  ln -s head3.lst.new head3.lst

# All other combos start with the cl000 head3 file:

  cd ../cl001  # Int
  cp -f ../cl000/head3.lst .
  conf=$pre$int
  sedARG=" -i '/$conf/ {s/ t 0.00/ t 1.00/}' "
  eval sed "$sedARG" head3.lst

if [[ -d ../cl010 ]]; then
  cd ../cl010  # Cen
  cp -f ../cl000/head3.lst .
  conf=$pre$cen
  sedARG=" -i '/$conf/ {s/ t 0.00/ t 1.00/}' "
  eval sed "$sedARG" head3.lst
fi
if [[ -d ../cl011 ]]; then
  cd ../cl011   # Cen + Int
  cp -f ../cl001/head3.lst .
  conf=$pre$cen
  sedARG=" -i '/$conf/ {s/ t 0.00/ t 1.00/}' "
  eval sed "$sedARG" head3.lst
fi

  cd ../cl100  # Ext
  cp -f ../cl000/head3.lst .
  conf=$pre$ext
  sedARG=" -i '/$conf/ {s/ t 0.00/ t 1.00/}' "
  eval sed "$sedARG" head3.lst

  cd ../cl101    # Ext + Int
  cp -f ../cl001/head3.lst .
  conf=$pre$ext
  sedARG=" -i '/$conf/ {s/ t 0.00/ t 1.00/}' "
  eval sed "$sedARG" head3.lst

if [[ -d ../cl110 ]]; then
  cd ../cl110   # Ext + Cen
  cp ../cl010/head3.lst .
  conf=$pre$ext
  sedARG=" -i '/$conf/ {s/ t 0.00/ t 1.00/}' "
  eval sed "$sedARG" head3.lst
fi

if [[ -d ../cl111 ]]; then
  cd ../cl111   # all
  cp -f ../cl110/head3.lst .
  conf=$pre$int
  sedARG=" -i '/$conf/ {s/ t 0.00/ t 1.00/}' "
  eval sed "$sedARG" head3.lst
fi
  cd ../

 cd ../
done
