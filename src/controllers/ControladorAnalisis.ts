import { PilaInstruccion } from 'src/model/instruccion/estructura/PilaInstruccion';
import { Archivo } from 'src/model/Proyecto/Archivo';
import { Proyecto } from 'src/model/Proyecto/Proyecto';
import { RecuperadorArchivos } from 'src/resources/utilidades/proyecto/RecuperadorArchivos';
import * as Separador from '../resources/analizador/separador/Separador'
import { ControladorAnalisisGeneral } from './ControladorAnalisisGeneral';

export class Analizador{

    private analizadorGeneral:ControladorAnalisisGeneral;
    private recuperadorArchivos:RecuperadorArchivos;

    public constructor(){
        this.analizadorGeneral = new ControladorAnalisisGeneral();
        this.recuperadorArchivos = new RecuperadorArchivos();
    }

    public analizar(codigo:String,pila:PilaInstruccion,pilaJava:PilaInstruccion):String{

        let resultado:String = "codigos:\n";
        Separador.reset();
        Separador.parse(codigo);
        /*resultado += "Paquete:"+Separador.getPaquete()+"\n";
        resultado += "codigo PY :"+Separador.getCodigoPython()+"\n";
        resultado += "codigo JAVA:"+Separador.getCodigoJava()+"\n";
        resultado += "codigo PROGRAMA:"+Separador.getCodigoPrograma()+"\n";*/
        return this.analizadorGeneral.analizar(Separador,pila,pilaJava);

    }

    public getInstrucciones():Array<any>{
        return this.analizadorGeneral.getInstrucciones();
    }

    public nuevoanalizar(proyecto:Proyecto,pila:PilaInstruccion,pilaJava:PilaInstruccion):string{
        
        let resultado:string = "";
        let archivos:Array<Archivo> = this.recuperadorArchivos.recuperar(proyecto);
        for(let i=0;i<archivos.length;i++){
            resultado += "";
            Separador.reset();
            Separador.parse(archivos[i].codigo);
            let txt = this.analizadorGeneral.analizar(Separador,pila,pilaJava);
            if(txt!=""){
                resultado += "Archivo: "+archivos[i].id+"\n";
                resultado += txt;
            }
        }
        if(resultado==""){
            return "Compilación exitosa.";
        }else{
            resultado = "Resultado:\n"+resultado;
            return resultado;
        }
    }

}