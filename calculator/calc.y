%{
    #include <stdio.h>
    #include <stdlib.h>
    int yylex(void);
    int yyerror(char *s) {
        printf("%s\n", s);
    }
%}


%token VALOR
%left '+'
%left '*'

%%

prog : E prog {printf("%d\n", $1);}
    | E  {printf("%d\n", $1);}
    ;

E: E '+' E    {$$ = $1 + $3;}
    | E '*' E {$$ = $1 * $3;}
    | VALOR {$$ = $1;}   
    ;
%%

#include "lex.yy.c"

int main (void) {
    yyin = fopen("test.au", "r");
    yyparse();
    fclose(yyin);
    return 0;
}