import { NgModule } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';

import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';
import { EditorComponent } from './IDE/editor/editor.component';
import { FormsModule } from '@angular/forms';
import { HttpClientModule } from '@angular/common/http';
import { ModalModule } from './modal/modulo/modal/modal.module';
import { BarraComponent } from './barra/barra.component';
import { InicioComponent } from './inicio/inicio.component';
import { ProyectoService } from './services/proyecto/proyecto.service';
import { ProyectosComponent } from './proyectos/proyectos.component';
import { Codigo3dService } from './services/codigo3d/codigo3d.service';

@NgModule({
  declarations: [
    AppComponent,
    EditorComponent,
    BarraComponent,
    InicioComponent,
    ProyectosComponent
  ],
  imports: [
    BrowserModule,
    AppRoutingModule,
    FormsModule,
    HttpClientModule,
    ModalModule
  ],
  providers: [ProyectoService,Codigo3dService],
  bootstrap: [AppComponent]
})
export class AppModule { }
