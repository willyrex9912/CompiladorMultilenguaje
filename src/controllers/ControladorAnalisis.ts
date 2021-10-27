import { ArchivoInstrucciones } from 'src/model/archivoinstruccion/ArchivoInstrucciones';
import { ListaArchivoInstrucciones } from 'src/model/archivoinstruccion/ListaArchivoInstrucciones';
import { ListaInstruccion } from 'src/model/instruccion/estructura/ListaInstruccion';
import { PilaInstruccion } from 'src/model/instruccion/estructura/PilaInstruccion';
import { Instruccion } from 'src/model/instruccion/Instruccion';
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

    public nuevoanalizar(proyecto:Proyecto,instruccionesFinales:ListaInstruccion):string{
        let archivosJava:ListaArchivoInstrucciones = new ListaArchivoInstrucciones();
        let archivosPython:ListaArchivoInstrucciones = new ListaArchivoInstrucciones();


        let resultado:string = "";
        let archivos:Array<Archivo> = this.recuperadorArchivos.recuperar(proyecto);

        for(let i=0;i<archivos.length;i++){
            resultado += "";
            Separador.reset();
            Separador.parse(archivos[i].codigo);

            //let txt = this.analizadorGeneral.analizar(Separador,pila,pilaJava);
            let archInsJava:ArchivoInstrucciones = new ArchivoInstrucciones(archivos[i].id);
            let txt:string = "";
            txt += this.analizadorGeneral.analizarCodigoJava(Separador,archInsJava.getPila());
            if(archInsJava.getInstrucciones().length){
                archivosJava.push(archInsJava);
            }            
            
            if(txt!=""){
                resultado += "Archivo: "+archivos[i].id+"\n";
                resultado += txt;
            }
        }

        for(let i=0;i<archivos.length;i++){
            resultado += "";
            Separador.reset();
            Separador.parse(archivos[i].codigo);

            let archInsPy:ArchivoInstrucciones = new ArchivoInstrucciones(archivos[i].id);
            let txt:string = "";
            txt += this.analizadorGeneral.analizarCodigoPython(Separador,archInsPy.getPila());
            if(archInsPy.getInstrucciones().length){
                archivosPython.push(archInsPy);
            }            
            
            if(txt!=""){
                resultado += "Archivo: "+archivos[i].id+"\n";
                resultado += txt;
            }
        }

        for(let i=0;i<archivos.length;i++){
            resultado += "";
            Separador.reset();
            Separador.parse(archivos[i].codigo);

            let archInsPrograma:ArchivoInstrucciones = new ArchivoInstrucciones(archivos[i].id);
            let txt = this.analizadorGeneral.analizarCodigoPrograma(Separador,archInsPrograma.getPila(),archivosJava,archivosPython,archivos[i].id);
            if(archInsPrograma.getInstrucciones().length){
                if(instruccionesFinales.length==0){
                    instruccionesFinales.push.apply(instruccionesFinales,archInsPrograma.getInstrucciones());
                }
            }
            
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