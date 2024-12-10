import { Component, OnInit } from '@angular/core';
import { PrologService } from '../../services/prolog.service'; 
import { Message } from '../../models/message.model'; 

@Component({
  selector: 'app-home',
  templateUrl: './home.component.html',
  styleUrls: ['./home.component.css']
})
export class HomeComponent implements OnInit {
  registroChat: Message[] = [];
  respuesta: string = '';
  ocupado: boolean = false;
  respuestas: { label: string, value: string }[] = [];
  darkMode: boolean = true;

  constructor(private prolog: PrologService) {}

  ngOnInit() {
    this.nuevaSesion();
  }

  mostrarPregunta(pregunta: string) {
    this.registroChat = [
      ...this.registroChat,
      {
        modo: 'sistema_pregunta',
        mensaje: pregunta
      }
    ];
  }

  mostrarRespuesta(respuesta: string[]) {
    const respuestasFormatted = respuesta.map(r => ({
      modo: 'sistema_respuesta',
      mensaje: r
    }));
    this.registroChat = [...this.registroChat, ...respuestasFormatted];
  }

  scrollBottom() {
    window.scrollTo({ top: document.body.scrollHeight, behavior: 'smooth' });
  }

  componerRespuestas(respuestasArr: string[]) {
    this.respuesta = '';
    this.respuestas = respuestasArr.map(r => ({
      label: r,
      value: r
    }));
  }

  async parseInput(entrada: string[]) {
    switch (entrada[0]) {
      case 'PREGUNTA':
        this.mostrarPregunta(entrada[1]);
        this.componerRespuestas(entrada.slice(2));
        break;
      case 'RESPUESTA':
        this.mostrarRespuesta(entrada.slice(1));
        await new Promise(r => setTimeout(r, 50));
        this.scrollBottom();
        const resultado = await this.prolog.esperarRespuesta().toPromise();
        if (resultado) {
          if (resultado) {
            await this.parseInput(resultado);
          }
        }
        break;
      default:
        break;
    }
  }

  async nuevaSesion() {
    this.ocupado = true;
    this.registroChat = [];
    this.prolog.iniciarSesion();
    const resultado = await this.prolog.esperarRespuesta().toPromise();
    if (resultado) {
      if (resultado) {
        await this.parseInput(resultado);
      }
    }
    this.ocupado = false;
    window.scrollTo({ top: 0, behavior: 'smooth' });
  }

  async enviarRespuesta() {
    if (this.respuesta.trim() === '') return;
    this.ocupado = true;
    this.registroChat = [
      ...this.registroChat,
      {
        modo: 'usuario',
        mensaje: this.respuesta
      }
    ];
    await new Promise(r => setTimeout(r, 50));
    this.scrollBottom();
    this.respuesta = '';
    const resultado = await this.prolog.esperarRespuesta().toPromise();
    if (resultado) {
      if (resultado) {
        await this.parseInput(resultado);
      }
    }
    this.scrollBottom();
    this.ocupado = false;
  }

  toggleDarkMode() {
    this.darkMode = !this.darkMode;
    if (this.darkMode) {
      document.documentElement.classList.add('dark');
      document.documentElement.style.setProperty('--header-bg-color', '#1a1a1a');
      document.documentElement.style.setProperty('--header-text-color', '#e0e0e0');
    } else {
      document.documentElement.classList.remove('dark');
      document.documentElement.style.setProperty('--header-bg-color', '#949494');
      document.documentElement.style.setProperty('--header-text-color', '#1a1a1a');
    }
  }
}