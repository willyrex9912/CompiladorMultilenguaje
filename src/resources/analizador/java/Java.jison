%lex
%options case-sensitive


%%

[ \r\t\n]+                   { /*ignorar*/}
[/][/].*                                        { /*ignorar comentario de linea*/}
[/][*][^*]*[*]+([^/*][^*]*[*]+)*[/]             { /*ignorar comentario de bloque*/}

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

//  instrucciones y ciclos
"if"                            return 'PR_IF'
"else"                          return 'PR_ELSE'
"for"                           return 'PR_FOR'
"switch"                        return 'PR_SWITCH'
"case"                          return 'PR_CASE'
"do"                            return 'PR_DO'
"while"                         return 'PR_WHILE'
"default"                       return 'PR_DEFAULT'
"break"                         return 'PR_BREAK'
"println"                       return 'PR_PRINTLN'
"print"                         return 'PR_PRINT'


//simbolos
"++"                            return 'INCREMENTO'
"--"                            return 'DECREMENTO'
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
"||"                            return 'XOR'
"|"                             return 'OR'
"&&"                            return 'AND'
"=="                            return 'IGUAL'
"!="                            return 'NO_IGUAL'
">="                            return 'MAYOR_IGUAL'
"<="                            return 'MENOR_IGUAL'
">"                             return 'MAYOR'
"<"                             return 'MENOR'
"!"                             return 'NOT'
";"                             return 'PUNTO_Y_COMA'
":"                             return 'DOS_PUNTOS'
","                             return 'COMA'
"="                             return 'ASIGNACION'

[a-zA-Z]+[a-zA-Z0-9_]*          return 'ID'




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
    //-w-let tablaDeSimbolos = [];
    let tablasDeSimbolos = [];
    //-w-let ambitoActual = [];
    let ids = [];
    let simbolosParametros = [];
    let cadParametros = "";
    let ambitoClase = true;
    let tipoDatoSwtich = "";

    exports.getErrores = function (){
        return errores;
    }

    exports.reset = function(){
        errores.splice(0, errores.length);
        //-w-tablaDeSimbolos.splice(0, tablaDeSimbolos.length);
        tablasDeSimbolos.splice(0, tablasDeSimbolos.length);
        let tablaGlobal = [];
        tablasDeSimbolos.push(tablaGlobal);
        //-w-ambitoActual.splice(0, ambitoActual.length);
        ids.splice(0, ids.length);
        simbolosParametros.splice(0, simbolosParametros.length);
        cadParametros = "";
        ambitoClase = true;
        tipoDatoSwtich = "";
    }

    function nuevoAmbito(){
        let nuevaTabla = [];
        if(tablasDeSimbolos.length){
            nuevaTabla = tablasDeSimbolos.at(-1).slice();
        }
        tablasDeSimbolos.push(nuevaTabla);
    }

    function getAmbitoActual(){
        return tablasDeSimbolos.at(-1);
    }

    function cerrarAmbito(){
        tablasDeSimbolos.pop();
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
                return operacion;
            }else{
                //Analizar tipo de resultado
                if($2!=null){
                    let tipoResultado = yy.filtrarOperacion($2.tipoResultado,$3.tipoResultado,$3.operacionPendiente);
                    if(tipoResultado!=null){
                        operacion = new Object();
                        operacion.tipoResultado = tipoResultado;
                        operacion.operacionPendiente = $1;
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

    //-w-function existeSimbolo(id,ambito,rol){
    function existeSimbolo(id,rol){
        //-w-for(let simbolo in tablaDeSimbolos){
        for(let simbolo in getAmbitoActual()){
            //-w-if(tablaDeSimbolos[simbolo].rol==rol && tablaDeSimbolos[simbolo].id==id && ambito==tablaDeSimbolos[simbolo].ambito){
            if(getAmbitoActual()[simbolo].rol==rol && getAmbitoActual()[simbolo].id==id){
                return true;
            }
        }
        return false;
    }

    function existeClase(id,yy){
        //-w-for(let simbolo in tablaDeSimbolos){
        for(let simbolo in getAmbitoActual()){
            //-w-if(tablaDeSimbolos[simbolo].rol==yy.CLASE && tablaDeSimbolos[simbolo].id==id){
            if(getAmbitoActual()[simbolo].rol==yy.CLASE && getAmbitoActual()[simbolo].id==id){
                return true;
            }
        }
        return false;
    }

    function obtenerSimbolo(id){
        //-w-for (let i=tablaDeSimbolos.length - 1; i >= 0; i--) {
        //-w-for (let i=tablaDeSimbolos.length - 1; i >= 0; i--) {
            //-w-if(id==tablaDeSimbolos[i].id){
                //-w-return tablaDeSimbolos[i];
        for (let i=getAmbitoActual().length - 1; i >= 0; i--) {
            if(id==getAmbitoActual()[i].id){
                return getAmbitoActual()[i];
            }
        }
        return null;
    }

    function obtenerUltimoMetodo(yy){
        /*-w-for (let i=tablaDeSimbolos.length - 1; i >= 0; i--) {
            if(tablaDeSimbolos[i].rol == yy.METODO){
                return tablaDeSimbolos[i];
            }
        }*/
        console.log(tablasDeSimbolos);
        for (let i=getAmbitoActual().length - 1; i >= 0; i--) {
            if(getAmbitoActual()[i].rol == yy.METODO){
                return getAmbitoActual()[i];
            }
        }
        return null;
    }

    function agregarSimbolo(id,tipo,ambito,visibilidad,rol){
        let simboloNuevo = new Object();
        simboloNuevo.id = id;
        simboloNuevo.tipo = tipo;
        simboloNuevo.ambito = ambito;
        simboloNuevo.visibilidad = visibilidad;
        simboloNuevo.rol = rol;
        //-w-tablaDeSimbolos.push(simboloNuevo);
        getAmbitoActual().push(simboloNuevo);
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
            //-w-tablaDeSimbolos.push(simbolosParametros.pop());
            getAmbitoActual().push(simbolosParametros.pop());
            //-w-tablaDeSimbolos.at(-1).ambito = ambitoActual.at(-1);
        }
    }

    function validarVariable(id,yy){
        //-w-let tabla = tablaDeSimbolos.slice();
        let tabla = getAmbitoActual().slice();
        while(tabla.length>0){
            let sim = tabla.pop();
            if((sim.rol==yy.VARIABLE || sim.rol==yy.PARAMETRO) && sim.id==id){
                /*-w-let ambitos = ambitoActual.slice();
                while(ambitos.length>0){
                    if(sim.ambito==ambitos.pop()){
                        return sim;
                    }
                }*/
                return sim;
            }
        }
        return null;
    }
%}

%%

inicial :  a1 EOF   {
                        for(const simbolo in getAmbitoActual()){
                            console.log("-----------------");
                            /*-w-console.log("Id: "+tablaDeSimbolos[simbolo].id);
                            console.log("Tipo: "+tablaDeSimbolos[simbolo].tipo);
                            console.log("Ambito: "+tablaDeSimbolos[simbolo].ambito);
                            console.log("Visibilidad: "+tablaDeSimbolos[simbolo].visibilidad);
                            console.log("Rol: "+tablaDeSimbolos[simbolo].rol);*/
                            console.log("Id: "+getAmbitoActual()[simbolo].id);
                            console.log("Tipo: "+getAmbitoActual()[simbolo].tipo);
                            console.log("Ambito: "+getAmbitoActual()[simbolo].ambito);
                            console.log("Visibilidad: "+getAmbitoActual()[simbolo].visibilidad);
                            console.log("Rol: "+getAmbitoActual()[simbolo].rol);
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
        //-w-ambitoActual.pop();
        cerrarAmbito();
    }
    | declaracion_clase_p LLAVE_A LLAVE_C { 
        //-w-ambitoActual.pop(); 
        cerrarAmbito();
    }
    | err
    ;

declaracion_clase_p : PR_PUBLIC PR_CLASS ID {
            if(existeClase($3,yy)){
                errorSemantico("La clase "+$3+" ya ha sido declarada.",this._$.first_line,this._$.first_column);
            }
            agregarSimbolo($3,"","",yy.PUBLIC,yy.CLASE);
            //-w-ambitoActual.push("class "+$3);
            nuevoAmbito();
        }
    ;

//------------------------------------------------------------------------------------


//INSTRUCCIONES DENTRO DE CLASE--------------------------------------------------------

instrucciones_clase : instrucciones_clase_p
    | instrucciones_clase_p instrucciones_clase
    ;

instrucciones_clase_p : declaracion_variable PUNTO_Y_COMA
    | declaracion_metodo
    ;

//-------------------------------------------------------------------------------------

//INSTRUCCIONES DENTRO DE METODO--------------------------------------------------------

instrucciones_metodo : instrucciones_metodo_p
    | instrucciones_metodo_p instrucciones_metodo
    ;

instrucciones_metodo_p : declaracion_variable PUNTO_Y_COMA
    | asignacion_variable PUNTO_Y_COMA
    | instruccion_if
    | ciclo_for
    | ciclo_while
    | ciclo_do_while
    | instruccion_switch
    | instruccion_print
    | instruccion_println
    ;

//-------------------------------------------------------------------------------------

//DECLARACION DE VARIABLE ------------------------------------------------------------

declaracion_variable : visibilidad tipo ids asignacion {
            if($1 != yy.DEFAULT){
                if(!ambitoClase){
                    errorSemantico("Ilegal inicio de expresión: "+$1+".",this._$.first_line,this._$.first_column);
                }
            }
            //declaracion y asignacion
            if($4==null || $2 == $4.tipoResultado){
                while(ids.length>0){
                    //asignacion de tipo correcta
                    let id = ids.pop();
                    //-w-if(existeSimbolo(id,ambitoActual.at(-1),yy.VARIABLE)){
                    if(existeSimbolo(id,yy.VARIABLE)){
                        errorSemantico("La variable "+id+" ya ha sido declarada.",this._$.first_line,this._$.first_column);
                    }else{
                        if($4 != null){
                            //simboloVariable.valor = $4.valor;
                        }
                        //-w-agregarSimbolo(id,$2,ambitoActual.at(-1),$1,yy.VARIABLE);
                        agregarSimbolo(id,$2,"",$1,yy.VARIABLE);
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

asignacion : /*Lambda*/ { $$ = null; }
    | ASIGNACION expresion_multiple { $$ = $2; }
    ;

//------------------------------------------------------------------------------------

//ASIGNACION DE VARIABLES ------------------------------------------------------------

asignacion_variable : ID ASIGNACION expresion_multiple {
        //validando id
        let simId = validarVariable($1,yy);
        if(simId==null){
            errorSemantico("No se encuentra el símbolo "+$1+" .",this._$.first_line,this._$.first_column);
        }else{
            if(simId.tipo == $3.tipoResultado){
                //asignacion exitosa;
                //++++++++++++++++++++++++AGREGAR EN CUADRUPLA++++++++++++++++++++++++
                //++++++++++++++++++++++++AGREGAR EN CUADRUPLA++++++++++++++++++++++++
                //++++++++++++++++++++++++AGREGAR EN CUADRUPLA++++++++++++++++++++++++
            }else{
                errorSemantico("Tipo de dato requerido : "+simId.tipo+" . Obtenido: "+$3.tipoResultado+" .",this._$.first_line,this._$.first_column);
            }
        }
    }
    | ID inc_dec {
        let simId_a = validarVariable($1,yy);
        if(simId_a==null){
            errorSemantico("No se encuentra el símbolo "+$1+" .",this._$.first_line,this._$.first_column);
        }else{
            if(simId_a.tipo == yy.INT || simId_a.tipo == yy.DOUBLE){
                //asignacion exitosa;
                //++++++++++++++++++++++++AGREGAR EN CUADRUPLA++++++++++++++++++++++++
                //++++++++++++++++++++++++AGREGAR EN CUADRUPLA++++++++++++++++++++++++
                //++++++++++++++++++++++++AGREGAR EN CUADRUPLA++++++++++++++++++++++++
            }else{
                errorSemantico("Tipo de dato requerido : "+yy.INT+","+yy.DOUBLE+" . Obtenido: "+simId_a.tipo+" .",this._$.first_line,this._$.first_column);
            }
        }
    }
    ;

inc_dec : INCREMENTO
    | DECREMENTO
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
        //-w-ambitoActual.pop(); 
        cerrarAmbito();
        ambitoClase = true;
    }
    | declaracion_metodo_p_a LLAVE_A LLAVE_C { 
        //-w-ambitoActual.pop();
        cerrarAmbito();
        ambitoClase = true; 
    }
    ;

declaracion_metodo_p_a : ID PARENT_A parametros_b_p PARENT_C {
        //-w-if(existeSimbolo(ambitoActual.at(-1)+"_"+$1+cadParametros,ambitoActual.at(-1),yy.METODO)){
        if(existeSimbolo($1+cadParametros,yy.METODO)){
            //-w-errorSemantico("El método "+$1+cadParametros+" ya ha sido declarado en "+ambitoActual.at(-1)+".",this._$.first_line,this._$.first_column);
            errorSemantico("El método "+$1+cadParametros+" ya ha sido declarado.",this._$.first_line,this._$.first_column);
        }
        //-w-agregarSimbolo(ambitoActual.at(-1)+"_"+$1+cadParametros,"",ambitoActual.at(-1),"",yy.METODO);
        agregarSimbolo($1+cadParametros,"","","",yy.METODO);
        nuevoAmbito();
        
        //-w-ambitoActual.push(ambitoActual.at(-1)+"_"+$1+cadParametros);
        ambitoClase = false;
        cadParametros = "";
        pushSimbolosParametros();
    }
    ;

parametros : parametros_p 
    | parametros_p COMA parametros
    ;

parametros_p : tipo ID { 
        cadParametros+="_"+$1; 
        if(simbolosParametros.some(w => w.id === $2)){
            errorSemantico("La variable "+$2+" ya ha sido definida como parámetro.",this._$.first_line,this._$.first_column);
        }else{
            agregarSimboloParametro($2,$1,yy.PRIVATE,yy.PARAMETRO);
        }
    }
    ;

parametros_b_p : parametros
    | /*Lambda*/ 
    ;

//------------------------------------------------------------------------------------

//INSTRUCCIONES PRINT Y PRINTLN ------------------------------------------------------

instruccion_print : PR_PRINT PARENT_A expresion_multiple PARENT_C PUNTO_Y_COMA {

    }
    ;

instruccion_println : PR_PRINTLN PARENT_A expresion_multiple PARENT_C PUNTO_Y_COMA {

    }
    ;

//------------------------------------------------------------------------------------

//CONDICIONAL IF ELSE-IF ELSE --------------------------------------------------------

instruccion_if : instruccion_if_b_p LLAVE_A instrucciones_metodo LLAVE_C fin_if instruccion_if_p {
        yy.PILA_INS.sacar();
    }
    ;

inicio_if : { nuevoAmbito(); };

fin_if : { cerrarAmbito(); };

instruccion_if_b_p : PR_IF inicio_if PARENT_A expresion_multiple PARENT_C {
        try{
            if($3.tipoResultado!=yy.BOOLEAN){
                errorSemantico("Tipo de dato requerido : "+yy.BOOLEAN+" . Obtenido: "+$3.tipoResultado+" .",this._$.first_line,this._$.first_column);
            }

            yy.PILA_INS.apilar(yy.nuevoIf($4.instruccion));
        }catch(exception){
        }
    }
    ;

instruccion_if_p : instrucciones_else_if
    | instrucciones_else_if instruccion_else
    | instruccion_else
    | /*Lambda*/
    ;

instrucciones_else_if : instruccion_else_if
    | instrucciones_else_if instruccion_else_if
    ;

instruccion_else_if : instruccion_else_if_b_p  LLAVE_A instrucciones_metodo LLAVE_C fin_else_if
    ;

fin_else_if : { 
        cerrarAmbito(); 
        yy.PILA_INS.sacar();
    };

instruccion_else_if_b_p : PR_ELSE PR_IF PARENT_A expresion_multiple PARENT_C {
        nuevoAmbito();
        yy.PILA_INS.apilar(yy.nuevoElseIf($4.instruccion));
        try{
            if($4.tipoResultado!=yy.BOOLEAN){
                errorSemantico("Tipo de dato requerido : "+yy.BOOLEAN+" . Obtenido: "+$4.tipoResultado+" .",this._$.first_line,this._$.first_column);
            }
        }catch(exception){
        }
    }
    ;

instruccion_else : PR_ELSE inicio_else LLAVE_A instrucciones_metodo LLAVE_C fin_else
    ;

inicio_else : { 
        nuevoAmbito(); 
        yy.PILA_INS.apilar(yy.nuevoElse());
    };

fin_else : { 
        cerrarAmbito(); 
        yy.PILA_INS.sacar();
    };

//------------------------------------------------------------------------------------



// CICLO DO WHILE --------------------------------------------------------------------

ciclo_do_while : PR_DO inicio_do LLAVE_A instrucciones_metodo LLAVE_C fin_do
    PR_WHILE PARENT_A expresion_multiple PARENT_C PUNTO_Y_COMA {
        try{
            if($9.tipoResultado!=yy.BOOLEAN){
                errorSemantico("Tipo de dato requerido : "+yy.BOOLEAN+" . Obtenido: "+$9.tipoResultado+" .",this._$.first_line,this._$.first_column);
            }
        }catch(exception){
        }
    }
    ;

inicio_do : { nuevoAmbito(); };

fin_do : { cerrarAmbito(); };

//------------------------------------------------------------------------------------

// CICLO WHILE --------------------------------------------------------------------

ciclo_while : parte_while LLAVE_A instrucciones_metodo LLAVE_C fin_while
    ;

parte_while : PR_WHILE inicio_while PARENT_A expresion_multiple PARENT_C {
        try{
            if($4.tipoResultado!=yy.BOOLEAN){
                errorSemantico("Tipo de dato requerido : "+yy.BOOLEAN+" . Obtenido: "+$4.tipoResultado+" .",this._$.first_line,this._$.first_column);
            }
        }catch(exception){
        }
    }
    ;

inicio_while : { nuevoAmbito(); };

fin_while : { cerrarAmbito(); };

//------------------------------------------------------------------------------------

//CICLO FOR --------------------------------------------------------------------------

ciclo_for : PR_FOR inicio_for PARENT_A ciclo_for_p PARENT_C LLAVE_A instrucciones_metodo LLAVE_C fin_for {
        //-w-ambitoActual.pop();
    }
    ;

inicio_for : { nuevoAmbito(); };

fin_for : { cerrarAmbito(); };  

/* -w-
ciclo_for_b_p : PR_FOR {
        //-w-ambitoActual.push(ambitoActual.at(-1)+"_for");
    }
    ;*/

ciclo_for_p : primera_exp PUNTO_Y_COMA expresion_multiple PUNTO_Y_COMA accion_posterior {
        try{
            if($3.tipoResultado!=yy.BOOLEAN){
            errorSemantico("Tipo de dato requerido : "+yy.BOOLEAN+" . Obtenido: "+$3.tipoResultado+" .",this._$.first_line,this._$.first_column); 
            }
        }catch(e){
        }
    }
    ;

primera_exp : declaracion_variable
    | asignacion_variable
    ;

accion_posterior : asignacion_variable
    | /*Lambda*/
    ;

//------------------------------------------------------------------------------------


instruccion_switch : inicio_switch instruccion_switch_c_p 
    ;

inicio_switch : PR_SWITCH  PARENT_A expresion_multiple PARENT_C {
        if($3.tipoResultado == yy.DOUBLE || $3.tipoResultado == yy.BOOLEAN){
            errorSemantico("Tipo de dato requerido : "+yy.INT+","+yy.CHAR+","+yy.STRING+" . Obtenido: "+$3.tipoResultado+" .",this._$.first_line,this._$.first_column);
        }
        tipoDatoSwtich = $3.tipoResultado;
    }
    ;

instruccion_switch_c_p : LLAVE_A LLAVE_C
    | LLAVE_A instruccion_switch_t_p LLAVE_C
    | LLAVE_A instruccion_switch_default LLAVE_C
    | LLAVE_A instruccion_switch_t_p instruccion_switch_default LLAVE_C
    ;

instruccion_switch_t_p : instruccion_switch_b_p
    | instruccion_switch_b_p instruccion_switch_t_p
    ;

instruccion_switch_b_p : PR_CASE inicio_cas_sw expresion_multiple DOS_PUNTOS instrucciones_metodo instruccion_break fin_cas_sw {
        if($3.tipoResultado != tipoDatoSwtich){
            errorSemantico("Tipo de dato requerido : "+tipoDatoSwtich+" . Obtenido: "+$3.tipoResultado+" .",this._$.first_line,this._$.first_column);
        }
    }
    ;

inicio_cas_sw : { nuevoAmbito(); };

fin_cas_sw : { cerrarAmbito(); }; 

instruccion_switch_default : PR_DEFAULT inicio_def_sw DOS_PUNTOS instrucciones_metodo fin_def_sw
    ;

inicio_def_sw : { nuevoAmbito(); };

fin_def_sw : { cerrarAmbito(); };  

//------------------------------------------------------------------------------------

// INSTRUCCION BREAK ----------------------------------------------------------------

instruccion_break : PR_BREAK PUNTO_Y_COMA
    | /*Lambda*/
    ;

//-----------------------------------------------------------------------------------

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


//-------------------------------------------------------------------------------


