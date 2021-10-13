import { Paquete } from "./Paquete";

export class Proyecto{

    private nombre:string;
    private paquetePrincipal:Paquete;

    constructor(nombre:string){
        this.nombre = nombre;
        this.paquetePrincipal = new Paquete(this.nombre);
    }

    public getNombre():string{
        return this.nombre;
    }

    public getPaquetePrincipal():Paquete{
        return this.paquetePrincipal;
    }

}