
%{ let indent = [0]; let dedent = 0; %}

%lex

%%

/*
[\n\r]+([ \t]+[\n\r]+)*                 return 'SALTO_DE_LINEA'
*/

(\r\n|\r|\n)+[ \t]*                     {
                                            indent = indent || [0];
                                            dedent = dedent || 0;

                                            if (dedent) {
                                                dedent--;
                                                this.unput("");
                                                console.log(":"+yytext+":");
                                                return 'DEDENT';
                                            }
                                            
                                            if(yytext!=""){
                                                let indentacion = yytext.replace(/^(\r\n|\r|\n)+/, '').length;
                                                console.log("indentacion->"+indentacion);
                                                if (indentacion > indent[0]) {
                                                indent.unshift(indentacion);
                                                return 'INDENT';
                                                }

                                                let dedents = [];

                                                while (indentacion < indent[0]) {
                                                dedents.push('DEDENT');
                                                indent.shift();
                                                }

                                                if (dedents.length) {
                                                dedent = dedents.length - 1;
                                                this.unput("");
                                                return 'DEDENT';
                                                }

                                                return 'SALTO_DE_LINEA';
                                            }
                                        }

[ ]+                                    { /*ignorar por el momento*/ }
/*
[\t]+                                   {
                                            let indentacion = yytext.length;
                                            if (indentacion > indent[0]) {
                                                indent.unshift(indentacion);
                                                return "INDENT";
                                            }

                                            var tokens = [];

                                            while (indentacion < indent[0]) {
                                                tokens.push("DEDENT");
                                                indent.shift();
                                            }

                                            if (tokens.length) return tokens;
                                        }
*/

[0-9]+"."[0-9]+                         return 'DOUBLE'
[0-9]+                                  return 'INT'
"True"|"False"                          return 'BOOLEAN'
\"[^"]*\"                               { yytext = yytext.substr(1,yyleng-2); return 'STRING'; }
\'[^']*\'                               { yytext = yytext.substr(1,yyleng-2); return 'STRING'; }

//palabras reservadas
"def"                                   return 'PR_DEF'
"print"                                 return 'PR_PRINT'
"println"                               return 'PR_PRINTLN'

//  instrucciones y ciclos
"if"                                    return 'PR_IF'
"elif"                                  return 'PR_ELIF'
"else"                                  return 'PR_ELSE'

//simbolos
"**"                                    return 'POTENCIA'
[+]                                     return 'SUMA'
[-]                                     return 'RESTA'
[*]                                     return 'MULTIPLICACION'
[/]                                     return 'DIVISION'
[%]                                     return 'MODULO'
"{"                                     return 'LLAVE_A'
"}"                                     return 'LLAVE_C'
"["                                     return 'CORCH_A'
"]"                                     return 'CORCH_C'
"("                                     return 'PARENT_A'
")"                                     return 'PARENT_C'
"or"                                    return 'OR'
"and"                                   return 'AND'
"=="                                    return 'IGUAL'
"!="                                    return 'NO_IGUAL'
">="                                    return 'MAYOR_IGUAL'
"<="                                    return 'MENOR_IGUAL'
">"                                     return 'MAYOR'
"<"                                     return 'MENOR'
"not"                                   return 'NOT'
";"                                     return 'PUNTO_Y_COMA'
":"                                     return 'DOS_PUNTOS'
","                                     return 'COMA'
"="                                     return 'ASIGNACION'


[a-zA-Z]+[a-zA-Z0-9_]*                  return 'ID'

<<EOF>>                                 {
                                            if(insEsAbierta){
                                                let finalTokens = [];
                                                finalTokens.push('DEDENT');
                                                finalTokens.push('EOF');
                                                if(finalTokens.length) return finalTokens;
                                            }else{
                                                return 'EOF';
                                            }
                                        }
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

%start inicio

