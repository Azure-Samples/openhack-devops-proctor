import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { ChallengesManageComponent } from './challenges-manage.component';

describe('ChallengesAddComponent', () => {
  let component: ChallengesManageComponent;
  let fixture: ComponentFixture<ChallengesManageComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ ChallengesManageComponent ],
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(ChallengesManageComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
