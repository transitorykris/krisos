# Examples

## What's in here?

 * A bunch of random examples that I've used to test various aspects of KrisOS
 * Start in `tiny` for the tiniest of examples
 * `c` contains the beginnings of the C compiler chain, and a standard library that works on KrisOS

## Notes

 * The Makefile adds two bytes to the start of the binary these
 are tell KrisOS where to store the file in memory
 * This is little endian
 * All executables must be loaded at $1000
