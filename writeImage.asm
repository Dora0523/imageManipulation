# Student ID = 1234567
####################################write Image#####################
.data

buffer:                         .space 1024


headerP5:              .ascii "P5\n"
headerP2:              .ascii "P2\n"


space:                  .asciiz " "
newline:                .asciiz "\n"
null:                   .asciiz "\0"

.text
.globl write_image
write_image:
	# $a0 -> image struct
	# $a1 -> output filename
	# $a2 -> type (0 -> P5, 1->P2)
	################# returns #################
	# void
	# Add code here.
	
	
	## save s registers to stack##
	 addi  $sp, $sp, -36          # allocate memory in stack to strore 4 bytes
         sw    $ra, 32($sp)          
         sw    $s0, 28($sp)          
         sw    $s1, 24($sp)           
         sw    $s2, 20($sp)      
         sw    $s3, 16($sp)         
         sw    $s4, 12($sp)           
         sw    $s5, 8($sp)          
         sw    $s6, 4($sp)           
         sw    $s7, 0($sp)    
	#############################
	# get info
	########################
	## $ s0 = file ptr    ##
        ## $ s1 = width       ##
        ## $ s2 = height      ##
        ## $ s3 = max_value   ##
        ## $ s4 = content arr ##
        ## $ s6 = output file ##
        ########################
        move $s6,$a1
        la $s1 0($a0) 
        la $s2 4($a0)
        la $s3 8($a0)  
        la $s4 12($a0) # addresses of width,height,max value,contents

       
        # open file
	li $v0,13
	move $a0,$s6 # output file name
	li $a1,1 # write only
	syscall
	move $s0,$v0  # $s0 = returned file descriptor

	beq $a2,0,P5  # if type = 0, ==> P5

#################################### p 2 #######################################
	P2:
	### write into file###
	#p2
	li $v0, 15
	move $a0, $s0  # $a0 = file descriptor
	la $a1,headerP2
	la $a2,3 #header length
        syscall
        
        #width
	lw $a0,0($s1)
	jal itoa
	move $t0,$v0 # => address of int ascii
	move $t1,$v1 # ==> address length
	
	li $v0, 15
	move $a0, $s0  # $a0 = file descriptor
	move $a1,$t0
	move $a2,$t2
        syscall
        
        li $v0,15
	move $a0, $s0  # $a0 = file descriptor
        la $a1,space
        li $a2,1
        syscall
        
        #height
        lw $a0,0($s2)
	jal itoa
	move $t0,$v0 # => address of int ascii
	move $t1,$v1 # ==> address length
	
	li $v0, 15
	move $a0, $s0  # $a0 = file descriptor
	move $a1,$t0
	move $a2,$t2
        syscall
        
        li $v0,15
	move $a0, $s0  # $a0 = file descriptor
        la $a1,newline
        li $a2,1
        syscall
        
        #max_value
        lw $a0,0($s3)
	jal itoa
	move $t0,$v0 # => address of int ascii
	move $t1,$v1 # ==> address length
	
	li $v0, 15
	move $a0, $s0  # $a0 = file descriptor
	move $a1,$t0
	move $a2,$t2
        syscall
        
        li $v0,15
	move $a0, $s0  # $a0 = file descriptor
        la $a1,newline
        li $a2,1
        syscall        
        
        #contents # int => ascii
       la $t5,0($s4) # t5 = ptr to contents
       lw $t6,0($s1) # t6 = width
       lw $t7,0($s2) 
       mul $t7,$t7,$t6 # t7 = length of char

       
       loopC2:############
       beq $t7,$zero,END

       
       lb $a0,0($t5) # load one byte from content addr


       addi $t5,$t5,1 # $t5 ++
       
       ## convert int to ascii str
       jal itoa
       move $t0,$v0 # addr ascii
       move $t1,$v1 # length ascii
       


       li $v0,15 # write ascii to content
       move $a0,$s0
       move $a1,$t0
       move $a2,$t1
       syscall
     

       
       addi $t6,$t6,-1 # width -1
       
       beq $t6,$zero,NewLine2
       
       li $v0,15 # space
       move $a0,$s0
       la $a1,space
       li $a2,1
       syscall
       
       addi $t7,$t7,-1 # length-1
       j loopC2
       
       
       NewLine2:
       li $v0,15 # newline
       move $a0,$s0
       la $a1,newline
       li $a2,1
       syscall
       
       lb $t6,0($s1) #t6 = original width
       addi $t7,$t7,-1 # length-1
       j loopC2

       
       
       
   
