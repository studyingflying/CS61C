.globl classify

.text
# =====================================
# COMMAND LINE ARGUMENTS
# =====================================
# Args:
#   a0 (int)        argc
#   a1 (char**)     argv
#   a1[1] (char*)   pointer to the filepath string of m0
#   a1[2] (char*)   pointer to the filepath string of m1
#   a1[3] (char*)   pointer to the filepath string of input matrix
#   a1[4] (char*)   pointer to the filepath string of output file
#   a2 (int)        silent mode, if this is 1, you should not print
#                   anything. Otherwise, you should print the
#                   classification and a newline.
# Returns:
#   a0 (int)        Classification
# Exceptions:
#   - If there are an incorrect number of command line args,
#     this function terminates the program with exit code 31
#   - If malloc fails, this function terminates the program with exit code 26
#
# Usage:
#   main.s <M0_PATH> <M1_PATH> <INPUT_PATH> <OUTPUT_PATH>
classify:
    addi sp, sp, -60
    sw s0, 0(sp) # argv pointer
    sw s1, 4(sp) # index
    sw s2, 8(sp) # silent mode
    sw s3, 12(sp) # m0 pointer
    sw s4, 16(sp) # m1 pointer
    sw s5, 20(sp) # input pointer
    sw s6, 24(sp) # h
    sw s7, 28(sp) # o
    sw ra, 32(sp)

    li t0, 5
    bne a0, t0, error_args
    add s0, a1, x0 # argv pointer
    add s1, x0, x0 # index
    add s2, a2, x0 # silent mode
    
    # Read pretrained m0
    lw a0, 4(s0)
    addi a1, sp, 36 
    addi a2, sp, 40
    jal read_matrix
    add s3, a0, x0 # m0 pointer

    # Read pretrained m1
    lw a0, 8(s0)
    addi a1, sp, 44
    addi a2, sp, 48
    jal read_matrix
    add s4, a0, x0 # m1 pointer

    # Read input matrix
    lw a0, 12(s0)
    addi a1, sp, 52
    addi a2, sp, 56
    jal read_matrix
    add s5, a0, x0 # input pointer

    # Compute h = matmul(m0, input)
    lw t0, 36(sp) # row of m0
    lw t1, 56(sp) # col of input
    mul t2, t0, t1
    slli a0, t2, 2
    jal malloc
    beqz a0, error_malloc
    add s6, a0, x0 # h

    add a0, s3, x0
    lw a1, 36(sp)
    lw a2, 40(sp)
    add a3, s5, x0
    lw a4, 52(sp)
    lw a5, 56(sp)
    add a6, s6, x0
    jal matmul

    # Compute h = relu(h)
    add a0, s6, x0
    lw t0, 36(sp)
    lw t1, 56(sp)
    mul a1, t0, t1
    jal relu

    # Compute o = matmul(m1, h)
    lw t0, 44(sp)
    lw t1, 56(sp)
    mul t2, t0, t1
    slli a0, t2, 2
    jal malloc
    beqz a0, error_malloc
    add s7, a0, x0

    add a0, s4, x0
    lw a1, 44(sp)
    lw a2, 48(sp)
    add a3, s6, x0
    lw a4, 36(sp)
    lw a5, 56(sp)
    add a6, s7, x0
    jal matmul

    # Write output matrix o
    lw a0, 16(s0)
    add a1, s7, x0
    lw a2, 44(sp)
    lw a3, 56(sp)
    jal write_matrix

    # Compute and return argmax(o)
    add a0, s7, x0
    lw t0, 44(sp)
    lw t1, 56(sp)
    mul a1, t0, t1
    jal argmax
    add s1, a0, x0 # return value

    # If enabled, print argmax(o) and newline
    bne s2, x0, end_classify
    jal print_int
    li a0, '\n'
    jal print_char

end_classify:
    # free heap memory
    add a0, s6, x0
    jal free
    add a0, s7, x0
    jal free

    add a0, s1, x0 # store return value

    # Epilogue
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    lw s5, 20(sp)
    lw s6, 24(sp)
    lw s7, 28(sp)
    lw ra, 32(sp)
    addi sp, sp, 60

    jr ra

error_malloc:
    li a0, 26
    j exit

error_args:
    li a0, 31
    j exit