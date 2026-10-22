#include <stdlib.h>
#include "ast/ast.h"
#include "operations/operations.h"


typedef enum {NODE_INT, NODE_VAR, NODE_ADD, NODE_DIF, NODE_MUL, NODE_DIV} NodeType;

typedef struct Ast {
    NodeType type;
    struct Ast* left;
    struct Ast* right;
    float value;
} Ast;

Ast* newNode(Ast* l, Ast* r, NodeType t) {
    Ast* new   = (Ast*) malloc(sizeof(Ast));
    new->type  = t;
    new->left  = l;
    new->right = r;
    return new;
}

Ast* newLeaf(float v) {
    Ast* new   = (Ast*) malloc(sizeof(Ast));
    new->type  = NODE_INT;
    new->left  = NULL;
    new->right = NULL;
    new->value = v;
    return new;
}

int eval(Ast* n) {
    switch(n->type){
        case NODE_INT: return n->value; break;
        case NODE_VAR: {
            float v;
            if (!symtab_get(n->name, &v)) { report_error("Variable not defined"); return 0; }
            return v;
        }
        case NODE_ADD: return op_sum(eval(n->left), eval(n->right)); break;
        case NODE_DIF: return op_dif(eval(n->left), eval(n->right)); break;
        case NODE_MUL: return op_mul(eval(n->left), eval(n->right)); break;
        case NODE_DIV: return op_div(eval(n->left), eval(n->right)); break;
    }
}