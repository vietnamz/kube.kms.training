
import { Injectable } from '@angular/core';
import { Router } from '@angular/router';
import { Location } from '@angular/common';
import { Effect, Actions } from '@ngrx/effects';
import { map, tap } from 'rxjs/operators';
import * as RouterActions from './router.actions';

@Injectable()
export class RouterEffects {
  @Effect({ dispatch: false })
  navigate$ = this.actions$
    .ofType(RouterActions.GO)
    .pipe(
      map((action: RouterActions.NavigateTo) => action.payload),
      tap(({ path, query: queryParams, extras }) =>
        this.router.navigate(path, { queryParams, ...extras })
      )
    );
  constructor(
    private actions$: Actions,
    private router: Router,
    private location: Location
  ) {}
}