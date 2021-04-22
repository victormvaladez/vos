
BOOT_ADDR EQU 0x7c00


[bits 16]
[org BOOT_ADDR]

; --- Set Up Stack
%include "stack16.asm"

; Program start

mov [boot_drive], dl

mov dh, 2 ; attempt to load sectors
mov bx, 0x9000 ; load data into [es:0x9000]
call boot_disk_load

mov dx, [0x9000]
call print_hex

mov dx, [0x9000 + 512]
call print_hex


infinite_loop:
	jmp infinite_loop

%include "print_string.asm"
%include "print_hex.asm"
%include "disk.asm"

; Global variables
some_data: db "z"

my_string: db "Hello world! ", 0

boot_drive: db 0

; ------- Padding and magic BIOS boot number

times 510-($-$$) db 0
dw 0xaa55

; past first sector of disk
times 256 dw 0xdada
times 256 dw 0xface
