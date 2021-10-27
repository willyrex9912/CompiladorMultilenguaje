
%{ let indent = [0]; let dedent = 0; %}

%lex

%%

(\r\n|\r|\n)+[ \t]*                     {
                                            indent = indent || [0];
                                            dedent = dedent || 0;

                                            if (dedent) {
                                                dedent--;
                                                if(dedent){
                                                    this.unput(yytext);
                                                }
                                                return 'DEDENT';
                                            }
                                            
                                            let indentacion = yytext.replace(/^(\r\n|\r|\n)+/, '').length;
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
                                                if(dedent){
                                                    this.unput(yytext);
                                                }
                                                return 'DEDENT';
                                            }
                                            return 'SALTO_DE_LINEA';
                                        }

[ \t]+                                  { /*ignorar por el momento*/ }


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
"for"                                   return 'PR_FOR'
"in"                                    return 'PR_IN'
"range"                                 return 'PR_RANGE'
"while"                                 return 'PR_WHILE'

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

<<EOF>>                                 return 'EOF'

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
    let vals = [];

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
        dedent = 0;
        vals.splice(0, vals.length);
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
        try{
            if($2!=null){
                //Analizar tipo de resultado
                let tipoResultado = yy.filtrarOperacion($1.tipoResultado,$2.tipoResultado,$2.operacionPendiente);
                if(tipoResultado!=null){
                    operacion = new Object();
                    operacion.tipoResultado = tipoResultado;
                    operacion.operacionPendiente = $1;

                    operacion.instruccion = yy.nuevaOperacion($1.instruccion,$2.instruccion,$2.operacionPendiente,null);

                    return operacion;
                }else{
                    errorSemantico("Operandos incorrectos para el operador "+$2.operacionPendiente+" .",linea,columna);
                    return null;
                }
            }else{
                return $1;
            }
        }catch(error){
            return null;
        }
    }

    function produccionPrima(yy,$1,$2,$3,linea,columna){
        try{
            if($3==null){
                operacion = new Object();
                operacion.tipoResultado = $2.tipoResultado;
                operacion.operacionPendiente = $1;

                operacion.instruccion = $2.instruccion;

                return operacion;
            }else{
                //Analizar tipo de resultado
                if($2!=null){
                    let tipoResultado = yy.filtrarOperacion($2.tipoResultado,$3.tipoResultado,$3.operacionPendiente);
                    if(tipoResultado!=null){
                        operacion = new Object();
                        operacion.tipoResultado = tipoResultado;
                        operacion.operacionPendiente = $1;

                        operacion.instruccion = yy.nuevaOperacion($2.instruccion,$3.instruccion,$3.operacionPendiente,null);

                        return operacion;
                    }else{
                        errorSemantico("Operandos incorrectos para el operador "+$3.operacionPendiente+" .",linea,columna);
                        return null;
                    }
                }else{
                    return null;
                }
            }
        }catch(error){
            return null;
        }
    }

    function agregarSimbolo(id,tipo,ambito,visibilidad,rol){
        let simboloNuevo = new Object();
        simboloNuevo.id = id;
        simboloNuevo.tipo = tipo;
        simboloNuevo.ambito = ambito;
        simboloNuevo.visibilidad = visibilidad;
        simboloNuevo.rol = rol;
        tablaDeSimbolos.push(simboloNuevo);
    }

    function agregarSimboloParametro(id,tipo,visibilidad,rol){
        let simboloNuevo = new Object();
        simboloNuevo.id = id;
        simboloNuevo.tipo = tipo;
        simboloNuevo.ambito = "";
        simboloNuevo.visibilidad = visibilidad;
        simboloNuevo.rol = rol;
        simbolosParametros.push(simboloNuevo);
    }

    function pushSimbolosParametros(){
        while(simbolosParametros.length>0){
            tablaDeSimbolos.push(simbolosParametros.pop());
            tablaDeSimbolos.at(-1).ambito = ambitoActual.at(-1);
        }
    }

    function validarVariable(id,yy){
        let tabla = tablaDeSimbolos.slice();
        while(tabla.length>0){
            let sim = tabla.pop();
            if((sim.rol==yy.VARIABLE || sim.rol==yy.PARAMETRO) && sim.id==id){
                let ambitos = ambitoActual.slice();
                while(ambitos.length>0){
                    if(sim.ambito==ambitos.pop()){
                        return sim;
                    }
                }
            }
        }
        return null;
    }

