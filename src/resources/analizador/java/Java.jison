%lex
%options case-sensitive


%%

[ \r\t\n]+                   { /*ignorar*/}

[0-9]+"."[0-9]+                 return 'DOUBLE'
[0-9]+                          return 'INT'
"true"|"false"                  return 'BOOLEAN'
\"[^"]*\"                     { yytext = yytext.substr(1,yyleng-2); return 'STRING'; }
\'.\'                         { yytext = yytext.substr(1,yyleng-2); return 'CHAR'; }

//palabras reservadas
"public"                        return 'PR_PUBLIC'
"private"                       return 'PR_PRIVATE'
"class"                         return 'PR_CLASS'
"void"                          return 'PR_VOID'
"int"                           return 'PR_INT'
"double"                        return 'PR_DOUBLE'
"char"                          return 'PR_CHAR'
"boolean"                       return 'PR_BOOLEAN'
"String"                        return 'PR_STRING'
//simbolos
[+]                             return 'SUMA'
[-]                             return 'RESTA'
[*]                             return 'MULTIPLICACION'
[/]                             return 'DIVISION'
[%]                             return 'MODULO'
"^"                             return 'POTENCIA'
"{"                             return 'LLAVE_A'
"}"                             return 'LLAVE_C'
"["                             return 'CORCH_A'
"]"                             return 'CORCH_C'
"("                             return 'PARENT_A'
")"                             return 'PARENT_C'
"|"                             return 'OR'
"||"                            return 'NOR'
"&&"                            return 'AND'
"=="                            return 'IGUAL'
"!="                            return 'NO_IGUAL'
">"                             return 'MAYOR'
"<"                             return 'MENOR'
">="                            return 'MAYOR_IGUAL'
"<="                            return 'MENOR_IGUAL'
";"                             return 'PUNTO_Y_COMA'
"="                             return 'ASIGNACION'

[a-zA-Z]+[a-zA-Z0-9_]*          return 'ID'

[/][/].*                                        { /*ignorar comentario de linea*/}
[/][*][^*]*[*]+([^/*][^*]*[*]+)*[/]             { /*ignorar comentario de bloque*/}



<<EOF>>                         return 'EOF'
.                               {/*Instertar codigo para recuperar el error lexico*/
            //error
            ErrorLS = new Object();
            ErrorLS.lexema = yytext;
            ErrorLS.linea = yylloc.first_line;
            ErrorLS.columna = yylloc.first_column;
            ErrorLS.tipo = 'Léxico';
            ErrorLS.descripcion = 'El lexema '+yytext+' no es válido.';
            errores.push(ErrorLS);
    }


/lex


%start inicial

%{
    let errores = [];

    exports.getErrores = function (){
        return errores;
    }

    exports.reset = function(){
        errores.splice(0, errores.length);
    }

%}

%%

inicial :  a1 EOF
    ;

    

err : error {
            //error
            ErrorLS = new Object();
            ErrorLS.lexema = yytext;
            ErrorLS.linea = this._$.first_line;
            ErrorLS.columna = this._$.first_column;
            ErrorLS.tipo = 'Sintáctico';
            ErrorLS.descripcion = '';
            errores.push(ErrorLS);
    }
    ;

a1 : declaracion_clase
    | declaracion_clase a1
    ;

//DECLARACION DE CLASE ---------------------------------------------------------------

declaracion_clase : PR_PUBLIC PR_CLASS ID LLAVE_A instrucciones_clase LLAVE_C
    | err
    ;

//------------------------------------------------------------------------------------


//INSTRUCCIONES DENTRO DE CLASE--------------------------------------------------------

instrucciones_clase : instrucciones_clase_p
    | instrucciones_clase_p instrucciones_clase
    ;

instrucciones_clase_p : declaracion_variable
    ;

//-------------------------------------------------------------------------------------

//DECLARACION DE VARIABLE ------------------------------------------------------------

declaracion_variable : tipo ID asignacion 
    ;

tipo : PR_INT
    | PR_DOUBLE
    | PR_CHAR
    | PR_STRING
    | PR_BOOLEAN
    ;

asignacion : PUNTO_Y_COMA
    | ASIGNACION expresion_multiple PUNTO_Y_COMA
    ;

//------------------------------------------------------------------------------------

//EXPRESION MULTIPLE----------------------------------------------------------------
expresion_multiple : a3;

a3 : b3 a3p;

a3p : a3bp b3 a3p
    | //Lambda
    ;

a3bp : OR
    | XOR
    ;

b3 : c3 b3p;

b3p : b3bp c3 b3p
    | //Lambda
    ;
    
b3bp : AND
    ;

c3 : d3 c3p;

c3p : c3bp d3 c3p
    | //Lambda
    ;

c3bp : IGUAL
    | NO_IGUAL
    | MAYOR
    | MENOR
    | MAYOR_IGUAL
    | MENOR_IGUAL
    ;

d3 : e3 d3p
    ;

d3p : d3bp e3 d3p
    | //Lambda
    ;

d3bp : SUMA
    | RESTA
    ;

e3 : f3 e3p
    ;

e3p : e3bp f3 e3p
    | //Lambda
    ;

e3bp : MULTIPLICACION
    | DIVISION
    | MODULO
    ;

f3 : g3 f3p
    ;

f3p : f3bp g3 f3p
    | //Lambda
    ;

f3bp : POTENCIA
    ;


g3 : INT
    | DOUBLE
    | CHAR
    | STRING
    | BOOLEAN
    ;


//-------------------------------------------------------------------------------


