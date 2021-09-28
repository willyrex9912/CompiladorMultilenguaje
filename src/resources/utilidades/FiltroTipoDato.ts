export class FiltroTipoDato{

    public INT:String = "int";
    public DOUBLE:String = "double";
    public CHAR:String = "char";
    public STRING:String = "String";
    public BOOLEAN:String = "boolean";

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
        }else{
            return null;
        }
    }
    
}

