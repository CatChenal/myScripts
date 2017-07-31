#!/bin/bash
# To setup multiple default run folders in /home/catalys/cl-channels/runs/wat-clusters/dry-false-def
# Note: The runs parent folder contain the eps-vdw-preset run.prm: run.prm.mem.025.e4.local
# mem=26A
#..................................................................................................
if [[ $# -lt 1 ]]; then
  echo "Structure type start of name needed e.g. clusterAB"
  exit 0
fi

start_with=$1
# SRC has both slices and clusters pdbs:
SRC="/home/catalys/cl-channels/pdbs/MD-traject-1OTS/Dimer_slices/"
#runDIR="dry-false-def/"
param="-025e4"

prm="run.prm.def.mem.025.e4.local"
if [[ ! -f $prm ]]; then
  echo "Common run.prm file to all subfolders not found."
  exit 0
fi
submit="../submit-localmcce.sh"
runnameClst="clstA"
runnameSlic="slicA"

# setup run.prm for S1-S2:
sed -i '/(DO_PREMCCE)$/s/^f/t/; /(DO_ROTAMERS)$/s/^f/t/; /(DO_ENERGY)$/s/^t/f/; /(DO_MONTE)$/s/^t/f/' $prm
doThis=0

for inpdb in $(ls $SRC | grep $start_with| grep '\-dry.pdb')
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
  wetpdb=${inpdb/%-dry.pdb/-wat18A.pdb}
  echo $dir" - "$inpdb" - "$wetpdb

  if [ ! -d "$dir" ]; then
    mkdir $dir
  fi

  cd $dir

    /bin/rm -f wet.pdb prot.pdb
    cat $SRC$inpdb $SRC$wetpdb > wet.pdb
    ln -s  wet.pdb prot.pdb
    echo "Source of wet.pdb :: cat $SRC$inpdb $SRC$wetpdb > wet.pdb" > wet.info

  if [ $doThis -eq 1 ]; then
    /bin/rm -f run.prm
    ln -s ../$prm run.prm
    /bin/rm -f submit.sh
    cp ../$submit submit.sh
    SED_ARG=" -i 's/@@@@/"$runname$id"W/'"
    eval sed "$SED_ARG" submit.sh
  fi

  cd ../
done

