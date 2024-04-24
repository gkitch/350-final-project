#Master file which has the ability to read registers $r1-$r4 (button pressed) and control those
#   stepper motors accordingly ($r11-$r14), as well as switches ($r21 - $r23) which starts demos for various art.
#for returning to origin, we utilize $r5 (BTNC), as well as $r20 (SW[0]). The starting position is stored in $r8 (x), $r9 (y)
#   our updated current position (directly accessed in verilog), is held in these same registers
#   we begin our return to the preset origin (established at BTNC), assuming we always move up/left to get there

# KEY: RIGHT --> xDir = 1, DOWN --> yDir = 1

main:
    #checking if switches have been turned on (init. demos)
    bne $r21, $r0, demo_1
    bne $r22, $r0, demo_2 #Square
    bne $r23, $r0, demo_3 #ECE
    bne $r24, $r0, demo_4 #Spiraling square
    #checking if we have pressed any buttons
    bne $r1, $r0, upPressed
    bne $r2, $r0, downPressed
    bne $r3, $r0, leftPressed
    bne $r4, $r0, rightPressed
    #If the buttons are released, it stops
    addi $r11, $r0, 0
    addi $r12, $r0, 0
    addi $r13, $r0, 0
    addi $r14, $r0, 0
    #checking if we've lifted up the pen - needs to be below so button functionality still works
    bne $r6, $r0, pen_up
    #if $r6 is 0, verify that pen is down
    addi $r15, $r0, 0
    j main                      #Infinite loop

pen_up:
    addi $r15, $r0, 1
    j main

#instructions for when buttons are pressed
upPressed:
    addi $r11, $r0, 50000
    addi $r12, $r0, 1
    j main

downPressed:
    addi $r11, $r0, 50000
    addi $r12, $r0, 0
    j main

leftPressed:
    addi $r13, $r0, 50000
    addi $r14, $r0, 0
    j main

rightPressed:
    addi $r13, $r0, 50000 
    addi $r14, $r0, 1
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

