:- dynamic(paso/1).   % Paso actual en el sistema.
:- dynamic(plaga/1).  % Plaga identificada.
:- dynamic(sintoma/1). % Síntoma observado.
:- dynamic(calidad_agua/1). % Calidad de agua observada.
:- dynamic(rotacion/1). % Información sobre rotación de cultivos.
:- dynamic(enfermedad/1). % Enfermedad identificada.
:- dynamic(clima/1). % Condición climática observada.

% Paso inicial: Selección de diagnóstico
regla(Respuesta):- 
    (paso(_) -> 
        fail
    ; 
        !, ListaPasos = ['PREGUNTA', '¿Qué aspecto del cultivo desea revisar?', 'Enfermedades', 'Calidad del agua', 'Rotación de cultivos', 'Plagas', 'Condiciones climáticas'],
        Respuesta = ListaPasos,
        retractall(paso(_)),
        assertz(paso('Seleccionar Categoria'))
    ).

regla(Respuesta):-
    (paso('Seleccionar Categoria') ->
        !,retractall(paso(_)),!,
        assertz(paso(Respuesta))
    ).


% Preparación para enfermedad
regla(Respuesta):- 
    (paso('Enfermedades') -> 
        !, 
        Respuesta = ['PREGUNTA', '¿Qué síntoma observa en las plantas?', 'Hojas amarillentas', 'Manchas negras', 'Manchas marrones en hojas', 'Tallos quebradizos', 'Bordes mojados'],
        retractall(paso(_)),
        assertz(paso('Registrar Sintoma'))
    ).

% Preparación para calidad de agua
regla(Respuesta):- 
    (paso('Calidad del agua') -> 
        !, 
        Respuesta = ['PREGUNTA', '¿Qué problema ha notado con la calidad del agua?', 'Mala calidad', 'Sedimentos', 'Contaminada'],
        retractall(paso(_)),
        assertz(paso('Registrar Calidad Agua'))
    ).

% Preparación para rotación de cultivos
regla(Respuesta):- 
    (paso('Rotación de cultivos') -> 
        !, 
        Respuesta = ['PREGUNTA', '¿Qué aspecto de la rotación le interesa?', 'Mejora del suelo', 'Descanso del invernadero'],
        retractall(paso(_)),
        assertz(paso('Registrar Rotacion'))
    ).

% Preparación para plagas
regla(Respuesta):- 
    (paso('Plagas') -> 
        !, 
        Respuesta = ['PREGUNTA', '¿Qué síntoma de plaga ha observado?', 'Capa pegajosa', 'Bichitos verdes', 'Trips', 'Mosca blanca'],
        retractall(paso(_)),
        assertz(paso('Registrar Plaga'))
    ).

% Preparación para condiciones climáticas
regla(Respuesta):- 
    (paso('Condiciones climáticas') -> 
        !, 
        Respuesta = ['PREGUNTA', '¿Qué condición climática ha notado?', 'Calor', 'Humedad Alta', 'Sequía'],
        retractall(paso(_)),
        assertz(paso('Registrar Clima'))
    ).

% Registro del síntoma en caso de enfermedad
regla(Respuesta):- 
    (paso('Registrar Sintoma') -> 
        retractall(paso(_)),
        assertz(paso('Comprobar Sintoma')),
        assertz(sintoma(Respuesta))
    ).

% Comprobación de síntoma y diagnóstico para enfermedades
regla(Respuesta):- 
    (paso('Comprobar Sintoma'), sintoma('Hojas amarillentas') -> 
        !, 
        Respuesta = ['RESPUESTA', 'Posible deficiencia de nutrientes o infestación de mosca blanca. Revisa los nutrientes y busca insectos en el envés de las hojas.'],
        retractall(paso(_)),
        retractall(sintoma(_))
    ).