#################################### p 5 #######################################		
	P5:
	### write into file###
	#p5
	li $v0, 15
	move $a0, $s0  # $a0 = file descriptor
	la $a1,headerP5
	la $a2,3 #header length
        syscall

        #width
	lw $a0,0($s1)
	jal itoa
	move $t0,$v0 # => address of int ascii
	move $t1,$v1 # ==> address length
	
	li $v0, 15
	move $a0, $s0  # $a0 = file descriptor
	move $a1,$t0
	move $a2,$t2
        syscall
        
        li $v0,15
	move $a0, $s0  # $a0 = file descriptor
        la $a1,space
        li $a2,1
        syscall
        
        #height
        lw $a0,0($s2)
	jal itoa
	move $t0,$v0 # => address of int ascii
	move $t1,$v1 # ==> address length
	
	li $v0, 15
	move $a0, $s0  # $a0 = file descriptor
	move $a1,$t0
	move $a2,$t2
        syscall
        
        li $v0,15
	move $a0, $s0  # $a0 = file descriptor
        la $a1,newline
        li $a2,1
        syscall
        
        #max_value
        lw $a0,0($s3)
	jal itoa
	move $t0,$v0 # => address of int ascii
	move $t1,$v1 # ==> address length
	
	li $v0, 15
	move $a0, $s0  # $a0 = file descriptor
	move $a1,$t0
	move $a2,$t2
        syscall
        
        li $v0,15
	move $a0, $s0  # $a0 = file descriptor
        la $a1,newline
        li $a2,1
        syscall        

       #contents
       la $t5,0($s4)
  
       li $v0,15 # write to content
       move $a0,$s0
       move $a1,$t5
       li $a2,1024
       syscall
       

###########################################################################		
  END:
	
	
	
	
######################################
	 #close file
         li $v0, 16  
	 move $a0,$s0 # $a0 = file descriptor
         syscall
         

	
        

	
	
   ## store in return reg
   lw    $s7, 0($sp)           
   lw    $s6, 4($sp)            
   lw    $s5, 8($sp)           
   lw    $s4, 12($sp)          
   lw    $s3, 16($sp)          
   lw    $s2, 20($sp)         
   lw    $s1, 24($sp)           
   lw    $s0, 28($sp)          
   lw    $ra, 32($sp)          
   addi  $sp, $sp, 36    


	jr $ra
	


################################ ITOIA ############################################
itoa: 
# a0 = int, v0 = return add, v1 = length

  addi  $t0, $zero, 10         # $t0 = divide by 10
  add   $t1, $zero, $a0        # $t1 = $a0 = input integer
  add   $t3, $zero, $zero      # $t3 = 0
itoa.loop:
  div   $t1, $t0               # $t1 / 10
  mflo  $t1                    # $t1 => quotient
  mfhi  $t2                    # $t2 => remainder
  addi  $t2, $t2, 0x30         # to ASCII 
  addi  $sp, $sp, -1           # stack space + 1 byte
  sb    $t2, 0($sp)            # $t2 ==> stack
  addi  $t3, $t3, 1            # $t3++
  bne   $t1, $zero, itoa.loop  # if quotient($t1) != 0 ==> loop
  add   $v1, $zero, $t3        # #$v1 = string length
  
 # make space
 li $v0,9
 move $a0,$v1
 syscall  # => $v0  = return address
 move $t0,$v0 # t0 = address ptr
 
 # stack ==> address
 itoa.order:
  lb    $t1, 0($sp)            # $ t1 = last byte from stack
  addiu $sp, $sp, 1            # stack size -1

  sb    $t1, 0($t0)          # $t1 = last byte ==> str address
  addiu $t0, $t0, 1          # address +1
  addi  $t3, $t3, -1         # $str length -1
  bne   $t3, $zero, itoa.order # if t3 = 0 => end

  jr    $ra                    # jump to caller
  