demo_3: #ECE Demo
    #Letter E
    #move LEFT
    addi $r13, $r0, 50000
    addi $r14, $r0, 0
    addi $r28, $r0, 1
    sll $r29, $r28, 25
    jal stall
    nop
    nop
    addi $r13, $r0, 0
    addi $r14, $r0, 0
    #move DOWN
    addi $r11, $r0, 50000
    addi $r12, $r0, 0
    addi $r28, $r0, 1
    sll $r29, $r28, 25
    jal stall
    nop
    nop
    addi $r11, $r0, 0
    addi $r12, $r0, 0
    #move RIGHT
    addi $r13, $r0, 50000
    addi $r14, $r0, 1
    addi $r28, $r0, 1
    sll $r29, $r28, 25
    jal stall
    nop
    nop
    addi $r13, $r0, 0
    addi $r14, $r0, 0
    #move LEFT
    addi $r13, $r0, 50000
    addi $r14, $r0, 0
    addi $r28, $r0, 1
    sll $r29, $r28, 25
    jal stall
    nop
    nop
    addi $r13, $r0, 0
    addi $r14, $r0, 0
    #move DOWN
    addi $r11, $r0, 50000
    addi $r12, $r0, 0
    addi $r28, $r0, 1
    sll $r29, $r28, 25
    jal stall
    nop
    nop
    addi $r11, $r0, 0
    addi $r12, $r0, 0
    #move RIGHT
    addi $r13, $r0, 50000
    addi $r14, $r0, 1
    addi $r28, $r0, 1
    sll $r29, $r28, 25
    jal stall
    nop
    nop
    addi $r13, $r0, 0
    addi $r14, $r0, 0
    #move RIGHT
    addi $r13, $r0, 50000
    addi $r14, $r0, 1
    addi $r28, $r0, 1
    sll $r29, $r28, 24
    jal stall
    nop
    nop
    addi $r13, $r0, 0
    addi $r14, $r0, 0

    #Letter C
    #move RIGHT
    addi $r13, $r0, 50000
    addi $r14, $r0, 1
    addi $r28, $r0, 1
    sll $r29, $r28, 25
    jal stall
    nop
    nop
    addi $r13, $r0, 0
    addi $r14, $r0, 0
    #move LEFT
    addi $r13, $r0, 50000
    addi $r14, $r0, 0
    addi $r28, $r0, 1
    sll $r29, $r28, 25
    jal stall
    nop
    nop
    addi $r13, $r0, 0
    addi $r14, $r0, 0
    #move UP
    addi $r11, $r0, 50000
    addi $r12, $r0, 1
    addi $r28, $r0, 1
    sll $r29, $r28, 25
    jal stall
    nop
    nop
    addi $r11, $r0, 0
    addi $r12, $r0, 0
    #move UP
    addi $r11, $r0, 50000
    addi $r12, $r0, 1
    addi $r28, $r0, 1
    sll $r29, $r28, 25
    jal stall
    nop
    nop
    addi $r11, $r0, 0
    addi $r12, $r0, 0
    #move RIGHT
    addi $r13, $r0, 50000
    addi $r14, $r0, 1
    addi $r28, $r0, 1
    sll $r29, $r28, 25
    jal stall
    nop
    nop
    addi $r13, $r0, 0
    addi $r14, $r0, 0
    #move LEFT
    addi $r13, $r0, 50000
    addi $r14, $r0, 0
    addi $r28, $r0, 1
    sll $r29, $r28, 25
    jal stall
    nop
    nop
    addi $r13, $r0, 0
    addi $r14, $r0, 0
    #move DOWN
    addi $r11, $r0, 50000
    addi $r12, $r0, 0
    addi $r28, $r0, 1
    sll $r29, $r28, 25
    jal stall
    nop
    nop
    addi $r11, $r0, 0
    addi $r12, $r0, 0
    #move DOWN
    addi $r11, $r0, 50000
    addi $r12, $r0, 0
    addi $r28, $r0, 1
    sll $r29, $r28, 25
    jal stall
    nop
    nop
    addi $r11, $r0, 0
    addi $r12, $r0, 0
    #move RIGHT
    addi $r13, $r0, 50000
    addi $r14, $r0, 1
    addi $r28, $r0, 1
    sll $r29, $r28, 25
    jal stall
    nop
    nop
    addi $r13, $r0, 0
    addi $r14, $r0, 0
    #move RIGHT
    addi $r13, $r0, 50000
    addi $r14, $r0, 1
    addi $r28, $r0, 1
    sll $r29, $r28, 24
    jal stall
    nop
    nop
    addi $r13, $r0, 0
    addi $r14, $r0, 0

    #Letter E
    #move RIGHT
    addi $r13, $r0, 50000
    addi $r14, $r0, 1
    addi $r28, $r0, 1
    sll $r29, $r28, 25
    jal stall
    nop
    nop
    addi $r13, $r0, 0
    addi $r14, $r0, 0
    #move LEFT
    addi $r13, $r0, 50000
    addi $r14, $r0, 0
    addi $r28, $r0, 1
    sll $r29, $r28, 25
    jal stall
    nop
    nop
    addi $r13, $r0, 0
    addi $r14, $r0, 0
    #move UP
    addi $r11, $r0, 50000
    addi $r12, $r0, 1
    addi $r28, $r0, 1
    sll $r29, $r28, 25
    jal stall
    nop
    nop
    addi $r11, $r0, 0
    addi $r12, $r0, 0
    #move RIGHT
    addi $r13, $r0, 50000
    addi $r14, $r0, 1
    addi $r28, $r0, 1
    sll $r29, $r28, 25
    jal stall
    nop
    nop
    addi $r13, $r0, 0
    addi $r14, $r0, 0
    #move LEFT
    addi $r13, $r0, 50000
    addi $r14, $r0, 0
    addi $r28, $r0, 1
    sll $r29, $r28, 25
    jal stall
    nop
    nop
    addi $r13, $r0, 0
    addi $r14, $r0, 0
    #move UP
    addi $r11, $r0, 50000
    addi $r12, $r0, 1
    addi $r28, $r0, 1
    sll $r29, $r28, 25
    jal stall
    nop
    nop
    addi $r11, $r0, 0
    addi $r12, $r0, 0
    #move RIGHT
    addi $r13, $r0, 50000
    addi $r14, $r0, 1
    addi $r28, $r0, 1
    sll $r29, $r28, 25
    jal stall
    nop
    nop
    addi $r13, $r0, 0
    addi $r14, $r0, 0

    j main

