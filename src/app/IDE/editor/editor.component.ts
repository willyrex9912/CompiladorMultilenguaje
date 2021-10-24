import { Component, OnInit, ViewChild, AfterViewInit, ElementRef, ViewChildren, ViewContainerRef } from '@angular/core';
import { Router } from '@angular/router';
import * as ace from "ace-builds";
import { Analizador } from 'src/controllers/ControladorAnalisis';

import * as $ from 'jquery'; import 'jstree';
import { Proyecto } from 'src/model/Proyecto/Proyecto';
import { ProyectoService } from 'src/app/services/proyecto/proyecto.service';
import { GestionadorPaquete } from 'src/resources/utilidades/proyecto/GestionadorPaquete';
import { Archivo } from 'src/model/Proyecto/Archivo';
import { Codigo3dService } from 'src/app/services/codigo3d/codigo3d.service';
import { ListaInstruccion } from 'src/model/instruccion/estructura/ListaInstruccion';
import { PilaInstruccion } from 'src/model/instruccion/estructura/PilaInstruccion';

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
  public idArchivo:string = "";
  public idPaquete:string = "";
  public nombreProyecto:string = "";
  public textoInfo:string = "";
  public gestionadorPaquete:GestionadorPaquete;
  public codigoPrincipal = "";
  public archivoActual:Archivo;

  public proyecto:Proyecto;
  public codigo3d = "";

  private listaInstruccion:ListaInstruccion;
  private pilaInstruccion:PilaInstruccion;

  constructor(private servicioProyecto:ProyectoService, private servicioCodigo3d:Codigo3dService, private router:Router) {
    this.gestionadorPaquete = new GestionadorPaquete();
    if(localStorage.getItem('proyecto')!=null){
      servicioProyecto.getProyecto(localStorage.getItem('proyecto')).subscribe(data=>{
        this.proyecto = data;
      });
      localStorage.setItem('proyecto',null);
    }
  }

  ngOnInit(): void {
    $(function () {
      $('#jstree').jstree();
      $('#jstree').on("changed.jstree", function (e, data) {
        console.log(data.selected);
      });
    });
    this.expandir();
  }

  expandir():void{
    $('.expand').click(function() {
      $('ul', $(this).parent()).eq(0).toggle();
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
    this.listaInstruccion = new ListaInstruccion();
    this.pilaInstruccion = new PilaInstruccion(this.listaInstruccion);
    console.clear();
    const aceEditor = ace.edit(this.editor.nativeElement);
    this.txtConsola = this.analizador.analizar(aceEditor.getValue(),this.pilaInstruccion);
    console.log(this.listaInstruccion);
  }

  public generarCodigo3d(){
    console.log(this.listaInstruccion);
    this.servicioCodigo3d.enviarInstrucciones(this.listaInstruccion).subscribe(data=>{
      this.codigo3d = data.descripcion;
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

  /*
  public abrirModal(id:string):void{
    this.servicioModal.abrir(id);
  }

  public cerrarModal(id:string):void{
    this.servicioModal.cerrar(id);
  }
  */
  

  public crearArchivo():void{
    if(this.idValido(this.idArchivo)){
      this.gestionadorPaquete.nuevoArchivo(this.idArchivo,this.proyecto,"");
      this.idArchivo = "";
    }else{
      this.idArchivo = "";
    }
  }

  public crearPaquete():void{
    if(this.idValido(this.idPaquete)){
      this.gestionadorPaquete.crearPaquete(this.idPaquete,this.proyecto);
      this.idPaquete = "";
    }else{
      this.idPaquete = "";
    }
  }

  private idValido(id:string):boolean{
    return /^([a-zA-Z0-9_]+([.][a-zA-Z0-9_]+)*)$/.test(id);
  }

  public guardarProyecto():void{
    this.guardarCambios();
    if(this.proyecto!=null){
      this.servicioProyecto.enviarProyecto(this.proyecto).subscribe(data=>{
        this.textoInfo = data.descripcion;
        document.getElementById("abrirModalInfo").click();
      });
    }
  }

  public crearProyecto():void{
    this.proyecto = new Proyecto(this.nombreProyecto);
    this.nombreProyecto = "";
  }

  public actualizarCodigoEditor(id:string):void{
    this.guardarCambios();
    let archivo:Archivo = this.gestionadorPaquete.buscarArchivo(id,this.proyecto);
    if(archivo!=null){
      const aceEditor = ace.edit(this.editor.nativeElement);
      aceEditor.session.setValue(archivo.codigo);
      this.archivoActual = archivo;
    }
  }

  public mostrarProyecto(){
    console.log(this.proyecto);
    console.log(this.codigoPrincipal);
  }

  public guardarCambios():void{
    if(this.archivoActual!= null){
      const aceEditor = ace.edit(this.editor.nativeElement);
      this.archivoActual.codigo = aceEditor.getValue();
    }
  }

}
