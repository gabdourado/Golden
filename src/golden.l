%{
#include "golden.tab.h"
%}

VARIABLE [a-zA-Z][a-zA-Z0-9_]*
COMMENT  #[^\n]*
NUM      [0-9]+(\.[0-9]*)?
STRING   \"[^"]*\"

DECL  "let"
INPUT "input"
PRINT "print"

INT   "int"
FLOAT "float"
STR   "str"
BOOL  "bool"
TRUE  "true"
FALSE "false"

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

{DECL}      {return DECL;}
{INT}       {return INT;}
{FLOAT}     {return FLOAT;}
{STR}       {return STR;}
{BOOL}      {return BOOL;}
{TRUE}      {yylval.i = 1; return VALUE_BOOL;}
{FALSE}     {yylval.i = 0; return VALUE_BOOL;}
{INPUT}     {return INPUT;}
{PRINT}     {return PRINT;}
{ASSIGN}    {return ASSIGN;}
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
{SEMICOLON} {return SEMICOLON;}
{LPAREN}    {return LPAREN;}
{RPAREN}    {return RPAREN;}
{LBRACE}    {printf("LBRACE: %s\n", yytext);}
{RBRACE}    {printf("RBRACE: %s\n", yytext);}
{COLON}     {return COLON;}
{COMMA}     {printf("COMMA: %s\n", yytext);}
{VARIABLE}  {yylval.str = strdup(yytext); return VARIABLE;}
{NUM}       {
                if (strchr(yytext, '.') != NULL) {
                    yylval.f = atof(yytext);
                    return NUM_FLOAT;
                } else {
                    yylval.i = atoi(yytext);
                    return NUM_INT;
                }
            }
{STRING}    {
                yytext[strlen(yytext)-1] = '\0';
                yylval.str = strdup(yytext+1);
                return STRING;
            }

{COMMENT}   ;

[ \n\t] ;

. {printf("Error, character don't recognize: %s\n", yytext);}

%%