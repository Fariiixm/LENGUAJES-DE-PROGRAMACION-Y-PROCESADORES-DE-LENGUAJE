%{

   #include <stdio.h>
   #include <stdlib.h>
   #include <string.h>
   #include <math.h>
   
   #include "tablasimbolos.h"

   extern int  yylex(void);
   extern char *yytext;
   int yyerror(char *s);

   char *id, *id1, *id2;

%}
             

%union
{

  float valor_real;
  int   valor_ent;
  char* nombre;

}


%start S


%token TOKEN_ASIG
%token TOKEN_MAS
%token TOKEN_MENOS
%token TOKEN_MULT
%token TOKEN_DIV
%token TOKEN_PAA
%token TOKEN_PAC
%token TOKEN_EV
%token TOKEN_DN
%token TOKEN_COMA
%token TOKEN_LLAA
%token TOKEN_LLAC
%token TOKEN_IF
%token TOKEN_THEN
%token TOKEN_ELSE
%token TOKEN_MENOR
%token TOKEN_MAYOR
%token TOKEN_SWITCH
%token TOKEN_CASE
%token TOKEN_DEFAULT
%token TOKEN_DOSPUNTOS
%token TOKEN_PUNTOCOMA


%token <valor_ent>  TOKEN_INT
%token <valor_real> TOKEN_FLOAT
%token <valor_real> TOKEN_CIENTIFICO
%token <nombre>     TOKEN_ID


%type <valor_real> E0
%type <valor_real> E1
%type <valor_real> E2
%type <valor_real> CONDICIONAL
%type <valor_real> SWITCH;





%left TOKEN_MAS   TOKEN_MENOS 
%left TOKEN_MULT  TOKEN_DIV



%%



S : TOKEN_EV E0                       { printf("El resultado de evaluar el programa es %f\n", $2); }
  | TOKEN_EV CONDICIONAL              { printf("El resultado de evaluar el programa es %f\n", $2); }
  | TOKEN_DN LDs TOKEN_EV E0          { printf("El resultado de evaluar el programa es %f\n", $4); }
  | TOKEN_DN LDs TOKEN_EV CONDICIONAL { printf("El resultado de evaluar el programa es %f\n", $4); }
| TOKEN_DN LDs TOKEN_EV SWITCH
    {
      printf("El resultado de evaluar el programa es %.2f\n", $4);}
  ;


CONDICIONAL : TOKEN_IF 
                 TOKEN_PAA 
			       TOKEN_ID 
                      { 
					    id2 = NULL ;
				        id2 = (char *)malloc(15) ;             
				        sprintf(id2, "%s", $3) ;	
			          }
	               TOKEN_MAYOR 
				   E0 
				 TOKEN_PAC 
		      TOKEN_THEN 
			     TOKEN_LLAA 
				   E0 
				 TOKEN_LLAC 
			  TOKEN_ELSE 
			     TOKEN_LLAA 
				   E0 
				 TOKEN_LLAC 
			  { 
				if ( buscarTS(id2) > $6 ) $$ = $10 ;
			    else $$ = $14 ;
			  }
			;


LDs : LDs TOKEN_COMA D
    | D
    ;


D : TOKEN_ID      { 
                    printf("El valor del identificador %s es ", $1) ; 
                    id1 = NULL ;
			        id1 = (char *)malloc(15) ;             
				    sprintf(id1, "%s", $1) ; 
				  }			  
    TOKEN_ASIG E0      { 
	                     insertarTS(id1, $4) ; 
			             printf("%.2f.\n", $4) ; 
					   }
| 
 TOKEN_MENOR
    TOKEN_ID
                {
                    id = NULL;
                    id = (char *)malloc(15);
                    sprintf(id,"%s",$2); 

                }
    
TOKEN_COMA
    TOKEN_ID
                {
                    id2 = NULL;
                    id2 = (char *)malloc(15);
                    sprintf(id2,"%s",$5); 

                }
    
TOKEN_MAYOR
    TOKEN_ASIG
    
TOKEN_MENOR
    E0
            {
                printf("El valor del identificador %s es ", id);
                insertarTS(id, $10);
                printf("%.2f.\n", $10);
            }
    
TOKEN_COMA
    E0
            {
                printf("El valor del identificador %s es ", id2);
                insertarTS(id2, $13);
                printf("%.2f.\n", $13);
            }
    
TOKEN_MAYOR
    
;

SWITCH:    TOKEN_SWITCH TOKEN_PAA TOKEN_ID 
                              {
                                id1 = NULL;
                                id1 = (char *)malloc(15);
                                sprintf(id1, "%s", $3);
                              }
              TOKEN_PAC TOKEN_LLAA TOKEN_CASE E0 TOKEN_DOSPUNTOS E0 TOKEN_PUNTOCOMA TOKEN_CASE E0 TOKEN_DOSPUNTOS E0 TOKEN_PUNTOCOMA TOKEN_DEFAULT TOKEN_DOSPUNTOS E0 TOKEN_PUNTOCOMA TOKEN_LLAC
                              {
                                if ($8 == buscarTS(id1)) $$ = $10;
                                else if ($13 == buscarTS(id1)) $$ = $15;
                                else $$ = $19;
                              }
              ;

E0 : E0 TOKEN_MAS   E1  { $$ = $1 + $3 ; }
   | E0 TOKEN_MENOS E1  { $$ = $1 - $3 ; }
   | E1                 { $$ = $1 ;      }
   ;
   
   
E1 : E1 TOKEN_MULT E2   { $$ = $1 * $3 ; }
   | E1 TOKEN_DIV  E2   { $$ = $1 / $3 ; }
   | E2                 { $$ = $1 ;      }
   ;
   
   
E2 : TOKEN_INT              { $$ = $1 ;           }
   | TOKEN_FLOAT            { $$ = $1 ;           }
   | TOKEN_CIENTIFICO       { $$ = $1 ;           }
   | TOKEN_ID               { $$ = buscarTS($1);  }
   | TOKEN_PAA E0 TOKEN_PAC { $$ = $2 ;           }
   ;



%%



int main() {

  yyparse();

}
   


int yyerror(char *s)
{
  
  printf("Error %s", s);

}


             
int yywrap()  
{  

  return 1;  

}  