.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
#   d = matmul(m0, m1)
# Arguments:
#   a0 (int*)  is the pointer to the start of m0
#   a1 (int)   is the # of rows (height) of m0
#   a2 (int)   is the # of columns (width) of m0
#   a3 (int*)  is the pointer to the start of m1
#   a4 (int)   is the # of rows (height) of m1
#   a5 (int)   is the # of columns (width) of m1
#   a6 (int*)  is the pointer to the the start of d
# Returns:
#   None (void), sets d = matmul(m0, m1)
# Exceptions:
#   Make sure to check in top to bottom order!
#   - If the dimensions of m0 do not make sense,
#     this function terminates the program with exit code 38
#   - If the dimensions of m1 do not make sense,
#     this function terminates the program with exit code 38
#   - If the dimensions of m0 and m1 don't match,
#     this function terminates the program with exit code 38
# =======================================================
matmul:

    # Error checks
    bne a2, a4, Error
    li t0, 1
    blt a1, t0, Error
    blt a2, t0, Error
    blt a4, t0, Error
    blt a5, t0, Error

    # Prologue
    addi sp, sp, -36
    sw s0, 0(sp) # arr1
    sw s1, 4(sp) # arr2
    sw s2, 8(sp) # result array
    sw ra, 12(sp) 
    sw s3, 16(sp) # index i
    sw s4, 20(sp) # index j
    sw s5, 24(sp) # row of arr1
    sw s6, 28(sp) # col of arr1
    sw s7, 32(sp) # col of arr2
    add s0, a0, x0
    add s1, a3, x0
    add s2, a6, x0
    li s3, 0
    li s4, 0 
    add s5, a1, x0
    add s6, a2, x0
    add s7, a5, x0

outer_loop_start:
    beq s3, s5, outer_loop_end
    add t2, s1, x0  # *p = new_array2_begin

inner_loop_start:
    beq s4, s7, inner_loop_end
    
    add a0, s0, x0
    add a1, t2, x0
    add a2, s6, x0
    li a3, 1
    add a4, s7, x0
    
    jal ra, dot
    add t0, a0, x0 # dot product result
    sw t0, 0(s2) 
    addi s2, s2, 4 # arr2++

    addi s4, s4, 1 # j = j + 1
    slli t1, s4, 2 # t1 = j * 4
    add t2, t1, s1 # t2 = arr2 + j
    jal x0, inner_loop_start

inner_loop_end:
    add s4, x0, x0 # j = 0
    addi s3, s3, 1 # i++
    slli t0, s6, 2 # t0 = col1 * 4
    add s0, s0, t0 # p++ repeat 7 times
    jal x0, outer_loop_start

outer_loop_end:

    # Epilogue
    lw s0, 0(sp) # arr1
    lw s1, 4(sp) # arr2
    lw s2, 8(sp) # result array
    lw ra, 12(sp) 
    lw s3, 16(sp) # index i
    lw s4, 20(sp) # index j
    lw s5, 24(sp) # row of arr1
    lw s6, 28(sp) # col of arr1
    lw s7, 32(sp) # col of arr2
    addi sp, sp, 36

    jr ra

Error:
    li a0, 38
    j exit