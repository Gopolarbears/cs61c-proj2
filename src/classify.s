.globl classify

.text
classify:
    # =====================================
    # COMMAND LINE ARGUMENTS
    # =====================================
    # Args:
    #   a0 (int)    argc
    #   a1 (char**) argv
    #   a2 (int)    print_classification, if this is zero, 
    #               you should print the classification. Otherwise,
    #               this function should not print ANYTHING.
    # Returns:
    #   a0 (int)    Classification
    # Exceptions:
    # - If there are an incorrect number of command line args,
    #   this function terminates the program with exit code 89.
    # - If malloc fails, this function terminats the program with exit code 88.
    #
    # Usage:
    #   main.s <M0_PATH> <M1_PATH> <INPUT_PATH> <OUTPUT_PATH>
    li t0 5
    bne a0 t0 incorrect_command_args
    
    addi sp sp -52
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
    sw s11 44(sp)
    sw ra 48(sp)
    



	# =====================================
    # LOAD MATRICES
    # =====================================
    lw s0 4(a1)
    lw s1 8(a1)
    lw s2 12(a1)
    lw s3 16(a1)
    mv s11 a2





    # Load pretrained m0
    li a0 4
    jal malloc
    ble a0 x0 malloc_fail
    mv s4 a0
    li a0 4
    jal malloc
    ble a0 x0 malloc_fail
    mv s5 a0
    
    mv a0 s0 
    mv a1 s4
    mv a2 s5
    jal read_matrix
    mv s0 a0


    # Load pretrained m1
    li a0 4
    jal malloc
    ble a0 x0 malloc_fail
    mv s6 a0
    li a0 4
    jal malloc
    ble a0 x0 malloc_fail
    mv s7 a0
    
    mv a0 s1
    mv a1 s6
    mv a2 s7
    jal read_matrix
    mv s1 a0



    # Load input matrix
    li a0 4
    jal malloc
    ble a0 x0 malloc_fail
    mv s8 a0
    li a0 4
    jal malloc
    ble a0 x0 malloc_fail
    mv s9 a0
    
    mv a0 s2
    mv a1 s8
    mv a2 s9
    jal read_matrix
    mv s2 a0
    


    # =====================================
    # RUN LAYERS
    # =====================================
    # 1. LINEAR LAYER:    m0 * input
    # 2. NONLINEAR LAYER: ReLU(m0 * input)
    # 3. LINEAR LAYER:    m1 * ReLU(m0 * input)
    lw t0 0(s4)
    lw t1 0(s9)
    mul a0 t0 t1
    slli a0, a0, 2
    jal malloc
    ble a0 x0 malloc_fail
    mv s10 a0
    
    mv a0 s0
    lw a1 0(s4)
    lw a2 0(s5)
    mv a3 s2
    lw a4 0(s8)
    lw a5 0(s9)
    mv a6 s10
    jal matmul

    lw t0 0(s4)
    lw t1 0(s9)
    mul t2 t0 t1
    mv a0 s10
    mv a1 t2
    jal relu
    
    mv a0 s5
    jal free
    mv s5 s11
    
    mul a0 s6 s9
    slli a0, a0, 2
    jal malloc
    ble a0 x0 malloc_fail
    mv s11 a0
    

    mv a0 s1
    lw a1 0(s6)
    lw a2 0(s7)
    mv a3 s10
    lw a4 0(s4)
    lw a5 0(s9)
    mv a6 s11
    jal matmul  


    # =====================================
    # WRITE OUTPUT
    # =====================================
    # Write output matrix
    mv a0 s3
    mv a1 s11
    lw a2 0(s6)
    lw a3 0(s9)
    jal write_matrix
    


    # =====================================
    # CALCULATE CLASSIFICATION/LABEL
    # =====================================
    # Call argmax
    mv a0 s11
    lw t0 0(s6)
    lw t1 0(s9)
    mul t2 t0 t1
    mv a1 t2
    jal argmax


    # Print classification
    beq s5 x0 print
    
Done:
    mv a0 s0
    jal free
    mv a0 s1
    jal free
    mv a0 s2
    jal free
    mv a0 s4
    jal free
    mv a0 s6
    jal free
    mv a0 s7
    jal free
    mv a0 s8
    jal free
    mv a0 s9
    jal free
    mv a0 s10
    jal free
    mv a0 s11
    jal free
    
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
    lw s11 44(sp)
    lw ra 48(sp)
    addi sp sp 52

    ret
    
incorrect_command_args:
    li a1 89
    jal exit2
    
malloc_fail:
    li a1 88
    jal exit2

print:
    
    mv a1 a0
    jal print_int


    # Print newline afterwards for clarity
    li a1 '\n'
    jal print_char
    
    jal Done