regla(Respuesta):- 
    (paso('Comprobar Sintoma'), sintoma('Manchas negras') -> 
        !, 
        Respuesta = ['RESPUESTA', 'Posible infección por Alternaria. Aplicar fungicidas específicos.'],
        retractall(paso(_)),
        retractall(sintoma(_))
    ).

regla(Respuesta):- 
    (paso('Comprobar Sintoma'), sintoma('Manchas marrones en hojas') -> 
        !, 
        Respuesta = ['RESPUESTA', 'Posible infección por hongos. Aplicar fungicidas específicos.'],
        retractall(paso(_)),
        retractall(sintoma(_))
    ).

regla(Respuesta):- 
    (paso('Comprobar Sintoma'), sintoma('Tallos quebradizos') -> 
        !, 
        Respuesta = ['RESPUESTA', 'Posible deficiencia de calcio. Añade suplementos de calcio al suelo.'],
        retractall(paso(_)),
        retractall(sintoma(_))
    ).

regla(Respuesta):- 
    (paso('Comprobar Sintoma'), sintoma('Bordes mojados') -> 
        !, 
        Respuesta = ['RESPUESTA', 'Posible aparición de mildiu. Aplicar fungicidas específicos.'],
        retractall(paso(_)),
        retractall(sintoma(_))
    ).

% Registro de la calidad del agua
regla(Respuesta):- 
    (paso('Registrar Calidad Agua') -> 
        retractall(paso(_)),
        assertz(paso('Comprobar Calidad Agua')),
        assertz(calidad_agua(Respuesta))
    ).

% Comprobación de calidad del agua
regla(Respuesta):- 
    (paso('Comprobar Calidad Agua'), calidad_agua('Mala calidad') -> 
        !, 
        Respuesta = ['RESPUESTA', 'La mala calidad del agua podría estar afectando la salud de las plantas.'],
        retractall(paso(_)),
        retractall(calidad_agua(_))
    ).

regla(Respuesta):- 
    (paso('Comprobar Calidad Agua'), calidad_agua('Sedimentos') -> 
        !, 
        Respuesta = ['RESPUESTA', 'Presencia de sedimentos en el agua. Considerar el uso de un filtro.'],
        retractall(paso(_)),
        retractall(calidad_agua(_))
    ).


regla(Respuesta):- 
    (paso('Comprobar Calidad Agua'), calidad_agua('Contaminada') -> 
        !, 
        Respuesta = ['RESPUESTA', 'El agua contaminada puede ser perjudicial para las plantas, considere un sistema de purificación.'],
        retractall(paso(_)),
        retractall(calidad_agua(_))
    ).


% Registro de la rotación de cultivos
regla(Respuesta):- 
    (paso('Registrar Rotacion') -> 
        retractall(paso(_)),
        assertz(paso('Comprobar Rotacion')),
        assertz(rotacion(Respuesta))
    ).

% Comprobación de la rotación de cultivos
regla(Respuesta):- 
    (paso('Comprobar Rotacion'), rotacion('Mejora del suelo') -> 
        !, 
        Respuesta = ['RESPUESTA', 'La rotación de cultivos mejora la salud del suelo y las plantas.'],
        retractall(paso(_)),
        retractall(rotacion(_))
    ).

regla(Respuesta):- 
    (paso('Comprobar Rotacion'), rotacion('Descanso del invernadero') -> 
        !, 
        Respuesta = ['RESPUESTA', 'El descanso del invernadero permite regenerar el suelo.'],
        retractall(paso(_)),
        retractall(rotacion(_))
    ).

% Registro de plaga
regla(Respuesta):- 
    (paso('Registrar Plaga') -> 
        retractall(paso(_)),
        assertz(paso('Comprobar Plaga')),
        assertz(plaga(Respuesta))
    ).

regla(Respuesta):- 
    (paso('Comprobar Plaga'), plaga('Capa pegajosa') -> 
        !, 
        Respuesta = ['RESPUESTA', 'Posible infestación de mosca blanca. Revisa el envés de las hojas.'],
        retractall(paso(_)),
        retractall(plaga(_))
    ).

