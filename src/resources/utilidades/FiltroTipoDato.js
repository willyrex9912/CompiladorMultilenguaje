
//int -> 1
//double -> 2
//char -> 3
//String -> 4
//boolean -> 5

const INT = 1;
const DOUBLE = 2;
const CHAR = 3;
const STRING = 4;
const BOOLEAN = 5;

const POTENCIA = "^";
const MODULO = "%";
const DIVISION = "/";
const MULTIPLICACION = "*";
const SUMA = "+";
const RESTA = "-";
const IGUAL = "==";
const NO_IGUAL = "!=";
const MAYOR = ">";
const MENOR = "<";
const MAYOR_IGUAL = ">=";
const MENOR_IGUAL = "<=";
const AND = "&&";
const OR = "|";
const XOR = "||";


export function filtrarOperacion(tipo1, tipo2, tipoOperacion){
    if(tipoOperacion==POTENCIA){
        return filtrarPotencia(tipo1,tipo2);
    }else{
        return null;
    }
}

function filtrarSuma(tipo1, tipo2){
    if(tipo1 == INT){
        if(tipo2 == INT){
            return INT;
        }else if(tipo2 == DOUBLE){
            return DOUBLE;
        }else if(tipo2 == CHAR){
            return INT;
        }else if(tipo2 == STRING){
            return STRING;
        }else{
            return null;
        }
    }else if(tipo1 == DOUBLE){
        if(tipo2 == INT){
            return DOUBLE;
        }else if(tipo2 == DOUBLE){
            return DOUBLE;
        }else if(tipo2 == CHAR){
            return DOUBLE;
        }else if(tipo2 == STRING){
            return STRING;
        }else{
            return null;
        }
    }else if(tipo1 == CHAR){
        if(tipo2 == INT){
            return INT;
        }else if(tipo2 == DOUBLE){
            return DOUBLE;
        }else if(tipo2 == CHAR){
            return INT;
        }else if(tipo2 == STRING){
            return STRING;
        }else{
            return null;
        }
    }else if(tipo1 == STRING){
        return STRING;
    }else if(tipo1 == BOOLEAN){
        if(tipo2 == STRING){
            return STRING;
        }else{
            return null;
        }
    }else{
        return null;
    }
}

function filtrarPotencia(tipo1, tipo2){
    if(tipo1 == INT){
        if(tipo2 == INT){
            return INT;
        }else if(tipo2 == DOUBLE){
            return DOUBLE;
        }else{
            return null;
        }
    }else if(tipo1 == DOUBLE){
        if(tipo2 == DOUBLE){
            return INT;
        }else if(tipo2 == DOUBLE){
            return DOUBLE;
        }else{
            return null;
        }
    }else{
        return null;
    }
}

export {
INT ,
DOUBLE ,
CHAR ,
STRING ,
BOOLEAN ,
POTENCIA ,
MODULO ,
DIVISION ,
MULTIPLICACION ,
SUMA ,
RESTA ,
IGUAL ,
NO_IGUAL ,
MAYOR ,
MENOR ,
MAYOR_IGUAL ,
MENOR_IGUAL ,
AND ,
OR ,
XOR
}