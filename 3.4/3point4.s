	preserve8
	thumb
        
	area reset, data, readonly
	export __Vectors

__Vectors
    dcd 0x20001000
    dcd Reset_Handler
        
	align
        
	area mydata, data, readonly

test_data
	dcb 99, 45, 87   ; 99, 45, 87
        
	area mycode, code, readonly
        
	entry
	EXPORT Reset_Handler
        
Reset_Handler
    mov r0, #3              ; number of test cases = 3
    bl main
stop
    b stop

main
    push {lr}

    ldr r1, =test_data      ;input pointer to test_data
	ldr r7, =0x20000010		;to store (and show) input
    ldr r2, =0x20000020     ; output pointer


loop_test
    ldrb r3, [r1]	        ; load 99 onto r3
	add r1, r1, #0x01       ;moves r1's position by one byte
	strb r3, [r7]           ; 99 is stored onto r7 to show input
	add r7, r7, #0x01       ;moves r7's position by one byte

    bl test_logic           ;branches to test_logic

    strb r5, [r2], #1       ; store 99 into r2

    sub r0, r0, #1          ;r0 subtracted with 1 until r0 reaches 0 so program terminates
    cmp r0, #0
    bne loop_test

    pop {lr}
    bx lr


test_logic
    mov r4, #10             ;r4 = 10

    udiv r5, r3, r4         ; r5 = r3 \div r4 = 99 / 10 = 9 (ignoring remainder), tens
    mul  r6, r5, r4         ; r6 = r5 \times r4 = 9 * 10 = 90
    sub  r6, r3, r6         ; r6 = r3 - r6 = 99 - 90 = 9, ones

    lsl r5, r5, #4          ; shift 0000 1001 to 1001 0000
    orr r5, r5, r6          ; r5 = r5 or r6 = 1001 0000 or 0000 1001 = 1001 1001

    bx lr                   ;returns back to main branch

	end