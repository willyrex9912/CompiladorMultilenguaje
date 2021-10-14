import { Component, OnInit, ViewChild, AfterViewInit, ElementRef, ViewChildren, ViewContainerRef } from '@angular/core';
import { NavigationExtras, Router } from '@angular/router';
import * as ace from "ace-builds";
import { ServicioService } from 'src/app/Servicio/servicio.service';
import { Analizador } from 'src/controllers/ControladorAnalisis';
import { Cuadrupla } from 'src/model/Cuadrupla';

import * as $ from 'jquery'; import 'jstree';
import { Paquete } from 'src/model/Proyecto/Paquete';
import { Proyecto } from 'src/model/Proyecto/Proyecto';

@Component({
  selector: 'app-editor',
  templateUrl: './editor.component.html',
  styleUrls: ['./editor.component.css']
})
export class EditorComponent implements OnInit, AfterViewInit {

  private linea:Number = 0;
  private columna:Number = 0;
  @ViewChild('editor') private editor:ElementRef<HTMLElement>;
  private txtConsola:String = "";
  private analizador = new Analizador();

  private proyecto:Proyecto;

  constructor(private servicio:ServicioService, private router:Router) {
    //console.log(this.router.getCurrentNavigation().extras.state.nombre);
    
    //+++++++++++++TEMP++++++++++++++++++++++++++++++++++++++++++++++++
    this.proyecto = new Proyecto('proyecto1');
    this.simular();
  }

  ngOnInit(): void {
    $(function () {
      let data = ['test1','test2','test3'];
      $('#jstree').jstree();
      $('#jstree').on("changed.jstree", function (e, data) {
        console.log(data.selected);
      });
    });
  }

  ngAfterViewInit(){
    
    ace.config.set("fontSize", "25px");
    ace.config.set('basePath', 'https://unpkg.com/ace-builds@1.4.12/src-noconflict');

    const aceEditor = ace.edit(this.editor.nativeElement);
    aceEditor.session.selection.on('changeCursor',()=>{
      this.linea = aceEditor.getCursorPosition().row+1;
      this.columna = aceEditor.getCursorPosition().column;
    });

    aceEditor.setTheme('ace/theme/eclipse');
    aceEditor.session.setMode('ace/mode/java');
    aceEditor.session.setUseSoftTabs(false);
  }
  

  public compilar(){
    console.clear();
    const aceEditor = ace.edit(this.editor.nativeElement);
    this.txtConsola = this.analizador.analizar(aceEditor.getValue());
  }

  public generarCodigo3d(){
    let cuadruplas:Array<Cuadrupla> = new Array();
    cuadruplas.push(new Cuadrupla("+","t3","t1","t2"));
    cuadruplas.push(new Cuadrupla("-","t13","t11","t12"));
    cuadruplas.push(new Cuadrupla("*","t23","t21","t22"));
    cuadruplas.push(new Cuadrupla("/","t33","t31","t32"));
    this.servicio.enviarCuadruplas(cuadruplas).subscribe(data=>{
      console.log(data);
    });
  }

  public procesarArchivo(archivos:FileList){
    let reader:FileReader = new FileReader();
    reader.readAsText(archivos.item(0));
    reader.onload = (e) => {
        const aceEditor = ace.edit(this.editor.nativeElement);
        aceEditor.session.setValue(e.target.result.toString());
    };
  }

  public getLinea(){
    return this.linea;
  }

  public getColumna(){
    return this.columna;
  }

  public getTxtConsola(){
    return this.txtConsola;
  }

  public getProyecto(){
    return this.proyecto;
  }

  //+++++++++++++++++METODO TEMPORAL DE SIMULACION++++++++++++++++++++++
  public simular():void{
    this.proyecto.agregarPaquete('backend.analizador');
    this.proyecto.agregarPaquete('backend.controladores.mensaje');
    this.proyecto.agregarPaquete('backend.controladores.alerta');
    this.proyecto.agregarPaquete('backend.controladores.data');
    this.proyecto.agregarPaquete('backend.controladores.password');
    this.proyecto.agregarPaquete('backend.error');
    this.proyecto.agregarPaquete('frontend.vistas.principal');
    this.proyecto.agregarPaquete('frontend.vistas.secundaria');
    this.proyecto.agregarPaquete('frontend.controladores.password');
    console.log('METODOS CREADOS');
    console.log(this.proyecto)
    let nombrePaquete = 'frontend.vistas';
    let paquete = this.proyecto.buscarPaquete(nombrePaquete);
    if(paquete==null){
      console.log("No se ha encontrado el paquete "+nombrePaquete);
    }else{
      console.log("Paquete "+nombrePaquete+" cuenta con "+paquete.getPaquetes().length+" paquetes.");
    }
  }

}
