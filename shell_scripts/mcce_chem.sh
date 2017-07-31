#!/bin/bash
##
## TO AUTOMATE a Chemical potential titration:
## re-reqs: Run S1 & S2 & S3
MCCE_CHEM="/home/xzhu/mcce_version/Old/mcce2.4.4_extra/mcce"

echo  'Chemical potential titration setup: '
read -p ' Titration type (enter ph or eh), titr= ' titr
echo ' Titration type is: ' $titr
#10
eh0=0;ph0=0
if [[ "$titr"=="ph" ]]; then
  read -p ' Initial pH ([signed] integer)= ' ph0
  i=$ph0
else
  read -p ' Initial eH ([signed] integer)= ' eh0
  i=$eh0
fi
read -p ' How many points needed for '$titr' titration (num of folders to setup)?, n= ' n
read -p ' Initial value for Extra energy (kcal)= ' ex0
read -p ' Decrement value for Extra energy (negative number, kcal)= ' sx0
read -p ' Number of decremental Extra energy steps= ' dx0
#23
# Prep submit template in parent folder:
awk -v prog="$MCCE_CHEM" 'BEGIN {
            print "#!/bin/sh";
            print "#$ -S /bin/sh";
            print "#$ -N nnnn";
            print "#$ -cwd";
            print "#$ -o logrun.log";
            print "#$ -e logerr.log\n";
            print prog
           }'  > chem_submit.sh
#34
## Create submitall.cmd file:
if [[ -f submitall.cmd ]]; then
  /bin/rm submitall.cmd
fi
echo  >> submitall.cmd;
sed -i '1i \#\!\/bin\/bash' submitall.cmd
#41

for m in $(seq $i $n| awk '{printf "%.1f ", $1*1}')
do
  # Create folder titr_f
  fldr=$titr'_'$m
  echo $fldr
#47
  if [ ! -d $fldr ]; then
    mkdir $fldr
  fi
  cd $fldr
    if [ ! -f acc.res ]; then
      ln -s ../acc.res .
    fi
    if [ ! -f acc.atm ]; then
      ln -s ../acc.atm .
    fi
    if [ ! -f prot.pdb ]; then
      ln -s ../prot.pdb .
    fi
    if [ ! -f energies.opp ]; then
      ln -s ../energies.opp .
    fi
    if [ ! -d energies ]; then
      ln -s ../energies .
    fi
    if [ ! -f step3_out.pdb ]; then
      ln -s ../step2_out.pdb step3_out.pdb
    fi
    cp -f ../head3.lst .
#68
    # Edit parent run.prm file="run.prm.chem" with common lines & save into curr fldr:
    strSED=" -e '/TITR_STEPS/{s/^..  /"$dx0"  /}; /TITR_EX0/{s/^...  /"$ex0"  /}; /TITR_EXD/{s/^...  /"$sx0"  /}' "
    eval sed "$strSED" ../run.prm.chem > run.prm
    strSED=""
#73
    # Edit local run.prm with init ph/eh:
    if [[ "$titr"=="ph" ]]; then
      TITR="TITR_PH0"
    else
      TITR="TITR_EH0"
    fi
    strSED=" -i '/"$TITR"/{s/^.../"$m"/}' "
    eval sed "$strSED" run.prm
    strSED=""
#83
    # Create local submit.sh file by modifying master template with Name = ch_$m
    strSED=" 's/nnnn/ch_"$m"/'"
    eval sed "$strSED" ../chem_submit.sh > submit.sh
    strSED=""
#88
    # Edit submitall file:
    strSED="-i '\$a cd "$fldr"' "
    # echo $strSED
    eval sed "$strSED" ../submitall.cmd
    strSED=""
    sed -i '$a qsub submit.sh' ../submitall.cmd
    sed -i '$a cd ..\/' ../submitall.cmd
    echo \# >> ../submitall.cmd
#98
  cd ../
done
# Edit submitall file & run:
sed -i 's/qsub/  qsub/' submitall.cmd
sed -i '$a qstat' submitall.cmd
echo "Dot submitall.cmd to submit all chemical titration subfolders; i.e.: > . submitall.cmd"
