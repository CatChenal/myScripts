#!/bin/sh
# Cat Chenal 2011-08-02
#
USAGE="Argument(s) for this procedure: filename_pattern_of_files_to_convert [new_chain_ltr]; e.g.:  -occph*.pdb A"

fldr=""
filelist=""

for fldr in `ls -l | grep '^d'|awk '{print $NF}'`
do
  cd $fldr

  filelist="$fldr$1"
#  echo Folder: $fldr - Filelist: $filelist - New chain: $2

  for pdb in `echo $filelist`
  do
     mcce2pdb.sh $pdb $2
  done
  cd ../
done

echo "-> mcce to pdb conversion over"
