# Student ID = 1234567
##########################set pixel #######################
.data
errormsg:                  .asciiz "Error: pixel location outside the image.\n"

.text

.globl set_pixel
set_pixel:
	# $a0 -> image struct
	# $a1 -> row number
	# $a2 -> column number
	# $a3 -> new value (clipped at 255)
	###############return################
	#void
	# Add code here
	
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
	## $ s0 = max_value   ##
        ## $ s1 = width       ##
        ## $ s2 = height      ##
        ## $ s3 = set int     ##
        ## $ s4 = content arr ##
        ## $ s5 = row num     ##
        ## $ s6 = col num     ##
        ########################
        move $s0,$a0 # $s0 = content addr

        la $s1 0($a0) 
        lw $s1,0($s1) # $s1 = width
        
        la $s2 4($a0)
        lw $s2,0($s2) # s2 = height
        
        
        la $s4 12($a0) # s4  = addr of content
        
        move $s3,$a3 # int value

        move $s5,$a1 # row num
        move $s6,$a2 # col num
        
        # if input int larger than 255, set int to 255
        li $t0,255
        bge $s3,$t0,setInt
        j checkRange
              
        setInt:
        addi $s3,$zero,255 # input int = 255
        
        checkRange:
        # if location outside image,return 0 and print error msg
        bgt $s5,$s2,error
        bgt $s6,$s1,error
        
        # else, the value position = t0 = (s5-1) * s1 + s6 
        addi $s5,$s5,-1
        mul $t0,$s5,$s1
        add $t0,$t0,$s6

       
        move $t1,$s4 # t1 = ptr to content addr
        addi $t1,$t1,-1

        loop:
        addi $t1,$t1,1
        addi $t0,$t0,-1
        bne $t0,$zero,loop
        
        sb $s3,0($t1)
        #update max_value
        la $t0,8($s0)
        lw $t0,0($t0) # t0 = old max_val
        bge $s3,$t0,update
        j END
        
        update:
        sw $s3,8($s0)
        j END

       error:
       li $v0,4
       la $a0,errormsg
       syscall
       
  END:     
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
