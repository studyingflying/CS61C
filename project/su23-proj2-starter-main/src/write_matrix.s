.globl write_matrix

.text
# ==============================================================================
# FUNCTION: Writes a matrix of integers into a binary file
# FILE FORMAT:
#   The first 8 bytes of the file will be two 4 byte ints representing the
#   numbers of rows and columns respectively. Every 4 bytes thereafter is an
#   element of the matrix in row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is the pointer to the start of the matrix in memory
#   a2 (int)   is the number of rows in the matrix
#   a3 (int)   is the number of columns in the matrix
# Returns:
#   None
# Exceptions:
#   - If you receive an fopen error or eof,
#     this function terminates the program with error code 27
#   - If you receive an fclose error or eof,
#     this function terminates the program with error code 28
#   - If you receive an fwrite error or eof,
#     this function terminates the program with error code 30
# ==============================================================================
write_matrix:

    # Prologue
    addi sp, sp, -32
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)
    sw s4, 16(sp)
    sw ra, 20(sp)

    add s0, a0, x0
    add s1, a1, x0
    add s2, a2, x0
    add s3, a3, x0

    add a0, s0, x0
    li a1, 1
    jal fopen
    li t0, -1
    beq a0, t0, error_fopen
    add s4, a0, x0

    sw s2, 24(sp)
    sw s3, 28(sp)
    addi a1, sp, 24 
    li a2, 1
    li a3, 4
    jal fwrite
    li t0, 1
    bne a0, t0, error_fwrite

    add a0, s4, x0
    addi a1, sp, 28
    li a2, 1
    li a3, 4
    jal fwrite
    li t0, 1
    bne a0, t0, error_fwrite

    mul s0, s3, s2
    add a0, s4, x0
    add a1, s1, x0
    add a2, s0, x0
    li a3, 4
    jal fwrite
    bne s0, a0, error_fwrite

    add a0, s4, x0
    jal fclose
    bne a0, x0, error_fclose

    # Epilogue
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    lw ra, 20(sp)
    addi sp, sp, 32

    jr ra

error_fopen:
    li a0, 27
    j exit

error_fwrite:
    li a0, 30
    j exit

error_fclose:
    li a0, 28
    j exit