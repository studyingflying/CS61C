.globl relu

.text
# ==============================================================================
# FUNCTION: Performs an inplace element-wise ReLU on an array of ints
# Arguments:
#   a0 (int*) is the pointer to the array
#   a1 (int)  is the # of elements in the array
# Returns:
#   None
# Exceptions:
#   - If the length of the array is less than 1,
#     this function terminates the program with error code 36
# ==============================================================================
relu:
    # Prologue
    add t0, a0, x0
    add t1, x0, x0
    addi t5, x0, 1
    blt a1, t5, loop_end 
loop_start:
    beq t1, a1, normal
    slli t3, t1, 2 
    add t2, t0, t3
    lw t4, 0(t2)
    addi t1, t1, 1
    blt x0, t4, loop_continue
    sw x0, 0(t2)

loop_continue:
    jal x0, loop_start

loop_end: 
    li a0, 36
    j exit
    # Epilogue
normal:
    jr ra
