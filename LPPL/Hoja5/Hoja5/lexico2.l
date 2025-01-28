%{

   #include <stdio.h>
   #include <stdlib.h>

   #include "sintactico2.tab.h"

%}


%%

[+-]?[0-9]+             { 
                           yylval.valor = atoi(yytext);
                           return TOKEN_INT;
                           }

","                        { return TOKEN_COMA; }

"\n"

.

%%