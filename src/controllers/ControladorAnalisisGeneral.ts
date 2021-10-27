import { ConstructorMensajeError } from 'src/resources/utilidades/ConstructorMensajeError';
import { FiltroTipoDatoJava } from 'src/resources/utilidades/FiltroTipoDatoJava';
import { FiltroTipoDatoPython } from 'src/resources/utilidades/FiltroTipoDatoPython';
import * as AnalizadorJava from '../resources/analizador/java/Java';
import * as AnalizadorPython from '../resources/analizador/python/Python';
import * as AnalizadorPrograma from '../resources/analizador/programa/Programa';
import { FiltroTipoDatoPrograma } from 'src/resources/utilidades/FiltroTipoDatoPrograma';
import { ControladorInstrucciones } from './ControladorInstrucciones';
import { PilaInstruccion } from 'src/model/instruccion/estructura/PilaInstruccion';
import { ArchivoInstrucciones } from 'src/model/archivoinstruccion/ArchivoInstrucciones';
import { Importador } from 'src/model/archivoinstruccion/Importador';
//import * as Filtro from '../resources/utilidades/FiltroTipoDato'

export class ControladorAnalisisGeneral{

    private constructorRespuesta:ConstructorMensajeError;
    private filtroTipoDatoJava:FiltroTipoDatoJava;
    private filtroTipoDatoPython:FiltroTipoDatoPython;
    private filtroTipoDatoPrograma:FiltroTipoDatoPrograma;
    private controladorInstrucciones:ControladorInstrucciones;
    private importador:Importador;

    public constructor(){
        this.constructorRespuesta = new ConstructorMensajeError();
        this.filtroTipoDatoJava = new FiltroTipoDatoJava();
        this.filtroTipoDatoPython = new FiltroTipoDatoPython();
        this.filtroTipoDatoPrograma = new FiltroTipoDatoPrograma();
        this.controladorInstrucciones = new ControladorInstrucciones();
        this.importador = new Importador();
        this.inicializarYYJava();
        this.inicializarYYPython();
        this.inicializarYYPrograma();
    }

    public analizar(separador,pila:PilaInstruccion,pilaJava:PilaInstruccion):string{

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
            AnalizadorPrograma.reset(AnalizadorPrograma.parser.yy);
            AnalizadorPrograma.parser.yy.PILA_INS = pila;
            AnalizadorPrograma.parse(separador.getCodigoPrograma());
            if(AnalizadorPrograma.getErrores().length>0){
                respuesta += this.constructorRespuesta.construirMensaje(AnalizadorPrograma.getErrores(),separador.getInicioPrograma());
            }
        }

