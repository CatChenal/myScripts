#!/bin/bash
# arg1=list
# arg2=col
# col3 of opp = ele; col4 = vdw

# get list of confs to turn off
awk -v col=$2 ' {if ($col>3) {print FILENAME,$2, $col} }' energies/_CL-1*0467_00*.opp|awk '{print $2}'|sort|uniq > CLc_Yc_elepw_highconfs

get-egrepline-from-list.sh $1 > do_fix.cmd
# output =
#'/GLU01B0148_006|GLU01B0148_018|GLU01B0148_036|GLU02B0148_081|GLU02B0148_102|GLU-1A0148_011|GLU-1A0148_012|GLU-1B0148_112|
#GLU-1B0148_113|GLU-1B0148_114|GLU-1B0148_115|GLU-1B0148_116|GLU-1B0148_117|GLU-1B0148_118|GLU-1B0148_119|GLU-1B0148_120|
#GLU-1B0148_121|GLU-1B0148_122|GLU-1B0148_123|GLU-1B0148_124|GLU-1B0148_125|GLU-1B0148_126|GLU-1B0148_127|GLU-1B0148_128|GLU-1B0148_129|GLU-1B0148_130|GLU-1B0148_131/'
strSubs1="sed -i -e "
strSubs2=" {s/f 0/t 0/}' head3.lst"
cat do_fix.cmd

strSED="s/^/"$strSubs1"; s/\'$/
#sed -i -e  "s/^/sed -i /; s/'$\{s\/f 0\/t 0\/\}\'/' head3.lst/" do_fix.cmd

cat do_fix.cmd

