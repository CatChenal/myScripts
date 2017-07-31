#!/usr/bin/python
from pylab import *
import numpy as np
##from numpy import corrcoef, sum, log, arange
#from pylab import pcolor, show, colorbar, xticks, yticks

def mtx_correl(file_in, file_out):
	
##	f = open(file_in, "r")
	f = open(file_in).readlines()

	file_out = np.corrcoef(f)

	if _name_ == '_main_':
		import sys
		mtx_correl(sys.argv[1], sys.argv[2])

