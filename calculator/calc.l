%{
    
%}

NUM [0-9]+(\.[0-9]+)?
PRINT "print"
VAR [a-zA-Z_][a-zA-Z0-9_]*

%%

{NUM} {
    yylval.Float = atof(yytext);
    return NUM;
}


{PRINT} {return PRINT;}

{VAR} {
    yylval.Str = strdup(yytext);
    return VAR;
}

[-+*/()=^] {return *yytext;}

[\ \n\t]+ {;}

%%