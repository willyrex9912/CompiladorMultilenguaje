import { PilaInstruccion } from "../instruccion/estructura/PilaInstruccion";
import { ListaArchivoInstrucciones } from "./ListaArchivoInstrucciones";

export class Importador {

    public importar(idArchivo:string,pila:PilaInstruccion,listaJava:ListaArchivoInstrucciones,listaPython:ListaArchivoInstrucciones,idArchivoActual:string):boolean{
        let id:Array<string> = idArchivo.split(".");
        let tipo:string = id.shift();
        let archivo:string = id.pop();
        if(tipo=="JAVA"){
            //importacion del codigo de java
            if(archivo=="*"){
                //incluir todo el codigo en el archivo
                for(let i = 0;i<listaJava.length;i++){
                    if(listaJava[i].getId()==idArchivoActual){
                        pila.apilarGrupoDirecto(listaJava[i].getInstrucciones());
                        return true;
                    }
                }
                return false;
            }
        }else if(tipo=="PY"){
            //importacion del codigo de python
            if(archivo=="*"){
                //incluir todo el codigo en el archivo
                for(let i = 0;i<listaPython.length;i++){
                    if(listaPython[i].getId()==idArchivoActual){
                        pila.apilarGrupoDirecto(listaPython[i].getInstrucciones());
                        return true;
                    }
                }
                return false;
            }
        }
        return false;
    }

}