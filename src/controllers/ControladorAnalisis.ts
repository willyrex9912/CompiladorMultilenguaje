import * as AnalizadorJison from '../resources/analizador/Analizador'

export class Analizador{

    public analizar(codigo:String):String{

        //let resultado:String = "";
        //AnalizadorJison.reset();
        AnalizadorJison.parse(codigo);
        /*
        if(AnalizadorJison.errores.length>0){
            resultado+="Errores encontrados: "+AnalizadorJison.errores.length+"\n\n";
            for(let i=0; i<AnalizadorJison.errores.length; i++){
                resultado+="    Error en:   ' "+AnalizadorJison.errores[i].lexema+" '\n       Linea: "+AnalizadorJison.errores[i].linea+"\n       Columna: "+AnalizadorJison.errores[i].columna+"\n       Tipo: "+AnalizadorJison.errores[i].tipo+"\n       "+AnalizadorJison.errores[i].descripcion+"\n";
            }
            return resultado;
        }else{
            return "No se encontraron errores.";
        }*/
        return "vacio";
    }

}