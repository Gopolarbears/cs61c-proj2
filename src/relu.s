.globl relu

.text
# ==============================================================================
# FUNCTION: Performs an inplace element-wise ReLU on an array of ints
# Arguments:
# 	a0 (int*) is the pointer to the array
#	a1 (int)  is the # of elements in the array
# Returns:
#	None
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 78.
# ==============================================================================
relu:
    # Prologue
    li t0 0
    li t5 1
    mv t2 a0
    blt a1 t5 less_zero
    


loop_start:
    bge t0 a1 loop_end
    lw t1 0(t2)
    addi t0 t0 1
    blt t1 x0 loop_continue
    addi t2 t2 4
    j loop_start






loop_continue:
    addi t1 x0 0
    sw t1 0(t2)
    addi t2 t2 4
    j loop_start
    
less_zero:
    li a1 78
    j exit2


loop_end:
    

    # Epilogue

    
	ret
