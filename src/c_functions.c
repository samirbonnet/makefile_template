#include "c_functions.h"
#include <stdio.h>

void print_c_message(const char* message) {
    printf("C function says: %s\n", message);
}

int add_numbers(int a, int b) {
    return a + b;
}