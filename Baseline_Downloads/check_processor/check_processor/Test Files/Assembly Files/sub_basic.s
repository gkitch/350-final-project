nop 			# Basic Arithmetic Test with no Hazards
nop 			# Values initialized using addi (positive only) and sub
nop 			# Author: Oliver Rodas
nop
nop
nop 			# Initialize Values
addi $3, $0, 1	# r3 = 1
addi $4, $0, 35	# r4 = 35
addi $1, $0, 3	# r1 = 3
addi $2, $0, 21	# r2 = 21
sub $3, $0, $3	# r3 = -1
sub $4, $0, $4	# r4 = -35