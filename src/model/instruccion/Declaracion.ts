import { Instruccion } from "./Instruccion";

export class Declaracion implements Instruccion{

    tipo: string;
    instrucciones: Array<Instruccion>;

    constructor(
        private opr1:string,
        private opr2:Instruccion,
        private resultado:any,
        private opr:string,
    ){
    }

    agregarInstruccion(instruccion: Instruccion): void {
        throw new Error("Method not implemented.");
    }
    

}