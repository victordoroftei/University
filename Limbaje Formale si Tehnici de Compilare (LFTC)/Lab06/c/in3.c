#include <stdio.h>
#include <stdlib.h>

int main() {
    int a, b, c;
    a = 10;
    b = 5;
    c = a / b;

    printf("%d", c);
    printf("\n");

    c = 25 / 6;
    printf("%d", c);
    printf("\n");

    c = 25 / a;
    printf("%d", c);
    printf("\n");

    c = b / 25;
    printf("%d", c);
    printf("\n");

    return 0;
}