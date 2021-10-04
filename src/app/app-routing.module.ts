import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { MostrarCodigo3dComponent } from './Codigo3d/mostrar-codigo3d/mostrar-codigo3d.component';
import { EditorComponent } from './IDE/editor/editor.component';

const routes: Routes = [
  {path:'editor', component:EditorComponent},
  {path:'codigo3d', component:MostrarCodigo3dComponent}
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }
