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
"!"                             return 'NOT'
";"                             return 'PUNTO_Y_COMA'
","                             return 'COMA'
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
    let tablaDeSimbolos = [];
    let ambitoActual = [];
    let ids = [];
    let cadParametros = "";
    let ambitoClase = true;

    exports.getErrores = function (){
        return errores;
    }

    exports.reset = function(){
        errores.splice(0, errores.length);
        tablaDeSimbolos.splice(0, tablaDeSimbolos.length);
        ambitoActual.splice(0, ambitoActual.length);
        ids.splice(0, ids.length);
        cadParametros = "";
        ambitoClase = true;
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

    function existeVariableMetodo(id,ambito,rol){
        for(let simbolo in tablaDeSimbolos){
            if(tablaDeSimbolos[simbolo].rol==rol && tablaDeSimbolos[simbolo].id==id && ambito==tablaDeSimbolos[simbolo].ambito){
                return true;
            }
        }
        return false;
    }

    function existeClase(id,yy){
        for(let simbolo in tablaDeSimbolos){
            if(tablaDeSimbolos[simbolo].rol==yy.CLASE && tablaDeSimbolos[simbolo].id==id){
                return true;
            }
        }
        return false;
    }

    function obtenerSimbolo(id){
        for (let i=tablaDeSimbolos.length - 1; i >= 0; i--) {
            if(id==tablaDeSimbolos[i].id){
                return tablaDeSimbolos[i];
            }
        }
        return null;
    }

    function obtenerUltimoMetodo(yy){
        for (let i=tablaDeSimbolos.length - 1; i >= 0; i--) {
            if(tablaDeSimbolos[i].rol == yy.METODO){
                return tablaDeSimbolos[i];
            }
        }
        return null;
    }

%}

%%

inicial :  a1 EOF   {
                        for(const simbolo in tablaDeSimbolos){
                            console.log("-----------------");
                            console.log("Id: "+tablaDeSimbolos[simbolo].id);
                            console.log("Tipo: "+tablaDeSimbolos[simbolo].tipo);
                            console.log("Ambito: "+tablaDeSimbolos[simbolo].ambito);
                            console.log("Visibilidad: "+tablaDeSimbolos[simbolo].visibilidad);
                            console.log("Rol: "+tablaDeSimbolos[simbolo].rol);
                        }
                    }
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

declaracion_clase : declaracion_clase_p LLAVE_A instrucciones_clase LLAVE_C {
        ambitoActual.pop();
    }
    | declaracion_clase_p LLAVE_A LLAVE_C { ambitoActual.pop(); }
    | err
    ;

declaracion_clase_p : PR_PUBLIC PR_CLASS ID {
            if(existeClase($3,yy)){
                errorSemantico("La clase "+$3+" ya ha sido declarada.",this._$.first_line,this._$.first_column);
            }
            let simboloClase = new Object();
            simboloClase.id = $3;
            simboloClase.tipo = "";
            simboloClase.ambito = "";
            simboloClase.visibilidad = yy.PUBLIC;
            simboloClase.rol = yy.CLASE;
            tablaDeSimbolos.push(simboloClase);
            ambitoActual.push("class "+$3);
        }
    ;

//------------------------------------------------------------------------------------


//INSTRUCCIONES DENTRO DE CLASE--------------------------------------------------------

instrucciones_clase : instrucciones_clase_p
    | instrucciones_clase_p instrucciones_clase
    ;

instrucciones_clase_p : declaracion_variable
    | declaracion_metodo
    ;

//-------------------------------------------------------------------------------------

//INSTRUCCIONES DENTRO DE METODO--------------------------------------------------------

instrucciones_metodo : instrucciones_metodo_p
    | instrucciones_metodo_p instrucciones_metodo
    ;

instrucciones_metodo_p : declaracion_variable
    ;

//-------------------------------------------------------------------------------------

//DECLARACION DE VARIABLE ------------------------------------------------------------

