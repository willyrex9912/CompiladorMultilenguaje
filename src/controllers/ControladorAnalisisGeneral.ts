import { ConstructorMensajeError } from 'src/resources/utilidades/ConstructorMensajeError';
import { FiltroTipoDatoJava } from 'src/resources/utilidades/FiltroTipoDatoJava';
import { FiltroTipoDatoPython } from 'src/resources/utilidades/FiltroTipoDatoPython';
import * as AnalizadorJava from '../resources/analizador/java/Java';
import * as AnalizadorPython from '../resources/analizador/python/Python';
import * as AnalizadorPrograma from '../resources/analizador/programa/Programa';
//import * as Filtro from '../resources/utilidades/FiltroTipoDato'

export class ControladorAnalisisGeneral{

    private constructorRespuesta:ConstructorMensajeError;
    private filtroTipoDatoJava:FiltroTipoDatoJava;
    private filtroTipoDatoPython:FiltroTipoDatoPython;

    public constructor(){
        this.constructorRespuesta = new ConstructorMensajeError();
        this.filtroTipoDatoJava = new FiltroTipoDatoJava();
        this.filtroTipoDatoPython = new FiltroTipoDatoPython();
        this.inicializarYYJava();
        this.inicializarYYPython();
    }

    public analizar(separador):String{

        let respuesta:string = "";

        //analizando codigo python
        if(this.existeCodigo(separador.getCodigoPython())){
            AnalizadorPython.reset();
            AnalizadorPython.parse(separador.getCodigoPython()+"\n");
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
        if(this.existeCodigo(separador.getCodigoPrograma())){
            AnalizadorPrograma.reset();
            AnalizadorPrograma.parse(separador.getCodigoPrograma());
            if(AnalizadorPrograma.getErrores().length>0){
                respuesta += this.constructorRespuesta.construirMensaje(AnalizadorPrograma.getErrores(),separador.getInicioPrograma());
            }
        }

        return respuesta;
    }

    public existeCodigo(codigo:String):Boolean{
        return !(codigo.trim()=="");
    }

    private inicializarYYJava(){
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

    private inicializarYYPython(){
        let yy = AnalizadorPython.parser.yy;
        yy.INT = this.filtroTipoDatoPython.INT;
        yy.DOUBLE = this.filtroTipoDatoPython.DOUBLE;
        yy.STRING = this.filtroTipoDatoPython.STRING;
        yy.BOOLEAN = this.filtroTipoDatoPython.BOOLEAN;

        yy.PUBLIC = this.filtroTipoDatoPython.PUBLIC;
        yy.PRIVATE = this.filtroTipoDatoPython.PRIVATE;

        yy.METODO = this.filtroTipoDatoPython.METODO;
        yy.VARIABLE = this.filtroTipoDatoPython.VARIABLE;
        yy.PARAMETRO = this.filtroTipoDatoPython.PARAMETRO;

        yy.POTENCIA = this.filtroTipoDatoPython.POTENCIA;
        yy.MODULO = this.filtroTipoDatoPython.MODULO;
        yy.DIVISION = this.filtroTipoDatoPython.DIVISION;
        yy.MULTIPLICACION = this.filtroTipoDatoPython.MULTIPLICACION;
        yy.SUMA = this.filtroTipoDatoPython.SUMA;
        yy.RESTA = this.filtroTipoDatoPython.RESTA;
        yy.IGUAL = this.filtroTipoDatoPython.IGUAL;
        yy.NO_IGUAL = this.filtroTipoDatoPython.NO_IGUAL;
        yy.MAYOR = this.filtroTipoDatoPython.MAYOR;
        yy.MENOR = this.filtroTipoDatoPython.MENOR;
        yy.MAYOR_IGUAL = this.filtroTipoDatoPython.MAYOR_IGUAL;
        yy.MENOR_IGUAL = this.filtroTipoDatoPython.MENOR_IGUAL;
        yy.AND = this.filtroTipoDatoPython.AND;
        yy.OR = this.filtroTipoDatoPython.OR;
        
        yy.filtrarOperacion = this.filtroTipoDatoPython.filtrarOperacion;
    }

}