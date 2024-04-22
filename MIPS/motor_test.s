#This file tests the basic motor functions

main:
    nop
    nop
    addi $r9, $r0, 50
    nop
    nop
    bne $r1, $r0, upPressed
    nop
    nop
    bne $r2, $r0, downPressed
    nop
    nop
    bne $r3, $r0, leftPressed
    nop
    nop
    bne $r4, $r0, rightPressed
    nop
    nop

    #If the buttons are released, it stops
    addi $r11, $r0, 0
    addi $r12, $r0, 0
    addi $r13, $r0, 0
    addi $r14, $r0, 0

    j main                      #Infinite loop

upPressed:
    nop
    nop
    addi $r11, $r0, 50000
    addi $r12, $r0, 1
    
    j main

downPressed:
    nop
    nop
    addi $r11, $r0, 50000
    addi $r12, $r0, 0
    
    j main

leftPressed:
    nop
    nop
    addi $r13, $r0, 50000
    addi $r14, $r0, 0
    
    j main

rightPressed:
    nop
    nop
    addi $r13, $r0, 50000 
    addi $r14, $r0, 1
    
    j main
