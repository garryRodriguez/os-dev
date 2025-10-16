# ################################################################################
#
# portable Makefile snippet that tries to use i386-elf-gcc if available,
# otherwise falls back to gcc -m32. 
#
# How to run this makefile:
#
# In terminal inside c-kernel folder: run the following:
#    * make clean
#    * make
#    * qemu-system-i386 -cdrom os.iso

# 
# ###############################################################################



AS = nasm
# prefer cross toolchain if available
CC := $(shell if command -v i386-elf-gcc >/dev/null 2>&1; then echo i386-elf-gcc; else echo gcc; fi)
LD := $(shell if command -v i386-elf-ld >/dev/null 2>&1; then echo i386-elf-ld; else echo ld; fi)

CFLAGS = -ffreestanding -fno-builtin -O2 -Wall
# if using host gcc, add -m32
ifeq ($(shell $(CC) --version 2>/dev/null | head -n 1 | grep -i "i386-elf" >/dev/null; echo $$?),0)
    # i386-elf-gcc: fine, no -m32 needed
else
    CFLAGS += -m32
    LDFLAGS = -m elf_i386
endif

all: os.iso

boot.o: boot.s
	$(AS) -f elf32 boot.s -o boot.o

kernel.o: kernel.c print.h
	$(CC) $(CFLAGS) -c kernel.c -o kernel.o

print.o: print.c print.h
	$(CC) $(CFLAGS) -c print.c -o print.o

kernel.bin: boot.o kernel.o print.o
	$(LD) $(LDFLAGS) -T linker.ld -o kernel.bin boot.o kernel.o print.o --oformat elf32-i386

iso/boot/grub/grub.cfg:
	mkdir -p iso/boot/grub
	printf 'set timeout=1\nset default=0\n\nmenuentry "rodzOS Kernel" {\n  multiboot /boot/kernel.bin\n  boot\n}\n' > iso/boot/grub/grub.cfg

os.iso: kernel.bin iso/boot/grub/grub.cfg
	mkdir -p iso/boot
	cp kernel.bin iso/boot/
	grub-mkrescue -o os.iso iso

clean:
	rm -f *.o kernel.bin os.iso
	rm -rf iso



#### THE CODE BELOW IS THE ORIGINAL MAKEFILE BEFORE CHANGES 10152025 #####

# AS = nasm
# CC = gcc
# LD = ld

# CFLAGS = -m32 -ffreestanding -fno-builtin -O2 -Wall
# LDFLAGS = -m elf_i386 -T linker.ld

# all: os.iso

# boot.o: boot.s
# 	$(AS) -f elf32 boot.s -o boot.o

# kernel.o: kernel.c
# 	$(CC) $(CFLAGS) -c kernel.c -o kernel.o

# kernel.bin: boot.o kernel.o
# 	$(LD) $(LDFLAGS) -o kernel.bin boot.o kernel.o --oformat elf32-i386

# iso/boot/grub/grub.cfg:
# 	mkdir -p iso/boot/grub
# 	printf 'set timeout=1\nset default=0\n\nmenuentry "Rodz OS Kernel" {\n multiboot /boot/kernel.bin\n boot\n}\n' > iso/boot/grub/grub.cfg

# os.iso: kernel.bin iso/boot/grub/grub.cfg
# 	mkdir -p iso/boot/
# 	cp kernel.bin iso/boot/
# 	grub-mkrescue -o os.iso iso

# clean:
# 	rm -f *.o kernel.bin os.iso
# 	rm -rf iso
