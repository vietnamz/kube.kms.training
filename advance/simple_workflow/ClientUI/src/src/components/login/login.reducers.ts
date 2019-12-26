import {
  createSelector
} from 'reselect';
import {
  Action
} from '@ngrx/store';

import * as LoginActions from './login.actions';

export interface State {
  username: string,
    password: string,
    token: string,
    userId: number,
    numberLogin: number;
    name: string;
    users: any[];
};

const initialState: State = {
  username: 'usera',
  password: 'pass',
  token: '',
  numberLogin: 0,
  userId: 0,
  name: '',
  users: []
};

export function loginReducer(state = initialState, action): State {
  console.log(action);
  switch (action.type) {
    case LoginActions.LOGIN_SUCCESS:
      return { ...state, ...action.payload};

    case LoginActions.FIELD_UPDATE:
      state[action.payload.field] = action.payload.value;
      return state;

    case LoginActions.LOGIN:
    case LoginActions.FORGOT_PASSWORD:
      ++state.numberLogin;
      return state;

    default:
      {
        return state;
      }
  }
}
