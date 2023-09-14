.globl abs

.text
# =================================================================
# FUNCTION: Given an int return its absolute value.
# Arguments:
#   a0 (int*) is a pointer to the input integer
# Returns:
#   None
# =================================================================
abs:
    # Prologue

    # PASTE HERE
    lw t0 0(a0)
    bgt t0, zero, done

    sub t0, x0, t0
    # Epilogue
    sw t0 0(a0)
    
done:
    jr ra 