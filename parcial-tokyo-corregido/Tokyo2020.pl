leGusta(romeo, julieta).

seGustan(UnaPersona, OtraPersona) :-
    leGusta(UnaPersona, OtraPersona).

seGustan(UnaPersona, OtraPersona) :-
    seGustan(OtraPersona, UnaPersona).

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

% medalla(medalla, disciplina, altetaOPais)
% atleta(nombre, edad, pais)

medallasDelPais(Disciplina, Medalla, Pais) :-
    medalla(Medalla, Disciplina, Ganador),
    paisGanadorSegunDisciplina(Disciplina, Ganador, Pais).

paisGanadorSegunDisciplina(Disciplina, Ganador, Ganador) :-
    enEquipo(Disciplina).

paisGanadorSegunDisciplina(Disciplina, Ganador, Pais) :-
    individual(Disciplina),
    atleta(Ganador, _, Pais).

%  ===============
%      Punto 4
%  ===============

participoEn(Atleta, Disciplina, Ronda) :-
    individual(Disciplina),
    compite(Atleta, Disciplina),
    participaEnEvento(Atleta, Disciplina, Ronda).

participoEn(Atleta, Disciplina, Ronda) :-
    enEquipo(Disciplina),
    compite(Atleta, Disciplina),
    atleta(Atleta, _, Pais),
    participaEnEvento(Pais, Disciplina, Ronda).

participaEnEvento(Participante, Disciplina, Ronda) :-
    evento(Disciplina, Ronda, Participantes),
    member(Participante, Participantes).

%  ===============
%      Punto 5
%  ===============

dominio(Pais, Disciplina) :-
    individual(Disciplina),
    medalla(_, Disciplina, Atleta),
    atleta(Atleta, _, Pais),
    forall(medalla(_, Disciplina, OtroAtleta), atleta(OtroAtleta, _, Pais)).

%  ===============
%      Punto 6
%  ===============

medallaRapida(Disciplina) :-
    evento(Disciplina, rondaUnica, _),
    seDefinieronMedallas(Disciplina).

seDefinieronMedallas(Disciplina) :-
    medalla(bronce, Disciplina, _),
    medalla(plata, Disciplina, _),
    medalla(oro, Disciplina, _).

%  ===============
%      Punto 7
%  ===============

noEsElFuerte(Pais, Disciplina) :-
    atleta(_, _, Pais),
    compite(_, Disciplina),
    forall(atleta(Atleta, _, Pais), noEsElFuerteAtleta(Atleta, Disciplina)).

noEsElFuerteAtleta(Atleta, Disciplina) :-
    not(participoEn(Atleta, Disciplina, _)).

noEsElFuerteAtleta(Atleta, Disciplina) :-
    rondaInicialSegunDisciplina(Disciplina, RondaInicial),
    participoEn(Atleta, Disciplina, RondaInicial),
    not(participoEnOtraRonda(Atleta, Disciplina, RondaInicial)).

participoEnOtraRonda(Atleta, Disciplina, Ronda) :-
    participoEn(Atleta, Disciplina, OtraRonda),
    OtraRonda \= Ronda.

rondaInicialSegunDisciplina(Disciplina, faseDeGrupos) :-
    enEquipo(Disciplina).

rondaInicialSegunDisciplina(Disciplina, 1) :-
    individual(Disciplina).

%  ===============
%      Punto 8
%  ===============

medallasEfectivas(Pais, CuentaFinal) :-
    medallasDelPais(_, _, Pais),
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
    enEquipo(Disciplina),
    atleta(Atleta, _, Pais),
    medallasDelPais(Disciplina, Medalla, Pais),
    medallaDeOroODePlata(Medalla).

obtuvoMedallaOroOPlata(Atleta, Disciplina) :-
    individual(Disciplina),
    medalla(Medalla, Disciplina, Atleta),
    medallaDeOroODePlata(Medalla).

medallaDeOroODePlata(oro).
medallaDeOroODePlata(plata).