regla(Respuesta):- 
    (paso('Comprobar Plaga'), plaga('Bichitos verdes') -> 
        !, 
        Respuesta = ['RESPUESTA', 'Posible infestación de pulgones. ', 'Elige una opción: Más información o Sugerencias para tratar.'],
        retractall(paso(_)),
        assertz(paso('Elegir Opción'))
    ).

regla(Respuesta):- 
    (paso('Elegir Opción') -> 
        !, 
        Respuesta = ['PREGUNTA', '¿Qué deseas saber?', 'Más información', 'Sugerencias para tratar.'],
        retractall(paso(_)),
        assertz(paso('Procesar Opción'))
    ).


regla(Respuesta):- 
    (paso('Procesar Opción'), ultima_respuesta('Más información') -> 
        !, 
        Respuesta = ['RESPUESTA', 'Los pulgones son insectos pequeños que se alimentan de la savia de las plantas, debilitándolas.'],
        retractall(paso(_)),
        retractall(ultima_respuesta(_))
    ).

regla(Respuesta):- 
    (paso('Procesar Opción'), ultima_respuesta('Sugerencias para tratar.') -> 
        !, 
        Respuesta = ['RESPUESTA', 'Para tratar la infestación de pulgones, se puede aplicar un insecticida específico para pulgones o usar métodos naturales como la liberación de mariquitas.'],
        retractall(paso(_)),
        retractall(ultima_respuesta(_))
    ).

% Predicado para almacenar la última respuesta del usuario
registra_respuesta(Respuesta):- 
    retractall(ultima_respuesta(_)),
    assertz(ultima_respuesta(Respuesta)).


regla(Respuesta):- 
    (paso('Comprobar Plaga'), plaga('Trips') -> 
        !, 
        Respuesta = ['RESPUESTA', 'Posible infestación de trips. Revisa el envés de las hojas.'],
        retractall(paso(_)),
        retractall(plaga(_))
    ).
   
regla(Respuesta):- 
    (paso('Comprobar Plaga'), plaga('Mosca blanca') -> 
        !, 
        Respuesta = ['RESPUESTA', 'Posible infestación de mosca blanca. Revisa el envés de las hojas.'],
        retractall(paso(_)),
        retractall(plaga(_))
    ).


% Registro del clima
regla(Respuesta):- 
    (paso('Registrar Clima') -> 
        retractall(paso(_)),
        assertz(paso('Comprobar Clima')),
        assertz(clima(Respuesta))
    ).

% Comprobación de clima
regla(Respuesta):- 
    (paso('Comprobar Clima'), clima('Calor') -> 
        !, 
        Respuesta = ['RESPUESTA', 'Las altas temperaturas favorecen la proliferación de plagas. Mantenga un control de humedad.'],
        retractall(paso(_)),
        retractall(clima(_))
    ).

regla(Respuesta):- 
    (paso('Comprobar Clima'), clima('Humedad Alta') -> 
        !, 
        Respuesta = ['RESPUESTA', 'La humedad alta puede favorecer la aparición de hongos.'],
        retractall(paso(_)),
        retractall(clima(_))
    ).

regla(Respuesta):- 
    (paso('Comprobar Clima'), clima('Sequía') -> 
        !, 
        Respuesta = ['RESPUESTA', 'La sequía hace que aparezcan más ácaros y otras plagas que buscan plantas secas.'],
        retractall(paso(_)),
        retractall(clima(_))
    ).

limpiar:-
    retractall(paso(_)),
    retractall(plaga(_)),
    retractall(sintoma(_)),
    retractall(calidad_agua(_)),
    retractall(rotacion(_)),
    retractall(enfermedad(_)),
    retractall(clima(_)),
    retractall(ultima_respuesta(_)).
