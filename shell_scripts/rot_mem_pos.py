def rot_mem_pos(fldr, posfile, deg):

	import math

	## assume fldr = "/home/usr/folder/"   NO validation check righ now

	file_in=open(fldr+posfile,'r')
	file_out=open(fldr+"new_mem_pos",'r+')

	file_in.seek(0)
	for line in file_in:
           x=float(line[1:11])
	   y=float(line[13:23])
	   z=float(line[25:35])
           print x,y,z
           
           ## Normalize vector:
	   r=math.sqrt(x**2 + y**2 + z**2)
	   u=(x/r, y/r, z/r)
	
           ## pi/180= 3.1416/180 = 0.01745
		
           rad = float(adeg)* 0.01745
	   c = math.cos(rad)
	   s = math.sin(rad)

           newx=str( x*( u[0]**2 + (1 -u[0]**2)*c ) + y*( u[0]*u[1]*(1-c) - u[2]*s ) + z*( u[0]*u[2]*(1-c) + u[1]*s ) )
	   newy=str( x*( u[0]*u[1]*(1-c) + u[2]*s ) + y*( u[1]*u[1] + (1-u[1]**2)*c ) + z*( u[1]*u[2]*(1-c) - u[0]*s ) )
	   newz=str( x*( u[0]*u[2]*(1-c) - u[1]*s ) + y*( u[1]*u[2]*(1-c) + u[0]*s ) + z*( u[2]**2 +(1-u[2]**2)*c ) )
			
	   newline=newx+" "+newy+" "+newz
	   file_out.write(newline+'\n')

