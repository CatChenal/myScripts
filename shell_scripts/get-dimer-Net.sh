#!/bin/bash
# To get the Net charge for the 2 chain i a dimer
# input is sum_crg.out

grep A0 sum_crg.out >tmp

nawk 'BEGIN{prtline="Net_A:    "}
      {
       for (i=2; i<=NF; i++)
       {
         sum[i]+= $i
       }
      }
      END{
          for (i=2; i<=NF; i++)
          {
            prtline=sprintf("%s %3.2f",prtline, sum[i])
          }
          print prtline
         }' tmp > sumNetA.out
/bin/rm tmp

grep B0 sum_crg.out >tmp

nawk 'BEGIN{prtline="Net_B:    "}
      {
       for (i=2; i<=NF; i++)
       {
         sum[i]+= $i
       }
      }
      END{
          for (i=2; i<=NF; i++)
          {
            prtline=sprintf("%s %3.2f",prtline, sum[i])
          }
          print prtline
         }' tmp > sumNetB.out
/bin/rm tmp
