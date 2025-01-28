%{

   #include <stdio.h>
   #include <stdlib.h>

   extern int yylex(void);
   extern char *yytext;
   int yyerror(char *s);

%}


%union
{
  struct
  {
    int min_val;
    int max_val;
  } mm;
  int valor;
}



%start S

%token <valor> TOKEN_INT 
%token TOKEN_COMA

%type <mm> L 

%%


S : L { printf("El valor minimo es %d y el valor maximo es %d\n", $1.min_val, $1.max_val); }
  ;

L : TOKEN_INT TOKEN_COMA L { 
                             if ($1 < $3.min_val) $$.min_val = $1 ;
                             else $$.min_val = $3.min_val ;
                             
                             if ($1 > $3.max_val) $$.max_val = $1 ;
                             else $$.max_val = $3.max_val ;
                            }   

  | TOKEN_INT { 
                $$.min_val = $1 ;
                $$.max_val = $1 ;
               }
  ;

%%  

int main()
{
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
