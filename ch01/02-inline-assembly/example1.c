#include <stdio.h>

int main() {
    int out1, out2;
    int in1 = 1, in2 = 2, in3 = 3;

    __asm__ __volatile__ (
        "add %3, %4\n\t"
        "add %2, %3\n\t"
        "mov %4, %1\n\t"
        "mov %3, %0\n\t"
        : "=r" (out1), "=r" (out2)        // Output Operands, %0 binds to out1, %1 binds to out2
        : "r" (in1), "r" (in2), "r" (in3)  // Input Operands,  %2 binds to in1,  %3 binds to in2, %4 binds to in3
        :                               // Clobbers
    );

    printf("out1 = %d, out2 = %d\n", out1, out2);
    return 0;
}