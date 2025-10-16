#include "print.h"

/* VGA text mode constants*/
#define VGA_WIDTH 80
#define VGA_HEIGHT 25
#define VGA_BUF_SIZE (VGA_WIDTH * VGA_HEIGHT)

/* VGA text memory (each entry: low byte = char, high byte = attribute) */
static volatile uint16_t * const video = (volatile uint16_t *)0xB8000;

/* Cursor position ( index into text buffer ) */
static size_t cursor_pos = 0;

/*
 * Current text attribute (High byte of each word)
 */
static uint8_t text_color = 0x0F; /* Black background, bright white foreground*/

/*
 * Internal helper: scroll screen up by one line if cursor passes end
 */
static void scroll_if_needed(void){
    if (cursor_pos < VGA_BUF_SIZE) return;
    
    /* Move each line up by one (line i -> line i - 1) */
    for (size_t row = 1; row < VGA_HEIGHT; ++row)
    {
        for (size_t col = 0; col < VGA_WIDTH; ++col)
        {
            video[(row - 1) * VGA_WIDTH + col] = video[row * VGA_WIDTH + col];
        }
        
    }
    
    /* Clear last line*/
    uint16_t blank = ((uint16_t)text_color << 8) | (uint8_t)' ';
    for (size_t col = 0; col < VGA_WIDTH; ++col)
    {
        video[(VGA_HEIGHT - 1) * VGA_WIDTH + col] = blank;
    }

    /* Move cursor black one full line */
    cursor_pos -= VGA_WIDTH;
}

/* Set current text color attribute */
void set_text_color(uint8_t color){
    text_color = color;
}

/** Fill screen with spaces using current text color */
void clear_screen(void){
    uint16_t entry = ((uint16_t)text_color << 8) | (uint8_t)' ';
    for (size_t i = 0; i < VGA_BUF_SIZE; i++)
    {
        video[i] = entry;
    }

    cursor_pos = 0;
}

/* Print a single character; handle newline and carriage return */
void print_char(char c){
    if (c == '\r')
    {
        /* Carriage return -> move to start of line */
        cursor_pos -= (cursor_pos % VGA_WIDTH);
        return;
    }
    if (c == '\n')
    {
        /* newline -> move to start of next line */
        cursor_pos += VGA_WIDTH - (cursor_pos % VGA_WIDTH);
        scroll_if_needed();
        return;
    }

    /* Regular printable char */
    uint16_t entry = ((uint16_t)text_color << 8) | (uint8_t)c;
    video[cursor_pos++] = entry;
    scroll_if_needed();
}

/* Print zero terminated screen */
void print_string(const char *str){
    for (size_t i = 0; str[i] != '\0'; ++i)
    {
        print_char(str[i]);
    }
        
}