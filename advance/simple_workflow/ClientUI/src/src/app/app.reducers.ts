import { combineReducers, ActionReducerMap, ActionReducer } from '@ngrx/store';

import { createSelector } from 'reselect';

import { compose } from '@ngrx/core/compose';
import { storeFreeze } from 'ngrx-store-freeze';

import * as fromRouter from '@ngrx/router-store';
import * as fromLogin from '../components/login/login.reducers';
import * as fromWorkFlow from '../components/workFlow/workFlow.reducers';

export interface State {
  router: fromRouter.RouterReducerState;
  login: fromLogin.State;
  workFlow: fromWorkFlow.State;
}

export const appReducer: ActionReducerMap<State>  = {
  router: fromRouter.routerReducer,
  login: fromLogin.loginReducer,
  workFlow: fromWorkFlow.workFlowReducer
};