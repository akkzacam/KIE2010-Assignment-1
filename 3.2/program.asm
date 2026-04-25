	preserve8
	thumb
		
	area	reset, data, readonly
	export	__Vectors
__Vectors

	dcd 0x20002000
	dcd Reset_Handler
		
	align
		
	area	mydata, data, readonly
		
test_data
	dcb 0x35, 0x37
	dcb 0x39, 0x31
	dcb 0x37, 0x37
		
	area	mycode, code, readonly
		
	entry
	export	Reset_Handler
	
Reset_Handler
	mov r0, #3
	bl main
stop
	b stop

main
	push {lr}
	
	ldr r1, =0x20000000	;store tens
	ldr r2, =0x20000010	;store ones
	ldr r3, =0x20000020	;store data
	ldr r4, =test_data
	
loop_tests
	ldrb r5, [r4]
	add r4, #0x01
	ldrb r6, [r4]
	add r4, #0x01
	
	bl test_logic
	
	strb r5, [r3]
	add r3, #1
	add r1, #0x01
	add r2, #0x01
	sub r0, #1
	cmp r0, #0
	bne loop_tests
	
	pop {lr}
	bx lr
	
test_logic
	mov r7, #0x30
	sub r5, r5, r7	;5, 0000 0101
	sub r6, r6, r7	;7, 0000 
	
	strb r5, [r1]
	strb r6, [r2]
	
	lsl r5, #0x04	;shift 0000 0101 to 0101 0000
	orr r5, r5, r6	; logic or 0101 0000 with 0000 0111
	
	bx lr
	
	end