//Se (i == j) então:
//    f = g + h
//Senão:
//    f = g - h
//Fim

addi x20, x0, 3   
addi x21, x0, 2   
addi x22, x0, 16  
addi x23, x0, 16  

bne x22, x23, Else

add x19, x20, x21

jal x0, Exit

Else: 
    sub x19, x20, x21

Exit:
    halt





