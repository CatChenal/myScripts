#!/bin/bash


 conf="GLU-1A0148_083"
 id=${conf:5:10}
 echo $conf" -> id: " $id
exit 0
#...............

file=$1

gawk ' NR==1 { print; next }
       {   conf=substr($1,1,10);
           for (i=2; i<=NF; i++)
           {
               subtot[conf][i] += $i
           }
       }
       END {
             for (group in subtot)
             {
                printf "%s%s", group,
                for (i=2; i<=NF; i++) { printf "%s%s", subtot[group][i] }
             }
           }' $file
