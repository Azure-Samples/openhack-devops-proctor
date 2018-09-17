import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { ChallengesAddComponent } from './challenges-add.component';

describe('ChallengesAddComponent', () => {
  let component: ChallengesAddComponent;
  let fixture: ComponentFixture<ChallengesAddComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ ChallengesAddComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(ChallengesAddComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
