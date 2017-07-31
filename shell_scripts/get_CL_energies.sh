#!/bin/bash
if [[ $# -eq 0 ]]; then
  pH='All'
else
  pH=$1
fi
file_end=.mfe$pH.csv
# Get small subset using cutoff:
CUTOFF=1

if [[ $pH == "All" ]]; then
  echo Energies for CL at all points - Outputs smaller mfe file with energy cutoff of $CUTOFF
else
  echo Energies for CL at point=$pH - Outputs smaller mfe file with energy cutoff of $CUTOFF
fi
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
if [[ $pH != "All" ]]; then
   # get ph_col:
   Col=$(head -1 fort.38 |sed 's/ ph /ph/'| awk -v col="$pH" '{ for(n=2;n<=NF;n++) {if ( $n == col ) print n} }')
   echo 'point column in fort.38: ' $Col
fi
Cols=$(head -1 fort.38|awk '{print NF}')
echo 'Tot columns in fort.38: ' $Cols

  read -p "Use existing mostfav files? (0/1): " use_mostfav
  read -p "Use existing .mfe files? (0/1): " use_mfe_files
  read -p "Output non0 mfe values only? (0/1): " apply_mfe_cutoff
  read -p "Remove file_out files when done? (0/1): " rm_mfe
  read -p "Output charge vector at given pH? (0/1): " crg_vec
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
        sed  's/-0\.00/ 0\.00/g' $conf.mfe > tmp

        if [[ $apply_mfe_cutoff -eq 1 ]]; then
            nawk 'BEGIN { OFS="\t"}
                  NR==1 { print };
                   NR>1 { sum=0; for (i=2; i<=NF; i++){ sum+=$i }; if ( sum!=0 ) { print } }' tmp > $conf.mfe
        else
           /bin/mv tmp > $conf.mfe
        fi
        file_out=$conf$file_end ## file_end=.mfe$pH.csv
        /bin/rm -f $file_out

        if [[ $pH != "All" ]]; then
           nawk -v col="$Col" -v cols="$Cols" -v cutoff="$apply_mfe_cutoff" 'BEGIN {FS="\t"; OFS="\t"}
                          NR==1 { print "AAA_0000_chn",$col };
                          NR>1 { pHcol=$col; new="";
                                 if ( $1 ~ "SUM" ) { new="ZSUM"; print } 
                                 else { new=substr($1,1,3)"_"substr($1,6,4)"_"substr($1,5,1) };
                                        if (cutoff=="1") { if ( pHcol != 0 ) {print new, pHcol} } else { print new, pHcol }
                                      }
                               }' $conf.mfe > tmp

          sort -k1 tmp | nawk -F\t '{ print $1, $2 }' > $file_out

          strAWK=' { if ( ($1 ~ /0107_'$ch'|0148_'$ch'|0445_'$ch'|CL_0..._'$ch'|UM/) || ($2>'$CUTOFF') || ($2<'$CUTOFF'*-1)) {print} } '
          nawk "$strAWK" $file_out > $conf".mfesm.csv"

        else
           nawk -v cols="$Cols" -v cutoff="$apply_mfe_cutoff" 'BEGIN {FS="\t"; OFS="\t"; sum=0; cols2=-1*cols}
                          NR==1 { $1="aaa_mfe  "; print };
                          NR>1 { if ( $1 ~ "SUM" ) { $1="ZSUM____"; print } 
                                 else {
                                       if (cutoff=="1") { sum=0; for (i=2; i<=NF; i++){ sum+=$i }; if ( (sum>=cols)||(sum<=cols2) ) {print} } else { print }
                                      }
                               }' $conf.mfe > tmp

           sort -k1 tmp | nawk -F\t '{ print }' > $file_out

           strAWK=' {sum=0; for (i=2;i<=NF;i++){sum += $i}; if ( ($1 ~ /'$ch'0107_|'$ch'0148_|'$ch'0445_|CL-1'$ch'|UM/) || (sum>'$CUTOFF') || (sum<'$CUTOFF'*-1) ) {print} } '
           nawk "$strAWK" $file_out > $conf".mfesm.csv"
        fi
        /bin/rm tmp

        if [ $rm_mfe -eq 1 ]; then
          /bin/rm $file_out
        fi
      fi

      sed -i 's/ZSUM/SUM/' $conf".mfesm.csv"
    done
#    sed -i 's/ZSUM/SUM/' $conf".mfesm.csv"
  done

read -p "Remove master mfe files (without cutoff)? (0/1): " rm_mfe
if [ $rm_mfe -eq 1 ]; then
  /bin/rm _CL-1*mfe
fi
