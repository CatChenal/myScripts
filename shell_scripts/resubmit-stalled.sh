#!/bin/bash

if [[ $# -ne 3 ]]; then
  echo "ARGS: start_of_jobname stalled_step_number run.prm_used_by_subfolders. None provided."
  exit 0
fi
sgejobname=$1
step=$2
prm=$3
# delete from queue:
qstat|nawk -v job="$sgejobname" '$3 ~ job { if(substr($3,1,1)=="s") {dir="sliceAB-"substr($3,6,2)"-025e4"} else {dir="clusterAB-"substr($3,6,2)"-025e4"}; {print $1,dir} }' >tmp
for num in $(cat tmp|awk '{print $1}')
do
 qdel $num
done
## setup run.prm for step_$2 only:
case $step in
  1)
  sed -i '/(DO_PREMCCE)$/s/^./t/; /(DO_ROTAMERS)$/s/^./f/; /(DO_ENERGY)$/s/^./f/; /(DO_MONTE)$/s/^./f/' $prm
  ;;
  2)
  rm step2 *bkp MEM* *log ~temp* *opp head3.lst S2-MEM-new.pdb
  sed -i '/(DO_PREMCCE)$/s/^./f/; /(DO_ROTAMERS)$/s/^./t/; /(DO_ENERGY)$/s/^./f/; /(DO_MONTE)$/s/^./f/' $prm
  ;;
  3)
  sed -i '/(DO_PREMCCE)$/s/^./f/; /(DO_ROTAMERS)$/s/^./f/; /(DO_ENERGY)$/s/^./t/; /(DO_MONTE)$/s/^./f/' $prm
  ;;
  4)
  sed -i '/(DO_PREMCCE)$/s/^./f/; /(DO_ROTAMERS)$/s/^./f/; /(DO_ENERGY)$/s/^./f/; /(DO_MONTE)$/s/^./t/' $prm
  ;;
  *)
  echo "Unknown step number."
  exit 1
esac
echo "Subfolders resubmitted for step"$step":"
echo
for dir in $(cat tmp | awk '{print $2}')
do
  echo $dir
  cd $dir
    qsub submit.sh
  cd ../
done
