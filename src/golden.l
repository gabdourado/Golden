%{

%}

VAR [a-zA-Z][a-zA-Z0-9_]*
COMMENT #[^\n]*
DECL "let"
NUM [0-9]+(\.[0-9]*)?

ASSIGN "="
EQ "=="
NEQ "!="
LT "<"
LTE "<="
GT ">"
GTE ">="

PLUS  "+"
MINUS "-"
MUL  "*"
DIV   "/"

SEMICOLON ";"

%%

{DECL} {
    printf("VARIABLE DECLARATION: %s\n", yytext);
}

{ASSIGN} {
    printf("ASSIGN: %s\n", yytext);
}

{SEMICOLON} {
    printf("SEMICOLON: %s\n", yytext);
}

{EQ} {
    printf("EQUAL: %s\n", yytext);
}

{NEQ} {
    printf("NOT EQUAL: %s\n", yytext);
}

{LT} {
    printf("LESS: %s\n", yytext);
}

{LTE} {
    printf("LESS OR EQUAL: %s\n", yytext);
}

{GT} {
    printf("GREATER: %s\n", yytext);
}

{GTE} {
    printf("GREATER OR EQUAL: %s\n", yytext);
}

{PLUS} {
    printf("PLUS: %s\n", yytext);
}

{MINUS} {
    printf("MINUS: %s\n", yytext);
}

{MUL} {
    printf("MUL: %s\n", yytext);
}

{DIV} {
    printf("DIV: %s\n", yytext);
}

{VAR} {
    printf("VARIABLE: %s\n", yytext);
}

{NUM} {
    printf("NUMBER: %s\n", yytext);
}

{COMMENT} {
    printf("COMMENT: %s\n", yytext);
}

[ \n\t] ;

. {
    printf("Error, character don't recognize: %s\n", yytext);
}

%%

int main() {
    yyin = fopen("examples/test.au", "r");
    yylex();
    fclose(yyin);
    return 0;
}