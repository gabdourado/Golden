#ifndef AST
#define AST

AST* newNode(AST* l, AST* r, NodeType t);
AST* newLeaf(int v);
int eval(AST* n);

#endif