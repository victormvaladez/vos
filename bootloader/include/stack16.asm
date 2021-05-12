STACK_POINTER EQU 0x1200
STACK_SEGMENT EQU 0x070e

xor ax, ax
mov ds, ax ; set data segment
mov es, ax ; set other segment

mov ax, STACK_SEGMENT
cli
mov ss, ax
mov sp, STACK_POINTER
sti
