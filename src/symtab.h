#ifndef SYMTAB_H
#define SYMTAB_H

#define SYMTAB_MAX 100
#define NOME_MAX   64

void symtab_init(void);
int  symtab_full(void);
int  symtab_busca_idx(const char *nome);
int symtab_declara(const char *nome, float valor);
int  symtab_set(const char *nome, float valor);
int  symtab_get(const char *nome, float *out);

#endif