#This file tests the basic motor functions

main:
    #checking if switches have been turned on (init. demos)
    bne $r20, $r0, return_to_x_origin
    bne $r21, $r0, demo_1
    bne $r22, $r0, demo_2
    #checking if we have pressed any buttons
    bne $r1, $r0, upPressed
    bne $r2, $r0, downPressed
    bne $r3, $r0, leftPressed
    bne $r4, $r0, rightPressed
    bne $r5, $r0, set_origin
    #If the buttons are released, it stops
    addi $r11, $r0, 0
    addi $r12, $r0, 0
    addi $r13, $r0, 0
    addi $r14, $r0, 0
    j main                      #Infinite loop

#instructions for when buttons are pressed
upPressed:
    addi $r11, $r0, 50000
    addi $r12, $r0, 1
    #added to return to origin
    addi $r15, $r0, 1
    sub $r9, $r9, $r15
    j main

downPressed:
    addi $r11, $r0, 50000
    addi $r12, $r0, 0
    #added to return to origin
    addi $r9, $r9, 1
    j main

leftPressed:
    addi $r13, $r0, 50000
    addi $r14, $r0, 0
    #added to return to origin
    addi $r15, $r0, 1
    sub $r8, $r8, $r15
    j main

rightPressed:
    addi $r13, $r0, 50000 
    addi $r14, $r0, 1
    #added to return to origin
    addi $r8, $r8, 1
    j main

set_origin:
    #r8 represents x coordinates, r9 represents y coordinates
    addi $r8, $r0, 0
    addi $r9, $r0, 0
    j main

#to return to origin, know we want to move up and left
return_to_x_origin:
    #move up until we reach our starting x point
    addi $r7, $r7, 1
    addi $r11, $r0, 50000
    addi $r12, $r0, 1
    bne $r7, $r8, return_to_x_origin
    addi $r11, $r0, 0
    addi $r12, $r0, 0
    addi $r7, $r0, 0
    addi $r8, $r0, 0
    j return_to_y_origin

return_to_y_origin:
    #move left until we reach our starting y point
    addi $r7, $r7, 1
    addi $r13, $r0, 50000
    addi $r14, $r0, 0
    bne $r7, $r9, return_to_y_origin
    addi $r13, $r0, 0
    addi $r14, $r0, 0
    addi $r7, $r0, 0
    addi $r9, $r0, 0
    j main

#demos start here
demo_1:
    #we want to move diagonally for once delay cycle
    addi $r11, $r0, 50000
    addi $r12, $r0, 1
    addi $r13, $r0, 50000
    addi $r14, $r0, 1

    addi $r28, $r0, 1
    sll $r29, $r28, 26

    jal stall
    nop
    nop
    j main

demo_2:
    #move UP
    addi $r11, $r0, 50000
    addi $r12, $r0, 1
    addi $r28, $r0, 1
    sll $r29, $r28, 26
    jal stall
    nop
    nop
    addi $r11, $r0, 0
    addi $r12, $r0, 0
    #move RIGHT
    addi $r13, $r0, 50000
    addi $r14, $r0, 0
    addi $r28, $r0, 1
    sll $r29, $r28, 26
    jal stall
    nop
    nop
    addi $r13, $r0, 0
    addi $r14, $r0, 0
    #move DOWN
    addi $r11, $r0, 50000
    addi $r12, $r0, 0
    addi $r28, $r0, 1
    sll $r29, $r28, 26
    jal stall
    nop
    nop
    addi $r11, $r0, 0
    addi $r12, $r0, 0
    #move LEFT
    addi $r13, $r0, 50000
    addi $r14, $r0, 1
    addi $r28, $r0, 1
    sll $r29, $r28, 26
    jal stall
    nop
    nop
    addi $r13, $r0, 0
    addi $r14, $r0, 0

    j main

stall:
    addi $r28, $r28, 1
    bne $r28, $r29, stall
    jr $r31

stall:
    addi $r28, $r28, 1
    bne $r28, $r29, stall
    jr $r31



