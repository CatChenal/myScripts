BEGIN{prtline=""}
{
   for (i=1; i<=NF; i++)
   {
     sum[i]+= $i
   }
}
END {
  for (i=1; i<=NF; i++ )
  {
    prtline=prtline sum[i]/NR" "
  }
  print prtline
  }

function isnum(x)
  { return x == x + 0 }


