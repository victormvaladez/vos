
BOOT_ADDR EQU 0x7c00
PROTECTED_MODE_STACK_POSITION EQU 0x90000

KERNEL_ADDR EQU 0x1000
SECTORS_TO_READ EQU 15

[bits 16]
[org BOOT_ADDR]

; --- Set Up Stack
%include "stack16.asm"

; Program start

mov [boot_drive], dl ; save boot drive for later

call load_kernel
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

load_kernel:
    mov bx, kernel_loading_message
    call print_string

    mov bx, KERNEL_ADDR ; load data into KERNEL_ADDR
    mov dh, SECTORS_TO_READ ; attempt to load sectors
    mov dl, [boot_drive]
    call boot_disk_load

    mov bx, kernel_loaded_message
    call print_string

    ret

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

	mov ebp, PROTECTED_MODE_STACK_POSITION  ; reset the stack position
	mov esp, ebp

	call begin_protected_mode

	jmp $

begin_protected_mode:
	xor ebx, ebx
	mov ebx, pm_message
	call print_string_pm

    call KERNEL_ADDR

	jmp $


; Global variables
pm_message: db "Entered into Protected mode.", 0
kernel_loading_message: db "Loading kernel....", 0
kernel_loaded_message: db "Kernel loaded!", 0
boot_drive: db 0

; ------- Padding and magic BIOS boot number

times 510-($-$$) db 0
dw 0xaa55
