#!/bin/bash
#..................................................................................................
#runDIR="dry-false-def/"
#param='-025e4'

submit="submit-localmcce.sh"
runnameClst="clstA"
runnameSlic="slicA"

#sliceA-54-025e4/
#clusterA-02-025e4/

for dir in $(ls -l |grep '^d'|awk '{print $NF}')
do
  if [[ "${dir:0:1}" = "c" ]]; then
    id=${dir:9:2}
    runname=$runnameClst
  else
    id=${dir:7:2}
    runname=$runnameSlic
  fi
  cd $dir

  if [ -f "submit.sh" ]; then
    /bin/rm submit.sh
  fi
  cp ../$submit submit.sh
  SED_ARG=" -i 's/@@@@/"$runname$id"W/'"
#echo $dir": "$inpdb "$SED_ARG"
  eval sed "$SED_ARG" submit.sh
 cd ../
done