declaracion_variable : visibilidad tipo ids asignacion {
            if($1 != yy.DEFAULT){
                if(!ambitoClase){
                    errorSemantico("Ilegal inicio de expression: "+$1+".",this._$.first_line,this._$.first_column);
                }
            }
            //declaracion y asignacion
            if($4==null || $2 == $4.tipoResultado){
                while(ids.length>0){
                    //asignacion de tipo correcta
                    let id = ids.pop();
                    if(existeVariableMetodo(id,ambitoActual.at(-1),yy.VARIABLE)){
                        errorSemantico("La variable "+id+" ya ha sido declarada en "+ambitoActual.at(-1)+".",this._$.first_line,this._$.first_column);
                    }else{
                        let simboloVariable = new Object();
                        simboloVariable.id = id;
                        simboloVariable.tipo = $2;
                        simboloVariable.ambito = ambitoActual.at(-1);
                        simboloVariable.visibilidad = $1;
                        simboloVariable.rol = yy.VARIABLE;
                        if($4 != null){
                            //simboloVariable.valor = $4.valor;
                        }
                        tablaDeSimbolos.push(simboloVariable);
                    }
                }
            }else{
                errorSemantico("Tipo de dato requerido : "+$2+" . Obtenido: "+$4.tipoResultado+" .",this._$.first_line,this._$.first_column);
            }
        }
    ;

ids : ids_p
    | ids_p COMA ids
    ;

ids_p : ID { ids.push($1); }
    ;

tipo : PR_INT { $$ = yy.INT; }
    | PR_DOUBLE { $$ = yy.DOUBLE; }
    | PR_CHAR { $$ = yy.CHAR; }
    | PR_STRING { $$ = yy.STRING; }
    | PR_BOOLEAN { $$ = yy.BOOLEAN; }
    ;

asignacion : PUNTO_Y_COMA { $$ = null; }
    | ASIGNACION expresion_multiple PUNTO_Y_COMA { $$ = $2; }
    ;

//------------------------------------------------------------------------------------

//VISIBILIDAD-------------------------------------------------------------------------

visibilidad : PR_PUBLIC { $$ = yy.PUBLIC; }
    | PR_PRIVATE { $$ = yy.PRIVATE; }
    | /*Lambda*/ { $$ = yy.DEFAULT; }
    ;

//------------------------------------------------------------------------------------

//DECLARACION DE METODOS -------------------------------------------------------------

declaracion_metodo : visibilidad tipo declaracion_metodo_p { 
        let ultimoMetodoDeclarado = obtenerUltimoMetodo(yy);
        ultimoMetodoDeclarado.visibilidad = $1;
        ultimoMetodoDeclarado.tipo = $2;
    }
    | visibilidad PR_VOID declaracion_metodo_p {
        let ultimoMetodoDeclarado1 = obtenerUltimoMetodo(yy);
        ultimoMetodoDeclarado1.visibilidad = $1;
        ultimoMetodoDeclarado1.tipo = $2;
    }
    ;

declaracion_metodo_p : declaracion_metodo_p_a LLAVE_A instrucciones_metodo LLAVE_C { 
        ambitoActual.pop(); 
        ambitoClase = true;
    }
    | declaracion_metodo_p_a LLAVE_A LLAVE_C { 
        ambitoActual.pop();
        ambitoClase = true; 
    }
    ;

declaracion_metodo_p_a : ID PARENT_A parametros_b_p PARENT_C {
        if(existeVariableMetodo(ambitoActual.at(-1)+"_"+$1+cadParametros,ambitoActual.at(-1),yy.METODO)){
            errorSemantico("El método "+$1+cadParametros+" ya ha sido declarado en "+ambitoActual.at(-1)+".",this._$.first_line,this._$.first_column);
        }
        let simboloMetodo = new Object();
        simboloMetodo.id = ambitoActual.at(-1)+"_"+$1+cadParametros;
        simboloMetodo.tipo = "---";
        simboloMetodo.ambito = ambitoActual.at(-1);
        simboloMetodo.visibilidad = "---";
        simboloMetodo.rol = yy.METODO
        tablaDeSimbolos.push(simboloMetodo);
        
        ambitoActual.push(ambitoActual.at(-1)+"_"+$1+cadParametros);
        ambitoClase = false;
        cadParametros = "";
    }
    ;

parametros : parametros_p 
    | parametros_p COMA parametros
    ;

parametros_p : tipo ID { cadParametros+="_"+$1; }
    ;

parametros_b_p : parametros
    | /*Lambda*/ 
    ;

//------------------------------------------------------------------------------------



//EXPRESION MULTIPLE----------------------------------------------------------------
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

//+++++++++++++++++++++++++=PARENTESIS Y NOT

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


