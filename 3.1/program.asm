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
	mov r0 , #3	;counter starts at 3 for 3 different test cases
	bl main	
stop
	b stop

main
	push {lr}
	ldr r1, =0x20000000	;stores data for tens
	ldr r2, =0x20000010	;stores data for ones
	ldr r3, =0x20000020	;stores data for the 8-bit binary
	ldr r4, =test_data
	
loop_tests
	ldrb r5, [r4], #1	;4 (tens) is loaded onto r5
	ldrb r6, [r4], #1	;7 (ones) is loaded onto r6
	
	strb r5, [r1]			;4 is stored in r1, 0x20000010
	strb r6, [r2]			;7 is stored in r2, 0x20000020
	
	bl test_case			;calls algorithmic logic function
	add r1, r1, #0x01		;r1's location moved up by one byte
	add r2, r2, #0x01		;r2's location moved up by one byte
	strb r7, [r3], #0x01	;r7 (47) is stored in r3
	sub r0, r0, #1			;r0 subtracted with one to progress loop
	cmp r0, #0
	bne loop_tests
	
	pop {lr}
	bx lr
	
test_case
	ldrb r7, [r1]		;4 is loaded onto r7 = 4
	ldrb r8, [r2]		;7 is loaded onto r8 = 7
	
	mov r9, #0x0A		;r9 = 10
	mul r7, r7, r9		;r7 = r7 \times r9 = 4 \times 10 = 40
	add r7, r7, r8		;r7 = r7 + r8 = 40 + 7

	bx lr				;returns back to loop_tests where test_case is called
	
	end

	