%{
    let errores = [];
    let tablaDeSimbolos = [];
    let ambitoActual = [];
    let ids = [];
    let simbolosParametros = [];
    let cadParametros = "";
    let ambitoClase = true;
    let tipoDatoSwtich = "";

    let insEsAbierta = false;

    exports.getErrores = function (){
        return errores;
    }

    exports.reset = function(){
        errores.splice(0, errores.length);
        tablaDeSimbolos.splice(0, tablaDeSimbolos.length);
        ambitoActual.splice(0, ambitoActual.length);
        ids.splice(0, ids.length);
        simbolosParametros.splice(0, simbolosParametros.length);
        cadParametros = "";
        ambitoClase = true;
        tipoDatoSwtich = "";
        indent = [0];

        insEsAbierta = false;
    }

    function errorSemantico(descripcion,linea,columna){
        ErrorLS = new Object();
        ErrorLS.lexema = "";
        ErrorLS.linea = linea;
        ErrorLS.columna = columna;
        ErrorLS.tipo = 'Semántico';
        ErrorLS.descripcion = descripcion;
        errores.push(ErrorLS);
    }

    function produccion(yy,$1,$2,linea,columna){
        if($2!=null){
            //Analizar tipo de resultado
            if($2!=null){
                let tipoResultado = yy.filtrarOperacion($1.tipoResultado,$2.tipoResultado,$2.operacionPendiente);
                if(tipoResultado!=null){
                    operacion = new Object();
                    operacion.tipoResultado = tipoResultado;
                    operacion.operacionPendiente = $1;
                    return operacion;
                }else{
                    errorSemantico("Operandos incorrectos para el operador "+$2.operacionPendiente+" .",linea,columna);
                    return null;
                }
            }else{
                return null;
            }
        }else{
            return $1;
        }
    }

    function produccionPrima(yy,$1,$2,$3,linea,columna){
        if($3==null){
            operacion = new Object();
            operacion.tipoResultado = $2.tipoResultado;
            operacion.operacionPendiente = $1;
            return operacion;
        }else{
            //Analizar tipo de resultado
            if($2!=null){
                let tipoResultado = yy.filtrarOperacion($2.tipoResultado,$3.tipoResultado,$1);
                if(tipoResultado!=null){
                    operacion = new Object();
                    operacion.tipoResultado = tipoResultado;
                    operacion.operacionPendiente = $1;
                    return operacion;
                }else{
                    errorSemantico("Operandos incorrectos para el operador "+$1+" .",linea,columna);
                    return null;
                }
            }else{
                return null;
            }
        }
    }

    function cerrarAmbitos(){
        indent = [0];
    }

%}

%%

/** gramatica **/
inicio : a1 EOF
    | SALTO_DE_LINEA a1 EOF
    ;

a1 : declaracion_funcion
    | declaracion_funcion a1
    ;



// DEFINICION DE FUNCION -------------------------------------------------------------------

declaracion_funcion : def ID PARENT_A PARENT_C DOS_PUNTOS declaracion_funcion_p
    ;

def : PR_DEF { cerrarAmbitos(); };

declaracion_funcion_p : INDENT instrucciones_metodo DEDENT
    | /*Lambda*/
    ;
//-----------------------------------------------------------------------------------------



// INSTRUCCIONES DENTRO DE METODO ----------------------------------------------------------

instrucciones_metodo : instruccion
    | instruccion SALTO_DE_LINEA instrucciones_metodo
    | instruccion_p
    | instruccion_p instrucciones_metodo
    ;

instruccion : PR_PRINT
    | PR_PRINTLN
    | manejo_variable
    ;

instruccion_p: condicional_if
    ;

//-----------------------------------------------------------------------------------------



//MANEJO DE VARIABLES ---------------------------------------------------------------------

manejo_variable : ID ASIGNACION expresion_multiple;

//-----------------------------------------------------------------------------------------




// CONDICIONAL IF -------------------------------------------------------------------------

condicional_if : PR_IF condicional_if_p DOS_PUNTOS
    INDENT instrucciones_metodo DEDENT {
        insEsAbierta = false;
    }
    ;

condicional_if_p : PARENT_A expresion_multiple PARENT_C {
        insEsAbierta = true;
    }
    ;

condicional_elif : PR_ELIF PARENT_A expresion_multiple PARENT_C DOS_PUNTOS SALTO_DE_LINEA
    INDENT instrucciones_metodo DEDENT
    ;

condicional_else : PR_ELSE DOS_PUNTOS SALTO_DE_LINEA INDENT instrucciones_metodo DEDENT
    ;

//-----------------------------------------------------------------------------------------






// EXPRESION MULTIPLE ---------------------------------------------------------------------

expresion_multiple : a3 { $$ = $1; };


//---------------------A3---------------------
a3 : b3 a3p {
                $$ = produccion(yy,$1,$2,this._$.first_line,this._$.first_column);
            }
    ;

