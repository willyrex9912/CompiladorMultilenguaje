import { Paquete } from "src/model/Proyecto/Paquete";
import { Proyecto } from "src/model/Proyecto/Proyecto";

export class GestionadorPaquete{

    public buscarPaquete(nombrePaquete:string,proyecto:Proyecto):Paquete{
        let nombres:Array<string> = nombrePaquete.split('.');
        let paquete:Paquete = proyecto.getPaquetePrincipal(); 
        while(nombres.length){
            let paqueteTemp = this.buscarPaqueteEnLista(nombres.shift(),paquete.getPaquetes());
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

    public crearPaquete(nombrePaquete:string,proyecto:Proyecto):void{
        let nombres:Array<string> = nombrePaquete.split('.');
        let paquete:Paquete = proyecto.getPaquetePrincipal(); 
        let nombre:string;
        while(nombres.length){
            nombre = nombres.shift();
            let paqueteTemp = this.buscarPaqueteEnLista(nombre,paquete.getPaquetes());
            if(paqueteTemp==null){
                nombres.unshift(nombre);
                break;
            }else{
                paquete = paqueteTemp;
            }
        }

        if(nombres.length){
            let nuevoPaquete:Paquete;
            while(nombres.length){
                nuevoPaquete = new Paquete(nombres.shift());
                paquete.agregarPaquete(nuevoPaquete);
                paquete = nuevoPaquete;
            }
        }
    }

    private buscarPaqueteEnLista(nombre:string,paquetes:Array<Paquete>):Paquete{
        for (const i in paquetes) {
            if(paquetes[i].getNombre()==nombre){
                return paquetes[i];
            }
        }
        return null;
    }

}