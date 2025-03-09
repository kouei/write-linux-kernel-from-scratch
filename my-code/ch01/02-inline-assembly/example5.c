#include <stdio.h>

/*
 * If a register is declared in the "Clobbers" section, then:
 *
 *     1. Before the execution of the __asm__ block, its value will be saved somewhere else.
 *     2. During the execution of the __asm__ block, its value may be modified.
 *     3. After the execution of the __asm__ block, its value will be recovered.
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

void set_bx_with_clobbers(unsigned long val) {
	__asm__ __volatile__ (
        "mov %[val], %%bx"
        :                                    // Output Operands
        : [val] "r" ((unsigned short) val)   // Input Operands
        : "%bx"                              // Clobbers
    );
}

int main() {
    
    printf("Value in register %%BX = %lu\n", get_bx());

    set_bx_with_clobbers(1);
    printf("Set value in register %%BX to 1 (with clobbers)\n");
    
    printf("Value in register %%BX = %lu\n", get_bx());

    return 0;
}