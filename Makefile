AS = nasm
CC = gcc
LD = ld

CFLAGS = -m32 -ffreestanding -fno-builtin -O2 -Wall
LDFLAGS = -m elf_i386 -T linker.ld

all: os.iso

boot.o: boot.s
	$(AS) -f elf32 boot.s -o boot.o

kernel.o: kernel.c
	$(CC) $(CFLAGS) -c kernel.c -o kernel.o

kernel.bin: boot.o kernel.o
	$(LD) $(LDFLAGS) -o kernel.bin boot.o kernel.o --oformat elf32-i386

iso/boot/grub/grub.cfg:
	mkdir -p iso/boot/grub
	printf 'set timeout=1\nset default=0\n\nmenuentry "Rodz OS Kernel" {\n multiboot /boot/kernel.bin\n boot\n}\n' > iso/boot/grub/grub.cfg

os.iso: kernel.bin iso/boot/grub/grub.cfg
	mkdir -p iso/boot/
	cp kernel.bin iso/boot/
	grub-mkrescue -o os.iso iso

clean:
	rm -f *.o kernel.bin os.iso
	rm -rf iso
