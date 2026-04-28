# Project 2 - Assembly Double Program
CMSC313 - Dr. Kidd

Reads a number from stdin, doubles it, and prints the result.

## How to Run (on gl-server)

Assemble:
as --32 -o double.o double.s

Link:
ld -m elf_i386 -o double double.o

Run:
./double

An empty line will appear. Type your number and press Enter.

Expected output:
The double is: 10
