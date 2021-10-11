%lex
%options case-sensitive


%%
[ \r\t\n]+                              { /*ignorar*/}
[/][/].*                                { /*ignorar comentario de linea*/}
[/][*][^*]*[*]+([^/*][^*]*[*]+)*[/]     { /*ignorar comentario de bloque*/}

[0-9]+"."[0-9]+                         return 'FLOAT'
[0-9]+                                  return 'INT'
\'.\'                                   { yytext = yytext.substr(1,yyleng-2); return 'CHAR'; }
\"[^"]*\"                               { yytext = yytext.substr(1,yyleng-2); return 'PAQUETE'; }

//palabras reservadas
"int"                                   return 'PR_INT'
"float"                                 return 'PR_FLOAT'
"char"                                  return 'PR_CHAR'
"const"                                 return 'PR_CONST'
"#include"                              return 'PR_INCLUDE'
"void"                                  return 'PR_VOID'
"main"                                  return 'PR_MAIN'

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

[a-zA-Z]+[a-zA-Z0-9_]*                  return 'ID'

<<EOF>>                       return 'EOF'
.       {/*Instertar codigo para recuperar el error lexico*/
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

    exports.getErrores = function (){
        return errores;
    }
        
    exports.reset = function(yy){
        errores.splice(0, errores.length);
        tablaDeSimbolos.splice(0, tablaDeSimbolos.length);
        ambitoActual = [yy.GLOBAL];
        ids.splice(0, ids.length);
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
        }catch(error){
            return null;
        }
    }

    function existeSimbolo(id,ambito,rol){
        for(let simbolo in tablaDeSimbolos){
            if(tablaDeSimbolos[simbolo].rol==rol && tablaDeSimbolos[simbolo].id==id && ambito==tablaDeSimbolos[simbolo].ambito){
                return true;
            }
        }
        return false;
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

    function validarVariable(id,yy){
        let tabla = tablaDeSimbolos.slice();
        while(tabla.length>0){
            let sim = tabla.pop();
            if((sim.rol==yy.VARIABLE || sim.rol==yy.PARAMETRO || sim.rol==yy.CONSTANTE) && sim.id==id){
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

a1 : instrucciones_include declaraciones
    ;

include : PR_INCLUDE PAQUETE 
    ;

instrucciones_include :  instrucciones_include_p
    | /*Lambda*/
    ;

instrucciones_include_p : include
    | include instrucciones_include_p
    ;





// DECLARACION DE VARIABLES --------------------------------------------------------

declaraciones : declaraciones_p
    | /*Lambda*/
    ;

declaraciones_p : declaracion_variable
    | declaracion_variable declaraciones_p
    ;

declaracion_variable : tipo ids asignacion PUNTO_Y_COMA {
        //declaracion y asignacion
        if($3==null || $1 == $3.tipoResultado){
            while(ids.length>0){
                //asignacion de tipo correcta
                let id = ids.pop();
                if(existeSimbolo(id,ambitoActual.at(-1),yy.VARIABLE) || existeSimbolo(id,ambitoActual.at(-1),yy.CONSTANTE)){
                    errorSemantico("La variable "+id+" ya ha sido declarada en "+ambitoActual.at(-1)+".",this._$.first_line,this._$.first_column);
                }else{
                    if($3 != null){
                        //simboloVariable.valor = $3.valor;
                    }
                    agregarSimbolo(id,$1,yy.GLOBAL,yy.DEFAULT,yy.VARIABLE);
                }
            }
        }else{
            errorSemantico("Tipo de dato requerido : "+$1+" . Obtenido: "+$3.tipoResultado+" .",this._$.first_line,this._$.first_column);
        }
    }
    | PR_CONST tipo ids ASIGNACION expresion_multiple PUNTO_Y_COMA {
        //declaracion y asignacion
        if($2 == $5.tipoResultado){
            while(ids.length>0){
                //asignacion de tipo correcta
                let id = ids.pop();
                if(existeSimbolo(id,ambitoActual.at(-1),yy.VARIABLE) || existeSimbolo(id,ambitoActual.at(-1),yy.CONSTANTE)){
                    errorSemantico("La variable "+id+" ya ha sido declarada en "+ambitoActual.at(-1)+".",this._$.first_line,this._$.first_column);
                }else{
                    //simboloVariable.valor = $3.valor;
                    agregarSimbolo(id,$2,yy.GLOBAL,yy.DEFAULT,yy.CONSTANTE);
                }
            }
        }else{
            errorSemantico("Tipo de dato requerido : "+$2+" . Obtenido: "+$5.tipoResultado+" .",this._$.first_line,this._$.first_column);
        }
    }
    ;

ids : ids_p
    | ids_p COMA ids
    ;

ids_p : ID { ids.push($1); }
    ;

tipo : PR_INT { $$ = yy.INT; }
    | PR_FLOAT { $$ = yy.FLOAT; }
    | PR_CHAR { $$ = yy.CHAR; }
    ;

asignacion : /*Lambda*/ { $$ = null; }
    | ASIGNACION expresion_multiple { $$ = $2; }
    ;


//----------------------------------------------------------------------------------

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
    | FLOAT    {
                    operacion = new Object();
                    operacion.tipoResultado = yy.FLOAT;
                    $$ = operacion;
                }
    | CHAR      {
                    operacion = new Object();
                    operacion.tipoResultado = yy.CHAR;
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