        return respuesta;
    }

    public analizarCodigoPrograma(separador,pila:PilaInstruccion,archivosJava:Array<ArchivoInstrucciones>,archivosPython:Array<ArchivoInstrucciones>,idArchivoActual:string):string{

        let respuesta:string = "";

        //analizando codigo programa
        if(this.existeCodigo(separador.getCodigoPrograma())){
            AnalizadorPrograma.reset(AnalizadorPrograma.parser.yy);
            AnalizadorPrograma.parser.yy.PILA_INS = pila;
            AnalizadorPrograma.parser.yy.ARCHIVOS_JAVA = archivosJava;
            AnalizadorPrograma.parser.yy.ARCHIVOS_PYTHON = archivosPython;
            AnalizadorPrograma.parser.yy.arch_actual = idArchivoActual;
            AnalizadorPrograma.parser.yy.importador = this.importador;
            AnalizadorPrograma.parse(separador.getCodigoPrograma());
            if(AnalizadorPrograma.getErrores().length>0){
                respuesta += this.constructorRespuesta.construirMensaje(AnalizadorPrograma.getErrores(),separador.getInicioPrograma());
            }
        }

        return respuesta;
    }

    public analizarCodigoJava(separador,pila:PilaInstruccion):string{

        let respuesta:string = "";

        //analizando codigo java
        if(this.existeCodigo(separador.getCodigoJava())){
            AnalizadorJava.reset();
            AnalizadorJava.parser.yy.PILA_INS = pila;
            AnalizadorJava.parse(separador.getCodigoJava());
            if(AnalizadorJava.getErrores().length>0){
                respuesta += this.constructorRespuesta.construirMensaje(AnalizadorJava.getErrores(),separador.getInicioJava());
            }
        }

        return respuesta;
    }

    public analizarCodigoPython(separador,pila:PilaInstruccion):string{

        let respuesta:string = "";

        //analizando codigo python
        if(this.existeCodigo(separador.getCodigoPython())){
            AnalizadorPython.reset();
            AnalizadorPython.parser.yy.PILA_INS = pila;
            AnalizadorPython.parse(separador.getCodigoPython()+"\n");
            if(AnalizadorPython.getErrores().length>0){
                respuesta += this.constructorRespuesta.construirMensaje(AnalizadorPython.getErrores(),separador.getInicioPython());
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

        yy.ID = this.filtroTipoDatoJava.ID;

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

        this.agregarMetodos(yy);
    }

    private agregarMetodos(yy:any):void{
        yy.nuevaAsignacion = this.controladorInstrucciones.nuevaAsignacion;
        yy.nuevaOperacion = this.controladorInstrucciones.nuevaOperacion;
        yy.nuevaDeclaracion = this.controladorInstrucciones.nuevaDeclaracion;
        yy.nuevoMetodo = this.controladorInstrucciones.nuevoMetodo;
        yy.nuevoIf = this.controladorInstrucciones.nuevoIf;
        yy.nuevoElseIf = this.controladorInstrucciones.nuevoElseIf;
        yy.nuevoElse = this.controladorInstrucciones.nuevoElse;
        yy.nuevoWhile = this.controladorInstrucciones.nuevoWhile;
        yy.nuevoDoWhile = this.controladorInstrucciones.nuevoDoWhile;
        yy.nuevoFor = this.controladorInstrucciones.nuevoFor;
        yy.nuevoIncDec = this.controladorInstrucciones.nuevoIncDec;
        yy.nuevoSwitch = this.controladorInstrucciones.nuevoSwitch;
        yy.nuevoCase = this.controladorInstrucciones.nuevoCase;
        yy.nuevoDefault = this.controladorInstrucciones.nuevoDefault;
        yy.nuevoBreak = this.controladorInstrucciones.nuevoBreak;
        yy.nuevaClase = this.controladorInstrucciones.nuevaClase;
    }

    private inicializarYYPython(){
        let yy = AnalizadorPython.parser.yy;
        yy.INT = this.filtroTipoDatoPython.INT;
        yy.DOUBLE = this.filtroTipoDatoPython.DOUBLE;
        yy.STRING = this.filtroTipoDatoPython.STRING;
        yy.BOOLEAN = this.filtroTipoDatoPython.BOOLEAN;
        
        yy.ID = this.filtroTipoDatoPython.ID;

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

        this.agregarMetodos(yy);
    }

    private inicializarYYPrograma(){
        let yy = AnalizadorPrograma.parser.yy;
        yy.INT = this.filtroTipoDatoPrograma.INT;
        yy.FLOAT = this.filtroTipoDatoPrograma.FLOAT;
        yy.CHAR = this.filtroTipoDatoPrograma.CHAR;
        yy.BOOLEAN = this.filtroTipoDatoPrograma.BOOLEAN;

        yy.ID = this.filtroTipoDatoPrograma.ID;

        yy.VOID = this.filtroTipoDatoPrograma.VOID;

        yy.GLOBAL = this.filtroTipoDatoPrograma.GLOBAL;

        yy.METODO = this.filtroTipoDatoPrograma.METODO;
        yy.VARIABLE = this.filtroTipoDatoPrograma.VARIABLE;
        yy.CLASE = this.filtroTipoDatoPrograma.CLASE;
        yy.PARAMETRO = this.filtroTipoDatoPrograma.PARAMETRO;
        yy.CONSTANTE = this.filtroTipoDatoPrograma.CONSTANTE;

        yy.ASIGNACION = this.filtroTipoDatoPrograma.ASIGNACION;

        yy.POTENCIA = this.filtroTipoDatoPrograma.POTENCIA;
        yy.MODULO = this.filtroTipoDatoPrograma.MODULO;
        yy.DIVISION = this.filtroTipoDatoPrograma.DIVISION;
        yy.MULTIPLICACION = this.filtroTipoDatoPrograma.MULTIPLICACION;
        yy.SUMA = this.filtroTipoDatoPrograma.SUMA;
        yy.RESTA = this.filtroTipoDatoPrograma.RESTA;
        yy.IGUAL = this.filtroTipoDatoPrograma.IGUAL;
        yy.NO_IGUAL = this.filtroTipoDatoPrograma.NO_IGUAL;
        yy.MAYOR = this.filtroTipoDatoPrograma.MAYOR;
        yy.MENOR = this.filtroTipoDatoPrograma.MENOR;
        yy.MAYOR_IGUAL = this.filtroTipoDatoPrograma.MAYOR_IGUAL;
        yy.MENOR_IGUAL = this.filtroTipoDatoPrograma.MENOR_IGUAL;
        yy.AND = this.filtroTipoDatoPrograma.AND;
        yy.OR = this.filtroTipoDatoPrograma.OR;
        yy.XOR = this.filtroTipoDatoPrograma.XOR;
        yy.PUBLIC = this.filtroTipoDatoPrograma.PUBLIC;
        yy.PRIVATE = this.filtroTipoDatoPrograma.PRIVATE;
        yy.DEFAULT = this.filtroTipoDatoPrograma.DEFAULT;
        
        yy.filtrarOperacion = this.filtroTipoDatoPrograma.filtrarOperacion;

        this.agregarMetodos(yy);
    }

    public getInstrucciones():Array<any>{
        return AnalizadorPrograma.getInstrucciones();
    }

}