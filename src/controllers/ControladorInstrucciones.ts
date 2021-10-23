import { Asignacion } from "src/model/instruccion/Asignacion";
import { DoWhile } from "src/model/instruccion/ciclo/DoWhile";
import { For } from "src/model/instruccion/ciclo/For";
import { While } from "src/model/instruccion/ciclo/While";
import { Else } from "src/model/instruccion/condicional/Else";
import { ElseIf } from "src/model/instruccion/condicional/ElseIf";
import { If } from "src/model/instruccion/condicional/If";
import { Declaracion } from "src/model/instruccion/Declaracion";
import { IncDec } from "src/model/instruccion/inc-dec/IncDec";
import { Instruccion } from "src/model/instruccion/Instruccion";
import { Metodo } from "src/model/instruccion/Metodo";
import { Operacion } from "src/model/instruccion/Operacion";

export class ControladorInstrucciones{

    public nuevoFor(accionInicial:Instruccion,condicion:Instruccion,accionPosterior:Instruccion):For{
        return new For(accionInicial,condicion,accionPosterior);
    }

    public nuevoIncDec(id:string,opr:string):IncDec{
        return new IncDec(id,opr);
    }

    public nuevoDoWhile(condicion:Instruccion):DoWhile{
        return new DoWhile(condicion);
    }

    public nuevoWhile(condicion:Instruccion):While{
        return new While(condicion);
    }

    public nuevoElse():Else{
        return new Else();
    }

    public nuevoElseIf(condicion:Instruccion):ElseIf{
        return new ElseIf(condicion);
    }

    public nuevoIf(condicion:Instruccion):If{
        return new If(condicion);
    }

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