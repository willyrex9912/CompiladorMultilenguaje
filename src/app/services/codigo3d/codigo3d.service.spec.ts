import { TestBed } from '@angular/core/testing';

import { Codigo3dService } from './codigo3d.service';

describe('Codigo3dService', () => {
  let service: Codigo3dService;

  beforeEach(() => {
    TestBed.configureTestingModule({});
    service = TestBed.inject(Codigo3dService);
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });
});
