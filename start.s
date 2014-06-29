@@
@@ pijFORTHos -- Raspberry Pi JonesFORTH Operating System
@@
@@ This code is loaded at 0x00008000 on the Raspberry Pi ARM processor
@@ and is the first code that runs to boot the O/S kernel.
@@
@@ View this file with hard tabs every 8 positions.
@@	|	|	|	|	|			   max width ->
@@      |       |       |       |       |                          max width ->
@@ If your tabs are set correctly, the lines above should be aligned.
@@

@ _start is the kernel bootstrap entry point
	.text
	.align 2
	.global _start
_start:
	sub	sp, pc, #8	@ Bootstrap stack immediately before _start
	mov	r0, sp
	bl	c_start		@ Jump to C entry-point
	bl	jonesforth	@ If c_start returns, call jonesforth...
halt:
	b	halt		@ Full stop

@@
@@ Provide a few assembly-language helpers used by C code, e.g.: raspberry.c
@@
	.text
	.align 2

	.globl NO_OP
NO_OP:				@ void NO_OP();
	bx	lr

	.globl PUT_32
PUT_32:				@ void PUT_32(u32 addr, u32 data);
	str	r1, [r0]
	bx	lr

	.globl GET_32
GET_32:				@ u32 GET_32(u32 addr);
	ldr	r0, [r0]
	bx	lr

	.globl PUT_16
PUT_16:				@ void PUT_32(u32 addr, u16 data);
	strh	r1, [r0]
	bx	lr

	.globl GET_16
GET_16:				@ u16 GET_16(u32 addr);
	ldrh	r0, [r0]
	bx	lr

	.globl PUT_8
PUT_8:				@ void PUT_32(u32 addr, u8 data);
	strb	r1, [r0]
	bx	lr

	.globl GET_8
GET_8:				@ u8 GET_8(u32 addr);
	ldrb	r0, [r0]
	bx	lr

	.globl GET_PC
GET_PC:				@ u32 GET_PC();
	mov	r0,lr
	bx	lr

	.globl BRANCH_TO
BRANCH_TO:			@ void BRANCH_TO(u32 addr);
	bx	r0

BOOT:				@ u32 BOOT(u32 dst, u32 src, u32 len);
	stmfd	sp!, {r4-r13, lr}	@ stack save + stack pointer + return address
@	mov	lr, r0		@ put boot address in link register
@	add	r0, pc, #52	@ start address of code to copy
	add	r0, pc, #60	@ start address of code to copy
	ldmia	r0, {r3-r12}	@ read 10 words of code
	mov	r0, sp		@ stack pointer is copy target
	stmdb	r0!, {r3-r12}	@ copy code to stack
@	bx	sp		@ jump to code on the stack!
	ldmfd	sp, {r4-r13, pc}	@ stack restore + stack pointer + return
	.int	1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16
