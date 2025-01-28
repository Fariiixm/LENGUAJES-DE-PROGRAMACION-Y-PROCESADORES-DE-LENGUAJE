grammar P3;


options{
    language = Java;
    output   = AST;  
}


@members{
    int cnt   = -1;
    int linea =  1;
}


entrada returns [String codigo]
	: ec1 = ecuacion 
		{
		$codigo = $ec1.codigo;
		}
	( ec2 = ecuacion
		{
		$codigo += $ec2.codigo;
		}
	)*
		{
      	$codigo += "L" + linea + " : (HALT, NULL, NULL, NULL)\n";
       	System.out.print($codigo);
       	}
    ;
      
ecuacion returns [String codigo, int lineas]
    : Id '=' exp = expresion ';' 
    	{
    	$codigo = $exp.codigo;
		if ($exp.lineas == 0)
			$codigo += "L" + linea + " : (ASSIGN, " + $Id.text + ", " + $exp.resultado +  ", NULL)\n";
		else    	
			$codigo += "L" + linea + " : (ASSIGN, " + $Id.text + ", t" + cnt + ", NULL)\n";
		$lineas = 1 + $exp.lineas;
		++linea;
		}
	| 'if' 
		{
		int aux = linea;
		linea+=2;
		}
	'(' ex1 = expresion c = Comp ex2 = expresion ')' 
		{
		linea -= $ex1.lineas + $ex2.lineas;
		}
	'then' '{' en1 = programa '}' 'else' 
		{
		++linea;
		}
		
	'{' en2 = programa '}'
		{
		$codigo = "L" + aux + " : (IF_TRUE," + $ex1.text + $c.text + $ex2.text + ", GOTO, " + "L" + (aux + 2) + ")\n";
		$codigo += "L" + (aux+1) + " : (IF_FALSE," + $ex1.text + $c.text + $ex2.text + ", GOTO, " + "L" + (aux + 3 + $en1.lineas) + ")\n";
		$codigo += $en1.codigo;
		$codigo += "L" + (aux+$en1.lineas+2) + " : (IF_TRUE, NULL, GOTO, L" + (aux+4+$en1.lineas+$en2.lineas) + ")\n";
		$codigo += $en2.codigo;
		$codigo += "L" + (aux+$en1.lineas+$en2.lineas+3) + " : (IF_TRUE, NULL, GOTO, L" + (aux+4+$en1.lineas+$en2.lineas) + ")\n";
		linea++;
		$lineas = 4 + $en1.lineas + $en2.lineas;
		}
	| 'while' '(' exp1 = expresion c = Comp exp2 = expresion ')'
	
	{
		int linea_aux = linea;
		$codigo = "L" + linea_aux + " :(IF_TRUE, " + $exp1.resultado + $c.text + $exp2.resultado + 
		", GOTO, L" + (linea_aux + 2) + ")\n";
		linea = linea + 2;
	}
	'do' '{' p1 = programa '}'
	{
	 	$codigo += "L" + (linea_aux + 1) + ": (IF_FALSE, " + $exp1.resultado + $c.text + $exp2.resultado +
	 		", GOTO, L" +  (linea_aux + 3 + $p1.lineas) + ")\n";
	 	$codigo += $p1.codigo;
	 	$codigo += "L" + linea + ": (IF_TRUE, NULL, GOTO, L" + linea_aux + ")\n";
	 	++linea;
	 	$lineas = $p1.lineas + 3;
	}
	|'for'
	{
	int linea_aux = linea;
	linea = linea + 2;
	}
	'(' ID = Id '=' exp1 = expresion ';' ID2 = Id c1 = Comp exp5 = expresion ';' ID3 = Id op = ('++'|'--') ')'
	{$codigo = $exp1.codigo;
	if($exp1.lineas == 0) 
		$codigo += "L" + linea_aux + " : (ASSIGN, " + $ID.text + ", " + $exp1.resultado + ", NULL)\n"; 
	else 
		$codigo += "L" + linea_aux + " : (ASSIGN, " + $ID.text + ", t" + cnt + ", NULL)\n";	
	$lineas = 1 + $exp1.lineas;
	++linea;	
	
	}
	'{' p = programa '}'
        {
        	
        	$codigo += "L" + (linea_aux + 1) + " : (IF_TRUE, " + $ID2.text + $c1.text + $exp5.text + ", GOTO, L" + (linea_aux + 3) + ")\n";
        	$codigo += "L" + (linea_aux + 2) + " : (IF_FALSE, " + $ID2.text + $c1.text + $exp5.text + ", GOTO, L" + (linea_aux + 6 + $p.lineas) + ")\n";
        	$codigo += $p.codigo;
        	if ($op.text.equals("++")) {
            		$codigo += "L" + (linea_aux + 3 + $p.lineas) + " : (ADD, t" + cnt + "," + $ID3.text + ", 1)\n";
        	} else {
            		$codigo += "L" + (linea_aux + 3 + $p.lineas) + " : (SUB, t" + cnt + "," + $ID3.text + ", 1)\n";
        	}
        	$codigo += "L" + (linea_aux + 4 + $p.lineas) + " : (ASSIGN, " + $ID3.text + ", t" + cnt + ", NULL)\n"; 
        	linea += 2;
        	$codigo += "L" + (linea_aux + 5 + $p.lineas) + " : (IF_TRUE, NULL, GOTO, L" + (linea_aux + 1) + ")\n";
        	
        	linea++;
        	$lineas = 5 + $p.lineas;
        }
        
        
        | 'for' '[' ID = Id 'in' exp1 = expresion '..' exp2 = expresion 'step' exp3 = expresion ']' 
	{
    		int linea_aux = linea;
   	 	$codigo = $exp1.codigo;
    		if($exp1.lineas == 0) 
        		$codigo += "L" + linea_aux + " : (ASSIGN, " + $ID.text + ", " + $exp1.resultado + ", NULL)\n"; 
    		else 
        		$codigo += "L" + linea_aux + " : (ASSIGN, " + $ID.text + ", t" + cnt + ", NULL)\n"; 

    		$codigo += "L" + (linea_aux + 1) + " : (IF_FALSE, " + $ID.text + "<" + $exp2.text  + ", GOTO, L" + (linea_aux + 7) + ")\n";
    		$lineas = 1 + $exp1.lineas;
    		cnt++;
    		linea+=2; 
	}   
	'{' p = programa '}'
	{
    		$codigo += $p.codigo;
    		$codigo += "L" + (linea_aux + 3 + $p.lineas) + " : (ADD, t" + cnt + "," + $ID.text + ", " + $exp3.resultado + ")\n";
    		$codigo += "L" + (linea_aux + 4 + $p.lineas) + " : (ASSIGN, " + $ID.text + ", t" + cnt + ", NULL)\n"; 
    		linea += 2;
   		$codigo += "L" + (linea_aux + 5 + $p.lineas) + " : (IF_TRUE, " + "NULL, GOTO, L" + (linea_aux + 1) + ")\n";
    		cnt++;
   		linea++;
    		$lineas = 5 + $p.lineas;
	}
    ;




