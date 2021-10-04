import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http'
import { Instruccion } from 'src/model/Instruccion';

@Injectable({
  providedIn: 'root'
})
export class ServicioService {

  private url:string = "http://localhost:8080/compimult/codigo3d";

  constructor(private http:HttpClient) { }

  public getInstrucciones(){
    return this.http.get<Instruccion[]>(this.url);
  }

}
