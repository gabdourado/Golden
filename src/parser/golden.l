%{
    #include <math.h>
%}

NUM [0-9]+(\.[0-9]+)?
VAR [a-zA-Z_][a-zA-Z0-9_]*
STRING \"[^"]*\" 

%%

{NUM} {
    yylval.Float = atof(yytext);
    return NUM;
}

"print" { return PRINT; }
"input" { return INPUT; }
"float" { return FLOAT; }
"sqrt"  { return SQRT; }
"sin"   { return SIN; }
"cos"   { return COS; }
"tan"   { return TAN; }
"log"   { return LOG; }
"abs"   { return ABS; }
"pi"    { yylval.Float = M_PI; return NUM; }
"euler" { yylval.Float = M_E;  return NUM; }

{VAR} {
    yylval.Str = strdup(yytext);
    return VAR;
}

{STRING} {
    yytext[strlen(yytext)-1] = '\0';
    yylval.Str = strdup(yytext + 1);
    return STRING;
}

[-+*/()=^,] {return *yytext;}

[\ \n\t]+ {;}

%%