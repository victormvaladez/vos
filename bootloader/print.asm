
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

print_hex:									; will print to screen a hex representation of the value in the dx register
	PRINT_HEX_MASK EQU 0x000F
	PRINT_HEX_ASCII_NUMERIC_OFFSET EQU 48	; ASCII character 0
	PRINT_HEX_ASCII_ALPHA_OFFSET EQU 97 	; ASCII character a
	pusha
	mov cl, 4								; shift 4 bits at a time	
	mov ch, 4								; loop 4 times
	mov si, 5								; offset of HEX_OUT character eg 0x0000 (prints right to left)
	
	print_hex_loop:
	
	cmp ch, 0								; test for loop
	je print_hex_end 						; jump for loop end
	
	mov bx, dx								; move current dx value into bx for masking
	and bx, PRINT_HEX_MASK					; mask all but the least significant 4 bits	

	cmp bl, 10								; compare masked value for 10 and over (ie A-F)
	jge print_hex_alpha 					; if 10 or over, handle the alpha case...

	print_hex_number:
	add bl, PRINT_HEX_ASCII_NUMERIC_OFFSET	; otherwise move onto the numeric case (0-9)
	jmp print_hex_loop_end
	
	print_hex_alpha:
	add bl, PRINT_HEX_ASCII_ALPHA_OFFSET - 10 	; minus 10 to account for digits (0-9)
	jmp print_hex_loop_end

	print_hex_loop_end:
	mov [HEX_TEMPLATE + si], bl 					; "print" the character by placing it in memory at the specified offset
	shr dx, cl 										; shift the next 4 bits in
	sub ch, 1										; decrement main counter
	sub si, 1										; decrement HEX_TEMPLATE character offset
	jmp print_hex_loop

	print_hex_end:
	mov bx, HEX_TEMPLATE							; place HEX_TEMPLATE address into bx so we can print it
	call print_string 								; print the now filled out HEX_TEMPLATE string
	popa
	ret

HEX_TEMPLATE: db "0x0000", 0						; placeholder for hex output
