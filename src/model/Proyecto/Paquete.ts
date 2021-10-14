import { Archivo } from "./Archivo";

export class Paquete {

    private nombre:string;
    private id:string;
    private archivos:Array<Archivo>;
    private paquetes:Array<Paquete>;

    constructor(nombre:string,id:string){
        this.nombre = nombre;
        this.id = id;
        this.archivos = new Array();
        this.paquetes = new Array();
    }

    public getNombre():string{
        return this.nombre;
    }

    public getId():string{
        return this.id;
    }

    public getArchivos():Array<Archivo>{
        return this.archivos;
    }

    public getPaquetes():Array<Paquete>{
        return this.paquetes;
    }

    public agregarArchivo(archivo:Archivo):void{
        this.archivos.push(archivo);
    }

    public agregarPaquete(paquete:Paquete):void{
        this.paquetes.push(paquete);
    }

}