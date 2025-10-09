;boot.s (NASM, output format: elf32)
;Multiboot header + stub
bits32

section .multiboot
	align 4
	dd 0x1BADB002
	dd 0x00000003				;flags align module + request memory information
	dd -(0x1BADB002 - 0x00000003)		;checksum

section .text
global kernel_entry
extern kernel_main

kernel_entry:
	cli
	;setup basic stack (Info: Grub doesn't guarantee usable stack)
	mov esp, 0x90000
	call kernel_main			; C kernel (function entry point)

.halt:
	cli
	hlt
	jmp .halt
	
