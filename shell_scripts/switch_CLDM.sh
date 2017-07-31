#!/bin/bash
# To reorder and rename the dummy of CL so that the dummy is processed first.
# This entails changing the CL conformer name from _001 to _002 in all the opp files;
# Assumes unzipped energies folder.
#
# The argument passed (1/0) will revert the naming if equal to 1 [0=default=perform the changes]
#
DO_REVERT=$($# -eq 1;$1;0)
if [[ ! -d energies ]]; then

  echo "Energies folder not found unzip




if [[ $DO_REVERT -eq 1]]; then
  # change head3:
  sed -i -e '/CLDM/ {s/_001/_002/}; /_CL-1/ {s/_002/_001/}' head3.lst
  # change the opp:

  
