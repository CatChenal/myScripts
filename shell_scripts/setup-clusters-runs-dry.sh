#!/bin/bash
# To setup multiple default run folders in /home/catalys/cl-channels/runs/wat-clusters/dry-true & /dry-false-def
# Note: The runs parent folder contain the eps-vdw-preset run.prm: run.prm.memb.025.e4.local
# mem=28A
#..................................................................................................
#if [[ $# -lt 1 ]]; then
#  echo "run type fldr needed e.g. dry-true or dry-false
#  exit 0
#fi
### Set up for DRY-TRUE ########## To be called in ~/cl-channels/runs/wat-clusters/
###
# SRC has both slices and clusters pdbs:
SRC="/home/catalys/cl-channels/pdbs/MD-traject-1OTS/ChainA_slices/"
dryDIR="dry-true-def/"
param="-025e4"

prm="../run.prm.def.memb.025.e4.local"
submit="../submit-localmcce.sh"
runnameClst="clstA"
runnameSlic="slicA"

# setup run.prm for S1-S4:
sed -i '/(DO_PREMCCE)$/s/^f/t/; /(DO_ROTAMERS)$/s/^f/t/; /(DO_ENERGY)$/s/^f/t/; /(DO_MONTE)$/s/^f/t/' $prm

for inpdb in $(ls $SRC | grep '\-dry.pdb')
do
  # Shorten name for directory and run naming: clusterA-01-dry.pdb -> clusterA-01-025e4
  #                                          : sliceA-01-dry.pdb ->   sliceA-01-025e4
  dir=${inpdb/%-dry.pdb/$param}
  if [[ "${dir:0:1}" = "c" ]]; then
    id=${dir:9:2}
    runname=$runnameClst
  else
    id=${dir:7:2}
    runname=$runnameSlic
  fi
  echo $dir" - "$inpdb

  if [ ! -d "$dryDIR$dir" ]; then
    mkdir $dryDIR$dir
  fi

  cd $dryDIR$dir

  if [ -f "$inpdb" ]; then
    /bin/rm $inpdb
  fi
  if [ -f "prot.pdb" ]; then
    /bin/rm prot.pdb
  fi
  ln -s $SRC$inpdb .
  ln -s $inpdb prot.pdb

  if [ -f "run.prm" ]; then
    /bin/rm run.prm
  fi
  ln -s ../$prm run.prm

  if [ -f "submit.sh" ]; then
    /bin/rm submit.sh
  fi
  cp ../$submit submit.sh
  SED_ARG=" -i 's/@@@@/"$runname$id"/'"
  eval sed "$SED_ARG" submit.sh

  cd ../../
done