programa returns [String codigo, int lineas]
	: 	
		{
		$lineas = 0;
		$codigo = "";
		}
	( ec = ecuacion 
		{
		$codigo += $ec.codigo;
		$lineas += $ec.lineas;
		}
	)+
	;

expresion returns [String codigo, String resultado, int lineas]
	: m1 = termino 
		{ 
		String aux = $m1.resultado;
		$codigo = $m1.codigo;
		$resultado = $m1.resultado;
		$lineas = $m1.lineas;
		}
	( '+' m2=termino 
		{
		cnt++;
		$codigo += $m2.codigo;
		$codigo += "L" + linea + " : (ADD, t" + cnt + "," + aux + "," + $m2.resultado + ")\n";
		aux = "t" + cnt;
		++linea;
		$lineas = $lineas + 1 + $m2.lineas;
		$resultado =  "t" + cnt;
		}
	|	'-' m2=termino 
		{
		cnt++;
		$codigo += $m2.codigo;
		$codigo += "L" + linea + " : (SUB, t" + cnt + "," + aux + "," + $m2.resultado + ")\n";
		aux = "t" + cnt;
		++linea;
		$lineas = $lineas + 1 + $m2.lineas;
		$resultado =  "t" + cnt;
		}

	)*
	;

termino returns [String codigo, String resultado, int lineas]
	: m1 = factor 
		{ 
		String aux = $m1.resultado;
		$codigo = $m1.codigo;
		$lineas = $m1.lineas;
		$resultado = $m1.resultado;
		}
	( '*' m2=factor 
		{
		cnt++;
		$codigo += $m2.codigo;
		$codigo += "L" + linea + " : (MULT, t" + cnt + "," + aux + "," + $m2.resultado + ")\n";
		aux = "t" + cnt;
		++linea;
		$lineas = $lineas + 1 + $m2.lineas;
		$resultado =  "t" + cnt;
		}
	| '/' m2=factor 
		{
		cnt++;
		$codigo += $m2.codigo;
		$codigo += "L" + linea + " : (DIV, t" + cnt + "," + aux + "," + $m2.resultado + ")\n";
		aux = "t" + cnt;
		++linea;
		$lineas = $lineas + 1 + $m2.lineas;
		$resultado =  "t" + cnt;
		}
	)*
	;


factor returns [String codigo, String resultado, int lineas]
	: '(' exp = expresion ')' 
		{
		$lineas = $exp.lineas;
		$codigo = $exp.codigo;
		$resultado = $exp.resultado;
		}
	|	n = dato 
		{
		$lineas = $n.lineas;
		$codigo = $n.codigo;
		$resultado = $n.resultado;
		}
	;

dato returns [String codigo, String resultado, int lineas]
	: Number 
		{
		$lineas = 0;
		$codigo = "";
		$resultado = $Number.text;
		}
	| Id 
		{ 
		$lineas = 0;
		$codigo = "";
		$resultado = $Id.text;
		}
	| '-' Number 
		{
		$lineas = 1;
		cnt++;
		$codigo = "L" + linea + " : (NEG, t" + cnt + "," + $Number.text + ", NULL)\n";
		++linea;
		$resultado = "t" + cnt;
		}
	| '-' Id 
		{
		$lineas = 1;
		cnt++;
		$codigo = "L" + linea + " : (NEG, t" + cnt + "," + $Id.text + ", NULL)\n";
		++linea;
		$resultado = "t" + cnt;
		}
	;
	
	
Id 
	:	('a'..'z'|'A'..'Z')+ 
	; 
   
	
Number
	:	('0'..'9')+ ('.' ('0'..'9')+)? 
	;

Comp 
	: ('>' | '<' | '>=' | '<=' | '==' | '!=')
	;


/* Ignoramos todos los caracteres de espacios en blanco. */


WS
    :   (' ' | '\t' | '\r'| '\n')    { $channel=HIDDEN; }
    ;

