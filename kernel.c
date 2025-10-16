/* Kernel.c*/
#include "print.h"

void kernel_main(void){
	set_text_color(0x1E); /* blue background, yellow-ish text  */
	clear_screen();

	print_string("Rodz OS: Welcome!\n");
	print_string("Type commands (later) - Test by Garry for now :) \n");
	print_string("Line 3 is the newline demonstration + scrolling.");

	/** for testing, print new line to see if scrolling works */
	for (int i = 0; i < 40; ++i) {
        print_string("Line ");
        /* tiny integer to ascii (no sprintf) */
        char buf[16];
        int len = 0;
        int n = i;
        if (n == 0) {
            buf[len++] = '0';
        } else {
            int t = n;
            char rev[16];
            int rlen = 0;
            while (t > 0) {
                rev[rlen++] = '0' + (t % 10);
                t /= 10;
            }
            while (rlen--) buf[len++] = rev[rlen];
        }
        buf[len++] = '\n';
        buf[len] = '\0';
        print_string(buf);
    }

    for (;;) {
        __asm__ __volatile__("hlt");
    }
}

/* THE CODE BELOW IS THE ORIGINAL CODE BEFORE CHANGES 10152025 */

/* kernel.c -- minimal freestanding c 'kernel' for now :) */
/* Info: There is no C standard library use in here as I plan to complile freestanding and avoid startup code */
// typedef unsigned int uint32_t;
// void kernel_main(void){
// 	const char *msg = "Hello from rodzOS team. You are booting from C Kernel";

	/* VGA text buffer at 0xB8000 (text mode). Each entry is 2 bytes: char + attribute */
	// volatile unsigned short *video = (volatile unsigned short*)0xB8000;
	//unsigned short color = (0x0F << 8); 	/* black bg, bright white fg */

	// for(int i = 0; msg[i] != '\0'; ++i){
	// 	video[i] = color | (unsigned char)msg[i];
	// }

	/* Loop forever (but halt CPU when idle) */
// 	for(;;){
// 		__asm__ __volatile__("hlt");
// 	}
// }
