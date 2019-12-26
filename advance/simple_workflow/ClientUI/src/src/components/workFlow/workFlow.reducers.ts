import {
  createSelector
} from 'reselect';
import {
  Action
} from '@ngrx/store';

import * as Actions from './workFlow.actions';
import { Data } from './models/models';

export interface State {
  data: Data,
  form: {
    isShow: boolean,
    requestForUser: string
    numberOfRequestDays: number
    startDate: string
    comment: string
  }
}

const initialState: State = {
  data: {
    items: [],
    users: []
  },
  form: {
    isShow: true,
    numberOfRequestDays: 0,
    requestForUser: '',
    startDate: '',
    comment: ''
  }
};

export function workFlowReducer(state = initialState, action): State {
  switch (action.type) {
    case Actions.LOAD_SUCCESS:
      state.data = action.payload;
      return state;

    case Actions.SET_FIELD_VALUE:
      state.form[action.payload.field] = action.payload.value;
      state.form = {...state.form}
    return state;
    default:
      {
        return state;
      }
  }
}
