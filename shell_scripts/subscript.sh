#!/bin/sh
## To submit a script so that a long operation
## won't be killed by slaven/root check and kill script
## for CPY or MEM hungry jobs.
##
#$ -S /bin/sh
#$ -N script
#$ -cwd
#$ -o script.log
#$ -e scripterr.log

## Launch my_script
## Replace with actual script name before submitting with
##  qsub subscript.sh

## sed -i 's/cleanH3ext.sh  ####
#@@@CMD/my_script  ####\n#@@@CMD/' subscript.sh
#	fldrs_get_mfeps.sh
get_res_delphi_bkb.sh 0466 CL_f00

## To restore:
## sed -i '/  ####\n/d; s/#cleanH3ext.sh  ####
#@@@CMD/CMD/' subscript.sh

