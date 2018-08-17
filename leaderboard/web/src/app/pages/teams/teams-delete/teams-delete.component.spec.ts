import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { TeamsDeleteComponent } from './teams-delete.component';

describe('TeamsDeleteComponent', () => {
  let component: TeamsDeleteComponent;
  let fixture: ComponentFixture<TeamsDeleteComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ TeamsDeleteComponent ],
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(TeamsDeleteComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
