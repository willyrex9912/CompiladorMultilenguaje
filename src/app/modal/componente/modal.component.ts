import { Component, ElementRef, Input, OnDestroy, OnInit, ViewEncapsulation } from '@angular/core';
import { ModalService } from '../servicio/modal.service';

@Component({
  selector: 'wj-modal',
  templateUrl: './modal.component.html',
  styleUrls: ['./modal.component.css'],
  encapsulation: ViewEncapsulation.None
})
export class ModalComponent implements OnInit,OnDestroy {

  @Input() id: string;
  private elemento: any;

  constructor(private servicioModal: ModalService, private el: ElementRef) { 
    this.elemento = el.nativeElement;
  }

  ngOnInit(): void {
    // ensure id attribute exists
      if (!this.id) {
        console.error('modal must have an id');
        return;
    }

    // move element to bottom of page (just before </body>) so it can be displayed above everything else
    document.body.appendChild(this.elemento);

    // close modal on background click
    this.elemento.addEventListener('click', el => {
        if (el.target.className === 'wj-modal') {
            this.cerrar();
        }
    });

    // add self (this modal instance) to the modal service so it's accessible from controllers
    this.servicioModal.agregar(this);
  }

  // remove self from modal service when component is destroyed
  ngOnDestroy(): void {
    this.servicioModal.remover(this.id);
    this.elemento.remove();
  }

  // open modal
  abrir(): void {
    this.elemento.style.display = 'block';
    document.body.classList.add('wj-modal-open');
  }

  // close modal
  cerrar(): void {
    this.elemento.style.display = 'none';
    document.body.classList.remove('wj-modal-open');
  }

}
