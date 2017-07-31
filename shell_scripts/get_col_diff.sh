#!/bin/bash
# Input files assumed to be symmetric and with a descriptive header
# Field/col1=assumed to be descriptive: copied to output
DO_subtot=0
if [[ $# -lt 3 ]]; then
   echo "Required: File1, File2, output, 1/0 (subtotal by column1 values) [, col_number: if not included, then interactive selection from header]"
   exit 0
fi
F1=$1
F2=$2
Out=$3
DO_subtot=0 #$4

echo "Top of input file1:"
head -2 ./$1

read -p "Enter the number of the data column to subtract: " c1


nawk -v file1="$F2" -v col="$c1" 'BEGIN { OFS="\t";
                                          # load array with contents of col in file1:

                                          while ( getline var < file1 > 0 )
                                          { split(var, rec, " ")
                                            r_count++
                                            f1[r_count,col] = rec[col]
                                          }
                                          { print " ... diff_col: c["col"]" }
                                        }
                                        NR>1
                                        { diff=($col-f1[NR, col]);
                                          { print $1,$2,$col,f1[NR],diff }
                                        }' $F1 > $Out

if [[ $DO_subtot -eq 1 ]]; then

   if [[ "$F1" == *fort.38* ]]; then
      /bin/mv $Out tmp

      awk 'BEGIN { OFS="\t"; RES="" }
          { RES=substr($1,1,10);
            if( (substr(RES,4,2)=="01")||(substr(RES,4,2)=="02") )
            { RES=substr(RES,1,3)"00"substr(RES,6,5) };
            { print RES, $1, $2, $3, $4 }
          }' tmp > $Out

     /bin/rm tmp
#   fi

   nawk -v lim="0.01" 'BEGIN { OFS="\t"; RES=""; stot=0 }
         { if (NR==1) { RES=$1 } ;
           { if ( RES==$1 ){ stot=+$NF }
             else
             {
               if( (stot>=lim)||(stot<=lim*-1) ) { printf("%-14s%7.3f\n", RES" subtot", stot) };
               stot=0; RES=$1
             }
           }
         }' $Out > $Out"-sub.csv"

   strSED=$F1" - "$F2" Col["$fld"="$val"] difference file subtotalled by column1 values"
   echo $strSED >> $Out"-sub.csv"
  fi
fi
