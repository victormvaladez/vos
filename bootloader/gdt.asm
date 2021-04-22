gdt_start:

gdt_null:			; manditory "empty" segment descriptor
	dd 0x0
	dd 0x0

gdt_code_segment:
	dw 0xffff 		; limit (bits 0-15)
	dw 0x0000 		; base (bits 0-15)
	db 0x00   		; base (bits 16-23)
	db 10011010b	; 1st flags, type flags (1010)
	db 11001111b	; 2nd flags, limit (bits 16-19)
	db 0x00 		; base (bits 24-31)

gdt_data_segment:
	dw 0xffff 		; limit (bits 0-15)
	dw 0x0000 		; base (bits 0-15)
	db 0x00   		; base (bits 16-23)
	db 10010010b	; 1st flags, type flags (0010)
	db 11001111b	; 2nd flags, limit (bits 16-19)
	db 0x00 		; base (bits 24-31)

gdt_end:

gdt_descriptor:
	dw gdt_end - gdt_start - 1		; size of our gdt (minus 1?)
	dd gdt_start

CODE_SEG equ gdt_code_segment - gdt_start
DATA_SEG equ gdt_data_segment - gdt_start
