lw x10, v1
lw x11, v2
add x12, x10, x11
sw x12, v3
halt

v1: .word 0x5
v2: .word 0x10
v3: .word 0x0000

//v3: ['15', '00', '00', '00']
 
//////////////////////////////////////////

lw x10, v1
lw x11, v2
add x12, x10, x11
sw x12, v3
halt

v1: .word 0x14
v2: .word 0x7
v3: .word 0x0000


//v3: ['1b', '00', '00', '00']

//////////////////////////////////////////

lw x10, v1
lw x11, v2
add x12, x10, x11
sw x12, v3
halt

v1: .word 0x25
v2: .word 0x12
v3: .word 0x0000

//v3: ['37', '00', '00', '00']




