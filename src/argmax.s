.globl argmax

.text
# =================================================================
# FUNCTION: Given a int vector, return the index of the largest
#	element. If there are multiple, return the one
#	with the smallest index.
# Arguments:
# 	a0 (int*) is the pointer to the start of the vector
#	a1 (int)  is the # of elements in the vector
# Returns:
#	a0 (int)  is the first index of the largest element
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 77.
# =================================================================
argmax:

    # Prologue
    li t0 1
    blt a1 t0 less_one
    lw t1 0(a0)
    li t2 0
    li t4 1 

loop_start:
    bgt t4 a1 loop_end
    lw t3 0(a0)
    addi a0 a0 4
    addi t4 t4 1
    bgt t3 t1 fresh_max
    j loop_start
    
loop_end:
    addi a0 t2 0
    ret

fresh_max:
    addi t1 t3 0
    addi t2 t4 -2
    j loop_start

less_one:
    li a1 77
    j exit2
    
    # Epilogue
