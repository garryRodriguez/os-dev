#ifndef PRINT_H
#define PRINT_H

#include <stddef.h>
#include <stdint.h>

// Basic text colors (VGA attribute byte low nibble is foreground)
// high nibble is background
void set_text_color(uint8_t color);

// clear the screen and reset the cursor
void clear_screen(void);

// Print a single character (handles '\n' and '\r')
void print_char(char c);

// Print a zero-terminated string
void print_string(const char *str);

#endif /*PRINT_H*/