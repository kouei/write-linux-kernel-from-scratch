#include<stdio.h>

extern int func();

int main() {
    int x = func();
    printf("x = %d\n", x);
    return 0;
}