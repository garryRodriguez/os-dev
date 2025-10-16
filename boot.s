;boot.s (NASM, output format: elf32)
;Multiboot header + stub
bits32

section .multiboot
	align 4
	dd 0x1BADB002				; multiboot magic number
	dd 0x00000003				; flags align module + request memory information
	dd -(0x1BADB002 - 0x00000003)		;checksum

section .text
	global kernel_entry			; kernel entry
	extern kernel_main			; declare kernel_main as external file

kernel_entry:
	cli
	;setup basic stack (Info: Note that Grub doesn't guarantee usable stack)
	mov esp, 0x90000			; before call the function below, we need to have a valid stack
	call kernel_main			; C kernel (function entry point)

.halt:
	cli
	hlt
	jmp .halt
	
