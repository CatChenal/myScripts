#!/usr/bin/python

########################LIST PART BEGIN##################################
#input:         a integer
#return:        a list
#function:      create a list, and all elements are 0.0
#name and date: jianxun lu 01/26/12

def list_create(row):
	thelist=[]
        i=0
        while i<row:
                thelist.append(0.0)
                i+=1
        return thelist


#input:         a list
#return:        a number
#function:      find out the maximum of a list
#name and date: jianxun lu 01/26/12

def list_max(inputlist):
    maximum=inputlist[0]
    i=1
    while i<len(inputlist):
        if maximum<inputlist[i]:
            maximum=inputlist[i]
        i+=1
    return maximum


#input:         a list
#return:        a number
#function:      find out the minimum of a list
#name and date: jianxun lu 01/26/12

def list_min(inputlist):
    minimum=inputlist[0]
    i=1
    while i<len(inputlist):
        if minimum>inputlist[i]:
            minimum=inputlist[i]
        i+=1
    return minimum


#input:         two lists
#return:        a list
#function:      sum up two lists
#name and date: jianxun lu 01/26/12

def list_add(list1,list2):
    thelist=list_create(len(list1))
    i=0
    while i<len(list1):
        thelist[i]=list1[i]+list2[i]
        i+=1
    return thelist


#input:         a list, a floating number
#return:        a list
#function:      scalar multiplication of a list
#name and date: jianxun lu 01/26/12

def list_scalar_multiply(inputlist,scalar):
    thelist=list_create(len(inputlist))
    i=0
    while i<len(inputlist):
        thelist[i]=inputlist[i]*scalar
        i+=1
    return thelist


#input:         two lists
#return:        a list
#function:      list subtraction
#name and date: jianxun lu 01/26/12

def list_subtract(list1,list2):
    return list_add(list1,list_scalar_multiply(list2,-1))


#input:         a list, a floating number
#return:        a list
#function:      scalar division of a list
#name and date: jianxun lu 01/26/12

def list_scalar_divide(inputlist,scalar):
    return list_scalar_multiply(inputlist,1/float(scalar))


#input:         a list, a floating number
#return:        a list
#function:      scalar division of a list
#name and date: jianxun lu 01/26/12

def list_powersum(inputlist,power):
    thesum=0
    i=0
    while i<len(inputlist):
        thesum+=inputlist[i]**power
        i+=1
    return thesum

#input:        two lists
#return:        a floating number
#function:      calculate the correlation coefficient of two sets of data
#name and date: jianxun lu 01/25/12

def list_correlation(list1, list2):
    precision=0.01**2
    var1=list_powersum(list1,2)-list_powersum(list1,1)**2/float(len(list1))
    var2=list_powersum(list2,2)-list_powersum(list2,1)**2/float(len(list2))
    if var1<len(list1)*precision or var2<len(list2)*precision:
        return 0.0
    else:
        i=0
        productsum=0
        while i<len(list1):
            productsum+=list1[i]*list2[i]
            i+=1
        return (productsum-list_powersum(list1,1)*list_powersum(list2,1)/float(len(list1)))/(var1**0.5*var2**0.5)



##################LIST PART END#########################################



##################MATRIX PART BEGIN#####################################
#input:         two integers "row" and "column"
#return:        a matrix
#function:      create a matrix with row*column dimensions, and all elements are 0
#name and date: jianxun lu 01/25/12

def matrix_create(row,column):
    matrix=[]
    i=0
    while i<row:
        i_row=list_create(column)
        matrix.append(i_row)
        i+=1
    return matrix


#input:         two matrices
#return:        a matrix
#function:      sum up two matrices
#name and date: jianxun lu 01/26/12

def matrix_add(matrix1,matrix2):
    matrix=matrix_create(len(matrix1),len(matrix1[0]))
    i=0
    while i<len(matrix1):
        matrix[i]=list_add(matrix1[i],matrix2[i])
        i+=1
    return matrix


