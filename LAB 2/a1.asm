lw x10, v1
lw x11, v2
lw x12, v3
blt x11, x10, v1_maior
bge x11, x10, fim 

v1_maior:
	add x12, x10, x11
	sw x12, v3

fim:
	halt

v1: .word 0x6
v2: .word 0x15
v3: .word 0x0000


//v3: ['00', '00', '00', '00']

////////////////////////////////////

lw x10, v1
lw x11, v2
lw x12, v3
blt x11, x10, v1_maior
bge x11, x10, fim 

v1_maior:
	add x12, x10, x11
	sw x12, v3

fim:
	halt

v1: .word 0x14
v2: .word 0x7
v3: .word 0x0000


//v3: ['1b', '00', '00', '00']

////////////////////////////////////


lw x10, v1
lw x11, v2
lw x12, v3
blt x11, x10, v1_maior
bge x11, x10, fim 

v1_maior:
	add x12, x10, x11
	sw x12, v3

fim:
	halt

v1: .word 0x25
v2: .word 0x12
v3: .word 0x0000


//v3: ['37', '00', '00', '00']






