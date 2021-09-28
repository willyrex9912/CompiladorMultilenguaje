import { ConstructorMensajeError } from 'src/resources/utilidades/ConstructorMensajeError';
import { FiltroTipoDato } from 'src/resources/utilidades/FiltroTipoDato';
import * as AnalizadorJava from '../resources/analizador/java/Java';
//import * as Filtro from '../resources/utilidades/FiltroTipoDato'

export class ControladorAnalisisGeneral{

    private constructorRespuesta:ConstructorMensajeError;
    private filtroTipoDato:FiltroTipoDato;

    public constructor(){
        this.constructorRespuesta = new ConstructorMensajeError();
        this.filtroTipoDato = new FiltroTipoDato();
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
        yy.INT = this.filtroTipoDato.INT;
        yy.DOUBLE = this.filtroTipoDato.DOUBLE;
        yy.CHAR = this.filtroTipoDato.CHAR;
        yy.STRING = this.filtroTipoDato.STRING;
        yy.BOOLEAN = this.filtroTipoDato.BOOLEAN;
        yy.POTENCIA = this.filtroTipoDato.POTENCIA;
        yy.MODULO = this.filtroTipoDato.MODULO;
        yy.DIVISION = this.filtroTipoDato.DIVISION;
        yy.MULTIPLICACION = this.filtroTipoDato.MULTIPLICACION;
        yy.SUMA = this.filtroTipoDato.SUMA;
        yy.RESTA = this.filtroTipoDato.RESTA;
        yy.IGUAL = this.filtroTipoDato.IGUAL;
        yy.NO_IGUAL = this.filtroTipoDato.NO_IGUAL;
        yy.MAYOR = this.filtroTipoDato.MAYOR;
        yy.MENOR = this.filtroTipoDato.MENOR;
        yy.MAYOR_IGUAL = this.filtroTipoDato.MAYOR_IGUAL;
        yy.MENOR_IGUAL = this.filtroTipoDato.MENOR_IGUAL;
        yy.AND = this.filtroTipoDato.AND;
        yy.OR = this.filtroTipoDato.OR;
        yy.XOR = this.filtroTipoDato.XOR;
        
        yy.filtrarOperacion = this.filtroTipoDato.filtrarOperacion;
    }

}