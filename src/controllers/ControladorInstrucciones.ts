import { Asignacion } from "src/model/instruccion/Asignacion";
import { Instruccion } from "src/model/instruccion/Instruccion";

export class ControladorInstrucciones{
    
    public agregarAsignacion(asignacion:Asignacion,instrucciones:Array<Instruccion>,pilaInstrucciones:Array<Asignacion>):void{
        if(pilaInstrucciones.length){
            pilaInstrucciones[-1].agregarInstruccion(asignacion);
        }else{
            instrucciones.push(asignacion);
        }
    }

    public agregarDeclaracion():void{

    }

}