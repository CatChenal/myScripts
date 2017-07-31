#!/usr/bin/env python
import sys
import re

outpath = sys.argv[1]
try:
	outpath = sys.argv[2]
except IndexError:
	pass
temp_lines = []
f = open(sys.argv[1], 'r')
remover = re.compile('^(\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+).*')
for line in f:
	temp_line = remover.sub(r'\1', line)
	temp_lines.append(temp_line)
f.close()

# \S Matches any non-whitespace character; this is equivalent to the class [^ \t\n\r\f\v]
# \s Matches any whitespace character; this is equivalent to the class [ \t\n\r\f\v].

out = open(outpath, 'w')
for line in temp_lines:
	out.write(line)
out.close()
