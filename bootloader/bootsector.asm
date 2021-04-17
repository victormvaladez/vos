
BOOT_ADDR EQU 0x7c00
STACK_BASE EQU 0x8000

[org BOOT_ADDR]

; --- Set Up Stack
mov bp, STACK_BASE
mov sp, bp

mov bx, my_string
call print_string

mov dx, 0xface
call print_hex

mov dx, 0xe6f2
call print_hex

infinite_loop:
	jmp infinite_loop

%include "print.asm"

some_data:
	db "z"

my_string:
	db "allow 'orld! ", 0

; ------- Padding and magic BIOS boot number

times 510-($-$$) db 0

dw 0xaa55