import { ConstructorMensajeError } from 'src/resources/utilidades/ConstructorMensajeError';
import * as AnalizadorJava from '../resources/analizador/java/Java';
import * as Filtro from '../resources/utilidades/FiltroTipoDato'

export class ControladorAnalisisGeneral{

    private constructorRespuesta:ConstructorMensajeError;

    public constructor(){
        this.constructorRespuesta = new ConstructorMensajeError();
        this.inicializarYY();
    }

    public analizar(separador):String{

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

    private inicializarYY(){
        let yy = AnalizadorJava.parser.yy;
        yy.INT = Filtro.INT;
        yy.DOUBLE = Filtro.DOUBLE;
        yy.CHAR = Filtro.CHAR;
        yy.STRING = Filtro.STRING;
        yy.BOOLEAN = Filtro.BOOLEAN;
        yy.POTENCIA = Filtro.POTENCIA;
        yy.MODULO = Filtro.MODULO;
        yy.DIVISION = Filtro.DIVISION;
        yy.MULTIPLICACION = Filtro.MULTIPLICACION;
        yy.SUMA = Filtro.SUMA;
        yy.RESTA = Filtro.RESTA;
        yy.IGUAL = Filtro.IGUAL;
        yy.NO_IGUAL = Filtro.NO_IGUAL;
        yy.MAYOR = Filtro.MAYOR;
        yy.MENOR = Filtro.MENOR;
        yy.MAYOR_IGUAL = Filtro.MAYOR_IGUAL;
        yy.MENOR_IGUAL = Filtro.MENOR_IGUAL;
        yy.AND = Filtro.AND;
        yy.OR = Filtro.OR;
        yy.XOR = Filtro.XOR;
        
        yy.filtrarOperacion = Filtro.filtrarOperacion;
    }

}