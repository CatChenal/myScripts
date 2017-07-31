#!/bin/bash
# This version id NOT for ions
#
if [[ $# -eq 0 ]]; then
  echo 'Residue identifier (eg.0148 w/o chain) required [ pH def=4.5]'
  exit 0
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

pH=4.5
if [[ $# -eq 2 ]]; then
  pH=$2
fi
file_end=.mfe$pH.csv
RES=$1

# Get small subset using cutoff:
CUTOFF=3
echo 'Energies for '$RES' at pH '$pH' - Smaller mfe file uses '$CUTOFF' as energy cutoff.'

# get ph_col:
Col=$(head -1 fort.38 |sed 's/ ph /ph/'| awk -v col="$pH" '{ for(n=2;n<=NF;n++) {if ( $n == col ) print n} }')
Cols=$(head -1 fort.38|awk '{print NF}')
#echo 'pH column in fort.38: ' $Col
#echo 'Tot columns in fort.38: ' $Cols

#read -p "Do mfe chain diff only? (0/1): " do_sdiff
#do_sdiff+=0
#if [ $do_sdiff -eq 0 ]; then

  read -p "Use existing mostfav files? (0/1): " use_mostfav; use_mostfav+=0
  read -p "Use existing .mfe files? (0/1): " use_mfe_files; use_mfe_files+=0
  read -p "Output non0 mfe values only? (0/1): " apply_mfe_cutoff; apply_mfe_cutoff+=0

  read -p "Remove .mfe files when done? (0/1): " rm_mfe; run_mfe+=0
  read -p "Output charge vector at given pH? (0/1): " crg_vec; crg_vec+=0

  if [ $crg_vec -eq 1 ]; then
    get-crg-vector.sh $pH
  fi

  for ch in $(echo 'A B')
  do
    if [ $use_mostfav -eq 0 ]; then
      /bin/rm -f $ch$RES'_mostfav.csv'
      h3_mostfav.sh $ch$RES 1      # out: A0148_mostfav.csv
    fi

    for conf in $(awk '$1 !~ /CONFORM/{print $1}' $ch$RES'_mostfav.csv')
    do
      if [ $use_mfe_files -eq 0 ]; then
        mfe++ $conf -t 0 -x 0        # out: $conf.mfe
      fi

      if [ -f $conf.mfe ]; then
        file_out=$conf$file_end

        /bin/rm -f $file_out
        # correct round off format errors:
        sed -i 's/-0\.00/ 0\.00/g' $conf.mfe
        # Remove residues not common to both chains: A0017, A0459, A0460:
        sed -i '/A0017/d; /A0459/d; /A0460/d' $conf.mfe

        nawk -v col="$Col" -v cols="$Cols" -v cutoff="$apply_mfe_cutoff" 'BEGIN {FS="\t"; OFS="\t"; len=6}
                          NR==1 { print "AAA_0000_A",$col };
                          NR>1 { pHcol=$col; new="";
                                 if ( $1 ~ "SUM" ) { new="ZUM" } else {new=substr($1,1,3)"_"substr($1,6,4)"_"substr($1,5,1) };
                                 if (cutoff==1) { if ( pHcol != 0 ) {print new, pHcol} } else { {print new, pHcol} }
                               }' $conf.mfe > tmp

        sort -k1 -k2 -k3 tmp | nawk -F\t '{ print $1, $2 }' > $file_out

        strAWK=' { if ( ($1 ~ /'$RES'_'$ch'|CL_0..._'$ch'|UM/)||($2>'$CUTOFF') ) {print} } '
        nawk "$strAWK" $file_out > $conf".mfesm.csv"

        /bin/rm tmp
        /bin/rm -f $conf.mfe.non0

        if [ $rm_mfe -eq 1 ]; then
          /bin/rm $conf.mfe
        fi
      fi
    done
  done
#fi #not 'Do chain diff only'

# Get chain diff: not implemented as chains may not have same confs
