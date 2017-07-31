#/bin/bash
strARGs="Three ARGs needed: get_non0_files.sh files_identifier cutoff 1st_numeric_col"
# files_identifier : string (in quotes) to be used by echo (ls) to return bunch of file according to a common string or pattern
if [ $# -eq 0 ]; then
  echo $strARGs
  exit 0
fi
read -p "Remove starting files? (0/1)" rm_original
cutoff=$2
col1=$3
#for mfefile in $(echo $1)
for mfefile in $(ls -l *$1 | awk '{print $NF}')
do
  echo $mfefile

  basefile=${mfefile%.*}
  getnon0rows.sh $mfefile $cutoff $col1
  /bin/mv $mfefile.non0 $basefile.nz.csv
  if [[ $rm_original -eq 1 ]]; then
    /bin/rm $mfefile
  fi
done

