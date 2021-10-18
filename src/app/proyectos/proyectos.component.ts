import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { Proyecto } from 'src/model/Proyecto/Proyecto';
import { ProyectoService } from '../services/proyecto/proyecto.service';

@Component({
  selector: 'app-proyectos',
  templateUrl: './proyectos.component.html',
  styleUrls: ['./proyectos.component.css']
})
export class ProyectosComponent implements OnInit {

  public proyectos:Array<Proyecto>;

  constructor(private servicioProyecto:ProyectoService, private router:Router) {
    this.actualizarProyectos();
  }

  ngOnInit(): void {
  }

  private actualizarProyectos():void{
    this.servicioProyecto.getProyectos().subscribe( data => {
      this.proyectos = data;
    });
  }

  public abrirProyecto(nombre:string):void{
    localStorage.setItem('proyecto',nombre);
    this.router.navigate(["editor"]);
  }

}
