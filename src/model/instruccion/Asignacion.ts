import { Instruccion } from "./Instruccion";

export class Asignacion implements Instruccion{

    tipo:string = "Asignacion";
    instrucciones:Array<Instruccion>;

    constructor(
        private opr1:string,
        private opr2:Instruccion,
        private resultado:any,
        private opr:string
    ){
    }


    agregarInstruccion(instruccion: Instruccion): void {
        this.instrucciones.push(instruccion);
    }

}