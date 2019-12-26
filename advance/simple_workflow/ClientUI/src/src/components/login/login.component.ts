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
import * as Actions from './login.actions';
import {
  Observable
} from 'rxjs';

@Component({
  selector: 'app-login',
  templateUrl: './login.component.html',
  styleUrls: ['./login.component.scss']
})
export class LoginComponent implements OnInit {
  public username$: Observable<string>;
  public testCounter$: Observable<number>;
  private temp: any;

  constructor(private store: Store < State > ) {
    this.temp = {};

    this.testCounter$ = store.select(x => x.login.numberLogin);
    this.username$ = store.select(x=>x.login.username);
    this.username$.subscribe(x=> {
        this.temp.username = x;
    });
  }

  ngOnInit() {}

  onFieldChange(field, value) {
    this.store.dispatch(new Actions.FielUpdateAction({
      field,
      value
    }))
  }

  doLogin() {
    this.store.dispatch(new Actions.LoginAction({
      username: this.temp.username,
      password: ''
    }))
  }
}
