#!/bin/bash
sge_status='qw'

qstat|grep $sge_status | awk '{print "qdel "$1}' > qdel.cmd; chmod +x qdel.cmd; ./qdel.cmd
