import { Action } from '@ngrx/store';
import { ActivationEnd } from '@angular/router';

export const FIELD_UPDATE = '[LOGIN] FIELD_UPDATE';
export class FielUpdateAction implements Action {
  readonly type = FIELD_UPDATE;
  public payload: any;
  constructor(payload: any) {
    this.payload = payload;
  }
}

export const LOGIN = '[LOGIN] DO_LOGIN';
export class LoginAction implements Action {
  readonly type = LOGIN;
  constructor(public payload: any){}
}

export const LOGIN_SUCCESS = '[LOGIN] LOGIN_SUCCESS';
export class LoginSuccessAction implements Action {
  readonly type = LOGIN_SUCCESS;
  constructor(public payload: any) {}
}

export const ERROR = '[LOGIN] ERROR';
export class ErrorAction implements Action {
  readonly type = ERROR;
  constructor(public payload: any) {}
}

export const FORGOT_PASSWORD = '[LOGIN] FORGOT_PASSWORD';
export class ForgotPasswordAction implements Action {
    readonly type = FORGOT_PASSWORD;
}
  
export type Actions = LoginAction | ForgotPasswordAction;
