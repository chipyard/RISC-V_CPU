#Written by Jenna Kramer and Xeerak Muhammad
#.data

#.text
# li a7 5 # set up syscall 5 - read int
# li a0 0
# ecall

addi s0, zero, 25 # for vsim testing

# csrrw s0, 0xf00, x3 # for the actual board execution

# register a0 now has the number read in from console
#add s0 a0 zero #copy it to s0
slli s0 s0 14 # so it wont be 32,14

li s1 256 #guess also called x
li s2 128 #step size also called S

slli s1, s1, 14 # shift for guess and overwrite in s1
slli s2, s2, 14 #shift for step and overwrite in s2

#32 + 32 = 64
loop:
  mul s3, s1, s1 #x^2 saved in here # mul loo

  #mul hi
  mulhu s4, s1, s1 #x^2 for high bits

  # shift mul hi left by 18
  slli s4, s4, 18

  # shift mul lo right by 14
  srli s3, s3, 14

  # have to or the hi and lo bits together
  or s4, s3, s4 #store the or into register s4

  beq s4, s0, Clean_Up #If guess equals input number then break and clean up,if exact, exit from psudeo


  blt s4,s0 Step_Up #val < 0 check if so step = step+1,otherwise add if step to low
  bgt s4,s0 Step_Down #jump to step = step-1, subtract step if too high
 
  decrement:
  srli s2, s2, 1 # divide by two
  beqz s2, Clean_Up #stop condition
  b loop #End of loop function, go back up to top

Step_Up:
  add s1, s1, s2 # add step + guess and overwrite guess(s1)
  b decrement

Step_Down:
  sub s1, s1, s2 #Subtract by subtracting step by guess
  b decrement
  

Clean_Up:
  #Clean up registers and show output with syscall
  mv a0, s1 #Prep the PrintInt syscall with our value
  #li a7, 1 #Prepare the PrintInt syscall
  #ecall

#exit:
  #li a7, 10
  #ecall
  
  
  
  
  

 




#bin2dec
li s7, 429496730 #2^32 / 10 to represent 0.1
li s6, 10 #load the 10

#li t0 0  # call this the result


#csrrw s0, 0xf00, 0 #Load register s0 with binary number from switches


#li s0 736 # 1234
#csrrw s0, 0xf00, x3

mv s0, a0 # a0 is the final destination of the sqrt value
li t6 100000
#srli t6 t6 14
mul t5 s0 t6
mulhu t4 s0 t6
#srli s0 s0 14
slli t4 t4 18
srli t5 t5 14
or s0 t4 t5

#stored binary number is in reg s0 after being loaded from gpio
#need to multiply inputted number by fractional value.

#0
# (input 32,0) * (0.1 32,32) lower -> 32,32    e.g. (1234 32,0) * (0.1 32,32) lower -> (0.4 32,32)
mul s1,s0,s7 #multiply lower bits by 0.1
# (0.1 32,32) * (input 32,32) upper -> 32,0    e.g. (0.1 32,32) * (1234 32,0) upper -> (123, 32,0)
mulh s0, s7, s0 #multiply upper bits by 0.1
# (10 32,0) * (digit 32,32) upper -> 32,0      e.g. (10 32,0) * (0.4 32,32) upper -> (4 32,0)
# also (4 64,32)
mulhu s3, s6, s1 
# e.g. 123 | input      suggest result = result | (digit << position)

mv s4, s3


#1
mul s1, s7 , s0 #multiply lower bits by 0.1
# (0.1 32,32) * (input 32,32) upper -> 32,0    e.g. (0.1 32,32) * (1234 32,0) upper -> (123, 32,0)
mulh s0, s7, s0 #multiply upper bits by 0.1
# (10 32,0) * (digit 32,32) upper -> 32,0      e.g. (10 32,0) * (0.4 32,32) upper -> (4 32,0)
# also (4 64,32)
mulhu s3, s6, s1 
# e.g. 123 | input      suggest result = result | (digit << position)

slli	s4 ,s4, 4	
or	s4, s4, s3

