#include <string.h>
#include "symtab.h"

typedef struct {
    char  nome[NOME_MAX];
    float valor;
} variavel;

typedef struct {
    int      tam;
    variavel lista[SYMTAB_MAX];
} variaveis;

static variaveis V;

void symtab_init(void) { V.tam = 0; }

int symtab_full(void) { return V.tam >= SYMTAB_MAX; }

int symtab_busca_idx(const char *nome) {
    for (int i = 0; i < V.tam; i++)
        if (strcmp(nome, V.lista[i].nome) == 0) return i;
    return -1;
}

int symtab_declara(const char *nome, float valor) {
    int idx = symtab_busca_idx(nome);
    if (idx < 0) {
        if (symtab_full()) return -1;
        idx = V.tam++;
        strncpy(V.lista[idx].nome, nome, NOME_MAX - 1);
        V.lista[idx].nome[NOME_MAX - 1] = '\0';
        V.lista[idx].valor = valor;
        return 1;
    }
    return 0;
}

int symtab_set(const char *nome, float valor) {
    int idx = symtab_busca_idx(nome);
    if (idx < 0)      { return  0; }
    V.lista[idx].valor = valor;
    return 1;
}

int symtab_get(const char *nome, float *out) {
    int idx = symtab_busca_idx(nome);
    if (idx < 0) return 0;
    *out = V.lista[idx].valor;
    return 1;
}