
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

call switch_to_pm
jmp $

switch_to_pm:
	lgdt [gdt_descriptor]
	cli
	mov eax, cr0 ; set first bit of CR0 (control register) to 1 to enter into protected mode
	or eax, 0x1  ;
	mov cr0, eax ;

	jmp CODE_SEG:init_protected_mode

; ---- real mode routines
%include "print_string.asm"
%include "print_hex.asm"
%include "disk.asm"
%include "gdt.asm"

; ---- protected mode routines
[bits 32]

%include "print_string_pm.asm"

init_protected_mode:
	
	mov ax, DATA_SEG  ; now in 32bit mode, redefine all segments
	mov ds, ax
	mov ss, ax
	mov es, ax
	mov fs, ax
	mov gs, ax

	mov ebp, 0x90000  ; reset the stack position
	mov esp, ebp

	call begin_protected_mode

	jmp $

begin_protected_mode:
	xor ebx, ebx
	mov ebx, pm_message
	call print_string_pm

	jmp $


; Global variables
some_data: db "z"

my_string: db "Hello world! ", 0

pm_message: db "Entered into Protected mode.", 0

boot_drive: db 0

; ------- Padding and magic BIOS boot number

times 510-($-$$) db 0
dw 0xaa55

; past first sector of disk
times 256 dw 0xdada
times 256 dw 0xface
