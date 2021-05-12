
print_string:								; will print to screen starting at address in bx register
	pusha
	mov ah, 0x0e							; scrolling teletype BIOS routine
	mov si, 0								; init offset to 0
	print_string_loop:
		mov al, [bx + si]					; move character into proper register
		cmp al, 0							; compare character to NULL
		je print_string_end					; jump to end if NULL
		int 0x10							; print character to screen
		add si, 1							; increment offset
		jmp print_string_loop				; loop to pickup next character
	print_string_end:
	popa
	ret
