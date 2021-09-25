import { Component, OnInit, ViewChild, AfterViewInit, ElementRef, ViewChildren, ViewContainerRef } from '@angular/core';
import { Router } from '@angular/router';
import * as ace from "ace-builds";
import { Analizador } from 'src/controllers/ControladorAnalisis';

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

  constructor(private router:Router) { }

  ngOnInit(): void {
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
  }
  

  compilar(){
    const aceEditor = ace.edit(this.editor.nativeElement);
    this.txtConsola = this.analizador.analizar(aceEditor.getValue());
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

}
