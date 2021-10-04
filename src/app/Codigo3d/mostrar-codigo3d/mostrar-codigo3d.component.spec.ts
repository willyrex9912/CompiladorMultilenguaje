import { ComponentFixture, TestBed } from '@angular/core/testing';

import { MostrarCodigo3dComponent } from './mostrar-codigo3d.component';

describe('MostrarCodigo3dComponent', () => {
  let component: MostrarCodigo3dComponent;
  let fixture: ComponentFixture<MostrarCodigo3dComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ MostrarCodigo3dComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(MostrarCodigo3dComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
