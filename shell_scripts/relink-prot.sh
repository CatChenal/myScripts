#!/bin/bash

#SRC="/home/catalys/cl-channels/pdbs/MD-traject-1OTS/ChainA_slices/"

SRC="/home/catalys/cl-channels/pdbs/gromacs2/"

runname="clstA"
param="-025e4"

echo "----> "$(basename $0)":: Preset with:"
echo "----- Source folder for prot.pdb parent: "$SRC
echo "---->  Is that ok?  Enter y for yes, n for no: "; read answ
if [ "$answ" != "y" ]; then
  echo "---->  Exiting";
  exit 0;
else
  SRC=""
  echo "---->  Enter new folder path (or c to cancel): "; read SRC

  if [ "$SRC" = "c" ]; then
    echo "---->  Exiting";
    exit 0;

fi

for inpdb in `ls /home/catalys/cl-channels/pdbs/gromacs2/ | grep pdb|grep -v clusterA-01`
do
  # Shorten name for directory and run naming: clusterA-01.pdb -> clusterA-01
  dir=${inpdb/%.pdb/$param}
  id=${dir:9:2}
  echo $dir" - "$inpdb

#  if [ ! -d "./$dir" ]; then
#    mkdir ./$dir
#  fi
  cd ./$dir
  /bin/rm *log run.trace

  if [ -f "prot.pdb" ]; then
    /bin/rm prot.pdb
  fi
  ln -s $SRC$inpdb $inpdb
  ln -s $inpdb prot.pdb

 cd ../
done
