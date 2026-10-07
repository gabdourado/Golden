#include "io.h"
#include <stdio.h>

int op_read(float* out){
    return scanf("%f", out) == 1;
}
void op_write_str(char* out) {
    printf("%s\n", out);
}
void op_write_float(float out) {
    printf("%.6f\n", out);
}
void report_error(char* error) {
    printf("%s\n", error);
}