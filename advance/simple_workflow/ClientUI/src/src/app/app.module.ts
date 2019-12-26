import { NgModule } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';
import { FormsModule } from '@angular/forms';
import { NgbModule } from '@ng-bootstrap/ng-bootstrap';
import { RouterModule } from '@angular/router';
import { EffectsModule } from '@ngrx/effects';
import { StoreModule } from '@ngrx/store';
import { StoreRouterConnectingModule  } from '@ngrx/router-store';
import { StoreDevtoolsModule } from '@ngrx/store-devtools';

import { appRoutes } from './app.routers';
import { AppComponent } from './app.component';

import { LoginComponent } from '../components/login/login.component';
import { WorkFlowComponent } from '../components/workFlow/workFlow.component';

import { appReducer } from './app.reducers';
import { HttpClientModule } from '@angular/common/http'; 

import { Apis, Effects } from '../moduleRegister';

@NgModule({
  imports: [
    BrowserModule,
    FormsModule,
    HttpClientModule,
    EffectsModule.forRoot(Effects),
    NgbModule.forRoot(),
    RouterModule.forRoot(appRoutes),
    StoreModule.forRoot(appReducer),
    StoreRouterConnectingModule,
    StoreDevtoolsModule.instrument(),
  ],
  providers: [...Apis],
  declarations: [ AppComponent, LoginComponent, WorkFlowComponent],
  bootstrap:    [ AppComponent ]
})
export class AppModule { }
