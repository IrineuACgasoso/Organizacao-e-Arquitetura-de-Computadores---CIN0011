//int a = 6;
//int b = 15;
//int m = 0;
//
//Se (b < m) então:
//    m = a + b;
//Senão:
//    m = a - b;
//Fim

lw x10, a
lw x11, b
lw x12, m
// Brach se b < m
blt x11, x12, m_maior
// Caso contrário, subtrai a - b
sub x12, x10, x11
jal x0, fim

m_maior:
	add x12, x10, x11

fim:
	halt

a: .word 0x6
b: .word 0x15
m: .word 0x0000


