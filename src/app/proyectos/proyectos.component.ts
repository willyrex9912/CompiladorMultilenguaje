import { Component, OnInit } from '@angular/core';
import { Proyecto } from 'src/model/Proyecto/Proyecto';
import { ProyectoService } from '../services/proyecto/proyecto.service';

@Component({
  selector: 'app-proyectos',
  templateUrl: './proyectos.component.html',
  styleUrls: ['./proyectos.component.css']
})
export class ProyectosComponent implements OnInit {

  public proyectos:Array<Proyecto>;

  constructor(private servicioProyecto:ProyectoService) {
    this.actualizarProyectos();
  }

  ngOnInit(): void {
  }

  private actualizarProyectos(){
    this.servicioProyecto.getProyectos().subscribe( data => {
      this.proyectos = data;
    });
  }

}
