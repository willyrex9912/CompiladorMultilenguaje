import { Instruccion } from "./Instruccion";

export class Operacion implements Instruccion{

    private type:string = "Operacion";

    constructor(
        private opr1:Instruccion,
        private opr2:Instruccion,
        private opr:string,
        private resultado:any
    ){

    }

}