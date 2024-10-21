.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#
# FILE FORMAT:
#   The first 8 bytes are two 4 byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is a pointer to an integer, we will set it to the number of rows
#   a2 (int*)  is a pointer to an integer, we will set it to the number of columns
# Returns:
#   a0 (int*)  is the pointer to the matrix in memory
# Exceptions:
# - If malloc returns an error,
#   this function terminates the program with error code 88.
# - If you receive an fopen error or eof, 
#   this function terminates the program with error code 90.
# - If you receive an fread error or eof,
#   this function terminates the program with error code 91.
# - If you receive an fclose error or eof,
#   this function terminates the program with error code 92.
# ==============================================================================
read_matrix:

    # Prologue
    addi sp sp -40
    sw s0 0(sp)
    sw s1 4(sp)
    sw s2 8(sp)
    sw s3 12(sp)
    sw s4 16(sp)
    sw s5 20(sp)
    sw s6 24(sp)
    sw s7 28(sp)
    sw s8 32(sp)
    sw ra 36(sp)
    
    add s0 a0 x0
    add s1 a1 x0
    add s2 a2 x0
    
    add a1 s0 x0
    li a2 0
    jal fopen
    blt a0 x0 fopen_error
    add s3 a0 x0
    
    li s4 4
    
    add a1 s3 x0
    add a2 s1 x0
    add a3 s4 x0
    jal fread
    blt a0 x0 fread_error
    
    add a1 s3 x0
    add a2 s2 x0
    add a3 s4 x0
    jal fread
    blt a0 x0 fread_error
    
    lw t0 0(s1)
    lw t1 0(s2)
    mul t2 t0 t1
    mul t3 t2 s4
    add s7 t3 x0

    
    add a0 s7 x0
    jal malloc
    ble a0 x0 malloc_error
    add s8 a0 x0
    add a1 s3 x0
    add a2 s8 x0
    add a3 s7 x0
    jal fread
    blt a0 x0 fread_error
    
    
    add a1 s3 x0
    jal fclose
    li t3 -1
    beq a0 t3 fclose_error
    
    add a0 s8 x0
    
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
    lw ra 36(sp)
    addi sp sp 40

    ret

malloc_error:
    li a1 88
    jal exit2
    
fopen_error:
    li a1 90
    jal exit2
    
fread_error:
    li a1 91
    jal exit2
    
fclose_error:
    li a1 92
    jal exit2
    