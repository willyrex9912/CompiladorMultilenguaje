export class Archivo {

    private nombre:string;
    private paquete:string;
    private codigo:string;
    private id:string;

    constructor(nombre:string,id:string,paquete:string,codigo:string){
        this.nombre = nombre;
        this.id = id;
        this.paquete = paquete;
        this.codigo = codigo;
    }

    public getNombre():string{
        return this.nombre;
    }

    public getId():string{
        return this.id;
    }

    public getPaquete():string{
        return this.paquete;
    }

    public getCodigo():string{
        return this.codigo;
    }

}