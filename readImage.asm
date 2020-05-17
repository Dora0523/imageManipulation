#Student ID = 1234567
#########################Read Image#########################
.data
type_buffer:             .word 1024
type:			.word 

width:                  .word 
height:                 .word
max_value:              .word
Cbuffer:               .word 1024
Contents:              .word 1024


temp:                   .word 1024


space:                  .asciiz " "
newline:                .asciiz "\n"
 


.text
		.globl read_image
read_image:
	# $a0 -> input file name
	################# return #####################
	# $v0 -> Image struct :
	# struct image {
	#	int width;
	#       int height;
	#	int max_value;
	#	char contents[width*height];
	#	}
	##############################################
	# Add code here
	
	#### read info from image #########################
	
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
       ###############################3      


	#open file
	li $v0,13
	addi $a0,$a0,0 # $a0 = inputTest
	li $a1,0 # read only 
	syscall
	move $s0,$v0  # $s0 = returned file descriptor
	
	#read from file
	########################
	## $ s0 = file descr  ##
        ## $ s1 = width       ##
        ## $ s2 = height      ##
        ## $ s3 = max_value   ##
        ## $ s4 =  content arr##
        ## $ s5 = type        ##
        ## $ s6 = size content##
        ########################

	############# P2/P5 $##############
	li $v0,14
	move $a0,$s0 # $a0= file descriptor
	la $a1,type_buffer 
	li $a2,1 #length of type
	syscall
	
	li $v0,14
	move $a0,$s0 # $a0= file descriptor
	la $a1,type
	li $a2,1 #length of type
	syscall
	
	li $v0,14
	move $a0,$s0 # $a0= file descriptor
	la $a1,type_buffer 
	li $a2,1 #length of type
	syscall
	
	############# width ###############
	la $t0,width                               # $ t0 = address of width
	addi $t5,$zero,0     # $t5 = result in int

	
	LoopWidth:
	     
	      #### load one at a time to $t7
	      li $v0,14
	      move $a0,$s0 # $a0= file descriptor
	      la $a1,temp
	      li $a2,1 #length
	      syscall
              lb $t7,temp                       
              ####
              
              beq $t7,32,OutW                # if $t7 == space or newline   ===> OUT of loop
              beq $t7,10,OutW
              
              ### convert to int ###
              mul $t5,$t5,10   # t5=0  #t5=20
              addiu $t7,$t7,-48 # t7=2  #t7=7
              addu $t5,$t5,$t7 # t5=2  #t5=27
              ### 
              
              addi $t0,$t0,1  # increment address of t0 by 1
              
        j LoopWidth
        
        OutW:
          move $s1,$t5
          
        ############ height ###############
        la $t1,height                               # $ t1 = address of height
        addi $t5,$zero,0     # $t5 = result in int

	
	LoopHeight:
	     
	      #### load one byte at a time to $t7
	      li $v0,14
	      move $a0,$s0 # $a0= file descriptor
	      la $a1,temp
	      li $a2,1 #length
	      syscall
              lb $t7,temp                      
              ####
                        
              beq $t7,32,OutH                 # if byte in $t7 == " "   ===> OUT of loop
              beq $t7,10,OutH
              
              ### convert to int ###
              mul $t5,$t5,10   
              addiu $t7,$t7,-48 
              addu $t5,$t5,$t7 
              ### 
             
              addi $t1,$t1,1  # increment address of t1 by 1
              
        j LoopHeight
              
         OutH:              
          move $s2,$t5

                
        ############# max_value ##########
        la $t2,max_value                               # $ t2 = address of max value
	addi $t5,$zero,0     # $t5 = result in int
	
	LoopMax:
	     
	      #### load one byte at a time to $t7
	      li $v0,14
	      move $a0,$s0 # $a0= file descriptor
	      la $a1,temp
	      li $a2,1 #length
	      syscall
              lb $t7,temp                       
              ####
              
              
              beq $t7,32,OutM                 # if byte in $t7 == " "   ===> OUT of loop1
              beq $t7,10,OutM
               
               ### convert to int ###
              mul $t5,$t5,10   
              addiu $t7,$t7,-48 
              addu $t5,$t5,$t7 
              ### 
             
              addi $t1,$t1,1  # increment address of t1 by 1
              
              
        j LoopMax
              
         OutM:
          move $s3,$t5
    
       ############ contents ############### ALL store in int form #############

       
       ############### allocate memory for array of contents
       li $v0,9    #address of allocated memory
       mul $s6,$s1,$s2 # $ s6 = width * height
       move $a0,$s6
       syscall
       
       move $s4,$v0 # store allocated memory address to $s4
       
       ####################################
 
	la $t0,type
        lb $t1,0($t0)
        addi $t1,$t1,-48 # type ascii => int
        
	li $t2,5
	beq $t1,$t2,P5 
	
	
     
     P2:
      # ascii => int 
       ## read to $vo
       addi $t4,$s6,0 # $t4 = size of memory
            
       li $v0,14
       move $a0,$s0 # $a0= file descriptor
       la $a1,Cbuffer  # file => content buffer
       addi $a2,$zero,1024
       syscall   
       ###
              
       #remove space and newline, store char into $s4      

       la $t3,Cbuffer   # $t3 = address of content
       addi $t4,$s6,0   # $t4 = size of memory
   
       move $t5,$s4   # $t5 = pointer to address s4
       

       loopContent2:
          
          beq $t4,0,END  # if size memory = 0, OUT of loop
          
          lb $t1,0($t3) # $t1 = content char

         #convert ascii str to int
          move $a0,$t3 # address of ascii int 
          jal atoi  # return v0 = integer, v1 = length of int
          move $t1,$v0 #t1 = integer
          move $t2,$v1 #length of ascii str
          
          beq $t2,$zero,skip # if length of int is 0 ie space/newline => skip 
          
          addi $t2,$t2,1
          sb $t1,0($t5)  #store in t5 address


          addi $t5,$t5,1   # increment t5 address by 1
          addi $t4,$t4,-1  # decrease memory by 1
          
          add $t3,$t3,$t2
       j loopContent2
       
       skip:
                 addi $t3,$t3,1

       j loopContent2
       
   
   
   P5:


      # binary => int 
       ## read to $vo
       move $t4,$s6 # $t4 = memory needed
            
       li $v0,14
       move $a0,$s0 # $a0= file descriptor
       la $a1,Cbuffer  # file => content buffer
       addi $a2,$zero,1024
       syscall   
       ###
       
       #store char into $s4      

       la $t3,Cbuffer   # $t3 = address of content
       addi $t4,$s6,0   # $t4 = size of memory

       move $t5,$s4   # $t5 = pointer to address s4

       loopContent5:
         beq $t4,$zero,END  # if size memory = 0, OUT of loop

         lb $t1,0($t3) # $t1 = content                
         sb $t1,0($t5)  #store in t5 address

          addi $t5,$t5,1   # increment t5 address by 1
          addi $t4,$t4,-1  # decrease memory by 1
          
          addi $t3,$t3,1

       j loopContent5


