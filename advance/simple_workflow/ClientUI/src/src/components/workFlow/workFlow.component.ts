import {
  Component,
  OnInit
} from '@angular/core';
import {
  Store
} from '@ngrx/store';

import {
  State
} from '../../app/app.reducers';
import * as Actions from './workFlow.actions';
import {
  Observable
} from 'rxjs';
import {
  WorkFlowDataItem
} from './models/models';
import {
  WorkFlowApi
} from './workFlow.api';
import {
  LoginAction
} from '../login/login.actions';

@Component({
  selector: 'app-workFlow',
  templateUrl: './workFlow.component.html',
  styleUrls: ['./workFlow.component.scss']
})
export class WorkFlowComponent implements OnInit {
  public items$: Observable < WorkFlowDataItem[] > ;
  public users$: Observable < any[] > ;
  public currentUserName: string;
  public currentUserId: string;

  public form: any;

  constructor(private store: Store < State > , private workflowApi: WorkFlowApi) {
    this.items$ = this.store.select(x => x.workFlow.data.items);
    this.users$ = this.store.select(x => x.workFlow.data.users);
    this.store.select(x => x.login).subscribe(x => {
      this.currentUserName = x.name || x.username;
      this.currentUserId = x.username;
      this.store.dispatch(new Actions.LoadAction(x.username));
    });

    this.form = {};

    this.store.select(x => x.workFlow.form).subscribe(x => {
      this.form = x;
    });
  }

  ngOnInit() {}

  onFieldChange(field, value) {
    this.store.dispatch(new Actions.SetFieldValue({
      field,
      value
    }));
  }

  createRequest() {
    this.workflowApi.createRequest({ ...this.form,
      username: this.currentUserName
    }).then(() => {
      this.store.dispatch(new Actions.LoadAction(this.currentUserId));
    });
  }

  executeCommand(workflowId, currentUserId, commandName) {
    this.workflowApi.executeCommand({
      workflowId,
      executor: currentUserId,
      commandName
    }).then(() => {
      this.store.dispatch(new Actions.LoadAction(this.currentUserId));
    });
  }

  relogin(username) {
    this.store.dispatch(new LoginAction({
      username
    }));
  }
}
