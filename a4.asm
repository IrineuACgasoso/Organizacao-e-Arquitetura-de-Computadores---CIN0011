addi x11, x0, 32
    addi x12, x0, 1024

loop:
    lb   x10, 0(x11)
    beq  x10, x0, fim
    sb   x10, 0(x12)
    
    addi x11, x11, 1
    
    jal  x0, loop

fim:
    halt

str1: .string "Hello World"