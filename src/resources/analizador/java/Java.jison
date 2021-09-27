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

    function errorSemantico(descripcion){
        ErrorLS = new Object();
        ErrorLS.lexema = "";
        //ErrorLS.linea = this._$.first_line;
        ErrorLS.linea = 0;
        ErrorLS.columna = 0;
        ErrorLS.tipo = 'Semántico';
        ErrorLS.descripcion = descripcion;
        errores.push(ErrorLS);
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


//---------------------A3---------------------
a3 : b3 a3p  {
                if($2!=null){

                }else{
                    $$ = $1;
                }
            }
    ;

a3p : a3bp b3 a3p
    | /*Lambda*/    { $$ = null; }
    ;

a3bp : OR { $$ = yy.OR; }
    | XOR { $$ = yy.XOR; }
    ;

//---------------------B3---------------------
b3 : c3 b3p {
                if($2!=null){

                }else{
                    $$ = $1;
                }
            }
    ;

b3p : b3bp c3 b3p
    | /*Lambda*/    { $$ = null; }
    ;
    
b3bp : AND { $$ = yy.AND; }
    ;

//---------------------C3---------------------

c3 : d3 c3p {
                if($2!=null){

                }else{
                    $$ = $1;
                }
            }
    ;

c3p : c3bp d3 c3p
    | /*Lambda*/    { $$ = null; }
    ;

c3bp : IGUAL { $$ = yy.IGUAL; }
    | NO_IGUAL { $$ = yy.NO_IGUAL; }
    | MAYOR { $$ = yy.MAYOR; }
    | MENOR { $$ = yy.MENOR; }
    | MAYOR_IGUAL { $$ = yy.MAYOR_IGUAL; }
    | MENOR_IGUAL { $$ = yy.MENOR_IGUAL; }
    ;

//---------------------D3---------------------

d3 : e3 d3p {
                if($2!=null){

                }else{
                    $$ = $1;
                }
            }
    ;

d3p : d3bp e3 d3p
    | /*Lambda*/    { $$ = null; }
    ;

d3bp : SUMA { $$ = yy.SUMA; }
    | RESTA { $$ = yy.RESTA; }
    ;

//---------------------E3---------------------

e3 : f3 e3p {
                if($2!=null){

                }else{
                    $$ = $1;
                }
            }
    ;

e3p : e3bp f3 e3p
    | /*Lambda*/    { $$ = null; }
    ;

e3bp : MULTIPLICACION { $$ = yy.MULTIPLICACION; }
    | DIVISION { $$ = yy.DIVISION; }
    | MODULO { $$ = yy.MODULO; }
    ;

//---------------------F3---------------------

f3 : g3 f3p {
                if($2!=null){
                    //Analizar tipo de resultado
                    console.log("Analizando tipo de resultado");
                    if($2!=null){
                        let tipoResultado = yy.filtrarOperacion($1.tipoResultado,$2.tipoResultado,$2.operacionPendiente);
                        if(tipoResultado!=null){
                            operacion = new Object();
                            operacion.tipoResultado = tipoResultado;
                            operacion.operacionPendiente = $1;
                            $$ = operacion;
                        }else{
                            errorSemantico("Operandos incorrectos para el operador "+$2.operacionPendiente+" .");
                            $$ = null;
                        }
                    }
                }else{
                    $$ = $1;
                }
            }
    ;

f3p : f3bp g3 f3p   {
                        if($3==null){
                            console.log("Pasando aqui");
                            operacion = new Object();
                            operacion.tipoResultado = $2.tipoResultado;
                            operacion.operacionPendiente = $1;
                            $$ = operacion;
                        }else{
                            //Analizar tipo de resultado
                            console.log("Analizando tipo de resultado");
                            if($2!=null){
                                let tipoResultado = yy.filtrarOperacion($2.tipoResultado,$3.tipoResultado,$1);
                                if(tipoResultado!=null){
                                    operacion = new Object();
                                    operacion.tipoResultado = tipoResultado;
                                    operacion.operacionPendiente = $1;
                                    $$ = operacion;
                                }else{
                                    errorSemantico("Operandos incorrectos para el operador "+$1+" .");
                                    $$ = null;
                                }
                            }
                        }
                    }
    | /*Lambda*/    { $$ = null; }
    ;

f3bp : POTENCIA { $$ = yy.POTENCIA; }
    ;


//---------------------G3---------------------

g3 : INT        {
                    operacion = new Object();
                    operacion.tipoResultado = yy.INT;
                    $$ = operacion;
                }
    | DOUBLE    {
                    operacion = new Object();
                    operacion.tipoResultado = yy.DOUBLE;
                    $$ = operacion;
                }
    | CHAR      {
                    operacion = new Object();
                    operacion.tipoResultado = yy.CHAR;
                    $$ = operacion;
                }
    | STRING    {
                    operacion = new Object();
                    operacion.tipoResultado = yy.STRING;
                    $$ = operacion;
                }
    | BOOLEAN   {
                    operacion = new Object();
                    operacion.tipoResultado = yy.BOOLEAN;
                    $$ = operacion;
                }
    | ID        {
                    operacion = new Object();
                    operacion.tipoResultado = yy.ID;
                    $$ = operacion;
                }
    ;


//-------------------------------------------------------------------------------


