import { Archivo } from "./Archivo";

export class Paquete {

    private nombre:string;
    private archivos:Array<Archivo>;
    private paquetes:Array<Paquete>;

    constructor(nombre:string){
        this.nombre = nombre;
        this.archivos = new Array();
        this.paquetes = new Array();
    }

    public getNombre():string{
        return this.nombre;
    }

    public getArchivos():Array<Archivo>{
        return this.archivos;
    }

    public getPaquetes():Array<Paquete>{
        return this.paquetes;
    }

}