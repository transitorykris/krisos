// A simplified version of the example at
// https://cc65.github.io/doc/customizing.html

#include <stdio.h>

int main () {
    char c = 0;

    puts("Hello, World!");        //  Transmit "Hello World!"
    puts("Type something!");
    while(c != '\r') {
        c = getchar();
        putchar(c);
    }
    putchar('\n');
    putchar('\r');
    
    puts("Goodbye...");
    
    return(0x1234);
}
