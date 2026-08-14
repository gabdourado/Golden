%{
#include <stdio.h>
#include <string.h>

typedef enum{
    TYPE_INT,
    TYPE_FLOAT,
    TYPE_STR,
    TYPE_BOOL
} DataType;

typedef struct {
    char name[64];
    DataType type;
    union {
        int   i;
        float f;
        char  s[256];
        int   b;
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
void    symtab_set_bool (char* name, int   value);
Symbol* symtab_get      (char* name);

%}

%union {
    int   i;
    float f;
    char* str;
}

%token DECL INPUT PRINT ASSIGN SEMICOLON COLON
%token INT FLOAT STR BOOL
%token <i> NUM_INT
%token <f> NUM_FLOAT
%token <str> VARIABLE STRING

%%

%%