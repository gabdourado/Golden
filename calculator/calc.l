%{
    
%}

NUM [0-9]+(\.[0-9]+)?
VAR [a-zA-Z_][a-zA-Z0-9_]*

%%

{NUM} {
    yylval.Float = atof(yytext);
    return NUM;
}

"print" {return PRINT;}
"sqrt"  { return SQRT;}
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

[-+*/()=^] {return *yytext;}

[\ \n\t]+ {;}

%%