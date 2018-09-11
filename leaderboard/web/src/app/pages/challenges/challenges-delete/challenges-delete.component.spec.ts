import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { ChallengesDeleteComponent } from './challenges-delete.component';

describe('ChallengesDeleteComponent', () => {
  let component: ChallengesDeleteComponent;
  let fixture: ComponentFixture<ChallengesDeleteComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ ChallengesDeleteComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(ChallengesDeleteComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