a3p : a3bp b3 a3p   {
                        $$ = produccionPrima(yy,$1,$2,$3,this._$.first_line,this._$.first_column);
                    }
    | /*Lambda*/    { $$ = null; }
    ;

a3bp : OR { $$ = yy.OR; }
    | XOR { $$ = yy.XOR; }
    ;

//---------------------B3---------------------
b3 : c3 b3p {
                $$ = produccion(yy,$1,$2,this._$.first_line,this._$.first_column);
            }
    ;

b3p : b3bp c3 b3p   {
                        $$ = produccionPrima(yy,$1,$2,$3,this._$.first_line,this._$.first_column);
                    }
    | /*Lambda*/    { $$ = null; }
    ;
    
b3bp : AND { $$ = yy.AND; }
    ;

//---------------------C3---------------------

c3 : d3 c3p {
                $$ = produccion(yy,$1,$2,this._$.first_line,this._$.first_column);
            }
    ;

c3p : c3bp d3 c3p   {
                        $$ = produccionPrima(yy,$1,$2,$3,this._$.first_line,this._$.first_column);
                    }
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
                $$ = produccion(yy,$1,$2,this._$.first_line,this._$.first_column);
            }
    ;

d3p : d3bp e3 d3p   {
                        $$ = produccionPrima(yy,$1,$2,$3,this._$.first_line,this._$.first_column);
                    }
    | /*Lambda*/    { $$ = null; }
    ;

d3bp : SUMA { $$ = yy.SUMA; }
    | RESTA { $$ = yy.RESTA; }
    ;

//---------------------E3---------------------

e3 : f3 e3p {
                $$ = produccion(yy,$1,$2,this._$.first_line,this._$.first_column);
            }
    ;

e3p : e3bp f3 e3p   {
                        $$ = produccionPrima(yy,$1,$2,$3,this._$.first_line,this._$.first_column);
                    }
    | /*Lambda*/    { $$ = null; }
    ;

e3bp : MULTIPLICACION { $$ = yy.MULTIPLICACION; }
    | DIVISION { $$ = yy.DIVISION; }
    | MODULO { $$ = yy.MODULO; }
    ;

//---------------------F3---------------------

f3 : g3 f3p {
                $$ = produccion(yy,$1,$2,this._$.first_line,this._$.first_column);
            }
    ;

f3p : f3bp g3 f3p   {
                        $$ = produccionPrima(yy,$1,$2,$3,this._$.first_line,this._$.first_column);
                    }
    | /*Lambda*/    { $$ = null; }
    ;

f3bp : POTENCIA { $$ = yy.POTENCIA; }
    ;


//---------------------G3---------------------

g3 : PARENT_A a3 PARENT_C { $$ = $2; }
    | NOT ID    {
        let simbolo = obtenerSimbolo($2);
        if(simbolo==null){
            errorSemantico("No se encuentra el símbolo "+$2+" .",this._$.first_line,this._$.first_column);
            $$ = null;
        }else{
            if(simbolo.tipo==yy.BOOLEAN){
                operacion = new Object();
                operacion.tipoResultado = yy.BOOLEAN;
                $$ = operacion;
            }else{
                errorSemantico("Tipo de dato requerido : "+yy.BOOLEAN+" . Obtenido: "+simbolo.tipo+" .",this._$.first_line,this._$.first_column);
                $$ = null;
            }
        }
    }
    | NOT BOOLEAN    {
        operacion = new Object();
        operacion.tipoResultado = yy.BOOLEAN;
        $$ = operacion;
    }
    | NOT PARENT_A a3 PARENT_C {
        if($3==null){
            $$ = null;
        }else{
            if($3.tipoResultado==yy.BOOLEAN){
                operacion = new Object();
                operacion.tipoResultado = yy.BOOLEAN;
                $$ = operacion;
            }else{
                errorSemantico("Tipo de dato requerido : "+yy.BOOLEAN+" . Obtenido: "+$3.tipoResultado+" .",this._$.first_line,this._$.first_column);
                $$ = null;
            }
        }
    }
    ;

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
                    let sim_id_a = validarVariable($1,yy);
                    if(sim_id_a==null){
                        errorSemantico("No se encuentra el símbolo "+$1+" .",this._$.first_line,this._$.first_column);
                        operacion.tipoResultado = yy.ID;
                    }else{
                        operacion.tipoResultado = sim_id_a.tipo;
                    }
                    $$ = operacion;
                }
    ;

//-----------------------------------------------------------------------------------------