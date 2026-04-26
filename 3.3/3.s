	preserve8
	thumb
		
	area	reset, data, readonly
	export	__Vectors
		
__Vectors
	dcd 0x20002000
	dcd Reset_Handler
	
	align
		
	area mydata, data, readonly
test_data		;test data stores 3 different test values
	dcb 47
	dcb 92
	dcb 57
	
	area mycode, code, readonly
		
	entry
	export Reset_Handler
Reset_Handler
	mov r0, #3		;r0 starts at 3 for 3 different test cases
	bl main
stop
	b stop
	
main
	push{lr}
	ldr r1, =test_data			;loads test data in register 	
	ldr r2, =0x20000010			;stores bcd code for ones
	ldr r3, =0x20000020			;stores bcd code for tens
	ldr r4, =0x20000030			;stores ascii code for ones
	ldr r5, =0x20000040			;stores ascii code for tens
	
loop_test
	ldrb r12, [r1], #1			;47 is loaded onto r12
	
	bl test_logic				;test_logic branch is called
	
	strb r9, [r2]				;r2 stores value of r9 = 7
	strb r7, [r3]				;r3 stores value of r7 = 4
	strb r12, [r4]				;r4 stores value of r12 = 0x37
	strb r11, [r5]				;r5 stores value of r11 = 0x34
	
	add r2, #0x01				;moves all registers by one byte for next test case iteration
	add r3, #0x01
	add r4, #0x01
	add r5, #0x01
	
	sub r0, r0, #1				;r0 subtracted wtih 1 until reaches 0 to terminate program
	cmp r0, #0
	bne loop_test
	
	pop{lr}
	bx lr
	
test_logic
	mov r6, #10			;stores decimal 10 into r4
	udiv r7, r12, r6	;r7 = 47 / 10 = 4
	mul r8, r7, r6		;r8 = 4 * 10 = 40
	sub r9, r12, r8		;r9 = 47 - 40 = 7
	
	mov r10, #0x30		;r10 = #0x30
	add r11, r7, r10	;r11 = 0x04 + 0x30 = 0x34
	add r12, r9, r10	;r12 = 0x07 + 0x30 = 0x37
	
	bx lr				;branches back to main
	
	end