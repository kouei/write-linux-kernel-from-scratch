#include <stdio.h>

/*
 * We didn't write get_fs() and set_fs() here,
 * because it will cause segment fault on modern linux (e.g., ubuntu).
 */

unsigned long get_bx() {
    unsigned short val;
    
    __asm__ __volatile__ (
        "mov %%bx, %%ax"
        : "=a" (val) // Output Operands, %ax binds to val
        :            // Input Operands
        :            // Clobbers
    );

    return val;
}

void set_bx(unsigned long val) {
	__asm__ __volatile__ (
        "mov %0, %%bx"
        :                              // Output Operands
        : "a" ((unsigned short) val)   // Input Operands, %ax binds to val (transformed to unsigned short)
        :                              // Clobbers
    );
}

int main() {
    printf("Value in register %%BX = %lu\n", get_bx());

    set_bx(1);
    printf("Set value in register %%BX to 1\n");
    
    printf("Value in register %%BX = %lu\n", get_bx());
    
    return 0;
}