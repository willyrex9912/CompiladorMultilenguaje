import { Archivo } from "src/model/Proyecto/Archivo";
import { Paquete } from "src/model/Proyecto/Paquete";
import { Proyecto } from "src/model/Proyecto/Proyecto";

export class GestionadorPaquete{

    public nuevoArchivo(id:string,proyecto:Proyecto,codigo:string){
        let nombres:Array<string> = id.split('.');
        let nombreArchivo = nombres.pop();
        let nombrePaquete = nombres.join('.');
        if(nombres.length==0){
            console.log(proyecto.paquetePrincipal.nombre);
            proyecto.paquetePrincipal.archivos.push(new Archivo(nombreArchivo,id,proyecto.paquetePrincipal.nombre,codigo));
        }else{
            let paquete = this.crearPaquete(nombrePaquete,proyecto);
            paquete.archivos.push(new Archivo(nombreArchivo,id,paquete.nombre,codigo));
        }
    }

    public guardarCambiosArchivo(nombre:string,proyecto:Proyecto,codigo:string){
        let archivo = this.buscarArchivo(nombre,proyecto);
    }

    public buscarArchivo(id:string,proyecto:Proyecto){
        let nombres:Array<string> = id.split('.');
        let nombreArchivo = nombres.pop();
        let nombrePaquete = nombres.join('.');
        let paquete:Paquete
        if(nombrePaquete==""){
            paquete = proyecto.paquetePrincipal;
        }else{
            paquete = this.buscarPaquete(nombrePaquete,proyecto);
        }
        if(paquete==null){
            return null;
        }else{
            for (const i in paquete.archivos) {
                if(paquete.archivos[i].nombre==nombreArchivo){
                    return paquete.archivos[i];
                }
            }
            return null;
        }
    }

    public buscarPaquete(id:string,proyecto:Proyecto):Paquete{
        let nombres:Array<string> = id.split('.');
        let paquete:Paquete = proyecto.paquetePrincipal; 
        while(nombres.length){
            let paqueteTemp = this.buscarPaqueteEnLista(nombres.shift(),paquete.paquetes);
            if(paqueteTemp==null){
                nombres.unshift('WJAJ');
                break;
            }else{
                paquete = paqueteTemp;
            }
        }

        if(nombres.length){
            return null;
        }else{
            return paquete;
        }
    }

    public crearPaquete(id:string,proyecto:Proyecto):Paquete{
        let nombres:Array<string> = id.split('.');
        let paquete:Paquete = proyecto.paquetePrincipal; 
        let nombre:string;
        let nombreAcumulado:Array<string> = new Array();

        while(nombres.length){
            nombre = nombres.shift();
            let paqueteTemp = this.buscarPaqueteEnLista(nombre,paquete.paquetes);
            if(paqueteTemp==null){
                nombres.unshift(nombre);
                break;
            }else{
                nombreAcumulado.push(nombre);
                paquete = paqueteTemp;
            }
        }

        if(nombres.length){
            let nuevoPaquete:Paquete;
            while(nombres.length){
                nombreAcumulado.join('.')
                let nombreshift:string = nombres.shift();
                nombreAcumulado.push(nombreshift);
                nuevoPaquete = new Paquete(nombreshift,nombreAcumulado.join('.'));
                paquete.paquetes.push(nuevoPaquete);
                paquete = nuevoPaquete;
            }
        }
        return paquete;
    }

    private buscarPaqueteEnLista(nombre:string,paquetes:Array<Paquete>):Paquete{
        for (const i in paquetes) {
            if(paquetes[i].nombre==nombre){
                return paquetes[i];
            }
        }
        return null;
    }

}