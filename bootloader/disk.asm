BIOS_DISK_SERVICES EQU 0x13
BIOS_DISK_READ_SECTOR EQU 0x02

; load dh sectors to es:bx from drive dl
boot_disk_load:
	pusha
	push dx		; push dh / dh onto the stack for later use

	mov ah, BIOS_DISK_READ_SECTOR ; read sector function
	mov al, dh ; read dh sectors from the starting point
	mov ch, 0 ; select cylinder 0
	mov dh, 0 ; select the track on 1st side of floppy (indexed from 0)
	mov cl, 2 ; select the 2nd sector (indexed from 1)

	int BIOS_DISK_SERVICES ; attempt the read

	jc disk_error_carry ; carry flag will be set if error occurs
	pop dx ; restore original dx
	cmp dh, al ; ensure that the number of sectors read matches the number of sectors desired
	jne disk_error_sector
	popa
	ret

disk_error_carry:
	mov bx, DISK_ERROR_MSG_CARRYFLAG
	call print_string
	jmp $

disk_error_sector:
	mov bx, DISK_ERROR_MSG_SECTOR_MISMATCH
	call print_string
	jmp $

DISK_ERROR_MSG_CARRYFLAG: db "Disk read error: Carry flag set. Halting....", 0
DISK_ERROR_MSG_SECTOR_MISMATCH: db "Disk read error: Sectors read mismatch. Halting....", 0
