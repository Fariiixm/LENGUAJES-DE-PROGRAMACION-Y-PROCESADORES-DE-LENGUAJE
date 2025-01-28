struct nodo {
    char *nombre;
    float valor;
    char *tipo;
    struct nodo *siguiente;
};

struct nodo *lista = NULL;
int si = 0;
char *ident;

void insertarTS(char *ident, float v,char *tipo) {
    if(si == 1){
        for (struct nodo *nod = lista; nod != NULL; nod = nod->siguiente) {
         if (strcmp(nod->nombre, ident) == 0) {
                nod->valor = v;
                nod->tipo =tipo;
                return;
         }
    }
    struct nodo *nod = malloc(sizeof(struct nodo));
    nod->nombre = ident;
    nod->valor = v;
    nod->tipo = tipo;
    nod->siguiente = lista;
    lista = nod;
    }
}

void imprimirTS() {
    printf("Identificador\tTipo de datos\tValor\n");
    for (struct nodo *nod = lista; nod != NULL; nod = nod->siguiente) {
        //printf("%s\t%s\t%f\n", nod->nombre,nod->tipo, nod->valor);
         /* if (nod->tipo == "int")  // en c no se puede comparar dos cadenas ==
            printf("%s\t%s\t%d\n", nod->nombre, nod->tipo, nod->valor);
         if (nod->tipo == "float") 
            printf("%s\t%s\t%f\n", nod->nombre, nod->tipo, nod->valor);
         if (nod->tipo == "scientific") 
            printf("%s\t%s\t%d\n", nod->nombre, nod->tipo, nod->valor);*/

        if (strcmp(nod->tipo, "int") == 0) 
            printf("%s\t%s\t%d\n", nod->nombre, nod->tipo, (int)nod->valor);
        else if (strcmp(nod->tipo, "float") == 0) //%.2f precision decimales
            printf("%s\t%s\t%.2f\n", nod->nombre, nod->tipo, (float)nod->valor);
        else if (strcmp(nod->tipo, "scientific") == 0) 
            printf("%s\t%s\t%.2f\n", nod->nombre, nod->tipo, (float)nod->valor);
    }
}

float buscarTS(char *ident) {
    for (struct nodo *nod = lista; nod != NULL; nod = nod->siguiente) {
        if (strcmp(nod->nombre, ident) == 0) {
            return nod->valor;
        }
    }
    printf("(El identificador '%s' no esta definido !!!)", ident);
    return 0;
}
