import { ConstructorMensajeError } from 'src/resources/utilidades/ConstructorMensajeError';
import { FiltroTipoDatoJava } from 'src/resources/utilidades/FiltroTipoDatoJava';
import * as AnalizadorJava from '../resources/analizador/java/Java';
import * as AnalizadorPython from '../resources/analizador/python/Python';
//import * as Filtro from '../resources/utilidades/FiltroTipoDato'

export class ControladorAnalisisGeneral{

    private constructorRespuesta:ConstructorMensajeError;
    private filtroTipoDatoJava:FiltroTipoDatoJava;

    public constructor(){
        this.constructorRespuesta = new ConstructorMensajeError();
        this.filtroTipoDatoJava = new FiltroTipoDatoJava();
        this.inicializarYY();
    }

    public analizar(separador):String{

        let respuesta:string = "";

        //analizando codigo python
        if(this.existeCodigo(separador.getCodigoPython())){
            AnalizadorPython.reset();
            AnalizadorPython.parse(separador.getCodigoPython());
            if(AnalizadorPython.getErrores().length>0){
                respuesta += this.constructorRespuesta.construirMensaje(AnalizadorPython.getErrores(),separador.getInicioPython());
            }
        }

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
        yy.INT = this.filtroTipoDatoJava.INT;
        yy.DOUBLE = this.filtroTipoDatoJava.DOUBLE;
        yy.CHAR = this.filtroTipoDatoJava.CHAR;
        yy.STRING = this.filtroTipoDatoJava.STRING;
        yy.BOOLEAN = this.filtroTipoDatoJava.BOOLEAN;

        yy.VOID = this.filtroTipoDatoJava.VOID;

        yy.METODO = this.filtroTipoDatoJava.METODO;
        yy.VARIABLE = this.filtroTipoDatoJava.VARIABLE;
        yy.CLASE = this.filtroTipoDatoJava.CLASE;
        yy.PARAMETRO = this.filtroTipoDatoJava.PARAMETRO;

        yy.POTENCIA = this.filtroTipoDatoJava.POTENCIA;
        yy.MODULO = this.filtroTipoDatoJava.MODULO;
        yy.DIVISION = this.filtroTipoDatoJava.DIVISION;
        yy.MULTIPLICACION = this.filtroTipoDatoJava.MULTIPLICACION;
        yy.SUMA = this.filtroTipoDatoJava.SUMA;
        yy.RESTA = this.filtroTipoDatoJava.RESTA;
        yy.IGUAL = this.filtroTipoDatoJava.IGUAL;
        yy.NO_IGUAL = this.filtroTipoDatoJava.NO_IGUAL;
        yy.MAYOR = this.filtroTipoDatoJava.MAYOR;
        yy.MENOR = this.filtroTipoDatoJava.MENOR;
        yy.MAYOR_IGUAL = this.filtroTipoDatoJava.MAYOR_IGUAL;
        yy.MENOR_IGUAL = this.filtroTipoDatoJava.MENOR_IGUAL;
        yy.AND = this.filtroTipoDatoJava.AND;
        yy.OR = this.filtroTipoDatoJava.OR;
        yy.XOR = this.filtroTipoDatoJava.XOR;
        yy.PUBLIC = this.filtroTipoDatoJava.PUBLIC;
        yy.PRIVATE = this.filtroTipoDatoJava.PRIVATE;
        yy.DEFAULT = this.filtroTipoDatoJava.DEFAULT;
        
        yy.filtrarOperacion = this.filtroTipoDatoJava.filtrarOperacion;
    }

}