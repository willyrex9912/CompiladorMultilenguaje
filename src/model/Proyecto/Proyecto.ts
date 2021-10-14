import { GestionadorPaquete } from "src/resources/utilidades/proyecto/GestionadorPaquete";
import { Paquete } from "./Paquete";

export class Proyecto{

    private nombre:string;
    private paquetePrincipal:Paquete;
    private gestionadorPaquete:GestionadorPaquete;

    constructor(nombre:string){
        this.nombre = nombre;
        this.paquetePrincipal = new Paquete(this.nombre,this.nombre);
        this.gestionadorPaquete = new GestionadorPaquete();
    }

    public getNombre():string{
        return this.nombre;
    }

    public getPaquetePrincipal():Paquete{
        return this.paquetePrincipal;
    }

    public agregarPaquete(id:string):void{
        this.gestionadorPaquete.crearPaquete(id,this);
    }

    public crearArchivo(id:string):void{
        this.gestionadorPaquete.nuevoArchivo(id,this,"");
    }

    public buscarPaquete(id:string):Paquete{
        return this.gestionadorPaquete.buscarPaquete(id,this);
    }

}