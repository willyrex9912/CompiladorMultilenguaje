export class Cuadrupla {

    private operacion:string;
    private resultado:string;
    private argumento1:string;
    private argumento2:string;

    constructor(operacion:string,resultado:string,argumento1:string,argumento2:string){
        this.operacion = operacion;
        this.resultado = resultado;
        this.argumento1 = argumento1;
        this.argumento2 = argumento2;
    }

    public getOperacion(){
        return this.operacion;
    }

    public getResultado(){
        return this.resultado;
    }

    public getArgumento1(){
        return this.argumento1;
    }

    public getArgumento2(){
        return this.argumento2;
    }
    
}