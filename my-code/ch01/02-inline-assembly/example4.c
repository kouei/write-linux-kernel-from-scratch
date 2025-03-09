#include <stdio.h>

/*
 * Another implementation of example3.c
 */

unsigned long get_bx() {
    unsigned short val;
    
    __asm__ __volatile__ (
        "mov %%bx, %[val]"
        : [val] "=r" (val) // Output Operands
        :                // Input Operands
        :                // Clobbers
    );

    return val;
}

void set_bx(unsigned long val) {
	__asm__ __volatile__ (
        "mov %[val], %%bx"
        :                                    // Output Operands
        : [val] "r" ((unsigned short) val)   // Input Operands
        :                                    // Clobbers
    );
}

int main() {
    printf("Value in register %%BX = %lu\n", get_bx());

    set_bx(1);
    printf("Set value in register %%BX to 1\n");
    
    printf("Value in register %%BX = %lu\n", get_bx());
    
    return 0;
}