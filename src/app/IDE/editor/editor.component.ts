import { Component, OnInit, ViewChild, AfterViewInit, ElementRef, ViewChildren, ViewContainerRef } from '@angular/core';
import { Router } from '@angular/router';
import * as ace from "ace-builds";
import { ServicioService } from 'src/app/Servicio/servicio.service';
import { Analizador } from 'src/controllers/ControladorAnalisis';
import { Cuadrupla } from 'src/model/Cuadrupla';

import * as $ from 'jquery'; import 'jstree';
import { Proyecto } from 'src/model/Proyecto/Proyecto';
import { ModalService } from 'src/app/modal/servicio/modal.service';
import { ProyectoService } from 'src/app/services/proyecto/proyecto.service';
import { GestionadorPaquete } from 'src/resources/utilidades/proyecto/GestionadorPaquete';
import { Archivo } from 'src/model/Proyecto/Archivo';

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
  //private banderaExpandir = true;
  public gestionadorPaquete:GestionadorPaquete;
  public codigoPrincipal = "";
  private archivoActual;

  public proyecto:Proyecto;

  constructor(private servicio:ServicioService, private servicioProyecto:ProyectoService, private servicioModal:ModalService, private router:Router) {
    this.gestionadorPaquete = new GestionadorPaquete();
    if(localStorage.getItem('proyecto')!=null){
      servicioProyecto.getProyecto(localStorage.getItem('proyecto')).subscribe(data=>{
        this.proyecto = data;
      });
      localStorage.setItem('proyecto',null);
    }
    
    //console.log(this.router.getCurrentNavigation().extras.state.nombre);
    
    //+++++++++++++TEMP++++++++++++++++++++++++++++++++++++++++++++++++
    //this.proyecto = new Proyecto('proyecto1');
    //this.simular();
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

  public abrirModal(id:string):void{
    this.servicioModal.abrir(id);
  }

  public cerrarModal(id:string):void{
    this.servicioModal.cerrar(id);
  }
  
  
  //+++++++++++++++++METODO TEMPORAL DE SIMULACION++++++++++++++++++++++
  public simular():void{
    //this.proyecto.agregarPaquete('backend.analizador');
    this.gestionadorPaquete.crearPaquete('backend.controladores.mensaje',this.proyecto);
    this.gestionadorPaquete.crearPaquete('backend.controladores.alerta',this.proyecto);
    this.gestionadorPaquete.crearPaquete('backend.controladores.data',this.proyecto);
    this.gestionadorPaquete.crearPaquete('backend.controladores.password',this.proyecto);
    this.gestionadorPaquete.crearPaquete('backend.error',this.proyecto);
    this.gestionadorPaquete.crearPaquete('frontend.vistas.principal',this.proyecto);
    this.gestionadorPaquete.crearPaquete('frontend.vistas.secundaria',this.proyecto);
    this.gestionadorPaquete.crearPaquete('frontend.controladores.password',this.proyecto);
    this.gestionadorPaquete.nuevoArchivo('backend.analizador.lexer',this.proyecto,"");
    this.gestionadorPaquete.nuevoArchivo('frontend.vistas.principal.modelos.modelo',this.proyecto,"");
    this.gestionadorPaquete.nuevoArchivo('backend.recuperador.lexer',this.proyecto,"");
    this.gestionadorPaquete.nuevoArchivo('backend.controller',this.proyecto,"");
    this.gestionadorPaquete.nuevoArchivo('backend.controller2',this.proyecto,"");
    this.gestionadorPaquete.nuevoArchivo('main',this.proyecto,"");
    console.log('METODOS CREADOS');
    console.log(this.proyecto)
    let nombrePaquete = 'frontend.vistas';
    let paquete = this.gestionadorPaquete.buscarPaquete(nombrePaquete,this.proyecto);
    if(paquete==null){
      console.log("No se ha encontrado el paquete "+nombrePaquete);
    }else{
      console.log("Paquete "+nombrePaquete+" cuenta con "+paquete.paquetes.length+" paquetes.");
    }
  }

  public crearArchivo():void{
    if(this.idValido(this.idArchivo)){
      //this.proyecto.crearArchivo(this.idArchivo);
      this.gestionadorPaquete.nuevoArchivo(this.idArchivo,this.proyecto,"");
      this.idArchivo = "";
    }else{
      this.idArchivo = "";
    }
    //this.reexpandir();
    console.log(this.proyecto);
  }

  public crearPaquete():void{
    if(this.idValido(this.idPaquete)){
      this.gestionadorPaquete.crearPaquete(this.idPaquete,this.proyecto);
      this.idPaquete = "";
    }else{
      this.idPaquete = "";
    }
    //this.reexpandir();
  }

  /*
  reexpandir():void{
    if(this.banderaExpandir){
      this.expandir();
      this.banderaExpandir = false;
    }
  }
  */

  private idValido(id:string):boolean{
    return /^([a-zA-Z0-9_]+([.][a-zA-Z0-9_]+)*)$/.test(id);
  }

  public guardarProyecto():void{
    if(this.proyecto!=null){
      this.servicioProyecto.enviarProyecto(this.proyecto).subscribe(data=>{
        this.textoInfo = data.descripcion;
        this.abrirModal("modal-info");
      });
    }
  }

  public crearProyecto():void{
    this.proyecto = new Proyecto(this.nombreProyecto);
    this.nombreProyecto = "";
  }

  public actualizarCodigoEditor(id:string):void{
    let archivo:Archivo = this.gestionadorPaquete.buscarArchivo(id,this.proyecto);
    if(archivo!=null){
      const aceEditor = ace.edit(this.editor.nativeElement);
      aceEditor.session.setValue(archivo.codigo);
      this.archivoActual = archivo;
      //++++++++++++++++++++++++++CONECTAR CODIGO CON ARCHIVO ACTUAL
    }
  }

  public mostrarProyecto(){
    console.log(this.proyecto);
    console.log(this.codigoPrincipal);
  }

}
