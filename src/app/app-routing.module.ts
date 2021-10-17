import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { MostrarCodigo3dComponent } from './Codigo3d/mostrar-codigo3d/mostrar-codigo3d.component';
import { EditorComponent } from './IDE/editor/editor.component';
import { InicioComponent } from './inicio/inicio.component';
import { ProyectosComponent } from './proyectos/proyectos.component';

const routes: Routes = [
  {path:'', redirectTo: 'inicio', pathMatch:'full'},
  {path:'editor', component:EditorComponent},
  {path:'codigo3d', component:MostrarCodigo3dComponent},
  {path:'inicio',component:InicioComponent},
  {path:'proyectos',component:ProyectosComponent}
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }
