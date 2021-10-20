import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { EditorComponent } from './IDE/editor/editor.component';
import { InicioComponent } from './inicio/inicio.component';
import { ProyectosComponent } from './proyectos/proyectos.component';

const routes: Routes = [
  {path:'editor', component:EditorComponent},
  {path:'inicio',component:InicioComponent},
  {path:'proyectos',component:ProyectosComponent},
  {path:'', redirectTo: 'inicio', pathMatch:'full'}
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }
