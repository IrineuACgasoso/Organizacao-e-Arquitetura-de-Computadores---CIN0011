
    addi x11, x0, 2      
    sb   x11, 1029(x0)   

loop:
    lb   x10, 1026(x0)  
    andi x10, x10, 0x1  
    beq  x10, x0, loop   

    # BOTÃO FOI APERTADO!
    slli x11, x11, 1     
    sb   x11, 1029(x0)  

    # CONDIÇÃO DE PARADA
    addi x12, x0, 128
    beq  x11, x12, fim

espera_soltar:
    lb   x10, 1026(x0)
    andi x10, x10, 0x1
    bne  x10, x0, espera_soltar

    jal  x0, loop

fim:
    jal  x0, fim
