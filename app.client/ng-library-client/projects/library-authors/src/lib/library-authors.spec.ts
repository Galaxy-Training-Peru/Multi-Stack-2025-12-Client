import { ComponentFixture, TestBed } from '@angular/core/testing';

import { LibraryAuthors } from './library-authors';

describe('LibraryAuthors', () => {
  let component: LibraryAuthors;
  let fixture: ComponentFixture<LibraryAuthors>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [LibraryAuthors]
    })
    .compileComponents();

    fixture = TestBed.createComponent(LibraryAuthors);
    component = fixture.componentInstance;
    await fixture.whenStable();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