#input:         a matrix, a floating number
#return:        a matrix
#function:      scalar multiplication of a matrix
#name and date: jianxun lu 01/26/12

def matrix_scalar_multiply(imatrix,scalar):
    matrix=matrix_create(len(imatrix),len(imatrix[0]))
    i=0
    while i<len(imatrix):
        matrix[i]=list_scalar_multiply(imatrix[i],scalar)
        i+=1
    return matrix


#input:         two matrices
#return:        a matrix
#function:      matrix subtraction
#name and date: jianxun lu 01/26/12

def matrix_subtract(matrix1,matrix2):
    return matrix_add(matrix1,matrix_scalar_multiply(matrix2,-1))


#input:         a matrix, a floating number
#return:        a matrix
#function:      scalar division of a matrix
#name and date: jianxun lu 01/26/12

def matrix_scalar_divide(imatrix,scalar):
    return matrix_scalar_multiply(imatrix,1/float(scalar))


#input:         a matrix
#return:        the correlation coefficient matrix of the input matrix
#function:      calculate the correlation coefficient matrix from a input matrix
#name and date: jianxun lu 01/25/12

def matrix_correlation(imatrix):
    omatrix=matrix_create(len(imatrix),len(imatrix))
    i=0
    while i<len(imatrix):
        j=0
        while j<i:
            omatrix[i][j]=omatrix[j][i]
            j+=1
        omatrix[i][j]=1.0
        j+=1
        while j<len(imatrix):
            omatrix[i][j]=list_correlation(imatrix[i],imatrix[j])
            j+=1
        i+=1
    return omatrix


#input:        a matrix
#return:    a matrix
#function:    matrix transposing
#name and date:    jianxun lu 01/26/12

def matrix_transpose(imatrix):
    omatrix=matrix_create(len(imatrix[0]),len(imatrix))
    i=0
    while i<len(omatrix):
        j=0
        while j<len(omatrix[0]):
            omatrix[i][j]=imatrix[j][i]
            j+=1
        i+=1
    return omatrix


#input:         a matrix
#return:        a list
#function:      find out the module of each row in a matrix
#name and date: jianxun lu 01/26/12

def matrix_rowmodule(matrix):
    module=matrix_create(len(matrix),1)
    i=0
    while i<len(matrix):
        i_max=list_max(matrix[i])
        i_min=list_min(matrix[i])
        module[i][0]=i_max-i_min
        i+=1
    return module


#################MATRIX PART END########################################



#################IO PART BEGIN##########################################
#input:        a string naming a file
#return:    a matrix
#function:    read a floating number table into a matrix
#name and date:    jianxun lu 01/24/12

def table2matrix(inputfile):
    ifile=open(inputfile,"r")
    matrix=[]
    line=ifile.readline()
    while line!='':
        row=[]
        var=''
        for ch in line:
            if ch==' ':
                row.append(float(var))
                var=''
            elif ch=='\n':
                row.append(float(var))
            else:
                var+=ch
        matrix.append(row)
        line=ifile.readline()
    ifile.close()
    return matrix


#input:        a matrix, a string naming a file
#return:    none
#function:    output a file from the input matrix
#name and date:    jianxun lu 01/25/12

def matrix2table(matrix,outputfile):
    ofile=open(outputfile,"w")
    i=0
    while i<len(matrix):
        j=0
        while j<len(matrix[0]):
            ofile.write('%4.2f\t' % matrix[i][j])
            j+=1
        ofile.write('\n')
        i+=1
    ofile.close()


##################IO PART END############################################
    


#########MAIN FUNCTION###################################################
inputfilename='aa.dat'
outputfilename='bb.dat'
initialmatrix=table2matrix(inputfilename)
rmatrix=matrix_correlation(initialmatrix)
matrix2table(rmatrix,outputfilename)
