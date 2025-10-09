/* kernel.c -- minimal freestanding c 'kernel' for now :) */
/* Info: There is no C standard library use in here as I plan to complile freestanding and avoid startup code */
typedef unsigned int uint32_t;
void kernel_main(void){
	const char *msg = "Hello from rodzOS team. You are booting from C Kernel";

	/* VGA text buffer at 0xB8000 (text mode). Each entry is 2 bytes: char + attribute */
	volatile unsigned short *video = (volatile unsigned short*)0xB8000;
	unsigned short color = (0x0F << 8); 	/* black bg, bright white fg */

	for(int i = 0; msg[i] != '\0'; ++i){
		video[i] = color | (unsigned char)msg[i];
	}

	/* Loop forever (but halt CPU when idle) */
	for(;;){
		__asm__ __volatile__("hlt");
	}
}
