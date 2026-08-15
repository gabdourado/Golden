%{
#include <stdlib.h>
#include <stdio.h>
#include <string.h>

typedef enum{
    TYPE_INT,
    TYPE_FLOAT,
    TYPE_STR,
} DataType;

typedef struct {
    char name[64];
    DataType type;
    union {
        int   i;
        float f;
        char  s[256];
    } value;
} Symbol;

typedef struct {
    Symbol s[100];
    int    length; 
} Table;

Table T;

void    symtab_set_int  (char* name, int   value);
void    symtab_set_float(char* name, float value);
void    symtab_set_str  (char* name, char* value);
Symbol* symtab_get      (char* name);

int yylex(void);
int yyerror(char *s);

extern FILE *yyin;

%}

%union {
    int   i;
    float f;
    char* str;
}

%token DECL INPUT PRINT ASSIGN SEMICOLON COLON LPAREN RPAREN
%token INT FLOAT STR
%token <i> NUM_INT
%token <f> NUM_FLOAT
%token <str> VARIABLE STRING

%%

programa:

    | programa statement
    ;

statement:
      declaration SEMICOLON
    | read        SEMICOLON
    | write       SEMICOLON
    ;

declaration:
    DECL VARIABLE COLON INT ASSIGN NUM_INT {
        symtab_set_int($2, $6);
    }
    | DECL VARIABLE COLON INT {
        symtab_set_int($2, 0);
    }
    | DECL VARIABLE COLON FLOAT ASSIGN NUM_FLOAT {
        symtab_set_float($2, $6);
    }
    | DECL VARIABLE COLON FLOAT {
        symtab_set_float($2, 0);
    }
    | DECL VARIABLE COLON STR ASSIGN STRING {
        symtab_set_str($2, $6);
    }
    | DECL VARIABLE COLON STR {
        symtab_set_str($2, "");
    }
    ;

read:
    INPUT LPAREN VARIABLE RPAREN {
        char buffer[256];
        scanf("%s", buffer);

        Symbol* sym = symtab_get($3);
        if(sym == NULL) 
            printf("Error: Undeclared Variable %s\n", $3);
        else{
             switch(sym->type){
                case TYPE_INT: {
                                    char *endptr;
                                    long val = strtol(buffer, &endptr, 10);
                                    if (endptr == buffer) {
                                        printf("Type Error!\n");
                                    } else {
                                        symtab_set_int($3, (int)val);
                                    }
                                    break;
                                }
                case TYPE_FLOAT: {
                                    char *endptr;
                                    double val = strtod(buffer, &endptr);
                                    if (endptr == buffer) {
                                        printf("Type Error!\n");
                                    } else {
                                        symtab_set_float($3, (float)val);
                                    }
                                    break;
                                }
                case TYPE_STR:   symtab_set_str($3, buffer); break;
            }
        }
    }
    ;

write:
    PRINT LPAREN VARIABLE RPAREN {
        Symbol* sym = symtab_get($3);
        if(sym == NULL)
            printf("Error: Undeclared Variable %s\n", $3);
        else {
            switch(sym->type){
                case TYPE_INT:   printf("%d\n", sym->value.i); break;
                case TYPE_FLOAT: printf("%f\n", sym->value.f); break;
                case TYPE_STR:   printf("%s\n", sym->value.s); break;
            }
        }
    }
    | PRINT LPAREN STRING RPAREN {
        printf("%s", $3);
    }
    ;  
%%

void symtab_set_int(char* name, int value) {
    for(int pos = 0; pos < T.length; pos++) {
        if(strcmp(T.s[pos].name, name) == 0) {
            T.s[pos].value.i = value;
            return;
        }
    }
    strcpy(T.s[T.length].name, name);
    T.s[T.length].type    = TYPE_INT;
    T.s[T.length].value.i = value;
    T.length++;
}

void symtab_set_float(char* name, float value) {
    for(int pos = 0; pos < T.length; pos++) {
        if(strcmp(T.s[pos].name, name) == 0) {
            T.s[pos].value.f = value;
            return;
        }
    }
    strcpy(T.s[T.length].name, name);
    T.s[T.length].type    = TYPE_FLOAT;
    T.s[T.length].value.f = value;
    T.length++;
}

void symtab_set_str(char* name, char* value){
    for(int pos = 0; pos < T.length; pos++) {
        if(strcmp(T.s[pos].name, name) == 0) {
            T.s[pos].type = TYPE_STR; 
            strcpy(T.s[pos].value.s, value);
            return;
        }
    }
    strcpy(T.s[T.length].name, name);
    T.s[T.length].type = TYPE_STR;
    strcpy(T.s[T.length].value.s, value);
    T.length++;
}

Symbol* symtab_get(char* name) {
    for(int pos = 0; pos < T.length; pos++) 
        if(strcmp(T.s[pos].name, name) == 0) 
            return &T.s[pos];
    return NULL;
    
}

int main() {
    yyin = fopen("examples/test.au", "r");
    yyparse();
    fclose(yyin);
    return 0;
}

int yyerror(char *s) {
    fprintf(stderr, "Erro sintatico: %s\n", s);
    return 0;
}