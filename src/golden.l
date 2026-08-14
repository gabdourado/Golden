%{

%}

VAR [a-zA-Z][a-zA-Z0-9_]*
COMMENT #[^\n]*
NUM [0-9]+(\.[0-9]*)?
STRING \"[^"]*\"

DECL  "let"
INPUT "input"
PRINT "print"

INT   "int"
FLOAT "float"
STR   "str"
BOOL  "bool"

ASSIGN "="
EQ     "=="
NEQ    "!="
LT     "<"
LTE    "<="
GT     ">"
GTE    ">="

PLUS  "+"
MINUS "-"
MUL   "*"
DIV   "/"

SEMICOLON ";"
LPAREN    "("
RPAREN    ")"
LBRACE    "{"
RBRACE    "}"
COLON     ":"
COMMA     ","

%%

{DECL}      {printf("VARIABLE DECLARATION: %s\n", yytext);}
{INT}       {printf("TYPE INT: %s\n", yytext);}
{FLOAT}     {printf("TYPE FLOAT: %s\n", yytext);}
{STR}       {printf("TYPE STR: %s\n", yytext);}
{BOOL}      {printf("TYPE BOOL: %s\n", yytext);}
{INPUT}     {printf("INPUT: %s\n", yytext);}
{PRINT}     {printf("OUTPUT: %s\n", yytext);}
{ASSIGN}    {printf("ASSIGN: %s\n", yytext);}
{EQ}        {printf("EQUAL: %s\n", yytext);}
{NEQ}       {printf("NOT EQUAL: %s\n", yytext);}
{LT}        {printf("LESS: %s\n", yytext);}
{LTE}       {printf("LESS OR EQUAL: %s\n", yytext);}
{GT}        {printf("GREATER: %s\n", yytext);}
{GTE}       {printf("GREATER OR EQUAL: %s\n", yytext);}
{PLUS}      {printf("PLUS: %s\n", yytext);}
{MINUS}     {printf("MINUS: %s\n", yytext);}
{MUL}       {printf("MUL: %s\n", yytext);}
{DIV}       {printf("DIV: %s\n", yytext);}
{SEMICOLON} {printf("SEMICOLON: %s\n", yytext);}
{LPAREN}    {printf("LPAREN: %s\n", yytext);}
{RPAREN}    {printf("RPAREN: %s\n", yytext);}
{LBRACE}    {printf("LBRACE: %s\n", yytext);}
{RBRACE}    {printf("RBRACE: %s\n", yytext);}
{COLON}     {printf("COLON: %s\n", yytext);}
{COMMA}     {printf("COMMA: %s\n", yytext);}
{VAR}       {printf("VARIABLE: %s\n", yytext);}
{NUM}       {printf("NUMBER: %s\n", yytext);}
{COMMENT}   {printf("COMMENT: %s\n", yytext);}
{STRING}    {printf("STRING: %s\n", yytext);}

[ \n\t] ;

. {printf("Error, character don't recognize: %s\n", yytext);}

%%

int main() {
    yyin = fopen("examples/test.au", "r");
    yylex();
    fclose(yyin);
    return 0;
}