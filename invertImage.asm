#Student ID = 1234567
#################################invert Image######################
.data
.text
.globl invert_image
invert_image:
	# $a0 -> image struct
	#############return###############
	# $v0 -> new inverted image
	############################
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
	## $ s0 = image struct##
        ## $ s1 = max_value   ##
        ## $ s2 = content arr ##
        ## $ s3 = content len ##
        ## $ s4 = new max val ##
        ########################
        move $s0,$a0
        la $t0,0($a0)
        lw $t0,0($t0) # t0=length
        la $t1,4($a0)
        lw $t1,0($t1) # t1=height
        mul $s3,$t0,$t1 # s3=arr length
        
        la $s1 8($a0)  
        lw $s1,0($s1) # s1 = max value
        la $s2 12($a0) # s2 = content arr

move $t0,$s3 # t0=length
move $t1,$s2 # t1=addr of content arr
li $s4,0 # init new Max_value


loop:
# lb to $t2, substr by maxvalue, sb 
lb $t2,0($t1)
sub $t2,$s1,$t2 # value = max - value
sb $t2,0($t1)

## check new max value
blt $s4,$t2,newMax # if currentMax < t2, change max to t2
j increment

newMax:
add $s4,$zero,$t2

increment:
addi $t1,$t1,1 # incre content addr
addi $t0,$t0,-1 # decre length
bne $t0,$zero,loop 

###
# update max value
la $s1 8($a0)  
lb $s4,0($s1)
# return new inverted inmage
move $v0,$s0
                                     
                                           
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
	
