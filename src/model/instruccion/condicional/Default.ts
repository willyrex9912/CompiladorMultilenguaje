import { Instruccion } from "../Instruccion";

export class Default implements Instruccion{

    tipo: string = "Default";
    instrucciones: Array<Instruccion>;

    constructor(){
        this.instrucciones = new Array();
    }

}