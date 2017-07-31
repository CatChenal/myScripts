#!/bin/bash
# Cat Chenal 2013-06-03

if [ $# -lt 1 ]; then
  echo "Usage:  file_name?"
  exit 0
fi

awk 'BEGIN{ prt12="%-6s%5d %-4s %3s %1s%4d    %8.3f%8.3f%8.3f%6.2f%6.2f%12s\n"} \
    { if ( length($3)< 4 ) {atm=sprintf(" %-3s",$3)} else {atm=$3}; \
      if (NF==11) {chn=substr($5,1,1); seq=substr($5,2,4)} else {chn=$5; seq=$6}; \
      if ($3 !~ /^H/){ \
         { if (NF==11) {printf(prt12,$1,$2,atm,$4,chn,seq,$6,$7,$8,$9,$10,$11)} else \
                       {printf(prt12,$1,$2,atm,$4,chn,seq,$7,$8,$9,$10,$11,$12)} } \
                     } \
    }' $1

