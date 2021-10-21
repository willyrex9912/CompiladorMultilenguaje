import { Instruccion } from "./Instruccion";

export class ListaInstruccion extends Array<Instruccion> {

    public agregar(instruccion:Instruccion){
        this.push(instruccion);
    }

}