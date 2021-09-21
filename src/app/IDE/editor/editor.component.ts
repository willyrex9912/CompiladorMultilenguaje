import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';

@Component({
  selector: 'app-editor',
  templateUrl: './editor.component.html',
  styleUrls: ['./editor.component.css']
})
export class EditorComponent implements OnInit {

  

  constructor(private router:Router) { }

  ngOnInit(): void {
  }


  text:string = "";
  options:any = {maxLines: 1000, printMargin: false};
  
  onChange(code) {
      console.log("new code", code);
  }

}