%}

%%

/** gramatica **/
inicio : a1 EOF             {
                                for(const simbolo in tablaDeSimbolos){
                                    console.log("-----------------");
                                    console.log("Id: "+tablaDeSimbolos[simbolo].id);
                                    console.log("Tipo: "+tablaDeSimbolos[simbolo].tipo);
                                    console.log("Ambito: "+tablaDeSimbolos[simbolo].ambito);
                                    console.log("Visibilidad: "+tablaDeSimbolos[simbolo].visibilidad);
                                    console.log("Rol: "+tablaDeSimbolos[simbolo].rol);
                                }
                            }
    | SALTO_DE_LINEA a1 EOF {
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

a1 : declaracion_funcion
    | declaracion_funcion a1
    | err a1
    | err
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



// DEFINICION DE FUNCION -------------------------------------------------------------------

declaracion_funcion : declaracion_funcion_p DOS_PUNTOS declaracion_funcion_b_p {
        ambitoActual.pop();
        yy.PILA_INS.sacar();
    }
    ;

declaracion_funcion_p : PR_DEF ID PARENT_A parametros_b_p PARENT_C {
        let funcion = $2+cadParametros;
        ambitoActual.push(funcion);
        agregarSimbolo(funcion,"","global",yy.PUBLIC,yy.METODO);
        yy.PILA_INS.apilar(yy.nuevoMetodo(funcion));
        cadParametros = "";
        pushSimbolosParametros();
    }
    ;

declaracion_funcion_b_p : INDENT instrucciones_metodo DEDENT
    | SALTO_DE_LINEA
    ;



parametros : parametros_p 
    | parametros_p COMA parametros
    ;

parametros_p : ID { 
        cadParametros+="_"+$1; 
        if(simbolosParametros.some(w => w.id === $1)){
            errorSemantico("La variable "+$1+" ya ha sido declarada como parámetro.",this._$.first_line,this._$.first_column);
        }else{
            agregarSimboloParametro($1,"object",yy.PRIVATE,yy.PARAMETRO);
        }
    }
    ;

parametros_b_p : parametros
    | /*Lambda*/ 
    ;

//-----------------------------------------------------------------------------------------



// INSTRUCCIONES DENTRO DE METODO ----------------------------------------------------------

instrucciones_metodo : instruccion
    | instruccion SALTO_DE_LINEA instrucciones_metodo
    | instruccion_p
    | instruccion_p instrucciones_metodo
    | err instrucciones_metodo
    | err
    ;

instruccion : instruccion_imprimir
    | manejo_variable
    ;

instruccion_p: instruccion_if
    | ciclo_for
    | ciclo_while
    ;

//-----------------------------------------------------------------------------------------



//MANEJO DE VARIABLES ---------------------------------------------------------------------

manejo_variable: ids ASIGNACION valores {
        if(ids.length == vals.length){
            while(ids.length){
                try{
                    id_a = ids.pop();
                    let sim_id_a = validarVariable(id_a,yy);

                    let valpop = vals.pop();

                    if(sim_id_a==null){
                        //Declaracion y asignacion
                        agregarSimbolo(id_a,valpop.tipoResultado,ambitoActual.at(-1),yy.PRIVATE,yy.VARIABLE);
                    }else{
                        //Asignacion
                    }
                    yy.PILA_INS.apilar(yy.nuevaAsignacion(id_a,valpop.instruccion));
                }catch(error){
                }
            }
        }else{
            errorSemantico("Los valores para asignar no son iguales a las variables indicadas. Esperado: "+ids.length+" Obtenido: "+vals.length+" .",this._$.first_line,this._$.first_column);
        }
    }
    ;

ids : ID {
        ids.push($1);
    } 
    | ID COMA ids {
        ids.push($1);  
    }
    ;

valores : expresion_multiple {
        vals.push($1);
    }
    | expresion_multiple COMA valores {
        vals.push($1);
    }
    ;




//-----------------------------------------------------------------------------------------

// FUNCIONES PRINT Y PRINTLN --------------------------------------------------------------

instruccion_imprimir : instruccion_imprimir_p PARENT_A expresion_multiple PARENT_C {
        try{
            //asignar instruccion
        }catch(error){
        }
    }
    ;

instruccion_imprimir_p : PR_PRINT { $$ = "print"; }
    | PR_PRINTLN { $$ = "println"; }
    ;

//-----------------------------------------------------------------------------------------

// CICLO WHILE ----------------------------------------------------------------------------

ciclo_while : PR_WHILE ciclo_while_p DOS_PUNTOS
    INDENT instrucciones_metodo DEDENT
    ;

ciclo_while_p : PARENT_A expresion_multiple PARENT_C {
        try{
            if($2.tipoResultado!=yy.BOOLEAN){
            errorSemantico("Tipo de dato requerido : "+yy.BOOLEAN+" . Obtenido: "+$2.tipoResultado+" .",this._$.first_line,this._$.first_column);
            }
        }catch(error){
        }
    }
    ; 

//-----------------------------------------------------------------------------------------

// CICLO FOR ------------------------------------------------------------------------------

ciclo_for : PR_FOR ID PR_IN PR_RANGE PARENT_A range PARENT_C DOS_PUNTOS 
    INDENT instrucciones_metodo DEDENT
    ;

range: numero COMA numero COMA numero
    | numero COMA numero
    | numero
    ;

numero : expresion_multiple {
        try{
            if($1.tipoResultado!=yy.INT && $1.tipoResultado!=yy.DOUBLE){
                errorSemantico("Tipo de dato requerido : "+yy.INT+" , "+yy.DOUBLE+" . Obtenido: "+$1.tipoResultado+" .",this._$.first_line,this._$.first_column);
            }
        }catch(error){
        }
    }
    ;

//-----------------------------------------------------------------------------------------



// INSTRUCCION IF -------------------------------------------------------------------------

instruccion_if : PR_IF instruccion_if_p DOS_PUNTOS
    INDENT instrucciones_metodo DEDENT instruccion_if_b_p
    ;

instruccion_if_p : PARENT_A expresion_multiple PARENT_C {
        try{
            if($2.tipoResultado!=yy.BOOLEAN){
            errorSemantico("Tipo de dato requerido : "+yy.BOOLEAN+" . Obtenido: "+$2.tipoResultado+" .",this._$.first_line,this._$.first_column);
            }
        }catch(error){
        }
    }
    ;

instruccion_if_b_p : instrucciones_elif
    | instrucciones_elif instruccion_else
    | instruccion_else
    | /*Lambda*/
    ;

instrucciones_elif : instruccion_elif
    | instrucciones_elif instruccion_elif
    ;

instruccion_elif : PR_ELIF instruccion_elif_p DOS_PUNTOS
    INDENT instrucciones_metodo DEDENT
    ;

instruccion_elif_p : PARENT_A expresion_multiple PARENT_C {
        try{
            if($2.tipoResultado!=yy.BOOLEAN){
            errorSemantico("Tipo de dato requerido : "+yy.BOOLEAN+" . Obtenido: "+$2.tipoResultado+" .",this._$.first_line,this._$.first_column);
            }
        }catch(error){
        }
    }
    ;

instruccion_else : PR_ELSE DOS_PUNTOS INDENT instrucciones_metodo DEDENT
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
                    operacion.instruccion = yy.nuevaOperacion(null,null,yy.INT,$1.toString());
                    $$ = operacion;
                }
    | DOUBLE    {
                    operacion = new Object();
                    operacion.tipoResultado = yy.DOUBLE;
                    operacion.instruccion = yy.nuevaOperacion(null,null,yy.DOUBLE,$1.toString());
                    $$ = operacion;
                }
    | STRING    {
                    operacion = new Object();
                    operacion.tipoResultado = yy.STRING;
                    operacion.instruccion = yy.nuevaOperacion(null,null,yy.STRING,$1.toString());
                    $$ = operacion;
                }
    | BOOLEAN   {
                    operacion = new Object();
                    operacion.tipoResultado = yy.BOOLEAN;
                    operacion.instruccion = yy.nuevaOperacion(null,null,yy.BOOLEAN,$1.toString());
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
                    operacion.instruccion = yy.nuevaOperacion(null,null,yy.ID,$1.toString());
                    $$ = operacion;
                }
    ;

//-----------------------------------------------------------------------------------------