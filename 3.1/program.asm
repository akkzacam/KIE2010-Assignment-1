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
	dcb 4, 7
	dcb 2, 3
	dcb 9, 1
	
	area mycode, code, readonly
		
	entry
	export Reset_Handler
		
Reset_Handler
	mov r0 , #3
	bl main	
stop
	b stop

main
	push {lr}
	ldr r1, =0x20000000	;tens
	ldr r2, =0x20000010	;ones
	ldr r3, =0x20000020	;data
	ldr r4, =test_data
	
loop_tests
	ldrb r5, [r4], #1
	ldrb r6, [r4], #1
	
	strb r5, [r1]
	strb r6, [r2]
	
	bl test_case
	add r1, r1, #0x01
	add r2, r2, #0x01
	strb r7, [r3], #0x01
	sub r0, r0, #1
	cmp r0, #0
	bne loop_tests
	
	pop {lr}
	bx lr
	
test_case
	ldrb r7, [r1]
	ldrb r8, [r2]
	
	mov r9, #0x0A
	mul r7, r7, r9
	add r7, r7, r8

	bx lr
	
	end

	