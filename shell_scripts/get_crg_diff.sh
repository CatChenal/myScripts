#!/bin/bash
# To get charge difference from a reference state

#read -p "Enter the path/filename of the apo sum_crg file to subtract: " 
basefile=$1

#read -p "File to use: " 
higher_state=$2

if [[ ${#higher_state} -gt 0 ]]; then

  nawk -v baseF="$basefile" ' BEGIN { while ( getline < baseF > 0 )
                                            {
                                               base_counter++
                                               base[base_counter] = $1
                                            }
                                    }
                             { print  base[NR]"\n"$0  } ' $higher_state


fi
