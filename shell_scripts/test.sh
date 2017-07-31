#!/bin/bash


awk -v srv="apply_server=" '{ for(n=1;n<=NF;n++) { if ( $n ~ srv ) print n, substr($n, length(srv)+1,1) } }' text


