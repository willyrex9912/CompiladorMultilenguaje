%lex
%options case-sensitive


%%
[ \r\t\n]+                              { /*ignorar*/}
[/][/].*                                { /*ignorar comentario de linea*/}
[/][*][^*]*[*]+([^/*][^*]*[*]+)*[/]     { /*ignorar comentario de bloque*/}

[0-9]+"."[0-9]+                         return 'DOUBLE'
[0-9]+                                  return 'INT'
\'.\'                                   { yytext = yytext.substr(1,yyleng-2); return 'CHAR'; }


//palabras reservadas
"#include"                              return 'PR_INCLUDE'


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
        

%}

%%

inicial :  a1 EOF
    ;

include : PR_INCLUDE 
    ;


