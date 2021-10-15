import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Confirmacion } from 'src/model/Confirmacion';
import { Proyecto } from 'src/model/Proyecto/Proyecto';

@Injectable({
  providedIn: 'root'
})
export class ProyectoService {

  private url:string = "http://localhost:8080/compimult/GuardarProyecto";

  constructor(private httpClient:HttpClient) { }

  public getInstrucciones(){
    return this.httpClient.get<Confirmacion>(this.url);
  }

  public enviarProyecto(proyecto:Proyecto){
    return this.httpClient.post<Confirmacion>(this.url,proyecto);
  }

}
