import {
  Injectable
} from '@angular/core';
import {
  Router
} from '@angular/router';
import {
  Location
} from '@angular/common';
import {
  Effect,
  Actions
} from '@ngrx/effects';
import {
  map,
  catchError,
  switchMap,
  mergeMap
} from 'rxjs/operators';
import { of
} from 'rxjs';

import {
  NavigateTo
} from '../../app/router.actions';
import * as LoginActions from './login.actions';
import {
  LoginApi
} from './login.api';

@Injectable()
export class LoginEffects {
  constructor(private actions$: Actions, private loginApi: LoginApi) {}

  @Effect({
    dispatch: true
  })
  doLogin$ = this
    .actions$
    .ofType(LoginActions.LOGIN)
    .pipe(
      map((action: LoginActions.LoginAction) => action.payload),
      switchMap(payload =>
        this.loginApi
        .login(payload.username, payload.password)
        .pipe(
          mergeMap(res => [new LoginActions.LoginSuccessAction(res),
            new NavigateTo({
              path: ['/workflow']
            })
          ]),
          catchError(error => this.handleError(error))
        )
      )
    );

  private handleError(error) {
    console.error(error);
    return of(new LoginActions.ErrorAction(error));
  }
}
