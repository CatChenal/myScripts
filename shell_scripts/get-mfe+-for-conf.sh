#/bin/bash
#get-mfe+-for-conf.sh
#input = list of confs
# Call: get-mfe+-for-conf.sh conf.lst
#
oppfldr="energies"

if [ ! -d $oppfldr ];
then
    zopp -x energies
fi

# Rm previous calcs:
/bin/rm *.mfe+

lst=$1

awk '{print "mfe++ "$1" 0.5 0.5 > "$1".mfe+"}' $lst  > conf-mfe+.cmd
echo "conf-mfe+.cmd: "
cat conf-mfe+.cmd

. conf-mfe+.cmd

/bin/rm *.mfe conf-mfe+.cmd


#sed 's/^\(.\{14\}\)/mfe++ \1 0.5 > \1\.mfe\.out/' $1 > run-conf-for-mfe.cmd; . run-conf-for-mfe.cmd; /bin/rm run-conf-for-mfe.cmd
#sed 's/^\(.\{14\}\)/\/bin\/rm \1\.mfe/' $1 > run-conf-for-mfe.cmd; . run-conf-for-mfe.cmd; /bin/rm run-conf-for-mfe.cmd