demo_4: #Spiraling square
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
    sll $r29, $r28, 25
    jal stall
    nop
    nop
    addi $r13, $r0, 0
    addi $r14, $r0, 0

    #move UP
    addi $r11, $r0, 50000
    addi $r12, $r0, 1
    addi $r28, $r0, 1
    sll $r29, $r28, 25
    jal stall
    nop
    nop
    addi $r11, $r0, 0
    addi $r12, $r0, 0
    #move RIGHT
    addi $r13, $r0, 50000
    addi $r14, $r0, 0
    addi $r28, $r0, 1
    sll $r29, $r28, 25
    jal stall
    nop
    nop
    addi $r13, $r0, 0
    addi $r14, $r0, 0
    #move DOWN
    addi $r11, $r0, 50000
    addi $r12, $r0, 0
    addi $r28, $r0, 1
    sll $r29, $r28, 25
    jal stall
    nop
    nop
    addi $r11, $r0, 0
    addi $r12, $r0, 0
    #move LEFT
    addi $r13, $r0, 50000
    addi $r14, $r0, 1
    addi $r28, $r0, 1
    sll $r29, $r28, 24
    jal stall
    nop
    nop
    addi $r13, $r0, 0
    addi $r14, $r0, 0

    #move UP
    addi $r11, $r0, 50000
    addi $r12, $r0, 1
    addi $r28, $r0, 1
    sll $r29, $r28, 24
    jal stall
    nop
    nop
    addi $r11, $r0, 0
    addi $r12, $r0, 0
    #move RIGHT
    addi $r13, $r0, 50000
    addi $r14, $r0, 0
    addi $r28, $r0, 1
    sll $r29, $r28, 24
    jal stall
    nop
    nop
    addi $r13, $r0, 0
    addi $r14, $r0, 0
    #move DOWN
    addi $r11, $r0, 50000
    addi $r12, $r0, 0
    addi $r28, $r0, 1
    sll $r29, $r28, 24
    jal stall
    nop
    nop
    addi $r11, $r0, 0
    addi $r12, $r0, 0
    #move LEFT
    addi $r13, $r0, 50000
    addi $r14, $r0, 1
    addi $r28, $r0, 1
    sll $r29, $r28, 23
    jal stall
    nop
    nop
    addi $r13, $r0, 0
    addi $r14, $r0, 0

    #move UP
    addi $r11, $r0, 50000
    addi $r12, $r0, 1
    addi $r28, $r0, 1
    sll $r29, $r28, 23
    jal stall
    nop
    nop
    addi $r11, $r0, 0
    addi $r12, $r0, 0
    #move RIGHT
    addi $r13, $r0, 50000
    addi $r14, $r0, 0
    addi $r28, $r0, 1
    sll $r29, $r28, 23
    jal stall
    nop
    nop
    addi $r13, $r0, 0
    addi $r14, $r0, 0
    #move DOWN
    addi $r11, $r0, 50000
    addi $r12, $r0, 0
    addi $r28, $r0, 1
    sll $r29, $r28, 23
    jal stall
    nop
    nop
    addi $r11, $r0, 0
    addi $r12, $r0, 0
    #move LEFT
    addi $r13, $r0, 50000
    addi $r14, $r0, 1
    addi $r28, $r0, 1
    sll $r29, $r28, 22
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