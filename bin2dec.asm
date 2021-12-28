
 

li s7, 429496730 #2^32 / 10 to represent 0.1
li s6, 10 #load the 10

#li t0 0  # call this the result


#csrrw s0, 0xf00, 0 #Load register s0 with binary number from switches


#li s0 736 # 1234
csrrw s0, 0xf00, x3

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



csrrw x20, 0xf02, s4 #Output results of s5 onto the display and overwrite a0 with returned 0 from write-only CSR


 

