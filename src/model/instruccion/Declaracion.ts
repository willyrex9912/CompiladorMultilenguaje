import { Instruccion } from "./Instruccion";

export class Declaracion implements Instruccion{

    constructor(
        private opr1:string,
        private opr2:Instruccion,
        private resultado:any,
        private opr:string,
    ){
    }

}