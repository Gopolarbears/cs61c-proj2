.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int vectors
# Arguments:
#   a0 (int*) is the pointer to the start of v0
#   a1 (int*) is the pointer to the start of v1
#   a2 (int)  is the length of the vectors
#   a3 (int)  is the stride of v0
#   a4 (int)  is the stride of v1
# Returns:
#   a0 (int)  is the dot product of v0 and v1
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 75.
# - If the stride of either vector is less than 1,
#   this function terminates the program with error code 76.
# =======================================================
dot:

    # Prologue
    li t0 1
    blt a2 t0 length_lessthan_1
    blt a3 t0 stride_lessthan_1
    blt a4 t0 stride_lessthan_1
    
    li t1 0
    li t5 0
    li t6 4
    mul a3 a3 t6
    mul a4 a4 t6


loop_start:
    bge t1 a2 loop_end
    lw t2 0(a0)
    lw t3 0(a1)
    mul t4 t2 t3
    add t5 t5 t4
    addi t1 t1 1
    add a0 a0 a3
    add a1 a1 a4
    j loop_start


loop_end:
    add a0 t5 x0
    ret

length_lessthan_1:
    li a1 75
    j exit2
    
stride_lessthan_1:
    li a1 76
    j exit2

    # Epilogue

    
