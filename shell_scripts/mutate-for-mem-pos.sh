#!/bin/sh
# Series of commands to mutate pdb file for proper membrane postioning
# jul-26-10 - Cat Chenal
#
# ARG -> LYS mutate:
# ARG A|B [18;19;23;147;167;205,209;230;340]

# LEU -> ARG mutate:
# LEU A|B 293

cp prot1.pdb prot.pdb

sed -i ' /REMARK/d' prot.pdb


sed '
s/^\(ATOM.\{9\}OG  SER [AB] [ 86|313|329|349|350]\)/REMARK \1/
s/^\(ATOM.\{9\}\)O\(B  SER [AB] [ 86|313|329|349|350]\)/\1C\2/
s/^\(ATOM.\{13\}\)SER\( [AB] [ 86|313|329|349|350]\)/\1ALA\2/
s/^\(ATOM.\{9\}NH[12] ARG [AB] [ 18| 19| 23|147|167|205|209|230|340]\)/REMARK \1/
s/^\(ATOM.\{9\}\)N\(E  ARG [AB] [ 18| 19| 23|147|167|205|209|230|340]\)/\1C\2/
s/^\(ATOM.\{9\}\)C\(Z  ARG [AB] [ 18| 19| 23|147|167|205|209|230|340]\)/\1N\2/
s/^\(ATOM.\{13\}\)ARG\( [AB] [ 18| 19| 23|147|167|205|209|230|340]\)/\1LYS\2/
s/^\(ATOM.\{9\}NH[12] ARG [AB]  64\)/REMARK \1/
s/^\(ATOM.\{9\}\)N\([EZ]  ARG [AB]  64\)/\1O\2/
s/^\(ATOM.\{13\}\)ARG\( [AB]  64\)/\1GLU\2/
s/^\(ATOM.\{9\}\)O\(E2 GLU [AB] [117|377|457|459]\)/\1N\2/
s/^\(ATOM.\{13\}\)GLU\( [AB] [117|377|457|459]\)/\1GLN\2/
s/^\(ATOM.\{9\}\)C\(D[12] LEU [AB] [ 84|293|304]\)/\1O\2/
s/^\(ATOM.\{13\}\)LEU\( [AB] [ 84|293|304]\)/\1ASP\2/' < prot.pdb > newprot.pdb

mv newprot.pdb prot.pdb
#egrep -c 'LEU [AB] 293' prot.pdb
#egrep 'CD[12] LEU [AB]  293' prot.pdb

#====  to reformat after cut & paste:  =======
#vi filename
#:set fileformat=unix
#:wq!
#=============================================
