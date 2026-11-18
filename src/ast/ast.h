#ifndef AST_H
#define AST_H

typedef enum {
    NODE_FLOAT, NODE_VAR, NODE_PRINTSTR, NODE_INPUT, NODE_G, NODE_L, NODE_GE, NODE_LE, NODE_E, NODE_D, 
    NODE_ADD, NODE_SUB, NODE_MUL, NODE_DIV, NODE_POW, NODE_NEG, NODE_SQRT, NODE_SIN, NODE_COS,
    NODE_TAN, NODE_ABS, NODE_LOG, NODE_DECL, NODE_ATRIB, NODE_PRINT, NODE_BLOCO, NODE_IF, NODE_IFELSE, NODE_WHILE
} NodeType;

typedef struct ast {
    int nodetype;
    struct ast *left, *right, *cond;
    char name[50];
    float v;
    char* str;
} Ast;

typedef struct vars {
    char name[50];
    float valor;
    struct vars* prox;
} Vars;

Ast*  newNode(int type, Ast* l, Ast* r);
Ast*  newFloat(float v);
Ast*  newVar(char* name);
Ast*  newNamed(int type, char* name, Ast* l);
Ast * newCmp(int op_type, Ast *l, Ast *r);
Ast*  newStr(char* s);
Ast * newFlow(int nodetype, Ast *cond, Ast *l, Ast *r);
float eval(Ast* n);
void  report_error(char* msg);

#endif