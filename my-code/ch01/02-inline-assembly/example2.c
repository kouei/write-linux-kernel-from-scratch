#include <stdio.h>

int main() {
    int out1, out2;
    int in1 = 1, in2 = 2, in3 = 3;

    __asm__ __volatile__ (
        "add %[in2], %[in3]\n\t"
        "add %[in1], %[in2]\n\t"
        "mov %[in3], %[out2]\n\t"
        "mov %[in2], %[out1]\n\t"
        : [out1] "=r" (out1), [out2] "=r" (out2)           // Output Operands, %out1 binds to out1, %out2 binds to out2
        : [in1] "r" (in1), [in2] "r" (in2), [in3] "r" (in3)  // Input Operands,  %in1 binds to in1,  %in2 binds to in2, %in3 binds to in3
        :                                              // Clobbers
    );

    printf("out1 = %d, out2 = %d\n", out1, out2);
    return 0;
}