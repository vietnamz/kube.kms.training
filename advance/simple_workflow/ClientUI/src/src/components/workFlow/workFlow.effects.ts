import {Injectable} from '@angular/core';
import {Router} from '@angular/router';
import {Location} from '@angular/common';
import {Effect, Actions} from '@ngrx/effects';
import {map, catchError, switchMap} from 'rxjs/operators';
import { of } from 'rxjs';

import * as WorkFlowActions from './workFlow.actions';
import { WorkFlowApi } from './workFlow.api';

@Injectable()
export class WorkFlowEffects {
    constructor(private actions$ : Actions, private workFlowApi: WorkFlowApi) {}

    @Effect({dispatch: true})
    loadData$ = this
        .actions$
        .ofType(WorkFlowActions.LOAD_DATA)
        .pipe(
          map((action : WorkFlowActions.LoadAction) => action),
          switchMap(payload =>
            this.workFlowApi
              .load(payload.username)
              .pipe(
                map(res =>new WorkFlowActions.LoadSuccessAction(res)),
                catchError(error => this.handleError(error))
              )
          )
      );

      
  private handleError(error) {
    console.error(error);
    return of (new WorkFlowActions.ErrorAction(error));
  }
}