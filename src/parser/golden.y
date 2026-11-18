%{
    #include <stdio.h>
    #include "ast/ast.h"

    int  yylex(void);
    void yyerror(char *s) { printf("%s\n", s); }
%}

%union {
    float Float;
    char* Str;
    Ast*  a;
}

%token <Float> NUM
%token <Str> VAR STRING
%token PRINT INPUT FLOAT SQRT SIN COS TAN LOG ABS

%type <a> statement declaration decl_list decl_item assignment write E T U F

%%

prog
    :
    | prog statement { eval($2); }
    ;

statement
    : declaration { $$ = $1; }
    | assignment  { $$ = $1; }
    | write       { $$ = $1; }
    ;

declaration
    : FLOAT decl_list { $$ = $2; }
    ;

decl_list
    : decl_item                  { $$ = $1; }
    | decl_list ',' decl_item    { $$ = newNode(NODE_BLOCO, $1, $3); }
    ;

decl_item
    : VAR         { $$ = newNamed(NODE_DECL, $1, NULL); }
    | VAR '=' E   { $$ = newNamed(NODE_DECL, $1, $3); }
    ;

assignment
    : VAR '=' E   { $$ = newNamed(NODE_ATRIB, $1, $3); }
    ;

write
    : PRINT '(' E ')'      { $$ = newNode(NODE_PRINT, $3, NULL); }
    | PRINT '(' STRING ')' { $$ = newStr($3); }
    ;

E   : E '+' T { $$ = newNode(NODE_ADD, $1, $3); }
    | E '-' T { $$ = newNode(NODE_SUB, $1, $3); }
    | T       { $$ = $1; }
    ;

T   : T '*' U { $$ = newNode(NODE_MUL, $1, $3); }
    | T '/' U { $$ = newNode(NODE_DIV, $1, $3); }
    | U       { $$ = $1; }
    ;

U   : '-' U   { $$ = newNode(NODE_NEG, $2, NULL); }
    | F       { $$ = $1; }
    ;

F   : '(' E ')'      { $$ = $2; }
    | NUM            { $$ = newFloat($1); }
    | VAR            { $$ = newVar($1); }
    | SQRT '(' E ')' { $$ = newNode(NODE_SQRT, $3, NULL); }
    | SIN  '(' E ')' { $$ = newNode(NODE_SIN,  $3, NULL); }
    | COS  '(' E ')' { $$ = newNode(NODE_COS,  $3, NULL); }
    | TAN  '(' E ')' { $$ = newNode(NODE_TAN,  $3, NULL); }
    | LOG  '(' E ')' { $$ = newNode(NODE_LOG,  $3, NULL); }
    | ABS  '(' E ')' { $$ = newNode(NODE_ABS,  $3, NULL); }
    ;

%%

#include "lex.yy.c"

int main(int argc, char **argv) {
    yyin = fopen(argv[1], "r");
    int r = yyparse();
    fclose(yyin);
    return r;
}