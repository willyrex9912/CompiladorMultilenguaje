export class FiltroTipoDato{

    //tipos de datos
    public INT:String = "int";
    public DOUBLE:String = "double";
    public CHAR:String = "char";
    public STRING:String = "String";
    public BOOLEAN:String = "boolean";

    //void para complemento de tipo de metodo
    public VOID:String = "void";

    //tipos de roles de simbolos
    public METODO:String = "metodo";
    public VARIABLE:String = "variable";
    public CLASE:String = "clase";

    //tipos de operaciones
    public POTENCIA:String = "^";
    public MODULO:String = "%";
    public DIVISION:String = "/";
    public MULTIPLICACION:String = "*";
    public SUMA:String = "+";
    public RESTA:String = "-";
    public IGUAL:String = "==";
    public NO_IGUAL:String = "!=";
    public MAYOR:String = ">";
    public MENOR:String = "<";
    public MAYOR_IGUAL:String = ">=";
    public MENOR_IGUAL:String = "<=";
    public AND:String = "&&";
    public OR:String = "|";
    public XOR:String = "||";

    public PUBLIC:String = "public";
    public PRIVATE:String = "private";
    public DEFAULT:String = "default";

    public filtrarOperacion(tipo1:String, tipo2:String, tipoOperacion:String):String{
        if(tipoOperacion==this.POTENCIA){
            if(tipo1 == this.INT){
                if(tipo2 == this.INT){
                    return this.INT;
                }else if(tipo2 == this.DOUBLE){
                    return this.DOUBLE;
                }else{
                    return null;
                }
            }else if(tipo1 == this.DOUBLE){
                if(tipo2 == this.DOUBLE){
                    return this.INT;
                }else if(tipo2 == this.DOUBLE){
                    return this.DOUBLE;
                }else{
                    return null;
                }
            }else{
                return null;
            }
        }else if(tipoOperacion==this.MULTIPLICACION){
            if(tipo1==this.INT){
                if(tipo2==this.INT){
                    return this.INT;
                }else if(tipo2 == this.DOUBLE){
                    return this.DOUBLE;
                }else if(tipo2 == this.CHAR){
                    return this.INT;
                }else{
                    return null;
                }
            }else if(tipo1==this.DOUBLE){
                if(tipo2==this.INT){
                    return this.DOUBLE;
                }else if(tipo2 == this.DOUBLE){
                    return this.DOUBLE;
                }else if(tipo2 == this.CHAR){
                    return this.DOUBLE;
                }else{
                    return null;
                }
            }else if(tipo1==this.CHAR){
                if(tipo2==this.INT){
                    return this.INT;
                }else if(tipo2 == this.DOUBLE){
                    return this.DOUBLE;
                }else if(tipo2 == this.CHAR){
                    return this.INT;
                }else{
                    return null;
                }
            }else{
                return null;
            }
        }else if(tipoOperacion==this.DIVISION){
            if(tipo1==this.INT){
                if(tipo2==this.INT){
                    return this.DOUBLE;
                }else if(tipo2 == this.DOUBLE){
                    return this.DOUBLE;
                }else if(tipo2 == this.CHAR){
                    return this.DOUBLE;
                }else{
                    return null;
                }
            }else if(tipo1==this.DOUBLE){
                if(tipo2==this.INT){
                    return this.DOUBLE;
                }else if(tipo2 == this.DOUBLE){
                    return this.DOUBLE;
                }else if(tipo2 == this.CHAR){
                    return this.DOUBLE;
                }else{
                    return null;
                }
            }else if(tipo1==this.CHAR){
                if(tipo2==this.INT){
                    return this.DOUBLE;
                }else if(tipo2 == this.DOUBLE){
                    return this.DOUBLE;
                }else if(tipo2 == this.CHAR){
                    return this.DOUBLE;
                }else{
                    return null;
                }
            }else{
                return null;
            }
        }else if(tipoOperacion==this.MODULO){
            if(tipo1==this.INT){
                if(tipo2==this.INT){
                    return this.INT;
                }else if(tipo2 == this.DOUBLE){
                    return this.INT;
                }else if(tipo2 == this.CHAR){
                    return this.INT;
                }else{
                    return null;
                }
            }else if(tipo1==this.DOUBLE){
                if(tipo2==this.INT){
                    return this.INT;
                }else if(tipo2 == this.DOUBLE){
                    return this.INT;
                }else if(tipo2 == this.CHAR){
                    return this.INT;
                }else{
                    return null;
                }
            }else if(tipo1==this.CHAR){
                if(tipo2==this.INT){
                    return this.INT;
                }else if(tipo2 == this.DOUBLE){
                    return this.INT;
                }else if(tipo2 == this.CHAR){
                    return this.INT;
                }else{
                    return null;
                }
            }else{
                return null;
            }
        }else if(tipoOperacion==this.SUMA){
            if(tipo1 == this.INT){
                if(tipo2 == this.INT){
                    return this.INT;
                }else if(tipo2 == this.DOUBLE){
                    return this.DOUBLE;
                }else if(tipo2 == this.CHAR){
                    return this.INT;
                }else if(tipo2 == this.STRING){
                    return this.STRING;
                }else{
                    return null;
                }
            }else if(tipo1 == this.DOUBLE){
                if(tipo2 == this.INT){
                    return this.DOUBLE;
                }else if(tipo2 == this.DOUBLE){
                    return this.DOUBLE;
                }else if(tipo2 == this.CHAR){
                    return this.DOUBLE;
                }else if(tipo2 == this.STRING){
                    return this.STRING;
                }else{
                    return null;
                }
            }else if(tipo1 == this.CHAR){
                if(tipo2 == this.INT){
                    return this.INT;
                }else if(tipo2 == this.DOUBLE){
                    return this.DOUBLE;
                }else if(tipo2 == this.CHAR){
                    return this.INT;
                }else if(tipo2 == this.STRING){
                    return this.STRING;
                }else{
                    return null;
                }
            }else if(tipo1 == this.STRING){
                return this.STRING;
            }else if(tipo1 == this.BOOLEAN){
                if(tipo2 == this.STRING){
                    return this.STRING;
                }else{
                    return null;
                }
            }else{
                return null;
            }
        }else if(tipoOperacion==this.RESTA){
            if(tipo1 == this.INT){
                if(tipo2 == this.INT){
                    return this.INT;
                }else if(tipo2 == this.DOUBLE){
                    return this.DOUBLE;
                }else if(tipo2 == this.CHAR){
                    return this.INT;
                }else{
                    return null;
                }
            }else if(tipo1 == this.DOUBLE){
                if(tipo2 == this.INT){
                    return this.DOUBLE;
                }else if(tipo2 == this.DOUBLE){
                    return this.DOUBLE;
                }else if(tipo2 == this.CHAR){
                    return this.DOUBLE;
                }else{
                    return null;
                }
            }else if(tipo1 == this.CHAR){
                if(tipo2 == this.INT){
                    return this.INT;
                }else if(tipo2 == this.DOUBLE){
                    return this.DOUBLE;
                }else if(tipo2 == this.CHAR){
                    return this.INT;
                }else{
                    return null;
                }
            }else{
                return null;
            }
        }else if(tipoOperacion==this.IGUAL || tipoOperacion==this.NO_IGUAL){
            if(tipo1 == this.INT){
                if(tipo2 == this.INT){
                    return this.BOOLEAN;
                }else if(tipo2 == this.DOUBLE){
                    return this.BOOLEAN;
                }else if(tipo2 == this.CHAR){
                    return this.BOOLEAN;
                }else{
                    return null;
                }
            }else if(tipo1 == this.DOUBLE){
                if(tipo2 == this.INT){
                    return this.BOOLEAN;
                }else if(tipo2 == this.DOUBLE){
                    return this.BOOLEAN;
                }else if(tipo2 == this.CHAR){
                    return this.BOOLEAN;
                }else{
                    return null;
                }
            }else if(tipo1 == this.CHAR){
                if(tipo2 == this.INT){
                    return this.BOOLEAN;
                }else if(tipo2 == this.DOUBLE){
                    return this.BOOLEAN;
                }else if(tipo2 == this.CHAR){
                    return this.BOOLEAN;
                }else{
                    return null;
                }
            }else if(tipo1 == this.STRING){
                if(tipo2 == this.STRING){
                    return this.BOOLEAN;
                }else{
                    return null;
                }
            }else if(tipo1 == this.BOOLEAN){
                if(tipo2 == this.BOOLEAN){
                    return this.BOOLEAN;
                }else{
                    return null;
                }
            }else{
                return null;
            }
        }else if(tipoOperacion==this.MAYOR || tipoOperacion==this.MENOR || tipoOperacion==this.MAYOR_IGUAL || tipoOperacion==this.MENOR_IGUAL){
            if(tipo1 == this.INT){
                if(tipo2 == this.INT){
                    return this.BOOLEAN;
                }else if(tipo2 == this.DOUBLE){
                    return this.BOOLEAN;
                }else if(tipo2 == this.CHAR){
                    return this.BOOLEAN;
                }else{
                    return null;
                }
            }else if(tipo1 == this.DOUBLE){
                if(tipo2 == this.INT){
                    return this.BOOLEAN;
                }else if(tipo2 == this.DOUBLE){
                    return this.BOOLEAN;
                }else if(tipo2 == this.CHAR){
                    return this.BOOLEAN;
                }else{
                    return null;
                }
            }else if(tipo1 == this.CHAR){
                if(tipo2 == this.INT){
                    return this.BOOLEAN;
                }else if(tipo2 == this.DOUBLE){
                    return this.BOOLEAN;
                }else if(tipo2 == this.CHAR){
                    return this.BOOLEAN;
                }else{
                    return null;
                }
            }else{
                return null;
            }
        }else if(tipoOperacion == this.AND || tipoOperacion == this.OR || tipoOperacion == this.XOR){
            if(tipo1==this.BOOLEAN && tipo2==this.BOOLEAN){
                return this.BOOLEAN;
            }else{
                return null;
            }
        }else{
            return null;
        }
    }
    
}

