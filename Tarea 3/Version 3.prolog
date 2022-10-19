%=========================================================================
% Javier Martìnez Carranza  
%  
%   Tarea 3: Problemas tipo cebra...
%       Resolver en Prolog el problema recortado tipo cebra versión 3: 
%           4 casas, 4 atributos y 9 pistas.
%               1) Hay dos casas entre la del bolichista y la del nadador...
%               2) Hay una casa entre la del irlandés y la del que juega voleyball...
%               3) La segunda casa es negra...
%               4) Hay una casa entre la del dueño de caballos y la casa roja...
%               5) Un escocés vive junto al dueño de tortugas...
%               6) Hay dos casas entre la del dueño de caballos y la casa del dueño de mariposas...
%               7) El bolichista vive en algún lugar posterior a la casa del tenista...
%               8) Hay una casa entre la del que juega voleyball y la casa blanca...
%               9) Un ruso vive en la primera casa...
%
%   Predicados relevantes:
%       visualiza_vecindario(<Vecindario>).
%
%=========================================================================

%--------------- 
% visualiza_vecindario/1. Obtener todas las posibilidades del problema de la cebra recortado.
%     visualiza_vecindario(<Vecindario>).
%       
%       Explicación: Verdadero si <Vecindario> cumple todas las pistas del problema de la cebra.
%---------------
visualiza_vecindario(V):-	V=[_,_,_,_],
                            dos_casas(casa(_,_,_,bolichista),casa(_,_,_,nadador),V),
                            casa_intermedia(casa(_,"irlandés",_,_),casa(_,_,_,volleyball),V),
                            V=[_,casa(negra,_,_,_),_,_],
                            casa_intermedia(casa(_,_,caballos,_),casa(roja,_,_,_),V),
                            junto_a(casa(_,"escocés",_,_),casa(_,_,tortugas,_),V),
                            dos_casas(casa(_,_,caballos,_),casa(_,_,mariposas,_),V),
                            después_de(casa(_,_,_,bolichista),casa(_,_,_,tenista),V),
                            casa_intermedia(casa(_,_,_,volleyball),casa(blanca,_,_,_),V),
                            V=[casa(_,ruso,_,_),_,_,_].

%--------------- 
% junto_a/3. Verificar si una casa está junto a otra.
%     junto_a(<Casa 1>, <Casa 2>, <Vecindario>).
%       
%       Explicación: Verdadero si <Casa 1> y <Casa 2> se encuentran a un lado de la otra (sin importar cuál de 
%					las dos este antes o después) dentro de <Vecindario>.
%---------------
junto_a(Casa1,Casa2,Vecindario):-  append(_, [Casa1,Casa2|_], Vecindario).
junto_a(Casa1,Casa2,Vecindario):-  append(_, [Casa2,Casa1|_], Vecindario).

%--------------- 
% intermedia_a/3. Verificar si entre dos casas existe otra casa de diferencia.
%     intermedia_a(<Casa 1>, <Casa 2>, <Vecindario>).
%       
%       Explicación: Verdadero si existe una casa en medio de <Casa 1> y <Casa 2> (sin importar cuál de 
%					las dos este antes o después) dentro de <Vecindario>.
%---------------
casa_intermedia(Casa1,Casa2,Vecindario):-  append(_, [Casa1,_,Casa2|_], Vecindario).
casa_intermedia(Casa1,Casa2,Vecindario):-  append(_, [Casa2,_,Casa1|_], Vecindario).

%--------------- 
% dos_casas/3. Verificar si entre dos casas existen dos casas de diferencia.
%     dos_casas(<Casa 1>, <Casa 2>, <Vecindario>).
%       
%       Explicación: Verdadero si existen dos casas en medio de <Casa 1> y <Casa 2> (sin importar cuál de 
%					las dos este antes o después) dentro de <Vecindario>.
%---------------
dos_casas(Casa1,Casa2,Vecindario):-  append(_, [Casa1,_,_,Casa2|_], Vecindario).
dos_casas(Casa1,Casa2,Vecindario):-  append(_, [Casa2,_,_,Casa1|_], Vecindario).

%--------------- 
% después_de/3. Verificar si después de una casa existe otra dentro de un vecindario.
%     después_de(<Casa 1>, <Casa 2>, <Vecindario>).
%       
%       Explicación: Verdadero si <Casa 2> se encuentra en algun lugar despues de <Casa 1> dentro de <Vecindario>.
%---------------
después_de(Casa1,Casa2,Vecindario):-  append(_, [Casa1|Resto], Vecindario), member(Casa2,Resto).
