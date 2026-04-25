	preserve8
	thumb
		
	area	reset, data, readonly
	export	__Vectors
		
__Vectors
	dcd 0x20002000
	dcd Reset_Handler
	
	align
		
	area mydata, data, readonly
test_data
	dcb 47
	dcb 92
	dcb 57
	
	area mycode, code, readonly
		
	entry
	export Reset_Handler
Reset_Handler
	mov r0, #3
	bl main
stop
	b stop
	
main
	push{lr}
	ldr r1, =test_data	;loads test data in register 	
	ldr r2, =0x20000010	;stores bcd code for ones
	ldr r3, =0x20000020	;stores bcd code for tens
	ldr r4, =0x20000030	;stores ascii code for ones
	ldr r5, =0x20000040	;stores ascii code for tens
	
loop_test
	ldrb r12, [r1], #1
	
	bl test_logic
	
	strb r9, [r2]
	strb r7, [r3]
	strb r12, [r4]
	strb r11, [r5]
	
	add r2, #0x01
	add r3, #0x01
	add r4, #0x01
	add r5, #0x01
	
	sub r0, r0, #1
	cmp r0, #0
	bne loop_test
	
	pop{lr}
	bx lr
	
test_logic
	mov r6, #10	;stores decimal 10 into r4
	udiv r7, r12, r6	;r7 = 47 / 10 = 4
	mul r8, r7, r6	;r8 = 4 * 10 = 40
	sub r9, r12, r8	;r9 = 47 - 40 = 7
	
	mov r10, #0x30
	add r11, r7, r10	;r11 = 0x04 + 0x30 = 0x34
	add r12, r9, r10	;r12 = 0x07 + 0x30 = 0x37
	
	bx lr
	
	end