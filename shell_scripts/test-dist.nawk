# nawk script
#    nawk -f test-dist.nawk s2.pdb xyzfile > out
# ==================================================================
function getawkline (inpdb, xyz){
  Cols=NF;
  totCol=expr $Cols + 1;
  #totCol=$Cols;
  echo "Args given: "argc"; "argv"; output col "$totCol;
  {split($2,coord," ")
  inX=coord[1];
  inY=coord[2];
  inZ=coord[3];
  }
# col 6, 7, 8 = x, y, z in step2.pdb
  cX=6;
  cY=7;
  cZ=8;
  awkline=echo "{d=0; d=sqrt(($inX-$"$cX")^2 + ($inY-$"$cY")^2 + ($inZ-$"$cZ")^2);tot="$totCol"; $"$totCol"=d; print}";
  echo "--- $awkline";
}
nawkline=getawkline($1, $2)
{
nawkline
}
