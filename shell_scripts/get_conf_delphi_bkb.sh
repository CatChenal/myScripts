#!/bin/bash
# For use to get a conf bkb details from opp files when Delphi folder was saved.
#
if  [[ $# -lt 3 ]]; then
  echo $(basename $0) " - Required: <conformer_id> <run_id> <subfolder where most occ'd conf will be retrieved>"
  exit 0
fi
CONF=$1
if [[ ${#CONF} -ne 14 ]]; then
  echo $(basename $0) " - Wrong input: 10-digit conformer id needed."
  exit 0
fi
RUN=$2
FLDR=$3
ch=${CONF:5:1}
occ_min=0.05

      # opp header:
      #    column #: 1     2              3         4          5          6
      # description: conf# name           corr_el   vdw_pwise  delphi_el  post_bdry_corr_el
      #                    00197 SERBKA0214_000 0.046     0.000      0.067     [?]

if [[ -f $RUN/$FLDR/fort.38 ]]; then

   # 1 mostocc conf at point 2 if apo state
   line=$(awk -v res="$CONF" -v run="$FLDR" -v occ="$occ_min" '{if ($1 ~ res) {if (run ~ /CL_000/) {pt=$3} else {pt=$2}; if (pt < occ){pt=0}; {print $1, pt}} }' $RUN/$FLDR/fort.38)
   occ=$(echo $line |awk '{printf "%.2f", $NF}')

   if [[ "$occ" != "0.00" ]]; then

      id=${CONF:5:10}        #GLU-1A0148_083 -> A0148_083
      bkb_file=$RUN/"BKB/"$id"_"${FLDR/CL/bkb}".csv"

      # Assuming dimer. Total other chain contribution separately. /000/ isolates bkb elements.
      awk -v cnf="$CONF" -v ch1="$ch" -v w="$occ" 'BEGIN{ OFS="\t"; if (ch1=="A"){ch2="B0"} else {ch2="A0"}; id=substr(cnf,6,5)}
                                                   /_000/{ if ( $2 ~ ch2 ) { other_el+=$3;  }
                                                           else if ( $2 ~ id ) { self_el+=$3; }
                                                           else { sum_el+=$3; };
                                                           if ( ($2 !~ /MEM/)&&( ($3 != "0.000")||($3 != "-0.000") ) )
                                                                { printf("%s %6.2f\n", substr($2,1,3)"_"substr($2,6,5), $3); }
                                                         }
                                                   END{ TOT=other_el+self_el+sum_el;
                                                        printf("%s %6.2f\n", "Other_ch", other_el+=other_el<0?-0.005:0.005);
                                                        printf("%s %6.2f\n", "Self    ", self_el+=self_el<0?-0.005:0.005);
                                                        printf("%s %6.2f\n", "Rest    ", sum_el+=sum_el<0?-0.005:0.005);
                                                        printf("%s %6.2f\n", "TOT_"substr(cnf,6,9), TOT+=TOT<0?-0.005:0.005);
                                                        printf("%s %6.2f\n", "occ_"substr(cnf,6,9), w+=w<0?-0.005:0.005)
                                                      }' $RUN/$FLDR/energies/$CONF".opp" > $bkb_file

      if [[ $ch == "A" ]]; then
         sed -i '/_B0/d' $bkb_file
      else
         sed -i '/_A0/d' $bkb_file
      fi

      if [[ ! -s $bkb_file ]]; then
         /bin/rm $bkb_file
      fi

   fi # occ not 0
fi # f38
