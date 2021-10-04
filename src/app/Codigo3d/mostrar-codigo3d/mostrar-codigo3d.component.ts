import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { Instruccion } from 'src/model/Instruccion';
import { ServicioService } from '../../Servicio/servicio.service'

@Component({
  selector: 'app-mostrar-codigo3d',
  templateUrl: './mostrar-codigo3d.component.html',
  styleUrls: ['./mostrar-codigo3d.component.css']
})
export class MostrarCodigo3dComponent implements OnInit {

  public instrucciones:Array<Instruccion>;
  constructor(private servicio:ServicioService, private router:Router) { }

  ngOnInit(): void {
    this.servicio.getInstrucciones().subscribe(data=>{
      this.instrucciones = data;
    })


  }

}
