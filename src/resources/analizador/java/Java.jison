%lex
%options case-sensitive


%%

[ \r\t\n]+                   { /*ignorar*/}

[0-9]+                          return 'ENTERO'
"public"                        return 'PR_PUBLIC'
"¿"                             return 'QM_APERTURA'
[?]                             return 'QM_CIERRE'
[*]                             return 'ASTERISCO'
[+]                             return 'MAS'
"{"                             return 'LLAVE_APERTURA'
"}"                             return 'LLAVE_CIERRE'
"["                             return 'CORCH_APERTURA'
"]"                             return 'CORCH_CIERRE'
"("                             return 'PARENT_APERTURA'
")"                             return 'PARENT_CIERRE'
"|"                             return 'PLECA'
":"                             return 'DOS_PUNTOS'
";"                             return 'PUNTO_Y_COMA'


"//".*                                           { /*ignorar comentario de linea*/}
[/][*][^*]*[*]+([^/*][^*]*[*]+)*[/]             { /*ignorar comentario de bloque*/}

\"[^""]*\""                       { yytext = yytext.substr(1,yyleng-2); return 'CADENA'; }

<<EOF>>                         return 'EOF'
.                               {/*Instertar codigo para recuperar el error lexico*/
            //error
            ErrorLS = new Object();
            ErrorLS.lexema = yytext;
            ErrorLS.linea = yylloc.first_line;
            ErrorLS.columna = yylloc.first_column;
            ErrorLS.descripcion = 'Error léxico en '+yytext;
            errores.push(ErrorLS);
    }


/lex


%start inicial

%{
    let errores = [];

    exports.getErrores = function (){
        return errores;
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
            ErrorLS.descripcion = '';
            errores.push(ErrorLS);
    }
    ;
