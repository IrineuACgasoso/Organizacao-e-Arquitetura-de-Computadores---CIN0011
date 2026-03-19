//Se (i == j) então:
//    f = g + h
//Senão:
//    f = g - h
//Fim

addi x20, x0, 1    # g = 1
addi x21, x0, 2    # h = 2
addi x22, x0, 16   # i = 16
addi x23, x0, 16   # j = 16 

//Pula para Else se não forem iguais
bne x22, x23, Else

//Se j == i
add x19, x20, x21

jal x0, Exit

Else: //Se j != i
    sub x19, x20, x21

Exit:
    halt


