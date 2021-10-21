import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Confirmacion } from 'src/model/Confirmacion';
import { Asignacion } from 'src/model/instruccion/Asignacion';
import { Instruccion } from 'src/model/instruccion/Instruccion';
import { Operacion } from 'src/model/instruccion/Operacion';

@Injectable({
  providedIn: 'root'
})
export class Codigo3dService {

  private url:string = "http://localhost:8080/compimult/codigo3d";

  constructor(private httpClient:HttpClient) { }

  /*
  public enviarInstrucciones(instrucciones:Array<any>){
    return this.httpClient.post<Confirmacion>(this.url,instrucciones);
  }*/

  public enviarInstrucciones(){
    let instrucciones:Array<Instruccion> = new Array();
    //instrucciones.push(new Asignacion("x",new Operacion(null,null,"int",12),null,"asignacion"));
    instrucciones.push(new Operacion(null,null,"int",12));
    console.log(instrucciones);
    return this.httpClient.post<Confirmacion>(this.url,instrucciones);
  }

}
