#include <math.h>
#include <stdio.h>
#include "operations.h"

float op_sum(float a, float b) { return a + b; }

float op_dif(float a, float b) { return a - b; }

float op_mul(float a, float b) { return a * b; }

float op_div(float a, float b) {
    if (b == 0) {
        printf("Undefined\n"); 
        return 0;
    }
    return a / b;
}

float op_pow(float a, float b) {
    if (a == 0 && b == 0) {
        printf("Undefined\n"); 
        return 0;   
    }
    return pow(a, b);
}

float op_sqr(float a) {
    if(a < 0) {
        printf("Undefined\n"); 
        return 0;
    }
    return sqrt(a);
}

float op_sin(float a) { return sin(a); }

float op_cos(float a) { return cos(a); }

float op_tan(float a) { return tan(a); }

float op_log(float a) {
    if(a < 0) {
        printf("Undefined\n"); 
        return 0;  
    }
    return log10(a);
}

float op_abs(float a) { return fabs(a); }