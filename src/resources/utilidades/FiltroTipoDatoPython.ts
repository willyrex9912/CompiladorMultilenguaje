export class FiltroTipoDatoPython{

    //tipos de datos
    public INT:string = "int";
    public DOUBLE:string = "double";
    public STRING:string = "String";
    public BOOLEAN:string = "boolean";

    public ID:string = "id";

    //private para variables
    public PUBLIC:string = "public";
    public PRIVATE:string = "private";

    //tipos de roles de simbolos
    public METODO:string = "metodo";
    public VARIABLE:string = "variable";
    public PARAMETRO:string = "parametro";

    //tipos de operaciones
    public POTENCIA:string = "**";
    public MODULO:string = "%";
    public DIVISION:string = "/";
    public MULTIPLICACION:string = "*";
    public SUMA:string = "+";
    public RESTA:string = "-";
    public IGUAL:string = "==";
    public NO_IGUAL:string = "!=";
    public MAYOR:string = ">";
    public MENOR:string = "<";
    public MAYOR_IGUAL:string = ">=";
    public MENOR_IGUAL:string = "<=";
    public AND:string = "and";
    public OR:string = "or";

    public filtrarOperacion(tipo1:String, tipo2:String, tipoOperacion:String):string{
        if(tipoOperacion==this.POTENCIA){
            if(tipo1 == this.INT){
                if(tipo2 == this.INT){
                    return this.INT;
                }else if(tipo2 == this.DOUBLE){
                    return this.DOUBLE;
                }else if(tipo2 == this.BOOLEAN){
                    return this.INT;
                }else{
                    return null;
                }
            }else if(tipo1 == this.DOUBLE){
                if(tipo2 == this.INT){
                    return this.DOUBLE;
                }else if(tipo2 == this.DOUBLE){
                    return this.DOUBLE;
                }else if(tipo2 == this.BOOLEAN){
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
                }else if(tipo2 == this.BOOLEAN){
                    return this.INT;
                }else{
                    return null;
                }
            }else if(tipo1==this.DOUBLE){
                if(tipo2==this.INT){
                    return this.DOUBLE;
                }else if(tipo2 == this.DOUBLE){
                    return this.DOUBLE;
                }else if(tipo2 == this.BOOLEAN){
                    return this.DOUBLE;
                }else{
                    return null;
                }
            }else{
                return null;
            }
        }else if(tipoOperacion==this.DIVISION){
            if(tipo1==this.INT || tipo1 == this.DOUBLE || tipo1 == this.BOOLEAN){
                if(tipo2==this.INT || tipo2 == this.DOUBLE || tipo2 == this.BOOLEAN){
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
                    return this.DOUBLE;
                }else if(tipo2 == this.BOOLEAN){
                    return this.INT;
                }else{
                    return null;
                }
            }else if(tipo1==this.DOUBLE){
                if(tipo2==this.INT){
                    return this.DOUBLE;
                }else if(tipo2 == this.DOUBLE){
                    return this.DOUBLE;
                }else if(tipo2 == this.BOOLEAN){
                    return this.DOUBLE;
                }else{
                    return null;
                }
            }else if(tipo1==this.BOOLEAN){
                if(tipo2==this.INT){
                    return this.INT;
                }else if(tipo2 == this.DOUBLE){
                    return this.DOUBLE;
                }else if(tipo2 == this.BOOLEAN){
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
                }else if(tipo2 == this.BOOLEAN){
                    return this.INT;
                }else{
                    return null;
                }
            }else if(tipo1 == this.DOUBLE){
                if(tipo2 == this.INT){
                    return this.DOUBLE;
                }else if(tipo2 == this.DOUBLE){
                    return this.DOUBLE;
                }else if(tipo2 == this.BOOLEAN){
                    return this.DOUBLE;
                }else{
                    return null;
                }
            }else if(tipo1 == this.STRING){
                if(tipo2 == this.STRING){
                    return this.STRING;
                }else{
                    return null;
                }
            }else if(tipo1 == this.BOOLEAN){
                if(tipo2 == this.INT){
                    return this.INT;
                }else if(tipo2 == this.DOUBLE){
                    return this.DOUBLE;
                }else if(tipo2 == this.BOOLEAN){
                    return this.INT;
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
                }else if(tipo2 == this.BOOLEAN){
                    return this.INT;
                }else{
                    return null;
                }
            }else if(tipo1 == this.DOUBLE){
                if(tipo2 == this.INT){
                    return this.DOUBLE;
                }else if(tipo2 == this.DOUBLE){
                    return this.DOUBLE;
                }else if(tipo2 == this.BOOLEAN){
                    return this.DOUBLE;
                }else{
                    return null;
                }
            }else if(tipo1 == this.BOOLEAN){
                if(tipo2 == this.INT){
                    return this.INT;
                }else if(tipo2 == this.DOUBLE){
                    return this.DOUBLE;
                }else if(tipo2 == this.BOOLEAN){
                    return this.INT;
                }else{
                    return null;
                }
            }else{
                return null;
            }
        }else if(tipoOperacion==this.IGUAL || tipoOperacion==this.NO_IGUAL){
            return this.BOOLEAN;
        }else if(tipoOperacion==this.MAYOR || tipoOperacion==this.MENOR || tipoOperacion==this.MAYOR_IGUAL || tipoOperacion==this.MENOR_IGUAL){
            if(tipo1 == this.INT || tipo1 == this.DOUBLE || tipo1 == this.BOOLEAN){
                if(tipo2 == this.INT || tipo2 == this.DOUBLE || tipo2 == this.BOOLEAN){
                    return this.BOOLEAN;
                }else{
                    return null;
                }
            }else{
                return null;
            }
        }else if(tipoOperacion == this.AND || tipoOperacion == this.OR){
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

