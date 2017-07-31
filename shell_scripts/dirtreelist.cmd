#!/bin/sh
#Scriptname: treelist
#Args: folder name to be listed

cd $1 | tree -Cdsu         # prints dir structure of given dir only

echo --- treelist for $1 folder over ---
