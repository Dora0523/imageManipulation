#Student ID = 1234567
############################ Q1: file-io########################
.data
			.align 2
inputTest1:             .asciiz "test1.txt"   
#inputTest1:             .asciiz "test.txt"   

			.align 2
inputTest2:		.asciiz "test2.txt"
			.align 2
outputFile:		.asciiz "copy.pgm"
			.align 2
buffer:			.space 1024
space: .asciiz  " "


toWrite:                .asciiz "P2\n24 7\n15\n"

errormsg:                  .asciiz "Error occured"
bin:   .byte 
.text
.globl fileio

fileio:


	la $a0,inputTest1
	#la $a0,inputTest2
	jal read_file
	
	la $a0,outputFile
	jal write_file
	
	li $v0,10		# exit...
	syscall	
		

	
read_file:
	# $a0 -> input filename	
	# Opens file
	# read file into buffer
	# return
	# Add code here
	
	#### 
	#open file
	li $v0,13
	addi $a0,$a0,0 # $a0 = inputTest
	li $a1,0 # read only 
	syscall
	
	beq $v0,-1,error # opening Error

	move $s0,$v0  # $s0 = returned file descriptor
	
	#read from file
	li $v0,14
	move $a0,$s0 # $a0= file descriptor
	la $a1,buffer # $a1 = buffer
	li $a2,1024 #length of buffer
	syscall
	
	#print content to screen
        li  $v0, 4          
        la  $a0, buffer     
        syscall            
	
	#close file
	li $v0,16
	move $a0,$s0 # $a0 = file descriptor
	syscall
	
	beq $v0,-1,error # closing Error
	
	jr $ra
	
	error:
	li $v0,4 
	la $a0,errormsg 
	syscall


	jr $ra
	
write_file:
	# $a0 -> outputFilename
	# open file for writing
	# write following contents:
	# P2
	# 24 7
	# 15
	# write out contents read into buffer
	# close file
	# Add  code here
	
	#####
	# open copy.pgm
	li $v0,13
	addi $a0,$a0,0 # $a0 = copy.pgm
	li $a1,1 # write only
	syscall
	
        beq $v0,-1,error2 # opening Error
	
	move $s0,$v0  # $s0 = returned file descriptor
	
	# write into copy.pgm
	
	 # PGM header
	li $v0, 15
	move $a0, $s0  # $a0 = file descriptor
        la $a1, toWrite
        la $a2, 11
        syscall
        
        
         # buffer 
        li   $v0, 15  
        move $a0, $s0      # file descriptor 
        la   $a1, buffer
        li   $a2, 1024     #buffer length
        syscall
                    
	# close file
	 li $v0, 16  
	 move $a0,$s0 # $a0 = file descriptor
         syscall
         
         beq $v0,-1,error2 # closing Error
	
	 jr $ra
		  	  
        error2:
	li $v0,4 
	la $a0,errormsg 
	syscall

	jr $ra

