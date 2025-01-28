%{
    #include<stdio.h>
    #include<stdlib.h>
    #include<string.h>
    #include"tablasimbolos.h"
%}


SIENDO ("siendo")
EVALUA ("evalua")
SCIENTIFIC [0-9]+\.?[0-9]*[E][+-]?[1-9]+
FLOAT  [0-9]+\.[0-9]+
INT    [0-9]+
ID     [_a-zA-Z][a-zA-Z0-9_]*
OP     [+|-|*|/]
SEP    [,]
ASSIGN [=]
PARENTC [)]
PARENTA [(]



%%

[\t\n\r]+

{SIENDO}    { printf( "<palabra_reservada; %s>\n", yytext ); si=1; }

{EVALUA}     { printf( "<palabra_reservada; %s>\n", yytext ); si=0; }

{SCIENTIFIC} { printf( "<scientific; %e>\n",    atof(yytext) ); if(si==1){ insertarTS(ident, atof(yytext), "scientific");} }

{FLOAT}    { printf("<float; %f>\n",    atof(yytext) ); if(si==1){ insertarTS(ident, atof(yytext), "float");}}

{INT}      { printf( "<int; %d>\n",    atoi(yytext) ); if(si==1){ insertarTS(ident, atoi(yytext), "int");} }



{ID}       { printf( "<identificador, %s>\n", yytext ); 
	     ident = (char*)malloc(32); 
             strcpy(ident,yytext);
             }

{OP}       { printf("<operacion_aritmetico ; %s>\n", yytext);}

{SEP}      { printf("<separador ; %s>\n", yytext);}

{ASSIGN}   { printf("<operador_asigancion ; %s>\n", yytext);}

{PARENTC}       { printf("<parentesis_cerrado ; %s>\n", yytext);}

{PARENTA}       { printf("<parentesis_abierto ; %s>\n", yytext);}




%%

void yyerror( const char *msg )
{
    fprintf( stderr, "error %s\n", msg );
}

int yywrap()
{
    return 1;
}

int main( int argc, char **argv ) 
{
    ++argv, --argc;  /* se salta el nombre del programa */
    if ( argc > 0 )
            yyin = fopen( argv[0], "r" );
    else
            yyin = stdin;
    
    yylex();

    imprimirTS();

    return 0;
}

