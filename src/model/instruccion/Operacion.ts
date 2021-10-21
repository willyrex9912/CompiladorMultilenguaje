import { Instruccion } from "./Instruccion";

export class Operacion implements Instruccion{

    tipo:string = "Operacion";
    

    constructor(
        private opr1:Instruccion,
        private opr2:Instruccion,
        private opr:string,
        private resultado:any
    ){

    }
    instrucciones: Array<Instruccion>;

    agregarInstruccion(instruccion: Instruccion): void {
        throw new Error("Method not implemented.");
    }

}