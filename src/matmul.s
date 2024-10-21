.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
# 	d = matmul(m0, m1)
# Arguments:
# 	a0 (int*)  is the pointer to the start of m0 
#	a1 (int)   is the # of rows (height) of m0
#	a2 (int)   is the # of columns (width) of m0
#	a3 (int*)  is the pointer to the start of m1
# 	a4 (int)   is the # of rows (height) of m1
#	a5 (int)   is the # of columns (width) of m1
#	a6 (int*)  is the pointer to the the start of d
# Returns:
#	None (void), sets d = matmul(m0, m1)
# Exceptions:
#   Make sure to check in top to bottom order!
#   - If the dimensions of m0 do not make sense,
#     this function terminates the program with exit code 72.
#   - If the dimensions of m1 do not make sense,
#     this function terminates the program with exit code 73.
#   - If the dimensions of m0 and m1 don't match,
#     this function terminates the program with exit code 74.
# =======================================================
matmul:

    # Error checks
    ble a1 x0 m0_dimensions_error
    ble a2 x0 m0_dimensions_error
    ble a4 x0 m1_dimensions_error
    ble a5 x0 m1_dimensions_error
    bne a2 a4 dimensions_unmatch

    # Prologue 
    addi sp sp -48
    sw s0 0(sp)
    sw s1 4(sp)
    sw s2 8(sp)
    sw s3 12(sp)
    sw s4 16(sp)
    sw s5 20(sp)
    sw s6 24(sp)
    sw s7 28(sp)
    sw s8 32(sp)
    sw s9 36(sp)
    sw s10 40(sp)
    sw ra 44(sp)
    
    add s0 a0 x0
    add s1 a1 x0
    add s2 a2 x0
    add s3 a3 x0
    add s4 a4 x0
    add s5 a5 x0
    add s6 a6 x0
    
    li s7 0
    li s8 0
    addi s9 s3 0
    li t4 4
    mul s10 a2 t4


outer_loop_start:
    bge s7 s1 outer_loop_end
    j inner_loop_start



inner_loop_start:
    bge s8 s5 inner_loop_end
    
    addi a0 s0 0
    addi a1 s9 0
    addi a2 s2 0
    li a3 1
    addi a4 s5 0
    jal dot
    sw a0 0(s6)
    
    addi s8 s8 1
    addi s9 s9 4
    addi s6 s6 4

    j inner_loop_start
   

inner_loop_end:
    li s8 0
    addi s7 s7 1
    add s0 s0 s10
    add s9 s3 x0
    j outer_loop_start
    
    


outer_loop_end:
    

    # Epilogue
    lw s0 0(sp)
    lw s1 4(sp)
    lw s2 8(sp)
    lw s3 12(sp)
    lw s4 16(sp)
    lw s5 20(sp)
    lw s6 24(sp)
    lw s7 28(sp)
    lw s8 32(sp)
    lw s9 36(sp)
    lw s10 40(sp)
    lw ra 44(sp)
    addi sp sp 48
    ret
    
m0_dimensions_error:
    li a1 72
    ecall
    j exit2

m1_dimensions_error:
    li a1 73
    ecall
    j exit2

dimensions_unmatch:
    li a1 74
    ecall
    j exit2