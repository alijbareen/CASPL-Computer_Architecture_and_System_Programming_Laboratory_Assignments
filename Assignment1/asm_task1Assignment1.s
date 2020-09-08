section .data                    	; we define (global) initialized variables in .data section
    format: db "%d", 10, 0            		; an is a local variable of size double-word, we use it to count the string characters

section .text                    	; we write code in .text section
        global assFunc       		; 'global' directive causes the function assFunc(...) to appear in global scope
	extern printf
	extern c_check_validity

assFunc:                        	; assFunc function definition - functions are defined as labels
	push ebp
	mov ebp, esp
	sub esp, 4
	pushad
	mov ecx, dword[ebp+12]
	push ecx
	mov ebx, dword[ebp+8]
	push ebx
	call c_check_validity
	add esp, 8
	CMP eax, 1
	JE _sub
	JMP _add
_sub:
	sub ebx ,ecx
	push ebx
	push dword format
	call printf
	jmp _end
	
_add:
	add ebx ,ecx
	push ebx
	push dword format
	call printf
	jmp _end
	
_end:
	add esp, 8
	popad
	mov esp, ebp
	pop ebp
	ret
