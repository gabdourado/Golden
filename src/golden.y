%{  
    #include <stdio.h>
    #include "symtab.h"
    #include "operations.h"
    #include "io.h"

    int  yylex(void);
    void yyerror(char *s) { printf("%s\n", s); }
%}

%union{
    float Float;
    char* Str;
}

%token <Float> NUM
%token <Str> VAR STRING
%token PRINT INPUT FLOAT SQRT SIN COS TAN LOG ABS

%type <Float> E T P F U

%%

prog 
    : 
    |  prog statement
    ;

statement 
    : declaration
    | assignment
    | write
    | read
    ;

declaration
    : FLOAT VAR {
        int r = symtab_declara($2, 0.0f);
        if (r == -1)     { report_error("Mememory error"); }
        else if (r == 0) { report_error("Variable already declared"); }
    }
    | FLOAT VAR '=' E {
        int r = symtab_declara($2, $4);
        if (r == -1)     { report_error("Mememory error"); }
        else if (r == 0) { report_error("Variable already declared"); }
    }
    ;

write
    : PRINT '(' E ')'      { op_write_float($3); }
    | PRINT '(' STRING ')' { op_write_str($3); }
    ;

read
    : INPUT '(' VAR ')' {
        float v;
        if (!op_read(&v))            { report_error("Invalid input"); } 
        else if (!symtab_set($3, v)) { report_error("Variable not defined"); }
    }
    ;

assignment
    : VAR '=' E {
        if (!symtab_set($1, $3)) { report_error("Variable not defined"); }
    }
    ;

E   : E '+' T { $$ = op_sum($1, $3); }
    | E '-' T { $$ = op_dif($1, $3); }
    | T       { $$ = $1; }
    ;

T   : T '*' U { $$ = op_mul($1, $3); }
    | T '/' U { $$ = op_div($1, $3); }
    | U       { $$ = $1; }
    ;

U   : '-' U   { $$ = -$2; }
    | P       { $$ = $1; }
    ;

P   : F '^' U { $$ = op_pow($1, $3); }
    | F       { $$ = $1; }
    ;

F   : '(' E ')' { $$ = $2; }
    | NUM       { $$ = $1; }
    | VAR {
        float out;
        if(!symtab_get($1, &out)) { report_error("Variable not defined"); $$ = 0;}
        else { $$ = out; }

    }
    | SQRT '(' E ')'  { $$ = op_sqr($3); }
    | SIN  '(' E ')'  { $$ = op_sin($3); }
    | COS  '(' E ')'  { $$ = op_cos($3); }
    | TAN  '(' E ')'  { $$ = op_tan($3); }
    | LOG  '(' E ')'  { $$ = op_log($3); }
    | ABS  '(' E ')'  { $$ = op_abs($3); }
    ;

%%

#include "lex.yy.c"

int main(int argc, char **argv) {
    yyin = fopen(argv[1], "r");
    symtab_init();
    int r = yyparse();
    fclose(yyin);
    return r;
}