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
#   - If malloc returns an error,
#     this function terminates the program with error code 26
#   - If you receive an fopen error or eof,
#     this function terminates the program with error code 27
#   - If you receive an fclose error or eof,
#     this function terminates the program with error code 28
#   - If you receive an fread error or eof,
#     this function terminates the program with error code 29
# ==============================================================================
read_matrix:

    # Prologue
    addi sp, sp, -24
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)
    sw s4, 16(sp)
    sw ra, 20(sp)

    add s0, a0, x0 # char * p = filename
    add s1, a1, x0 # int * row = a1
    add s2, a2, x0 # int * col = a2

    # open the file
    li a1, 0
    jal fopen
    li t0, -1
    beq t0, a0, fopen_error

    add s3, a0, x0 # handle = file description
    add a1, s1, x0
    li a2, 4        
    jal fread
    li t0, 4
    bne a0, t0, fread_error

    add a0, s3, x0
    add a1, s2, x0
    li a2, 4
    jal fread
    li t0, 4
    bne a0, t0, fread_error

    lw t0, 0(s1)
    lw t1, 0(s2)
    mul s0, t0, t1
    slli s0, s0, 2
    add a0, s0, x0
    jal malloc
    beqz a0, malloc_error

    add s4, a0, x0 # result array
    add a0, s3, x0
    add a1, s4, x0
    add a2, s0, x0
    jal fread
    bne a0, s0, fread_error

    add a0, s3, x0
    jal fclose
    bne a0, x0, fclose_error

    # Epilogue
    add a0, s4, x0 # store result
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    lw ra, 20(sp)
    addi sp, sp, 24

    jr ra


fopen_error:
    li a0, 27
    j exit

fread_error:
    li a0, 29
    j exit

malloc_error:
    li a0, 26
    j exit

fclose_error:
    li a0, 28
    j exit