#!/bin/bash
# to be called in the folder to process
if [[ $# -lt 1 ]]; then
  echo "Required argument: 1: parent folder; [2: subset (e.g. n3)]. Missing."
  exit 0
fi
fldr=$1
cl_dir="cl010"
pH="4.5"

if [[ $# -eq 2 ]]; then
  subset="n3"
  level="../../"
  there=$subset"/"$cl_dir
else
  level="../"
  there=$cl_dir
fi
check_this=0
echo $there

cd $there
  if [[ $check_this -eq 1 ]]; then
    if [[ -L energies ]]; then
      check_link=$(ls -ls|awk '{print $NF}'|grep energies)   #../energies/
      if [[ {check_link:1:6} != "$level" ]]; then
        /bin/rm energies
        ln -s $level"energies" .
        chmod +x energies
      fi
    else
     ln -s $level"energies" .
    fi
    /bin/rm -f run.prm
    ln -s  $level"run.prm" .
  fi

  sed -i 's/GLU /GLU-/' pK.out
  E148file=$fldr"-E148_mfe.csv"
  E203file=$fldr"-E203_mfe.csv"
  touch $E148file

  mfe.py GLU-A0148_ $pH .5 >> $E148file
  mfe.py GLU-B0148_ $pH .5 >> $E148file
  mfe.py GLU-A0203_ $pH .5 >> $E203file
  mfe.py GLU-B0203_ $pH .5 >> $E203file
  sed -ie 's/Residue//; s/===//g; s/\*\*\*//g; s/---//g; /^$/d; s/\/Em=/ /' $E148file
  sed -ie 's/Residue//; s/===//g; s/\*\*\*//g; s/---//g; /^$/d; s/\/Em=/ /' $E203file

  if [[ "$fldr" =~ "R..L" ]]; then
    /bin/mv *mfe.csv ../$level.
  else
    /bin/mv *mfe.csv ../.   #$level.
  fi
cd $level
