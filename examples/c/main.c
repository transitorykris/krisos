// A simplified version of the example at
// https://cc65.github.io/doc/customizing.html

extern void __fastcall__ puts(char *str);

int main () {
	puts("Hello, world!");                //  Transmit "Hello World!"

  return(0);                                     //  We should never get here!
}
