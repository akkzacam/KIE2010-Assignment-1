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
    mov r0, #3              ; number of test cases
    bl main
stop
    b stop

main
    push {lr}

    ldr r1, =test_data      ; input pointer
	ldr r7, =0x20000010		;to store (and show) input
    ldr r2, =0x20000020     ; output pointer


loop_test
    ldrb r3, [r1]	; load value
	add r1, r1, #0x01
	strb r3, [r7]
	add r7, r7, #0x01

    bl test_logic           ; process

    strb r5, [r2], #1       ; store BCD result

    sub r0, r0, #1
    cmp r0, #0
    bne loop_test

    pop {lr}
    bx lr


test_logic
    mov r4, #10

    udiv r5, r3, r4         ; r5 = tens
    mul  r6, r5, r4         ; r6 = tens*10
    sub  r6, r3, r6         ; r6 = ones

    lsl r5, r5, #4          ; shift tens
    orr r5, r5, r6          ; combine ? BCD

    bx lr

	end