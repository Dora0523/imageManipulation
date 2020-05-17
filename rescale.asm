# Student ID = 1234567
###############################rescale image######################
.data

.text

.globl rescale_image
rescale_image:
	# $a0 -> image struct
	############return###########
	# $v0 -> rescaled image
	######################
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
	## $ s0 = content addr##
        ## $ s1 = min         ##
        ## $ s2 = max         ##
        ## $ s3 = content arr ##
        ## $ s4 = content len ##
        ########################

         move $s0,$a0
         la $t0,0($s0)
         lw $t0,0($t0)
         la $t1,4($s0)
         lw $t1,0($t1) 
         mul $s4,$t0,$t1 # s4 = content len
        
         la $s2,8($s0)
         lw $s2,0($s2) # s2 = max_val
         la $s3 12($a0) # s3 = content arr
         
   #loop through whole content to get Min Value
         
         move $t0,$s3 # t0 = addr ptr
         move $t1,$s4 # t1 = length
         
         lb $t2,0($t0)
         move $s1,$t2 # set first byte to Min to start
         
         getMin:
         lb $t2,0($t0)
         
         ## check new max value
         blt $t2,$s1,newMin # if t2 < currentMin , change Min to t2
         j increment

         newMin:
         move $s1,$t2 # update newMin
         increment:

         addi $t0,$t0,1 # incre content ptr
         addi $t1,$t1,-1 # decre length
         bne $t1,$zero,getMin
         

        
   #loop through content to update pixel
         move $t0,$s3 # t0 = addr ptr
         move $t1,$s4 # t1 = length
         sub $t3,$s2,$s1 # t3 = Max-Min
         li $t4,255
        

       update:       
         lb $t2,0($t0)
                  
         # update content ###  new$t2 = ($t2 - $s1) * 255 / t3
         mtc1 $t2,$f0
         mtc1 $s1,$f1
         mtc1 $t4,$f4
         mtc1 $t3,$f3
  
         cvt.s.w $f0,$f0 # convert to single precision
         cvt.s.w $f1,$f1
         cvt.s.w $f3,$f3
         cvt.s.w $f4,$f4
         
         sub.s $f0,$f0,$f1 # calculation
         mul.s $f0,$f0,$f4
         div.s $f0,$f0,$f3
         
         cvt.w.s $f1,$f0 # convert to int
         mfc1 $t2,$f1        
         ####################
         
         sb $t2,0($t0)

         addi $t0,$t0,1 # incre content ptr
         addi $t1,$t1,-1 # decre length
         bne $t1,$zero,update
        
	
	
	
END:       
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
