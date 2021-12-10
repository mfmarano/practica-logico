%  ===============
%      Punto 1
%  ===============

atleta(elNeneMalo, 30, argentina).
atleta(elHeredero, 32, argentina).
atleta(elNene, 25, argentina).
atleta(belenSucci, 35, argentina).
atleta(pequePareto, 35, argentina).
atleta(alexisMacAlister, 22, argentina).
atleta(funaTonaki, 26, japon).
atleta(delPotro, 32, argentina).
atleta(ariarneTitmus, _, australia).
atleta(kathleenLedecky, _, estadosUnidos).
atleta(bingjieLi, _, china).
atleta(johnFast, 20, estadosUnidos).
atleta(quickRick, 22, estadosUnidos).
atleta(flash, 19, estadosUnidos).

compite(elNeneMalo, voleyMasculino).
compite(elHeredero, voleyMasculino).
compite(elNene, voleyMasculino).
compite(belenSucci, hockeyFemenino).
compite(pequePareto, judo).
compite(alexisMacAlister, futbolMasculino).
compite(funaTonaki, judo).
compite(ariarneTitmus, natacion400MetrosFemenino).
compite(kathleenLedecky, natacion400MetrosFemenino).
compite(bingjieLi, natacion400MetrosFemenino).
compite(johnFast, velocidadMasculino).
compite(quickRick, velocidadMasculino).
compite(flash, velocidadMasculino).

enEquipo(voleyMasculino).
enEquipo(hockeyFemenino).
enEquipo(futbolMasculino).
individual(judo).
individual(natacion400MetrosFemenino).
individual(velocidadMasculino).

medalla(bronce, voleyMasculino, argentina).
medalla(plata, hockeyFemenino, argentina).
medalla(oro, hockeyFemenino, paisesBajos).
medalla(bronce, natacion400MetrosFemenino, bingjieLi).
medalla(plata, natacion400MetrosFemenino, kathleenLedecky).
medalla(oro, natacion400MetrosFemenino, ariarneTitmus).
medalla(bronce, velocidadMasculino, johnFast).
medalla(plata, velocidadMasculino, quickRick).
medalla(oro, velocidadMasculino, flash).

evento(futbolMasculino, faseDeGrupos, [argentina, espania, egipto, australia]).

evento(voleyMasculino, tercerPuesto, [argentina, brasil]).
evento(hockeyFemenino, final, [argentina, paisesBajos]).

evento(judo, octavosDeFinal, [pequePareto, marusaStangar]).
evento(judo, cuartosDeFinal, [pequePareto, funaTonaki]).
evento(natacion400MetrosFemenino, final, [bingjieLi, kathleenLedecky, ariarneTitmus]).

evento(velocidadMasculino, rondaUnica, [johnFast, quickRick, flash]).

%  ===============
%      Punto 2
%  ===============

vinoAPasear(Atleta) :-
    atleta(Atleta, _, _),
    not(compite(Atleta, _)).

%  ===============
%      Punto 3
%  ===============

medallasDelPais(Disciplina, Medalla, Pais) :-
    medalla(Medalla, Disciplina, Ganador),
    paisSegunDisciplina(Disciplina, Ganador, Pais).

% Relaciona al país según la disciplina.
% Si es individual, relaciona al país del atleta. Si es en equipo, relaciona al país.
paisSegunDisciplina(Disciplina, Ganador, Ganador) :-
    enEquipo(Disciplina).

paisSegunDisciplina(Disciplina, Ganador, Pais) :-
    individual(Disciplina),
    atleta(Ganador, _, Pais).

%  ===============
%      Punto 4
%  ===============

participoEn(AtletaOPais, Disciplina, Ronda) :-
    participanteSegunDisciplina(Disciplina, AtletaOPais, Participante),
    participaEnEvento(Participante, Disciplina, Ronda).

% Relaciona al participante según la disciplina.
% Si es individual, relaciona al atleta. Si es en equipo, relaciona al país del atleta.
participanteSegunDisciplina(Disciplina, AtletaOPais, AtletaOPais) :-
    individual(Disciplina).

participanteSegunDisciplina(Disciplina, AtletaOPais, Participante) :-
    enEquipo(Disciplina),
    atleta(AtletaOPais, _, Participante).

participaEnEvento(Participante, Disciplina, Ronda) :-
    evento(Disciplina, Ronda, Participantes),
    member(Participante, Participantes).

%  ===============
%      Punto 5
%  ===============

pais(Pais) :-
    distinct(atleta(_, _, Pais)).

dominio(Pais, Disciplina) :-
    pais(Pais),
    individual(Disciplina),
    forall(medalla(Medalla, Disciplina, _), medallasDelPais(Disciplina, Medalla, Pais)).

%  ===============
%      Punto 6
%  ===============

medallaRapida(Disciplina) :-
    evento(Disciplina, Ronda, _),
    not(tieneOtraRonda(Disciplina, Ronda)).

tieneOtraRonda(Disciplina, Ronda) :-
    evento(Disciplina, OtraRonda, _),
    Ronda \= OtraRonda.

%  ===============
%      Punto 7
%  ===============

disciplina(Disciplina) :-
    distinct(compite(_, Disciplina)).
    

noEsElFuerte(Pais, Disciplina) :-
    pais(Pais),
    disciplina(Disciplina),
    leFueMal(Pais, Disciplina).

leFueMal(Pais, Disciplina) :-
    not(participoEn(Pais, Disciplina, _)).

leFueMal(Pais, Disciplina) :-
    not(participoEnRondaNoInicial(Pais, Disciplina)).

participoEnRondaNoInicial(Pais, Disciplina) :-
    participoEn(Pais, Disciplina, Ronda),
    not(rondaInicialSegunDisciplina(Disciplina, Ronda)).

rondaInicialSegunDisciplina(Disciplina, faseDeGrupos) :-
    enEquipo(Disciplina).

rondaInicialSegunDisciplina(Disciplina, ronda1) :-
    individual(Disciplina).

%  ===============
%      Punto 8
%  ===============

medallasEfectivas(Pais, CuentaFinal) :-
    pais(Pais),
    findall(Valor, valorPorMedallaDePais(Pais, Valor), Valores),
    sumlist(Valores, CuentaFinal).

valorPorMedallaDePais(Pais, Valor) :-
    medallasDelPais(_, Medalla, Pais),
    valorMedalla(Medalla, Valor).

valorMedalla(oro, 3).
valorMedalla(plata, 2).
valorMedalla(bronce, 1).

%  ===============
%      Punto 9
%  ===============

laEspecialidad(Atleta) :-
    atleta(Atleta, _, _),
    not(vinoAPasear(Atleta)),
    forall(participoEn(Atleta, Disciplina, _), obtuvoMedallaOroOPlata(Atleta, Disciplina)).

obtuvoMedallaOroOPlata(Atleta, Disciplina) :-
    medalla(Medalla, Disciplina, Ganador),
    participanteSegunDisciplina(Disciplina, Atleta, Ganador),
    medallaDeOroODePlata(Medalla).

medallaDeOroODePlata(oro).
medallaDeOroODePlata(plata).