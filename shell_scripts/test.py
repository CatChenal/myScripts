#!/usr/bin/python


   if os.path.isfile("head2.lst"):
      n_confs = len(open("head2.lst").readlines()) - 1
      n_steps = int(n_confs/JOBS_MAX)
#   n_steps = int(sys.argv[1])

     steps = int(raw_input("Enter your preferred number of steps (suggested number is %d ): ", n_steps));
     print "Received input is : ", steps


str = input("Enter your input: ");
print "Received input is : ", str
 
# > test.py
# Enter your input: [x*5 for x in range(2,10,3)]
# Received input is :  [10, 25, 40]
# => range=range(start, end, step)

