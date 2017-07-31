#!/bin/bash
RES=$1
do_weighted_sum=0

if [[ $# -eq 2 ]]; then
   do_weighted_sum=$2
fi

for ch in $(echo 'A B')
do
   RESid=$ch$RES
   NEU='GLU0.'$RESid;   NEG='GLU-1'$RESid

   h3_mostfav.sh $RESid 0 # outfile = $RESid"_mostfav.csv"; hdr:   #CONFORMER          vdw0     vdw1     epol    dsolv    h3Tot

   occCols=$(awk ' NR==1{print NF;exit}' fort.38)

   grep $NEU $RESid"_mostfav.csv" > $RESid"_neu.h3"
   nawk -v crg="$NEU" 'BEGIN{OFS="\t"} $1~crg {print $2"\t"$1}' fort.38 > $RESid"_neu_holo.occ"
   nawk -v crg="$NEU" -v col="$occCols" 'BEGIN{OFS="\t"} $1~crg {print $col"\t"$1}' fort.38 > $RESid"_neu_apo.occ"

   grep $NEG $RESid"_mostfav.csv" > $RESid"_neg.h3"
   nawk -v crg="$NEG" 'BEGIN{OFS="\t"} $1~crg {print $2"\t"$1}' fort.38 > $RESid"_neg_holo.occ"
   nawk -v crg="$NEG" -v col="$occCols" 'BEGIN{OFS="\t"} $1~crg {print $col"\t"$1}' fort.38 > $RESid"_neg_apo.occ"

   # Get weighted sum of RES confs:
   for crg in $(echo 'neu neg')
   do
      file2=$RESid"_"$crg".h3"

      for stat in $(echo 'holo apo')
      do
         file3=$file2"."$stat
         occ_file=$RESid"_"$crg"_"$stat".occ"
         cp $file2 tmp

         for conf in $(awk '{print $1}' $file2)
         do
            mfe_file=$conf".mfe"
            if [[ ! -f $mfe_file ]]; then
               mfe++ $conf -t 1 -x 1 > $mfe_file
            fi
            grep -m 1 SUM $mfe_file > $mfe_file".sum"

            # update h3 file with sum_mfe and occ
            if [[ "$stat" = "holo" ]]; then
               sum_mfe=$(awk '/SUM/{print $2;exit}' $mfe_file".sum")
            else
               sum_mfe=$(awk '/SUM/{print $NF;exit}' $mfe_file".sum")  #  'col 2=holo; col NF=apo
            fi
            occ=$(nawk -v id="$conf" '$2==id { print $1}' $occ_file)

##            echo $occ_file : $crg : $stat : $conf : $sum_mfe : $occ
            strSED=" -i ' /"$conf"/{s/$/	"$sum_mfe"/}' ";  eval sed -i "$strSED" tmp
            strSED=" -i ' /"$conf"/{s/$/	"$occ"/}' "   ;  eval sed -i "$strSED" tmp

            /bin/rm $mfe_file
         done  #conf

         mv tmp $file3
         fileout=$file3".new"

         nawk -v state="$stat" -v CRG="$crg" -v do_sum="$do_weighted_sum" ' BEGIN \
                                  { OFS="\t"; min_mfe=0; min_conf=""; min_h3tot=0; min_Tot=0; if (do_sum=="0"){ last="Tot" } else { last="w_Tot" };
                                    printf("%-14s%8s%8s%8s%8s%8s%8s%8s%8s\n", "CONFORMER","vdw0","vdw1","epol","dsolv","h3Tot" ,state"_mfe", state"_occ",last)
                                  }
                                  {
                                    if (NR==1) { min_conf=$1; min_h3tot=$6; min_mfe=$7; min_Tot=$9 };
                                    occ=1; if (do_sum=="1"){ occ=$8 };
                                    $9=sprintf("%6.2f",($6+$7)*occ);
                                    if ( $7 < min_mfe ) { min_conf=$1; min_h3tot=$6; min_mfe=$7; min_Tot=sprintf("%6.2f",($6+$7)*occ) };
                                    prtLine=sprintf("%14s",$1);
                                    for (i=2; i<=9; i++)
                                    {
                                       prtLine=prtLine"\t"sprintf("%6.2f",$i);
                                       sum[i]+=$i
                                    };
                                    print prtLine;
                                  }
                                  END{
                                       prtLine=sprintf("%14s",CRG"_"state"_totals");
                                       for (i=2; i<=9; i++) { prtLine=prtLine"\t"sprintf("%6.2f",sum[i]) };
                                       print prtLine;
                                       printf("%-46s %6.2f%6.2f%8s%6.2f\n", min_conf, min_h3tot, min_mfe, ";", min_Tot)
                                     }' $file3 > $fileout
      done #stat
   done # crg
done # ch

/bin/rm *.occ *.h3 *.h3.apo *.h3.holo *.mfe.sum
here=$(pwd)
fld=$(basename $here)
egrep totals *.new|sed 's/\.new:/\t/'|sort > $fld"_Ex_ch-states-tots.csv"

