#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include "ast.h"

static Vars* tab = NULL;

void report_error(char* msg) { printf("Error: %s\n", msg); }

static Vars* search_var(char* name) {
    Vars* l_aux = tab;
    while (l_aux != NULL) {
        if (strcmp(name, l_aux->name) == 0) 
            return l_aux;
        l_aux = l_aux->prox;    
    }
    return NULL;
}

static Vars* new_var(char* name) {
    Vars* p = calloc(1, sizeof(Vars));
    strncpy(p->name, name, 49);
    p->prox = tab;
    tab = p;
    return p;
}

Ast* newNode(int type, Ast* l, Ast* r) {
    Ast* n = calloc(1, sizeof(Ast));
    n->nodetype = type;
    n->left = l;
    n->right = r;
    return n;
}

Ast* newFloat(float v) {
    Ast* n = calloc(1, sizeof(Ast));
    n->nodetype = NODE_FLOAT;
    n->v = v;
    return n;
}

Ast* newVar(char* name) {
    Ast* n = calloc(1, sizeof(Ast));
    n->nodetype = NODE_VAR;
    strncpy(n->name, name, 49);
    return n;
}

Ast* newNamed(int type, char* name, Ast* l) {
    Ast* n = calloc(1, sizeof(Ast));
    n->nodetype = type;
    strncpy(n->name, name, 49);
    n->left = l;
    return n;
}

Ast* newStr(char* s) {
    Ast* n = calloc(1, sizeof(Ast));
    n->nodetype = NODE_PRINTSTR;
    n->str = strdup(s);
    return n;
}

Ast * newCmp(int op_type, Ast *l, Ast *r) {
	Ast *new = (Ast*)malloc(sizeof(Ast));
	switch(op_type){
		case 1: new->nodetype = NODE_G; break;
		case 2: new->nodetype = NODE_L; break;
		case 3: new->nodetype = NODE_GE; break;
		case 4: new->nodetype = NODE_LE; break;
		case 5: new->nodetype = NODE_E; break;
		case 6: new->nodetype = NODE_D; break;
	}
	new->left = l;
	new->right = r;
	return new;
}

Ast * newFlow(int nodetype, Ast *cond, Ast *l, Ast *r) {
	Ast *new = (Ast*)malloc(sizeof(Ast));
	new->nodetype = nodetype;
	new->cond = cond;
	new->left = l;
	new->right = r;
	return new;
}

float eval(Ast* n) {
    if (!n) return 0;
    switch (n->nodetype) {
        case NODE_FLOAT: return n->v;
        case NODE_VAR: {
            Vars* p = search_var(n->name);
            if (!p) { report_error("Variable not defined"); return 0; }
            return p->valor;
        }
        case NODE_G:   return (eval(n->left) > eval(n->right))  ? 1 : 0; break;
        case NODE_L:   return (eval(n->left) < eval(n->right))  ? 1 : 0; break;
        case NODE_GE:  return (eval(n->left) >= eval(n->right)) ? 1 : 0; break;
        case NODE_LE:  return (eval(n->left) <= eval(n->right)) ? 1 : 0; break;
        case NODE_E:   return (eval(n->left) == eval(n->right)) ? 1 : 0; break;
        case NODE_D:   return (eval(n->left) != eval(n->right)) ? 1 : 0; break;
        case NODE_ADD: return eval(n->left) + eval(n->right);
        case NODE_SUB: return eval(n->left) - eval(n->right);
        case NODE_MUL: return eval(n->left) * eval(n->right);
        case NODE_DIV: {
            float d = eval(n->right);
            if (d == 0) { report_error("Division by zero"); return 0; }
            return eval(n->left) / d;
        }
        case NODE_SQRT: {
            float x = eval(n->left);
            if(x < 0) {
                printf("Undefined\n"); 
                return 0;
            } return sqrt(x);
        }
        case NODE_POW: return powf(eval(n->left), eval(n->right));
        case NODE_SIN: return sin(eval(n->left));
        case NODE_COS: return cos(eval(n->left));
        case NODE_TAN: return tan(eval(n->left));
        case NODE_LOG: {
            float x = eval(n->left);
            if(x < 0) {
                printf("Undefined\n"); 
                return 0;  
            }
            return log10(x);
        }
        case NODE_ABS: return fabs(eval(n->left));
        case NODE_NEG: return -eval(n->left);
        case NODE_DECL: {
            if (search_var(n->name)) { report_error("Variable already declared"); return 0; }
            Vars* p = new_var(n->name);
            p->valor = eval(n->left); 
            return p->valor;
        }
        case NODE_ATRIB: {
            Vars* p = search_var(n->name);
            if (!p) { report_error("Variable not defined"); return 0; }
            p->valor = eval(n->left);
            return p->valor;
        }
        case NODE_PRINT: {
            float v = eval(n->left);
            printf("%g\n", v);
            return v;
        }
        case NODE_PRINTSTR: {
            printf("%s\n", n->str);
            return 0;
        }
        case NODE_INPUT: {
            Vars* p = search_var(n->name);
            if (!p) { report_error("Variable not defined"); return 0; }

            float v;
            if (scanf("%f", &v) != 1) {
                report_error("Invalid input");
                int c;
                while ((c = getchar()) != '\n' && c != EOF);
                return 0;
            }
            p->valor = v;
            return v;
        }
        case NODE_IF:
            if (eval(n->cond) != 0)
                eval(n->left);
            return 0;

        case NODE_IFELSE:
            if (eval(n->cond) != 0)
                eval(n->left);
            else
                eval(n->right);
            return 0;
        case NODE_BLOCO:
            eval(n->left);
            return eval(n->right);
    }
    return 0;
}