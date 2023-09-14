.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int arrays
# Arguments:
#   a0 (int*) is the pointer to the start of arr0
#   a1 (int*) is the pointer to the start of arr1
#   a2 (int)  is the number of elements to use
#   a3 (int)  is the stride of arr0
#   a4 (int)  is the stride of arr1
# Returns:
#   a0 (int)  is the dot product of arr0 and arr1
# Exceptions:
#   - If the number of elements to use is less than 1,
#     this function terminates the program with error code 36
#   - If the stride of either array is less than 1,
#     this function terminates the program with error code 37
# =======================================================
dot:
    addi t0, x0, 1
    blt a2, t0, Exception1
    blt a3, t0, Exception2
    blt a4, t0, Exception2
    addi sp, sp, -20

    # Prologue
    sw s0, 0(sp) # temp1
    sw s1, 4(sp) # temp2
    sw s2, 8(sp) # i
    sw s3, 12(sp) 
    sw ra, 16(sp)

    add t0, a0, x0 # array1
    add t1, a1, x0 # array2
    add t2, x0, x0 # index1
    add t3, x0, x0 # index2
    add t4, x0, x0 # result
    add s2, x0, x0
    add s3, x0, x0

loop_start:
    beq s2, a2, loop_end
    slli t5, t2, 2 
    slli t6, t3, 2
    add t0, a0, t5
    add t1, a1, t6
    lw s0, 0(t0)
    lw s1, 0(t1)

    mul s3, s1, s0
    add t4, t4, s3

    add t2, t2, a3
    add t3, t3, a4
    addi s2, s2, 1
    jal x0, loop_start

loop_end:
    # Epilogue
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw ra, 16(sp)
    addi sp, sp, 20
    add a0, t4, x0

    jr ra

Exception1:
    li a0, 36
    j exit

Exception2:
    li a0, 37
    j exit

