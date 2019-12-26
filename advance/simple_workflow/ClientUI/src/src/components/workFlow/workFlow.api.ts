import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';

import { URL_API } from '../../config-url';

@Injectable()
export class WorkFlowApi {
  private readonly API_URL = `${URL_API}/demo`;

  constructor(private http: HttpClient) {}

  load(username: string) {
    return this.http.get<any>(`${this.API_URL}/items?username=` + username);
  }

  createRequest(data) {
    return this.http.post(`${this.API_URL}/ot-requests`, data).toPromise().then();
  }

  executeCommand(data) {
    return this.http.post(`${this.API_URL}/execute-command`, data).toPromise().then();
  }
}
