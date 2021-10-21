import { Instruccion } from "./Instruccion";
import { ListaInstruccion } from "./ListaInstruccion";

export class PilaInstruccion extends Array<Instruccion>{

    constructor(private listaPrincipal:ListaInstruccion){
        super();
    }

    public apilar(instruccion:Instruccion){
        if(this.length){
            this[-1].instrucciones.push(instruccion);
            this.push(instruccion);
        }else{
            if(instruccion.tipo=="Metodo"){
                this.push(instruccion);
            }
            this.listaPrincipal.agregar(instruccion);
        }
    }

    public sacar():void{
        this.pop();
    }

}