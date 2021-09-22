import * as AnalizadorJison from '../resources/analizador/Analizador'

export class Analizador{

    public analizar(codigo:String):String{
        AnalizadorJison.parse(codigo);
        return "ESTE ES EL CODIGO: \n"+codigo;
    }

}