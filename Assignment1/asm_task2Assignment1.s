section	.rodata						; we define (global) read-only variables in .rodata section
	format_string: db "%s", 10, 0	; format string/

section .bss						; we define (global) uninitialized variables in .bss section
	an: resb 12						; enough to store integer in [-2,147,483,648 (-2^31) : 2,147,483,647 (2^31-1)]
	an_flip: resb 12 				; enough to store integer in [-2,147,483,648 (-2^31) : 2,147,483,647 (2^31-1)]


section .text
	global convertor
	extern printf

convertor:

	push ebp
	mov ebp, esp	
	pushad		

	mov ecx, dword [ebp+8]			; get function argument (pointer to string)

	mov eax, 0						; 
	mov ebx, 0						; 
	mov edx, 0						; 

ascii_te_decimal: 

	mov bl, byte [ecx]			; get the next char from the input string[i] //first is 0
	inc ecx						; i++
	cmp ebx, 0					; if null terminated then we jump to start code
	je _prepare_decimal_convert			;
	cmp ebx, 'q'				; if null terminated then we jump to start code
	je _end_code				;  
	cmp ebx, 10					; if the string[i] is '\n' thne we jump to start code
	je _prepare_decimal_convert			; 
	sub ebx, 48					; convert ascii to decimal by removing '0'
	mov edx ,eax				; save the res from eax to ebx
	imul edx, 10				; ebx = 10*ebx
	add edx, ebx				; ebx= edx +10*ebx 
	mov eax ,edx				; eax = ebx

	jmp ascii_te_decimal		;

_prepare_decimal_convert:

	mov eax , edx				; the int value of our number is in edx
	push edx 					; we store the value from edx to stack
	pushad
	mov ebx	, 16				; this will be our divider

	mov ecx	, 12				; we start from the bottom of the array (little endian)


_start_loop:
	mov edx, 0             		; set edx to 0 to get the result of div
	div ebx     	  			; 

	cmp edx, 10					;
	jb convert_to_hex			; if edx < 10  jump to convert_to_hex
	add edx, 55					; else we add 'A'-10 (65-10=55) 
	jmp _insert_hexa			; 				

convert_to_hex:
	add edx, 48					; we add 48 , '0' is the 48

_insert_hexa:
	mov byte [an + ecx], dl			; insert into an array from the last position
	mov [an + edx +ecx], bl			; 
	sub ecx , 1						; i--
	cmp eax	, 0						; while num !=0
	ja _start_loop					;


_prepare_string_reverse:

	add ecx, 1						;
	mov eax, 32						;
	mov edx, 0						; i=0

reverse_string:
	cmp eax, edx					; while i < 32
	je _end_code					;
	add ecx , edx					;
	mov bl, [an + ecx]				; 
	sub ecx , edx					;
	mov [an + edx], bl				;
	inc edx							; i++
	jmp reverse_string				;

_end_code:

	popad
	pop edx							;store input in decimal value
	push an							; call printf with 2 arguments
	push format_string				; pointer to str and pointer to format string
	call printf						; call printf method from c
	add esp, 8						; clean up stack after call
	popad			
	mov esp, ebp	
	pop ebp
	ret