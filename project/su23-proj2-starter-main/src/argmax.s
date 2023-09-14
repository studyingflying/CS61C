.globl argmax

.text
# =================================================================
# FUNCTION: Given a int array, return the index of the largest
#   element. If there are multiple, return the one
#   with the smallest index.
# Arguments:
#   a0 (int*) is the pointer to the start of the array
#   a1 (int)  is the # of elements in the array
# Returns:
#   a0 (int)  is the first index of the largest element
# Exceptions:
#   - If the length of the array is less than 1,
#     this function terminates the program with error code 36
# =================================================================
argmax:
    # Prologue
    add t0, a0, x0
    add t1, a1, x0
    addi t2, x0, 1
    blt t1, t2, Exceptions    
    add t3, x0, x0
    lw t4, 0(a0)
    add t2, x0, x0 
loop_start:
    beq t3, t1, loop_end
    lw t5, 0(t0)
    addi t0, t0, 4
    blt t4, t5, loop_continue
    addi t3, t3, 1
    jal x0, loop_start

loop_continue:
    add t4, t5, x0
    add t2, t3, x0
    addi t3, t3, 1
    jal x0, loop_start

loop_end:
    # Epilogue
    add a0, t2, x0
    jr ra

Exceptions:
    li a0 36
    j exit