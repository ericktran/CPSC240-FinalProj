#/*
#Erick Tran
#CPSC240-01
#ericktran@csu.fullerton.edu
#Braking Force Program
#*/

#!/bin/bash
# Author: Erick Tran

echo "Assemble braking.asm"
nasm -f elf64 -l braking.lis -o braking.o braking.asm

echo "Compile final.cpp"
g++ -c -Wall -m64 -no-pie -o final.o final.cpp -std=c++17

echo "Link the object files"
g++ -m64 -no-pie -o a.out -std=c++17 braking.o final.o

echo "\n----- Run the program -----"
./a.out

#Delete some un-needed files
rm *.o
rm *.out
rm *.lis

echo "----- End Program -----"
