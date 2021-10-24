import { Instruccion } from "../Instruccion";

export class Case implements Instruccion{

    tipo: string = "Case";
    instrucciones: Array<Instruccion>;

    constructor(private variable:Instruccion){
        this.instrucciones = new Array();
    }

}