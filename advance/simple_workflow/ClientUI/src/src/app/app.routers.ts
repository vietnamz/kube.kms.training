import { Routes } from '@angular/router';

import {LoginComponent} from '../components/login/login.component'
import {WorkFlowComponent} from '../components/workFlow/workFlow.component'

export const appRoutes: Routes =
  [
    {
      path: 'workflow',
      component: WorkFlowComponent
    },
    {
      path: 'login',
      component: LoginComponent
    }
  ]