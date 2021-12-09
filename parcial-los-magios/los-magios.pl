% enunciado: https://docs.google.com/document/d/1cf4ebrJWsKBhb5wqJiEfnPoiqFKjQNSlHovY5Yo2Hj0/edit

persona(bart).
persona(larry).
persona(otto).
persona(marge).

% los magios son functores alMando(nombre, antiguedad), novato(nombre) y elElegido(nombre).
persona(alMando(burns,29)).
persona(alMando(clark,20)).
persona(novato(lenny)).
persona(novato(carl)).
persona(elElegido(homero)).

% hechos
hijo(homero,abbe).
hijo(bart,homero).
hijo(larry,burns).

salvo(carl,lenny).
salvo(homero,larry).
salvo(otto,burns).

%Los beneficios son funtores confort(descripcion), confort(descripcion, caracteristica), 
% dispersion(descripcion), economico(descripcion, monto).
gozaBeneficio(carl, confort(sillon)).
gozaBeneficio(lenny, confort(sillon)).
gozaBeneficio(lenny, confort(estacionamiento, techado)).
gozaBeneficio(carl, confort(estacionamiento, libre)).
gozaBeneficio(clark, confort(viajeSinTráfico)).
gozaBeneficio(clark, dispersion(fiestas)).
gozaBeneficio(burns, dispersion(fiestas)).
gozaBeneficio(lenny, economico(descuento, 500)).

% =============
%    Punto 1   
% =============

esMagio(Persona) :-
    persona(alMando(Persona, _)).
esMagio(Persona) :-
    persona(novato(Persona)).
esMagio(Persona) :-
    persona(elElegido(Persona)).

aspiranteMagio(Persona) :-
    hijo(Persona, Magio),
    esMagio(Magio).

aspiranteMagio(Persona) :-
    salvo(Persona, Magio),
    esMagio(Magio).

% =============
%    Punto 2   
% =============

puedeDarOrdenes(UnMagio, OtroMagio) :-
    persona(alMando(UnMagio, _)),
    magioInferior(UnMagio, OtroMagio).

magioInferior(_, Magio) :-
    persona(novato(Magio)).

magioInferior(UnMagio, OtroMagio) :-
    persona(alMando(UnMagio, Numero)),
    persona(alMando(OtroMagio, OtroNumero)),
    OtroNumero < Numero.

puedeDarOrdenes(UnMagio, OtroMagio) :-
    persona(elElegido(UnMagio)),
    esMagio(OtroMagio).

% =============
%    Punto 3   
% =============

sienteEnvidia(Persona, Envidiadas) :-
    findall(Envidiada, sienteEnvidiaPor(Persona, Envidiada), Envidiadas).
    
sienteEnvidiaPor(Persona, Envidiada) :-
    aspiranteMagio(Persona),
    esMagio(Envidiada).

sienteEnvidiaPor(Persona, Envidiada) :-
    persona(Persona),
    not(aspiranteMagio(Persona)),
    aspiranteMagio(Envidiada).

sienteEnvidiaPor(Persona, Envidiada) :-
    persona(novato(Persona)),
    persona(alMando(Envidiada, _)).

% =============
%    Punto 4   
% =============

masEnvidioso(Persona) :-
    cantidadDePersonasEnvidiadas(Persona, Cantidad),
    not(existeAlguienMasEnvidioso(Persona, Cantidad)).

existeAlguienMasEnvidioso(Persona, Cantidad) :-
    cantidadDePersonasEnvidiadas(OtraPersona, OtraCantidad),
    OtraPersona \= Persona,
    OtraCantidad > Cantidad.

cantidadDePersonasEnvidiadas(Persona, Cantidad) :-
    sienteEnvidia(Persona, PersonasEnvidiadas),
    length(PersonasEnvidiadas, Cantidad).

    