%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    #include <math.h>

    typedef struct {
        char nome[50];
        float valor;
    } variavel;

    typedef struct {
        int tam;
        variavel lista[100];
    } variaveis;

    variaveis V;

    int busca_idx(char* nome) {
        for(int i = 0; i < V.tam; i++)
            if (strcmp(nome, V.lista[i].nome) == 0) return i;
        return -1;
    }

    int yylex(void);
    void yyerror(char *s) { printf("%s\n", s); }
%}

%union{
    float Float;
    char* Str;
}

%token <Float> NUM
%token <Str> VAR
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
    : PRINT '(' VAR ')' {
        int idx = busca_idx($3);
        if(idx >= 0) { printf("%.2f\n", V.lista[idx].valor); }
        else         { printf("Variable not defined\n"); }
    }
    ;

assingment
    : VAR '=' E {
        int idx = busca_idx($1);
        if(idx < 0) { idx = V.tam++; strcpy(V.lista[idx].nome, $1); }
        V.lista[idx].valor = $3;
    }
    ;

E :   E '+' T {$$ = $1 + $3;}
    | E '-' T {$$ = $1 - $3;}
    | T       {$$ = $1;}
    ;

T :   T '*' U {$$ = $1 * $3;}
    | T '/' U {
        if($3 != 0) {$$ = $1 / $3;}
        else        {printf("Undefined\n"); $$ = 0;}
    }
    | U       {$$ = $1;}
    ;

U : '-' U     {$$ = -$2;}
    | P       {$$ = $1;}
    ;

P :   F '^' U {$$ = pow($1, $3);}
    | F       {$$ = $1;}
    ;

F : '(' E ')'   {$$ = $2;}
    | NUM       {$$ = $1;}
    | VAR {
        int idx = busca_idx($1);
        if (idx < 0) { printf("Variable not defined\n"); $$ = 0; }
        else         {$$ = V.lista[idx].valor;}
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
    V.tam = 0;
    yyin = fopen("test.au", "r");
    yyparse();
    fclose(yyin);
    return 0;
}