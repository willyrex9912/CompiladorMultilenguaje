import { Component, OnInit } from '@angular/core';
import { NavigationExtras, Router } from '@angular/router';

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.css']
})
export class AppComponent {
  title = 'CompiladorMultilenguaje';

  constructor(private router:Router){}
  
  MostrarEditor(){
    this.router.navigate(["editor",{ id: 'heroId', foo: 'foo' }]);
  }

  MostrarConsola(){
    this.router.navigate(["consola"]);
  }
  
}
