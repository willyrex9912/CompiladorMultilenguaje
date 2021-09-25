import { ConstructorMensajeError } from 'src/resources/utilidades/ConstructorMensajeError';
import * as AnalizadorJava from '../resources/analizador/java/Java';

export class ControladorAnalisisGeneral{

    private constructorRespuesta:ConstructorMensajeError;

    public constructor(){
        this.constructorRespuesta = new ConstructorMensajeError();
    }

    public analizar(separador):String{
        console.log(separador.getInicioPython());
        console.log(separador.getInicioJava());
        console.log(separador.getInicioPrograma());

        let respuesta:string = "";
        //analizandp codigo python

        //analizando codigo java
        if(this.existeCodigo(separador.getCodigoJava())){
            AnalizadorJava.reset();
            AnalizadorJava.parse(separador.getCodigoJava());
            if(AnalizadorJava.getErrores().length>0){
                respuesta += this.constructorRespuesta.construirMensaje(AnalizadorJava.getErrores(),separador.getInicioJava());
            }
        }
        //analizando codigo programa

        return respuesta;
    }

    public existeCodigo(codigo:String):Boolean{
        return !(codigo.trim()=="");
    }

}