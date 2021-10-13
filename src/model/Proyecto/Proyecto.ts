import { GestionadorPaquete } from "src/resources/utilidades/proyecto/GestionadorPaquete";
import { Paquete } from "./Paquete";

export class Proyecto{

    private nombre:string;
    private paquetePrincipal:Paquete;
    private gestionadorPaquete:GestionadorPaquete;

    constructor(nombre:string){
        this.nombre = nombre;
        this.paquetePrincipal = new Paquete(this.nombre);
        this.gestionadorPaquete = new GestionadorPaquete();
    }

    public getNombre():string{
        return this.nombre;
    }

    public getPaquetePrincipal():Paquete{
        return this.paquetePrincipal;
    }

    public agregarPaquete(nombre:string):void{
        this.gestionadorPaquete.crearPaquete(nombre,this);
    }

    public agregarArchivo(nombre:string):void{

    }

    public buscarPaquete(nombre:string):Paquete{
        return this.gestionadorPaquete.buscarPaquete(nombre,this);
    }

}