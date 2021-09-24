import * as Separador from '../resources/analizador/separador/Separador'

export class Analizador{

    public analizar(codigo:String):String{

        let resultado:String = "codigos:\n";
        Separador.reset();
        Separador.parse(codigo);
        resultado += "codigo PY :"+Separador.getCodigoPython()+"\n";
        resultado += "codigo JAVA:"+Separador.getCodigoJava()+"\n";
        resultado += "codigo PROGRAMA:"+Separador.getCodigoPrograma()+"\n";
        return resultado;
        
    }

}