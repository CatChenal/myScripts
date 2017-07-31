#!/bin/bash
# To check whether low pKa is due to H+ clashes, hence absence of neutral confs
#
if [[ $# -eq 0 ]]; then
  read -p "Enter the directory name where to check occ of neutral confs: " fld
  read -p "Enter a residue id (4 digits): " res_id
else
  fld=$1
  res_id=$2
fi

fileout="confs.stats.csv"

if [[ -f $fileout ]]; then
  read -p "Overwrite existing file? (1:yes/0:no) " do_over
  if [[ $do_over -eq 1 ]]; then
    /bin/rm -f $fileout
    touch $fileout
  else
    read -p "Append results to existing file? (1:yes/0:no) " do_append
    if [[ $do_append -eq 0 ]]; then
      echo "Rename existing file. Exiting"
      exit 0
    fi
  fi
fi

for dir in $(ls -l */$fld/fort.38 |  awk 'substr($NF,1,1)~/^[A-Z]/{print substr($NF, 1,index($NF, "/")-1)}' )
do
  if [[ ! -f $dir/$fld/fort.38.non0 ]]; then
    cd $dir/$fld/
    getnon0rows.sh fort.38 0.05
    cd ../../
  fi

  echo $dir
#  f38=$dir/$fld/fort.38
#  f38non0=$dir/$fld/fort.38.non0

  for id in $(echo $res_id)
  do
     printf "%s\t%s\t..........\t%s\t%s\t%s\n" $dir $fld "cA" "cB" $id>> $fileout
     printf "%s\t%s\tGrand-Total:\t%s\t%s\n" $dir $fld $(grep -c A"$id" $dir/$fld/fort.38) $(grep -c B"$id" $dir/$fld/fort.38)  >>  $fileout
     printf "%s\t%s\tNeu:\t%s\t%s\n" $dir $fld $(grep A"$id" $dir/$fld/fort.38 |grep -c '0.A') $(grep B"$id" $dir/$fld/fort.38 |grep -c '0.B') >>  $fileout
     printf "%s\t%s\tCrg:\t%s\t%s\n" $dir $fld $(grep A"$id" $dir/$fld/fort.38 |grep -cv '0.A') $(grep B"$id" $dir/$fld/fort.38 |grep -cv '0.B') >>  $fileout

     printf "%s\t%s\tNon_0:\t%s\t%s\n" $dir $fld $(grep -c A"$id" $dir/$fld/fort.38.non0) $(grep -c B"$id" $dir/$fld/fort.38.non0) >>  $fileout
     printf "%s\t%s\tNeu:\t%s\t%s\n" $dir $fld $(grep A"$id" $dir/$fld/fort.38.non0 |grep -c '0.A') $(grep B"$id" $dir/$fld/fort.38.non0 |grep -c '0.B') >>  $fileout
     printf "%s\t%s\tCrg:\t%s\t%s\n" $dir $fld $(grep A"$id" $dir/$fld/fort.38.non0 |grep -cv '0.A') $(grep B"$id" $dir/$fld/fort.38.non0 |grep -cv '0.B') >>  $fileout
  done

done
