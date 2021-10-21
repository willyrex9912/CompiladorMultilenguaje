import { Asignacion } from "src/model/instruccion/Asignacion";
import { Declaracion } from "src/model/instruccion/Declaracion";
import { Instruccion } from "src/model/instruccion/Instruccion";
import { Metodo } from "src/model/instruccion/Metodo";
import { Operacion } from "src/model/instruccion/Operacion";
import { PilaInstruccion } from "src/model/instruccion/PilaInstruccion";

export class ControladorInstrucciones{
    
    public nuevoMetodo(nombre:string):Metodo{
        return new Metodo(nombre);
    }

    public nuevaAsignacion(opr1:string,opr2:Instruccion):Asignacion{
        return new Asignacion(opr1,opr2);
    }

    public nuevaDeclaracion(opr1:string,opr2:Instruccion):Declaracion{
        return new Declaracion(opr1,opr2);
    }

    public nuevaOperacion(opr1:Instruccion, opr2:Instruccion, opr:string, resultado:any):Operacion{
        return new Operacion(opr1,opr2,opr,resultado);
    }

}