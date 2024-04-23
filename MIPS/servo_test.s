#test demo for servo control with switches:
main:
    #checking if switch 15 is high (pick up pen)
    bne $r6, $r0, penup
    #if $r6 is 0, then we want to make sure pendown default (r15 = 0) [servo angle down]
    addi $r15, $r0, 0

    addi $r28, $r0, 1
    sll $r29, $r28, 26

    j main

penup:
    #setting reg15 to != 0 --> servo angle set to up
    addi $r15, $r0, 1
    j main

