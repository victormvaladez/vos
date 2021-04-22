
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


VIDEO_MEMORY equ 0xb8000
WHITE_ON_BLACK equ 0x0f


print_string_pm:				 ; will print to screen starting at address in ebx register
	pusha
	mov edx, VIDEO_MEMORY        ; edx is the location of the start of the video memory
	mov ah, WHITE_ON_BLACK       ; set color to white on black for all characters

	print_string_pm_loop:
		mov al, [ebx]    		 ; move character at address ebx into al to be printed
		cmp al, 0				 ; check for null at end
		je print_string_pm_end	 ; jump to end if null

		mov [edx], ax			; move value of attribute (color, etc) and character into video memory at address edx

		add ebx, 1				; increment for next character in print_string
		add edx, 2				; increment by 2 video memory address (one for attribute, one for character)

		jmp print_string_pm_loop
	print_string_pm_end:
	popa
	ret
