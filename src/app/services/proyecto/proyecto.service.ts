import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Confirmacion } from 'src/model/Confirmacion';
import { Proyecto } from 'src/model/Proyecto/Proyecto';

@Injectable({
  providedIn: 'root'
})
export class ProyectoService {

  private urlGuardarProyecto:string = "http://localhost:8080/compimult/GuardarProyecto";
  private urlProyectos:string = "http://localhost:8080/compimult/GetProyectos";
  private urlProyecto:string = "http://localhost:8080/compimult/GetProyecto";

  constructor(private httpClient:HttpClient) { }

  public getProyectos(){
    return this.httpClient.get<Array<Proyecto>>(this.urlProyectos);
  }

  public getProyecto(nombre:string){
    return this.httpClient.post<Proyecto>(this.urlProyecto,nombre);
  }

  public enviarProyecto(proyecto:Proyecto){
    return this.httpClient.post<Confirmacion>(this.urlGuardarProyecto,proyecto);
  }

}
