#!/bin/bash
# NOTE: ASSUMES first column is descriptive (not totalled)
#
E_WRONGARGS=85
START_COL=2		# default; 1st col=txt, confname, etc: skipped

if [ $# -lt 1 ]
then
   echo "Usage: `basename $0` filename ["t" if file has header, else nothing]"
   exit $E_WRONGARGS
fi
filename=$1
if [ $# -eq 2 ]; then
  hdr=1
else
  hdr=0
fi
nawk -v row="$hdr" -v col1="$START_COL" 'BEGIN{prtline="sum_occ "}
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
