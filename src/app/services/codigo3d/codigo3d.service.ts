import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Confirmacion } from 'src/model/Confirmacion';

@Injectable({
  providedIn: 'root'
})
export class Codigo3dService {

  private url:string = "http://localhost:8080/compimult/codigo3d";

  constructor(private httpClient:HttpClient) { }

  public enviarInstrucciones(instrucciones:Array<any>){
    return this.httpClient.post<Confirmacion>(this.url,instrucciones);
  }

}
