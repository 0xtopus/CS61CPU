addi s0, x0, 100
addi t0, x0, 50

sw t0, 100(s0)
sw t0, -10(s0)

addi s1, x0, 1
lw a0, 100(s0)
lw t1, -10(s0)
