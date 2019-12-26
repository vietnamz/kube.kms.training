import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';

import { URL_API } from '../../config-url';

@Injectable()
export class LoginApi {
  private readonly API_URL = `${URL_API}/demo/login?username=`;

  constructor(private http: HttpClient) {}

  login(username: string, password: string) {
    return this.http.get<any>(`${this.API_URL}${username}`);
  }
}
