%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>

    typedef struct {
        char* nome;
        float valor;
    } variavel;

    typedef struct {
        int tam;
        variavel lista[100];
    } variaveis;

    variaveis V;

    int yylex(void);
    int yyerror(char *s) {
        printf("%s\n", s);
    }
%}

%union{
    float Float;
    int Int;
    char* Str;
}

%token <Float> VALOR
%token <Str> VAR
%token PRINT
%left '+' '-'
%left '*' '/'

%type <Float> E;

%%

prog : prog cod
    |  cod
    ;

cod : 
    VAR '=' E {
        V.lista[V.tam].valor = $3;
        strcpy(V.lista[V.tam].nome, $1);
        V.tam++;
    }
    PRINT '(' VAR ')' {
        for(int i = 0; i < V.tam; i++) {
            if(strcmp($3, V.lista[i].nome) == 0) {
                printf("%2.f\n", V.lista[i].valor);
            }
        }
    }

E:    E '+' E   {$$ = $1 + $3;}
    | E '-' E   {$$ = $1 - $3;}
    | E '*' E   {$$ = $1 * $3;}
    | E '/' E   {$$ = $1 / $3;}
    | '(' E ')' {$$ = $2;}
    | VALOR {
                $$ = $1;
            }   
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