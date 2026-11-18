#ifndef AST_H
#define AST_H

typedef enum {
    NODE_FLOAT, NODE_VAR,
    NODE_ADD, NODE_SUB, NODE_MUL, NODE_DIV, NODE_NEG, NODE_ABS,
    NODE_DECL, NODE_ATRIB, NODE_PRINT, NODE_BLOCO
} NodeType;

typedef struct ast {
    int nodetype;
    struct ast *left, *right, *cond;
    char name[50];
    float v;
} Ast;

Ast*  newNode(int type, Ast* l, Ast* r);
Ast*  newFloat(float v);
Ast*  newVar(char* name);
Ast*  newNamed(int type, char* name, Ast* l);
float eval(Ast* n);
void  report_error(char* msg);

#endif