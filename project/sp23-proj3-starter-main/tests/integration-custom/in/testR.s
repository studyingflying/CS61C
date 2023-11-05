addi t0, x0, 1  # t0 = 1
add t1, t0, t0  # t1 = 2
sub s0, t1, t0  # s0 = t1 - t0 = 1 
and t2, t0, s0  # t2 = t0 & s0 = 1
or s1, x0, t1   # s1 = 0 & t1 = 1
xor a0, t0, t1  # a0 = t1 xor t0 = 3 
sll t2, t0, t1  # t2 = t0 << t1 = 4
srl s0, t2, t0  # s0 = t2 >> t0 = 2 
addi ra, x0, -1 # ra = -1
sra s0, ra, t1  # s0 = ra >> t1 = -1 
slt t0, a0, t2  # t0 = 1
mul s1, t1, t1  # s1 = t1 * t1 = 4
mulh s1, ra, ra # s1 = ra * ra = 1
mulhu s2, ra, ra  # s2 = ra * ra = (2^32 - 1)** 2 
