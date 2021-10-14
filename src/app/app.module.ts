import { NgModule } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';

import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';
import { MostrarCodigo3dComponent } from './Codigo3d/mostrar-codigo3d/mostrar-codigo3d.component';
import { EditorComponent } from './IDE/editor/editor.component';
import { FormsModule } from '@angular/forms';
import { ServicioService } from './Servicio/servicio.service';
import { HttpClientModule } from '@angular/common/http';
import { ModalModule } from './modal/modulo/modal/modal.module';
import { BarraComponent } from './barra/barra.component';
import { InicioComponent } from './inicio/inicio.component';

@NgModule({
  declarations: [
    AppComponent,
    EditorComponent,
    MostrarCodigo3dComponent,
    BarraComponent,
    InicioComponent
  ],
  imports: [
    BrowserModule,
    AppRoutingModule,
    FormsModule,
    HttpClientModule,
    ModalModule
  ],
  providers: [ServicioService],
  bootstrap: [AppComponent]
})
export class AppModule { }
