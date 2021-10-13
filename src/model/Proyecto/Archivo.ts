export class Archivo {

    private nombre:string;
    private paquete:string;
    private codigo:string;

    constructor(nombre:string,paquete:string,codigo:string){
        this.nombre = nombre;
        this.paquete = paquete;
        this.codigo = codigo;
    }

    public getNombre():string{
        return this.nombre;
    }

    public getPaquete():string{
        return this.paquete;
    }

    public getCodigo():string{
        return this.codigo;
    }

}