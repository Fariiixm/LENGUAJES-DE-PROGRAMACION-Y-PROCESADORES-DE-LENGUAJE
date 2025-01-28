%{

   #include <stdio.h>
   #include <stdlib.h>

   #include "sintactico2.tab.h"

%}



DIGITO [0-9]
ID     [a-zA-Z][a-zA-Z0-9_]*



%%



[+-]?{DIGITO}+             { 

                             yylval.valor_ent = atoi(yytext);
			                 return TOKEN_INT;

                           }


{DIGITO}+("."{DIGITO}+)?   {

                             yylval.valor_real = atof(yytext);
                             return TOKEN_FLOAT;

                           }


[+-]?{DIGITO}+(.{DIGITO}+)?([eE][+-]?{DIGITO}+)?  	{ 

                                                      yylval.valor_real = atof(yytext);
                                                      return TOKEN_CIENTIFICO;
													
													}


"evalua"                   { return TOKEN_EV; }

"siendo"                   { return TOKEN_DN; }

"if"                       { return TOKEN_IF; }

"then"                     { return TOKEN_THEN; }

"else"                     { return TOKEN_ELSE; }

"switch"                   { return TOKEN_SWITCH;  }

"case"                     { return TOKEN_CASE;    }

"default"                  { return TOKEN_DEFAULT; }

"="                        { return TOKEN_ASIG; }

"+"                        { return TOKEN_MAS; }

"-"                        { return TOKEN_MENOS; }

"*"                        { return TOKEN_MULT; }

"/"                        { return TOKEN_DIV; }

"("                        { return TOKEN_PAA; }

")"                        { return TOKEN_PAC; }

"{"                        { return TOKEN_LLAA; }

"}"                        { return TOKEN_LLAC; }

"<"                        { return TOKEN_MENOR; }

">"                        { return TOKEN_MAYOR; }

{ID}                       {  

                              yylval.nombre = yytext;
                              return TOKEN_ID; 
							  
						   }

":"                        { return TOKEN_DOSPUNTOS; }

";"                        { return TOKEN_PUNTOCOMA; }

","                        {  return TOKEN_COMA; }

"\n"

.



%%