END:

 #close file
li $v0,16
move $a0,$t0 # $a0 = file descriptor
syscall
##########################################
      
      

      
       
    ## allocate memory for returning
    li $v0,9    
    addi $a0,$zero,16
    add $a0,$a0,$s6
    syscall  # => v0 = allocated memory address
    
    
    
    
    sw $s1,0($v0) # int width
    sw $s2,4($v0) # int length
    sw $s3,8($v0) # int max_value
    

    la $t0,12($v0) #address of return image content     
    add $a1,$zero,$s6 # size of content
    
    la $t5,0($s4)
    l:
    lb $a0,0($t5)
    sb $a0,0($t0)
    addi $t5,$t5,1
    addi $t0,$t0,1
    addi $a1,$a1,-1
    bne $a1,$zero,l




# restore stack
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

################################ ATOI ############################################

# $a0 = address of ascii str  RETURN: $v0= converted integer, $v1= ascii length
atoi:
lb $v0,0($a0) 

bgt   $v0, 0x39,rt0
blt   $v0, 0x30,rt0 # if input NaN, return with length 0

addi $v0,$v0,-48 # v0 = return int
addi $v1,$zero,1 # v1 = length starts with 1

 
atoi.loop:
addi $a0,$a0,1 # increment addr ptr
lb $t6,0($a0) # t6 = next byte

bgt   $t6, 0x39,rt
blt   $t6, 0x30,rt # if next byte is newline or space, return 

#else  
addi $t6,$t6,-48 # next ascii =>int

mul $v0,$v0,10
add $v0,$v0,$t6 # update v0

addi $v1,$v1,1 # update v1

j atoi.loop

rt0:
 addi $v1,$zero,0

 jr $ra
rt:

 jr $ra

