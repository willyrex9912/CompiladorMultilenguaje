%lex
%options case-sensitive


%%
[ \r\t\n]+                   { agregarTexto(yytext); }

"%%PY"                       { codigoActual = 1; return 'ET_PY'; }
"%%JAVA"                     { codigoActual = 2; return 'ET_JAVA'; }
"%%PROGRAMA"                 { codigoActual = 3; return 'ET_PROGRAMA'; }

<<EOF>>                       return 'EOF'
.       {/*Instertar codigo para recuperar el error lexico*/
            agregarTexto(yytext);    
        }

/lex


%start inicial

%{
        let codigoPY = "";
        let codigoJAVA = "";
        let codigoPROGRAMA = "";
        let codigoActual = 0;

        function agregarTexto(texto){
                if(codigoActual==1){
                        codigoPY += texto;
                }else if(codigoActual==2){
                        codigoJAVA += texto;
                }else if(codigoActual==3){
                        codigoPROGRAMA += texto;
                }
        }

        exports.reset = function(){
                codigoPY = "";
                codigoJAVA = "";
                codigoPROGRAMA = "";
                codigoActual = 0;
        }

        exports.getCodigoPython = function(){
                return codigoPY;
        }
        
        exports.getCodigoJava = function(){
                return codigoJAVA;
        }

        exports.getCodigoPrograma = function(){
                return codigoPROGRAMA;
        }

%}

%%

inicial :  a1 EOF
    ;

a1 :    a2 a3 a4 
        | error
        ;

a2 :    ET_PY 
        | //lambda
        ;

a3 :    ET_JAVA 
        | //lambda
        ;

a4 :    ET_PROGRAMA 
        | //lambda
        ;
