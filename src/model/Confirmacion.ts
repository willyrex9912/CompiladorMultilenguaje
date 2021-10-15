export class Confirmacion {

    private descripcion:string;
    private estado:boolean;

    constructor(descripcion:string,estado:boolean){
        this.descripcion = descripcion;
        this.estado = estado;
    }

    public getDescripcion():string{
        return this.descripcion;
    }

    public getEstado():boolean{
        return this.estado;
    }

}