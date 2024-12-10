import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { map } from 'rxjs/operators';
import { environment } from '../../environments/environment';

@Injectable({
  providedIn: 'root',
})
export class PrologService {
  private apiUrl = environment.apiUrl; // Asegúrate de definir esto en tu archivo de entorno

  constructor(private http: HttpClient) {}

  iniciarSesion(): Observable<any> {
    return this.http.get(`${this.apiUrl}/api`).pipe(
      map((response: any) => {
        // Procesa la respuesta si es necesario
        return response.message;
      })
    );
  }

  esperarRespuesta(): Observable<string[]> {
    return this.http.get(`${this.apiUrl}/api/respuesta`).pipe(
      map((response: any) => {
        const respuestaString = response.match(/\[(.*?)\]/)[1];
        return respuestaString.split(',');
      })
    );
  }

  enviarRespuesta(respuesta: string): Observable<string[]> {
    return this.http.post(`${this.apiUrl}/api/respuesta`, { respuesta }).pipe(
      map((response: any) => {
        const respuestaString = response.match(/\[(.*?)\]/)[1];
        return respuestaString.split(',');
      })
    );
  }
}