import { ListaInstruccion } from "../instruccion/estructura/ListaInstruccion";
import { PilaInstruccion } from "../instruccion/estructura/PilaInstruccion";
import { Instruccion } from "../instruccion/Instruccion";

export class ArchivoInstrucciones {

    private pilaInstruccion:PilaInstruccion;
    private listaInstruccion:ListaInstruccion;

    constructor(private id:string){
        this.listaInstruccion = new ListaInstruccion();
        this.pilaInstruccion = new PilaInstruccion(this.listaInstruccion); 
    }

    public getId():string{
        return this.id;
    }

    public getPila():PilaInstruccion{
        return this.pilaInstruccion;
    }

    public getInstrucciones():ListaInstruccion{
        return this.listaInstruccion;
    }


}