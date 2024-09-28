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
    li t0 1
    li t2 a0
    


loop_start:
    bge t0 a1 loop_end
    lw t1 0(t2)
    addi t2 t2 4
    blt t1 x0 loop_continue






loop_continue:
    addi t1 x0 0
    j loop_start


loop_end:
    

    # Epilogue

    
	ret
