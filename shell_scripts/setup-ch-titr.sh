#!/bin/bash
# Gunner Lab - Cat Chenal - 12-20-10
#
#  TO AUTOMATE a Chemical potential 'titration':
#
#  Pre-reqs: Run S1 & S2 & S3
if [ ! -f "head3.lst" ];
then
  echo "Steps 1, 2 & 3 are required"
  exit 1
fi
SubmitNAME="#!/bin/sh |
#$ -S /bin/sh | 
#$ -N NAME | 
#$ -cwd | 
#$ -o logrun.log |
#$ -e logerr.log |
# Launch the MCCE: |
/home/mcce/mcce2.5.1/mcce"

echo "*** Chemical potential titration setup: ***"

echo "Titration type (enter 'ph' or 'eh'):"
read titr

eh0=0; ph0=0

if [ $titr="ph" ];
then
  echo "Initial pH value: "
  read ph0
  i=$ph0
  echo "Initial eH (mv): "
  read eh0
else
  echo "Initial eH (mv): "
  read eh0
  i=$eh0
  echo "Initial pH value: "
  read ph0
fi

echo "How many points needed for this $titr titration (num of folders to setup)?"
read n
echo "Initial value for Extra energy (kcal):"
read ex0
echo "Decrement step for Extra energy (neg number, kcal):"
read sx0
echo "Number of decremental steps:"
read dx0

#  Create submitall.cmd file:
echo \#\!\/bin\/bash > submitall.cmd
echo >> submitall.cmd

for (( f=$i; f=($i+$n-1); f++ ))
do
	# Create folder titr_f
	fldr=$titr"_"$f
	mkdir $fldr
	cd $fldr
	echo $SubmitNAME | sed 's/NAME/"$titr_$f"/' > submit.sh
#  echo $SubmitNAME | sed 's/NAME/"$titr_$f"/' ../submitNAME.sh > submit.sh
	ln -s ../acc.res ./
	ln -s ../acc.atm ./
	ln -s ../prot.pdb ./
	ln -s ../energies ./
	ln -s ../step3_out.pdb ./
	cp ../head3.lst ./

	# Edit parent run.prm with common lines & save into curr fldr:
	sed -e 's/^*(TITR_TYPE)$/^ch                                  (TITR_TYPE)$/' 
	    -e 's/^*(TITR_STEPS)$/^"sx0"                                (TITR_STEPS)$/' 
	    -e 's/^*(TITR_EX0)$/^"ex0"                                 (TITR_EX0)$/' 
	    -e 's/^*(TITR_EXD)$/^"dx0"                                 (TITR_EXD)$/' ../run.prm > run.prm
		
	# Edit local run.prm
	if [ $titr=="ph" ];
	then
		sed -i 's/*(TITR_PH0)$/"f"                                  (TITR_PH0)/' run.prm
	else
		sed -i 's/*(TITR_EH0)$/"f"                                  (TITR_EH0)/' run.prm
	fi
	
	# Edit submitall file:
	echo cd \.\/$titr_$f >> ../submitall.cmd
	echo qsub submit.sh >> ../submitall.cmd
	echo cd ../ >> ../submitall.cmd
	echo >> ../submitall.cmd
	
    cd ../
done

# Edit submitall file & run:
echo qstat >> submitall.cmd
. submitall.cmd

# ***  end of script ***
