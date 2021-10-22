import { DoWhile } from "../ciclo/DoWhile";
import { Else } from "../condicional/Else";
import { ElseIf } from "../condicional/ElseIf";
import { If } from "../condicional/If";
import { Instruccion } from "../Instruccion";
import { ListaInstruccion } from "./ListaInstruccion";

export class PilaInstruccion extends Array<Instruccion>{

    private auxIf:Array<If>;

    constructor(private listaPrincipal:ListaInstruccion){
        super();
        this.auxIf = new Array();
    }

    public apilar(instruccion:Instruccion){
        try{
            if(this.length){
                if(instruccion.tipo!="ElseIf" && instruccion.tipo!="Else"){
                    this.ultimo().instrucciones.push(instruccion);
                }

                if(
                    instruccion.tipo=="Metodo" || 
                    instruccion.tipo=="If" || 
                    instruccion.tipo=="ElseIf" || 
                    instruccion.tipo=="Else" || 
                    instruccion.tipo=="For" || 
                    instruccion.tipo=="While" || 
                    instruccion.tipo=="DoWhile" ||
                    instruccion.tipo=="Switch"
                ){
                    this.push(instruccion);
                }
                this.filtroIns(instruccion);
            }else{
                if(instruccion.tipo=="Metodo"){
                    this.push(instruccion);
                }
                this.listaPrincipal.agregar(instruccion);
            }
        }catch(e){
            console.log(e);
        }
    }

    public sacar():void{
        try{
            let ins = this.pop();
            if(ins.tipo=="If"){
                this.auxIf.pop();
            }
        }catch(e){
            console.log(e);
        }
    }

    public sacarDoWhile(condicion:Instruccion):void{
        try{
            let ins = this.pop() as DoWhile;
            ins.setCondicion(condicion);
        }catch(e){
            console.log(e);
        }
    }

    private filtroIns(instruccion:Instruccion){
        if(instruccion.tipo=="If"){
            this.auxIf.push(instruccion as If);
        }else if(instruccion.tipo=="ElseIf"){
            this.ultimoIf().instruccionesElseIf.push(instruccion as ElseIf);
        }else if(instruccion.tipo=="Else"){
            this.ultimoIf().instruccionElse = instruccion as Else;
        }
    }

    private ultimo():Instruccion{
        return this[this.length-1];
    }

    private ultimoIf():If{
        return this.auxIf[this.auxIf.length-1];
    }

}