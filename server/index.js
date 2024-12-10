const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');
const { Sequelize } = require('sequelize');
require('dotenv').config();
const fs = require('fs');
const path = require('path');

const app = express();
app.use(cors());
app.use(bodyParser.json());

// Configuración de Sequelize
const sequelize = new Sequelize(
    process.env.DB_NAME,
    process.env.DB_USER,
    process.env.DB_PASSWORD,
    {
        host: process.env.DB_HOST,
        dialect: 'mysql',
    }
);

// Prueba de conexión
sequelize.authenticate()
    .then(() => console.log('Conexión a la base de datos establecida'))
    .catch(err => console.error('Error al conectar:', err));

app.get('/api', (req, res) => {
    res.json({ message: '¡Hola desde el backend con Node.js y MySQL!' });
});

const PORT = 3000;
app.listen(PORT, () => console.log(`Servidor corriendo en http://localhost:${PORT}`));

//Prolog

export class Prolog {
    static prologFile = fs.readFileSync(path.join(__dirname, 'prolog.pl'), 'utf8');

    constructor() {}

    iniciarSesion() {
        this.session = window.pl.create();
    }

    async obtenerRespuesta() {
        const resultado = await this.ejecutarConsulta('regla(Respuesta).');
        const respuestaString = resultado[0].match(/\[(.*?)\]/)[1];
        const respuestasArray = respuestaString.split(',');

        return respuestasArray;
    }

    async enviarRespuesta(respuesta) {
        await this.ejecutarConsulta(`regla('${respuesta}').`);

        const resultado = await this.ejecutarConsulta('regla(Respuesta).');
        const respuestaString = resultado[0].match(/\[(.*?)\]/)[1];
        const respuestasArray = respuestaString.split(',');

        return respuestasArray;
    }

    ejecutarConsulta(regla) {
        return new Promise((resolve, reject) => {
            const session = this.session;
            const consulta = regla || this.reglaPorDefecto;
            let resultados = [];
            let finalizado = false;

            // Cargar el archivo del proyecto Prolog
            session.consult(Prolog.prologFile, {
                success: () => {
                    session.query(consulta, {
                        success: () => {
                            session.answers(
                                (x) => {
                                    let respuesta = session.format_answer(x);
                                    if (respuesta) {
                                        resultados.push(respuesta);
                                    }
                                },
                                {
                                    success: () => {
                                        finalizado = true;
                                        resolve(resultados);
                                    },
                                    error: (err) => {
                                        finalizado = true;
                                        reject(err);
                                    }
                                }
                            );
                        },
                        error: (err) => {
                            finalizado = true;
                            reject(err);
                        }
                    });

                    // Timeout
                    setTimeout(() => {
                        if (!finalizado) {
                            resolve(resultados);
                        }
                    }, 1000);
                },
                error: (err) => {
                    reject(err);
                }
            });
        });
    }
}
