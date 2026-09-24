%{
    
%}

NUM [0-9]+
PRINT "print"
VAR [a-zA-Z]

%%

{NUM} {
    yylval.Float = atof(yytext);
    return VALOR;
}

{VAR} {
    return VAR;
}

{PRINT} {return PRINT;}

[-+*/()] {return *yytext;}

[\ \n\t]* {;}

%%