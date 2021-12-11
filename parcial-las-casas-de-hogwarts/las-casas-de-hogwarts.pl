% enunciado: https://docs.google.com/document/d/1Dc7crdtkBYyoxiRes3BYaAOnHgkfYV_cvDBXn_yR2ZI/edit

% mago(nombre, statusDeSangre, [caracteristica])
mago(harry, mestiza, [coraje, amistad, orgullo, inteligencia]).
mago(ron, pura, [amistad, diversion, coraje]).
mago(hermione, impura, [inteligencia, coraje, responsabilidad, amistad, orgullo]).
mago(hannahAbbott, mestiza, [amistad, diversion]).
mago(draco, pura, [inteligencia, orgullo]).
mago(lunaLovegood, mestiza, [inteligencia, responsabilidad, amistad, coraje]).

casa(gryffindor).
casa(hufflepuff).
casa(ravenclaw).
casa(slytherin).

odia(harry, slytherin).
odia(draco, hufflepuff).

caracteriza(gryffindor, amistad).
caracteriza(gryffindor, coraje).
caracteriza(slytherin, orgullo).
caracteriza(slytherin, inteligencia).
caracteriza(ravenclaw, inteligencia).
caracteriza(ravenclaw, responsabilidad).
caracteriza(hufflepuff, amistad).
caracteriza(hufflepuff, diversion).

% ===============
%     Punto 1    
% ===============

mago(Mago) :-
    mago(Mago, _, _).

permiteEntrar(Casa, Mago) :-
    casa(Casa),
    mago(Mago),
    Casa \= slytherin.

permiteEntrar(slytherin, Mago) :-
    mago(Mago, Sangre, _),
    Sangre \= impura.

% ===============
%     Punto 2    
% ===============

tieneCaracter(Mago, Casa) :-
    casa(Casa),
    mago(Mago),
    forall(caracteriza(Casa, Caracteristica), tieneCaracteristica(Mago, Caracteristica)).

tieneCaracteristica(Mago, Caracteristica) :-
    mago(Mago, _, Caracter),
    member(Caracteristica, Caracter).

% ===============
%     Punto 3    
% ===============

casaPosible(Mago, Casa) :-
    tieneCaracter(Mago, Casa),
    permiteEntrar(Casa, Mago),
    not(odia(Mago, Casa)).

% ===============
%     Punto 4    
% ===============

cadenaDeAmistades(Magos) :-
    sonAmistosos(Magos),
    cadenaDeCasasPosibles(Magos).

sonAmistosos(Magos) :-
    forall(member(Mago, Magos), tieneCaracteristica(Mago, amistad)).

/* recursividad
cadenaDeCasasPosibles([Mago1, Mago2 | Magos]) :-
    casaPosible(Mago1, Casa),
    casaPosible(Mago2, Casa),
    cadenaDeCasasPosibles([Mago2 | Magos]).
cadenaDeCasasPosibles([_]).
cadenaDeCasasPosibles([]).
*/

cadenaDeCasasPosibles(Magos) :-
    forall(consecutivos(Mago1, Mago2, Magos), mismaCasaPosible(Mago1, Mago2)).

consecutivos(Anterior, Siguiente, Lista) :-
    nth1(IndiceAnterior, Lista, Anterior),
    IndiceSiguiente is IndiceAnterior + 1,
    nth1(IndiceSiguiente, Lista, Siguiente).

mismaCasaPosible(Mago1, Mago2) :-
    casaPosible(Mago1, Casa),
    casaPosible(Mago2, Casa),
    Mago1 \= Mago2.

% ===============
%     Punto 5    
% ===============

lugarProhibido(bosque, 50).
lugarProhibido(seccionRestringida, 10).
lugarProhibido(tercerPiso, 75).

alumnoFavorito(flitwick, hermione).
alumnoFavorito(snape, draco).
alumnoOdiado(snape, harry).

hizo(ron, buenaAccion(jugarAlAjedrez, 50)).
hizo(harry, fueraDeCama).
hizo(hermione, irA(tercerPiso)).
hizo(hermione, responder("Donde se encuentra un Bezoar", 15, snape)).
hizo(hermione, responder("Wingardium Leviosa", 25, flitwick)).
hizo(ron, irA(bosque)).
hizo(draco, irA(mazmorras)).

esDe(harry, gryffindor).

esBuenAlumno(Mago) :-
    hizo(Mago, Accion),
    not(malaAccion(Accion)).

malaAccion(fueraDeCama).
malaAccion(irA(Lugar)) :-
    lugarProhibido(Lugar, _).

% ===============
%     Punto 6    
% ===============

puntosDeCasa(Casa, PuntajeTotal) :-
    casa(Casa),
    findall(Puntaje, puntajeAlumno(Puntaje, Casa), Puntajes),
    sumlist(Puntajes, PuntajeTotal).

puntajeAlumno(Puntaje, Casa) :-
    esDe(Mago, Casa),
    findall(PuntajePorAccion, puntajePorAccionesDeMago(Mago, PuntajePorAccion), Puntajes),
    sumlist(Puntajes, Puntaje).

puntajePorAccionesDeMago(Mago, PuntajePorAccion) :-
    hizo(Mago, Accion),
    puntosAccion(Mago, Accion, PuntajePorAccion).

puntosAccion(Mago, responder(_, Dificultad, Profesor), Puntos) :-
    alumnoFavorito(Profesor, Mago),
    Puntos is Dificultad * 2.
puntosAccion(Mago, responder(_, Dificultad, Profesor), Dificultad) :-
    alumnoOdiado(Profesor, Mago).
puntosAccion(_, fueraDeCama, -50).
puntosAccion(_, irA(Lugar), Puntos) :-
    lugarProhibido(Lugar, Puntaje),
    Puntos is -Puntaje.
puntosAccion(_, buenaAccion(_, Puntos), Puntos).

% ===============
%     Punto 7    
% ===============

casaGanadora(Casa) :-
    puntosDeCasa(Casa, PuntajeCasa),
    not(otraCasaTieneMasPuntos(Casa, PuntajeCasa)).

otraCasaTieneMasPuntos(Casa, PuntajeCasa) :-
    casa(OtraCasa),
    puntosDeCasa(OtraCasa, OtroPuntaje),
    Casa \= OtraCasa,
    PuntajeCasa < OtroPuntaje.