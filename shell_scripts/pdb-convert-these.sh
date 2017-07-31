for pdb in $( cat $1)
do
  ./convert-to-pdb.sh $pdb
done
