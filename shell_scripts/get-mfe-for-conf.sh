#/bin/bash
#GET-MFE-FOR-COND.SH:
#input = list of confs

oppfldr="./energies"

if [ ! -d $oppfldr ];
then
    zopp -x energies
fi

sed 's/^\(.\{14\}\)/mfe++ \1 0.5 > \1\.mfe\.out/' $1 > run-conf-for-mfe.cmd; . run-conf-for-mfe.cmd; /bin/rm run-conf-for-mfe.cmd

sleep 150

sed 's/^\(.\{14\}\)/\/bin\/rm \1\.mfe/' $1 > run-conf-for-mfe.cmd; . run-conf-for-mfe.cmd; /bin/rm run-conf-for-mfe.cmd
