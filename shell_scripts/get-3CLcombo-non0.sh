#!/bin/bash

# 1OTSab-3CL-R0*00
# Q148Eu-R0*00
if [[ $# -eq 0 ]]; then
  echo "Argument missing (name(s) of folder(s) to process; e.g. 1OTSab-3CL-R0*00. Exiting."
  exit 0
fi
DO_relink_S2=1
read -p "Relink S2 in 'n.' folders?" DO_relink_S2

for dir in $(echo $1)
do
  # RLX="R"${dir#*R}
  # echo $RLX
  echo $dir
  cd $dir

  if [ -d n1 ]; then
    for Ndir in $(echo n*)
    do
      cd $Ndir
      dir2=$dir-$Ndir

      for subf in $(echo cl*)
      do
        cd $subf
        echo $dir2 $subf

        getnon0rows.sh fort.38
        /bin/mv -f fort.38.non0 fort.38
        if [ -f respair.lst ]; then
          getnon0rows.sh respair.lst 1
          /bin/mv -f respair.lst.non0 respair.lst
        fi
        if [ $DO_relink_S2 -eq 1 ]; then
          # The 'n.' folders are backup runs to obtain a stdev: their linked files
          # refer to one level up, but needs to be reset to 2 level up if processing needed after bkp.
          /bin/rm step2_out.pdb
          ln -s ../../step2_out.pdb .
        fi
        get-mostocc.sh 4.5 # => CLxxx-pH4.5.PDB
        mv $subf"-pH4.5.PDB" $dir2"-"$subf"-pH4.5.PDB"

        cd ../  # cl...
      done

      cd ../  # Ndir
    done
  else
    for subf in $(echo cl*)
    do
      cd $subf
      echo $dir $subf

      getnon0rows.sh fort.38
      /bin/mv -f fort.38.non0 fort.38
      if [ -f respair.lst ]; then
        getnon0rows.sh respair.lst 1
        /bin/mv -f respair.lst.non0 respair.lst
      fi
      get-mostocc.sh 4.5 # => CLxxx-pH4.5.PDB
      mv $subf"-pH4.5.PDB" $dir"-"$subf"-pH4.5.PDB"

      cd ../  # cl...
    done
  fi

  cd ../
done
