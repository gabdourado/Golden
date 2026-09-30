%{  
    #include <stdio.h>
    #include <math.h>
    #include "symtab.h"

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

E   : E '+' T {$$ = $1 + $3;}
    | E '-' T {$$ = $1 - $3;}
    | T       {$$ = $1;}
    ;

T   : T '*' U {$$ = $1 * $3;}
    | T '/' U {
        if($3 != 0) {$$ = $1 / $3;}
        else        {printf("Undefined\n"); $$ = 0;}
    }
    | U       {$$ = $1;}
    ;

U   : '-' U   {$$ = -$2;}
    | P       {$$ = $1;}
    ;

P   : F '^' U {$$ = pow($1, $3);}
    | F       {$$ = $1;}
    ;

F   : '(' E ')' {$$ = $2;}
    | NUM       {$$ = $1;}
    | VAR {
        float out;
        if(!symtab_get($1, &out)) { printf("Variable not defined\n"); $$ = 0;}
        else { $$ = out; }

    }
    | SQRT '(' E ')'  {
        if($3 >= 0) {$$ = sqrt($3);}
        else       {printf("Undefined\n"); $$ = 0;}
    }
    | SIN  '(' E ')'  {$$ = sin($3);}
    | COS  '(' E ')'  {$$ = cos($3);}
    | TAN  '(' E ')'  {$$ = tan($3);}
    | LOG  '(' E ')'  {
        if($3 > 0) {$$ = log10($3);}
        else       {printf("Undefined\n"); $$ = 0;}
    }
    | ABS  '(' E ')'  {$$ = fabs($3);}
    ;

%%

#include "lex.yy.c"

int main (void) {
    symtab_init();
    yyparse();
    return 0;
}