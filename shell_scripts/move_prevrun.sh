#!/bin/bash
# copies main S4 output files to new folder 'n1, n2...'
if [[ $# -eq 1 ]]; then
  if [[ ! -d $1 ]]; then
    echo Not a directory: $1
    exit 85
  fi
  dir=$1  # overwrite this dir
else
 N=$(echo "scale=0; $(ls -l | grep ^d| awk '{print $NF}'|grep '^n' | wc -l) + 1" |bc)
 dir="n"$N
 mkdir $dir
fi

pwd > parentFiles.csv
ls -ltr|awk '{print $6,$7"\t"$8"\t"$9"\t"$10"\t"$11}' >> parentFiles.csv

# get Cl params:
eps=$(awk '/EPSILON_PROT/{printf "%02d\n", $1 }' run.prm)
hom=$(awk '/MCCE_HOME/{print $1}' run.prm)
echo MCCE_HOME: $hom EPSILON_PROT: $eps >> CL_params.csv
grep CL $hom/param$eps/00always_needed.tpl >> CL_params.csv

/bin/mv *PDB *.mfe run.trace fort.3* mc_out pK.out sum_crg.out run.trace logrun.log progress.log *.csv $dir/.
#cp head3.lst $dir/head3.lst.bkp
echo Backup to $dir over.
