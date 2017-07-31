#!/bin/bash

if [[ ! -f run.prm ]]; then
    echo Needed: run.prm - Not found
    exit 85
fi
# get Cl params:
eps=$(awk '/EPSILON_PROT/{printf "%02d\n", $1 }' run.prm)
hom1=$(awk '/MCCE_HOME/{ print $1 }' run.prm)

hom=${hom1//\/\//\/}
params=$hom"/param"$eps

echo Data from run.prm:
echo ...MCCE_HOME: $hom1
echo ...EPSILON_PROT: $eps
echo ...Param dir: $params

echo Data from global tpl:
grep ...CL $params/00always_needed.tpl

echo Data from _cl.tpl:
egrep 'CONF|RXN|RAD' $params/_cl.tpl

