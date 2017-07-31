#!/bin/bash
# Scriptname: renameS4files.sh
# Cat Chenal @ Gunner Lab; 2010-06-17
#
# Purpose:      Renames Step4 files fort.38, sum_crg.out, pK.out, and
#		mc_out, fort.36 if present;
#		After editing head3.lst and running S4 multiple times, keeping
#		the output files of the succesive S4 runs creates a history of the
#		outcome of each new run.
# Inputfile:	None paased, but S4 files must exist.
# Arguments: 	Arg1 [Arg2]; e.g.: > renameS4files.sh x n
# Output:	None.  S4 files will be renamed with xn appended, e.g. fort.38 -> fort.38.xn
# Usage="	Call example: > renameS4files.sh nov 12 # Outcome: fort.38 will be renamed fort.38.nov12"
#  ----------------------------------------------------------------------------
this=$(basename $0)
#  Test if script was called w/o at least 1 argument:
if [[ $# -eq 0 ]]; then
  echo "  Script $this requires at least one argument.";
  echo $Usage
  exit 0
fi
#  Rename S4 files
if [[ $# -gt 1 ]]; then
  ext=.$1$2
else
  ext=.$1
fi

h3_too=0
read -p "Also rename head3.lst? (yes:1/no:0) " h3_too

for S4file in $(echo "fort.38 sum_crg.out pK.out")
do
  if [[ -e $S4file ]]; then
    mv $S4file $S4file$ext
  else
   echo $S4file" not found"
  fi
done
if [[ $h3_too -eq 1 ]]; then
  if [[ -f head3.lst ]]; then
    mv head3.lst head3.lst$ext
  fi
fi
echo ">> $this over: All found S4-files were renamed"
