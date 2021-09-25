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
"{"                             return 'LLAVE_A'
"}"                             return 'LLAVE_C'
"["                             return 'CORCH_A'
"]"                             return 'CORCH_C'
"("                             return 'PARENT_A'
")"                             return 'PARENT_C'
"|"                             return 'PLECA'
";"                             return 'PUNTO_Y_COMA'

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

declaracion_clase : PR_PUBLIC PR_CLASS ID LLAVE_A LLAVE_C
    | err
    ;
