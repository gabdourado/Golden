%{  
    #include <stdio.h>
    #include "symtab.h"
    #include "operations.h"

    int  yylex(void);
    void yyerror(char *s) { printf("%s\n", s); }
%}

%union{
    float Float;
    char* Str;
}

%token <Float> NUM
%token <Str> VAR STRING
%token PRINT SQRT SIN COS TAN LOG ABS

%type <Float> E T P F U

%%

prog 
    : 
    |  prog statement
    ;

statement 
    : assingment
    | write
    ;

write
    : PRINT '(' E ')'      { printf("%.6f\n", $3); }
    | PRINT '(' STRING ')' { printf("%s\n", $3); }
    ;

assingment
    : VAR '=' E {
        if(!symtab_set($1, $3)) { printf("Mememory error"); } 
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
        if(!symtab_get($1, &out)) { printf("Variable not defined\n"); $$ = 0;}
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

int main (void) {
    symtab_init();
    yyparse();
    return 0;
}