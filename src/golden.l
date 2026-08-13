%{

%}

STRING \"[^\"]*\"

%%

{STRING} {
    printf("STRING: %s\n", yytext);
}

%%

int main() {
    yyin = fopen("examples/test.au", "r");
    yylex();
    fclose(yyin);
    return 0;
}