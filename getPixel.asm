# Student ID = 1234567
##########################get pixel #######################
.data
errormsg:                  .asciiz "Error: pixel location outside the image.\n"
.text
.globl get_pixel
get_pixel:
	# $a0 -> image struct
	# $a1 -> row number
	# $a2 -> column number
	################return##################
	# $v0 -> value of image at (row,column)
	#######################################
	# Add Code

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
        ## $ s1 = width       ##
        ## $ s2 = height      ##
        ## $ s4 = content arr ##
        ## $ s5 = row num     ##
        ## $ s6 = col num     ##
        ########################

        la $s1 0($a0) 
        lw $s1,0($s1) # $s1 = width
        la $s2 4($a0)
        lw $s2,0($s2) # s2 = height
        la $s4 12($a0) # addresses of width,height,max value,contents
        
        move $s5,$a1 # row num
        move $s6,$a2 # col num
        
        # if location outside image,return 0 and print error msg
        bgt $s5,$s2,error
        bgt $s6,$s1,error
        
        # else, the value position = t0 = (s5-1) * s1 + s6 
        addi $s5,$s5,-1
        mul $t0,$s5,$s1
        add $t0,$t0,$s6

        
        move $t1,$s4 # t1 = ptr to content addr

        loop:
        lb $t2,0($t1)
        addi $t1,$t1,1
        addi $t0,$t0,-1
        bne $t0,$zero,loop
        
        move $v0,$t2
        j END
        
        error: # outside of location 

        li $v0,4
        la $a0,errormsg
        syscall
       
        li $v0,0
        j END

        

        
        
 END:       
        
        
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
        
        
