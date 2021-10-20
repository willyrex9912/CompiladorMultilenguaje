import * as Separador from '../resources/analizador/separador/Separador'
import { ControladorAnalisisGeneral } from './ControladorAnalisisGeneral';

export class Analizador{

    private analizadorGeneral:ControladorAnalisisGeneral;

    public constructor(){
        this.analizadorGeneral = new ControladorAnalisisGeneral();
    }

    public analizar(codigo:String):String{

        let resultado:String = "codigos:\n";
        Separador.reset();
        Separador.parse(codigo);
        /*resultado += "Paquete:"+Separador.getPaquete()+"\n";
        resultado += "codigo PY :"+Separador.getCodigoPython()+"\n";
        resultado += "codigo JAVA:"+Separador.getCodigoJava()+"\n";
        resultado += "codigo PROGRAMA:"+Separador.getCodigoPrograma()+"\n";*/
        return this.analizadorGeneral.analizar(Separador);

    }

    public getInstrucciones():Array<any>{
        return this.analizadorGeneral.getInstrucciones();
    }

}