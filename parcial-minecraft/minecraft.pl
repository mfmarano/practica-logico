/*
Se tiene la siguiente base de conocimiento en cuanto a los jugadores,
con información de cada uno sobre su nombre, ítems que posee, y su nivel de hambre (0 a 10).
*/

jugador(stuart, [piedra, piedra, piedra, piedra, piedra, piedra, piedra, piedra], 3).
jugador(tim, [madera, madera, madera, madera, madera, pan, carbon, carbon, carbon, pollo, pollo], 8).
jugador(steve, [madera, carbon, carbon, diamante, panceta, panceta, panceta], 2).

/*
También se tiene información sobre el mapa del juego,
particularmente de las distintas secciones del mismo,
los jugadores que se encuentran en cada uno, y su nivel de oscuridad (0 a 10).
*/

lugar(playa, [stuart, tim], 2).
lugar(mina, [steve], 8).
lugar(bosque, [], 6).


/*
Por último, se conoce cuáles son los ítems comestibles.
*/

comestible(pan).
comestible(panceta).
comestible(pollo).
comestible(pescado).

%  ==================================
%    Punto 1: Jugando con los items
%  ==================================

% a.
tieneItem(Jugador, Item) :-
    jugador(Jugador, Items, _),
    member(Item, Items).

% b.
sePreocupaPorSuSalud(Jugador) :-
    tieneItem(Jugador, Item),
    comestible(Item),
    tieneItem(Jugador, OtroItem),
    comestible(OtroItem),
    Item \= OtroItem.

% c.
cantidadDeItem(Jugador, Item, Cantidad) :-
    tieneItem(_, Item),
    findall(_, tieneItem(Jugador, Item), ListaDeItem),
    length(ListaDeItem, Cantidad).

tieneMasDe(Jugador, Item) :-
    cuantosTieneDe(Jugador, Item, CuantosJugador),
    forall(cuantosTieneDe(_, Item, CuantosOtroJugador), CuantosOtroJugador =< CuantosJugador).

cuantosTieneDe(Jugador, Item, Cuantos) :-
    tieneItem(Jugador, _),
    findall(_, tieneItem(Jugador, Item), ListaDeItem),
    length(ListaDeItem, Cuantos).

%  =====================================
%    Punto 2: Alejarse de la oscuridad
%  =====================================