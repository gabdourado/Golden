%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>

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
        int idx = busca_idx($1);
        if(idx < 0) { idx = V.tam++; strcpy(V.lista[idx].nome, $1); }
        V.lista[idx].valor = $3;
    }
    | PRINT '(' VAR ')' {
        int idx = busca_idx($3);
        if(idx >= 0) { printf("%.2f\n", V.lista[idx].valor); }
        else { printf("Semantic Error\n"); }
    }
    ;
E:    E '+' E   {$$ = $1 + $3;}
    | E '-' E   {$$ = $1 - $3;}
    | E '*' E   {$$ = $1 * $3;}
    | E '/' E   {$$ = $1 / $3;}
    | '(' E ')' {$$ = $2;}
    | NUM       {$$ = $1;}
    | VAR {
        int idx = busca_idx($1);
        if (idx < 0) { printf("Variable not defined\n"); $$ = 0; }
        else $$ = V.lista[idx].valor;
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