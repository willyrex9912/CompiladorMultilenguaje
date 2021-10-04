import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http'
import { Instruccion } from 'src/model/Instruccion';
import { Cuadrupla } from 'src/model/Cuadrupla';

@Injectable({
  providedIn: 'root'
})
export class ServicioService {

  private url:string = "http://localhost:8080/compimult/codigo3d";

  constructor(private http:HttpClient) { }

  public getInstrucciones(){
    return this.http.get<Instruccion[]>(this.url);
  }

  public enviarCuadruplas(cuadruplas:Array<Cuadrupla>){
    return this.http.post<Array<Cuadrupla>>(this.url,cuadruplas);
  }

}
