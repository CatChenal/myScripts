#!/bin/sh

this=`basename $0`

if [ $# -lt 2 ]; then
        echo "Call: $this ARG1=parent_dir_start_with ARG2=subfldr_to_process"
        echo "      parent_dir_start_with: start string common to a group of subfldrs to process, e.g. 'apo'"
        exit 1
fi

for fldr in `ls -l | grep '^d' | egrep '"$1"*' | awk '{print $NF}'`
do
  toDir=$fldr"/"$2"/"
  cd ./$toDir
    . get-abnormal-res.sh
     cd ../
  cd ../
done

#  here=`pwd`;
#  loc=`basename $here`
#  what="$1"*/"$2"/*.abn
#  egrep _ ./"$what" |sed 's/:/ /' > $loc"-"$2".abn"
