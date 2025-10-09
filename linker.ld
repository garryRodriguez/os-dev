ENTRY(kernel_entry)

SECTIONS
{
	/* Put the image at 1MB (GRUB can load ELF anywhere, 1MB is conventional)  */
	. = 0x00100000;

	.multiboot ALIGN(4) : { *(.multiboot) }

	.text ALIGN(4) : {
		*(.text)
		*(.text.*)
	}

	.rodata ALIGN(4) : { *(.rodata) }
	.data ALIGN(4) : { *(.data)}

	.bss ALIGN(4) : {
		*(.bss)
		*(COMMON)
	}
}
