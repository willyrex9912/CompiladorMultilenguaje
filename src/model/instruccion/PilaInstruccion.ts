import { Instruccion } from "./Instruccion";
import { ListaInstruccion } from "./ListaInstruccion";

export class PilaInstruccion extends Array<Instruccion>{

    constructor(private listaPrincipal:ListaInstruccion){
        super();
    }

    public apilar(instruccion:Instruccion){
        if(this.length){
            this[this.length-1].instrucciones.push(instruccion);
            if(
                instruccion.tipo=="Metodo" || 
                instruccion.tipo=="If" || 
                instruccion.tipo=="For" || 
                instruccion.tipo=="While" || 
                instruccion.tipo=="DoWhile" ||
                instruccion.tipo=="Switch"
            ){
                this.push(instruccion);
            }
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