/* Python Parser for Jison */
/* https://docs.python.org/2.7/reference/lexical_analysis.html */
/* https://docs.python.org/2.7/reference/grammar.html */

/* lexical gammar */

%{ let indent = [0]; %}

%lex

%%

[ \r\n]+                                { /*ignorar por el momento*/}
[\t]+                                   {
                                            let indentacion = yytext.length;
                                            console.log(yytext.length);
                                            if (indentacion > indent[0]) {
                                                indent.unshift(indentacion);
                                                console.log("retorno INDENT");
                                                return "INDENT";
                                            }

                                            var tokens = [];

                                            while (indentacion < indent[0]) {
                                                console.log("retorno DEDENT");
                                                tokens.push("DEDENT");
                                                indent.shift();
                                            }

                                            if (tokens.length) return tokens;
                                        }

"def"                                   return 'PR_DEF'
"print"                                 return 'PR_PRINT'
"println"                               return 'PR_PRINTLN'
"("                                     return 'PARENT_A'
")"                                     return 'PARENT_C'
":"                                     return 'DOS_PUNTOS'
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

    exports.getErrores = function (){
        return errores;
    }

    exports.reset = function(){
        errores.splice(0, errores.length);
        indent = [0];
    }

%}

%%

/** gramatica **/
inicio : definicion_funcion EOF
    ;

definicion_funcion : PR_DEF ID PARENT_A PARENT_C DOS_PUNTOS INDENT instrucciones DEDENT
    ;

instrucciones : instruccion 
    | instruccion instrucciones
    ;

instruccion : PR_PRINT
    ;