#!/bin/sh
# Purpose:  To run mfe at pH=7 for all res in pks.csv (the output of getpks-csv.sh)
# INPUT: the output file of getpks-csv.sh
# ----------------------------------

this="mfe-pks-csv.sh"

# Check if energies.opp has been unziped:
  file=./energies
  if [ !-d $file ]
  then
     zopp -x $file
  fi
# *****************************************
# TO DO  set awk loop here:
# for 

  mfe.py $res 7.0 0.5 > temp.csv	# mfe.py res_id titration_point [cutoff]
  fileout= "$res."

  fileout= "$fileout".mfe.csv
  echo "Outputfile: " $fileout

#awk 'NF>1 {print}' _CL-X0119-ph5.mfe|sed -e 's/^Residue //' -e 's/\(-TS\)\(  \)/(\1)/' -e 's/residues/res/'|awk '{OFS="\t"; print $1"\t"$2"\t"$3"\t"$4"\t"$5}' > _CL-X0119-ph5.mfe.csv

  #sed -e 's/Residue //' \-e 's/=\{28\}//g' -e 's/*\{28\}//g' -e 's/-\{28\}//g' temp.csv > $fileout

# done
  echo
  echo NOTE: $fileout is ready for import into Excel as a fixed column data file.
  echo
  echo  --- "$0" ---  Remove unzipped energies folder? \(y\/n\)?
  read reply 
  if [ "$reply" = "Y" -o "$reply" = "y" ]; then
	rm -fR energies	
  fi

