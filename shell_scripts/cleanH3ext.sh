#!/bin/bash

# By removing zero entries, file size reduced by ~75%

 sed -i '/This is Salah at 293 0$/d; /^1$/d' logrun.log
 sed -i 's/-0.000/ 0.000/; /0.000     0.000/d' head3_extended.lst
 echo head3_extended.lst cleaned and reduced on: $(date) > head3_ex.info