#2
mul s1, s7 , s0 #multiply lower bits by 0.1
# (0.1 32,32) * (input 32,32) upper -> 32,0    e.g. (0.1 32,32) * (1234 32,0) upper -> (123, 32,0)
mulh s0, s7, s0 #multiply upper bits by 0.1
# (10 32,0) * (digit 32,32) upper -> 32,0      e.g. (10 32,0) * (0.4 32,32) upper -> (4 32,0)
# also (4 64,32)
mulhu s3, s6, s1 
# e.g. 123 | input      suggest result = result | (digit << position)

slli	s4 ,s4, 4	
or	s4, s4, s3

#3
mul s1, s7 , s0 #multiply lower bits by 0.1
# (0.1 32,32) * (input 32,32) upper -> 32,0    e.g. (0.1 32,32) * (1234 32,0) upper -> (123, 32,0)
mulh s0, s7, s0 #multiply upper bits by 0.1
# (10 32,0) * (digit 32,32) upper -> 32,0      e.g. (10 32,0) * (0.4 32,32) upper -> (4 32,0)
# also (4 64,32)
mulhu s3, s6, s1 
# e.g. 123 | input      suggest result = result | (digit << position)

slli	s4 ,s4, 4	
or	s4, s4, s3

#4
mul s1, s7 , s0 #multiply lower bits by 0.1
# (0.1 32,32) * (input 32,32) upper -> 32,0    e.g. (0.1 32,32) * (1234 32,0) upper -> (123, 32,0)
mulh s0, s7, s0 #multiply upper bits by 0.1
# (10 32,0) * (digit 32,32) upper -> 32,0      e.g. (10 32,0) * (0.4 32,32) upper -> (4 32,0)
# also (4 64,32)
mulhu s3, s6, s1 
# e.g. 123 | input      suggest result = result | (digit << position)

slli	s4 ,s4, 4	
or	s4, s4, s3

#5
mul s1, s7 , s0 #multiply lower bits by 0.1
# (0.1 32,32) * (input 32,32) upper -> 32,0    e.g. (0.1 32,32) * (1234 32,0) upper -> (123, 32,0)
mulh s0, s7, s0 #multiply upper bits by 0.1
# (10 32,0) * (digit 32,32) upper -> 32,0      e.g. (10 32,0) * (0.4 32,32) upper -> (4 32,0)
# also (4 64,32)
mulhu s3, s6, s1 
# e.g. 123 | input      suggest result = result | (digit << position)

slli	s4 ,s4, 4	
or	s4, s4, s3

#6
mul s1, s7 , s0 #multiply lower bits by 0.1
# (0.1 32,32) * (input 32,32) upper -> 32,0    e.g. (0.1 32,32) * (1234 32,0) upper -> (123, 32,0)
mulh s0, s7, s0 #multiply upper bits by 0.1
# (10 32,0) * (digit 32,32) upper -> 32,0      e.g. (10 32,0) * (0.4 32,32) upper -> (4 32,0)
# also (4 64,32)
mulhu s3, s6, s1 
# e.g. 123 | input      suggest result = result | (digit << position)

slli	s4 ,s4, 4	
or	s4, s4, s3

#7
mul s1, s7 , s0 #multiply lower bits by 0.1
# (0.1 32,32) * (input 32,32) upper -> 32,0    e.g. (0.1 32,32) * (1234 32,0) upper -> (123, 32,0)
mulh s0, s7, s0 #multiply upper bits by 0.1
# (10 32,0) * (digit 32,32) upper -> 32,0      e.g. (10 32,0) * (0.4 32,32) upper -> (4 32,0)
# also (4 64,32)
mulhu s3, s6, s1 
# e.g. 123 | input      suggest result = result | (digit << position)

slli	s4 ,s4, 4	
or	s4, s4, s3

#srli s4,a0, 14

#mv a0, s4
#li a7, 34 #Prepare the PrintInt syscall
#ecall





csrrw x20, 0xf02, s4 #Output results of s5 onto the display and overwrite a0 with returned 0 from write-only CSR


 


  
