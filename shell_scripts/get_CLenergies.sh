#!/bin/bash
if [[ $# -eq 0 ]]; then
  pH=4.5
else
  pH=$1
fi
file_end=.mfe$pH.csv

# Get small subset using cutoff:
CUTOFF=1

echo Energies for CL at pH=$pH - Outputs smaller mfe file with energy cutoff of $CUTOFF

if [[ ! -f fort.38 ]]; then
  echo '.......File fort.38 not found.'
  exit 0
fi
if [[ ! -d energies ]]; then
  echo '.......Unzip energies.opp first.'
  exit 0
fi
if [[ ! -d step3_out.pdb ]]; then
   ln -s energies step3_out.pdb
fi
# get ph_col:
Col=$(head -1 fort.38 |sed 's/ ph /ph/'| awk -v col="$pH" '{ for(n=2;n<=NF;n++) {if ( $n == col ) print n} }')
Cols=$(head -1 fort.38|awk '{print NF}')
echo 'pH column in fort.38: ' $Col
echo 'Tot columns in fort.38: ' $Cols

read -p "Do sdiff only? (0/1): " do_sdiff; do_sdiff+=0

if [ $do_sdiff -eq 0 ]; then

  read -p "Use existing mostfav files? (0/1): " use_mostfav; use_mostfav+=0
  read -p "Use existing .mfe files? (0/1): " use_mfe_files; use_mfe_files+=0
  read -p "Output non0 mfe values only? (0/1): " apply_mfe_cutoff; apply_mfe_cutoff+=0

  read -p "Remove .mfe files when done? (0/1): " rm_mfe; rm_mfe+=0
  read -p "Output charge vector at given pH? (0/1): " crg_vec; crg_vec+=0
  if [ $crg_vec -eq 1 ]; then
    get-crg-vector.sh $pH
  fi

  for ch in $(echo 'A B')
  do
    if [ $use_mostfav -eq 0 ]; then
      /bin/rm -f CL-1$ch'_mostfav.csv'
      h3_mostfav.sh CL-1$ch 0      # out: CL-1A_mostfav.csv
    fi

    for conf in $(awk '$1 !~ /CONFORM/{print $1}' CL-1$ch'_mostfav.csv')
    do
      if [ $use_mfe_files -eq 0 ]; then
        ~/mcce251/tools/mfe/mfe++ $conf -t 0 -x 0        # out: $conf.mfe
      fi

      if [ -f $conf.mfe ]; then
        file_out=$conf$file_end
        /bin/rm -f $file_out
        # correct round off format errors:
        sed -i 's/-0\.00/ 0\.00/g' $conf.mfe
#        # Remove residues not common to both chains: A0017, A0459, A0460:
#        sed -i '/A0017/d; /A0459/d; /A0460/d' $conf.mfe

        nawk -v col="$Col" -v cols="$Cols" -v cutoff="$apply_mfe_cutoff" 'BEGIN {FS="\t"; OFS="\t"; len=6}
                          NR==1 { print "AAA_0000_chn",$col };
                          NR>1 { pHcol=$col; new="";
                                 if ( $1 ~ "SUM" ) { new="ZSUM" } else { new=substr($1,1,3)"_"substr($1,6,4)"_"substr($1,5,1) };
                                 if (cutoff==1) { if ( pHcol != 0 ) {print new, pHcol} } else { print new, pHcol }
                               }' $conf.mfe > tmp

        sort -k1 -k2 -k3 tmp | nawk -F\t '{ print $1, $2 }' > $file_out

        strAWK=' { if ( ($1 ~ /0107_'$ch'|0148_'$ch'|0445_'$ch'|CL_0..._'$ch'|UM/) || ($2>'$CUTOFF') || ($2<'$CUTOFF'*-1)) {print} } '
        nawk "$strAWK" $file_out > $conf".mfesm.csv"

        /bin/rm tmp

        if [ $rm_mfe -eq 1 ]; then
          /bin/rm $conf.mfe
        fi
      fi
    done
  done
fi
skip_this=1
# Files need to have matching rows. Need frther refinements.
if [ $skip_this -eq 0 ]; then
# Get chain diff: _CL-1B0468_001.mfe4.5.csv
#                 0123456789
for mfe_file1 in $(ls _CL-1A*$file_end)
do
  out=${mfe_file1:1:9}
  conf1=${mfe_file1:6:8}
  mfe_file2='_CL-1B'$conf1$file_end

  nawk -v file2="$mfe_file2" ' BEGIN { FS="\t"; OFS="\t"; print "CONF......","chainA","chainB","diff"
                                       # load array with contents of file2
                                       while ( getline < file2 > 0 )
                                       {
                                        f2_counter++
                                        f2[f2_counter,1] = $1
                                        f2[f2_counter,2] = $2
                                       }
                                     }
                               { diff=( $2 - f2[NR,2] ); 
                                 { if ( diff != 0 ) { print $1,$2,f2[NR,2],diff } }
                               }
                               END{ print FILENAME,"minus", file2}' $mfe_file1 > $out"_mfe_chn_diff.csv"
done
#   { if ( (diff < -0.05) || (diff >  0.05) ) { print $1,$2,f2[NR,2],diff } }
fi

read -p "Remove mfe files without cutoff? (0/1): " rm_mfe
if [ $rm_mfe -eq 1 ]; then
  /bin/rm *$file_end
fi
