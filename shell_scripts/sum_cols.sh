#!/bin/bash
#
E_WRONGARGS=85
START_COL=2		# default; 1st col=txt, confname, etc: skipped
START_ROW=0		# no header assumed

if [ $# -lt 1 ]
then
   echo "Usage: $(basename $0) filename [1 if file has header, else 0 (default), required if first_col given; first_col (2=default)]"
   exit $E_WRONGARGS
fi
filename=$1
COL=$START_COL

if [[ $# -eq 3 ]]; then
  ROW=$2
  COL=$3
elif [[ $# -eq 2 ]]; then
  ROW=$2
fi

nawk -v row="$hdr" -v col1="$START_COL" 'BEGIN{prtline="Sum: "}
        NR>row {
          for (i=col1; i<=NF; i++)
          {
             sum[i]+= $i
          }
        }
        END{
          for (i=col1; i<=NF; i++)
          {
            prtline=prtline sum[i]" "
          }
          print prtline
        }' $filename
