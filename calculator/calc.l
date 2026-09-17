%{
    
%}

NUM [0-9]+

%%

{NUM} {
    yylval = atoi(yytext);
    return VALOR;
}

"+" {
    return '+';
}

"*" {
    return '*';
}

[\ \n\t]* {;}

%%