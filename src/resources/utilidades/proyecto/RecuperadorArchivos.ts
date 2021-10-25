import { Archivo } from "src/model/Proyecto/Archivo";
import { Paquete } from "src/model/Proyecto/Paquete";
import { Proyecto } from "src/model/Proyecto/Proyecto";

export class RecuperadorArchivos {

    public recuperar(proyecto:Proyecto):Array<Archivo>{
        let archivos:Array<Archivo> = new Array();
        this.recuperarArchivosPaquete(proyecto.paquetePrincipal,archivos);
        return archivos;
    }

    private recuperarArchivosPaquete(paquete:Paquete,archivos:Array<Archivo>){
        for(let i=0;i<paquete.archivos.length;i++){
            archivos.push(paquete.archivos[i]);
        }
        for(let i=0;i<paquete.paquetes.length;i++){
            this.recuperarArchivosPaquete(paquete.paquetes[i],archivos);
        }
    }

}