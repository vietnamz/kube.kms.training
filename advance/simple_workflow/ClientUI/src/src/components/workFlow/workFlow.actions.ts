import {
  Action
} from '@ngrx/store';

export const LOAD_DATA = '[WF] LOAD_DATA';
export class LoadAction implements Action {
  readonly type = LOAD_DATA;
  constructor(public username) {}
}

export const LOAD_SUCCESS = '[WF] LOAD_SUCCESS';
export class LoadSuccessAction implements Action {
  readonly type = LOAD_SUCCESS;
  constructor(public payload: any) {}
}

export const ERROR = '[WF] ERROR';
export class ErrorAction implements Action {
  readonly type = ERROR;
  constructor(public payload: any) {}
}

export const SET_FIELD_VALUE = '[WF] SET_FIELD_VALUE';
export class SetFieldValue implements Action {
  readonly type = SET_FIELD_VALUE;
  constructor(public payload: any) {}
}


export type Actions = LoadAction | ErrorAction;
