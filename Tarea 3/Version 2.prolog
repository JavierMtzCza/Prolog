%=========================================================================
% Javier Martìnez Carranza  
%  
%   Tarea 3: Problemas tipo cebra...
%       Resolver en Prolog el problema recortado tipo cebra versión 2: 
%           3 casas, 4 atributos y 6 pistas.
%                1) El brasileño NO vive en la segunda casa...
%                2) El dueño de perros juega baloncesto...
%                3) Hay una casa intermedia entre la del que juega fútbol y la casa roja...
%                4) El dueño de peces vive junto al dueño de gatos...
%                5) El dueño de perros vive junto a la casa verde...
%                6) Un alemán vive en la tercera casa...	
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
vecindario(V):-	V=[_,_,_],
                (V=[casa(_,"brasileño",_,_),_,_];V=[_,_,casa(_,"brasileño",_,_)]),
				member(casa(_,_,perros,baloncesto),V),
                intermedia_a(casa(_,_,_,"fútbol"),casa(roja,_,_,_),V),
                junto_a(casa(_,_,peces,_),casa(_,_,gatos,_),V),
                junto_a(casa(_,_,perros,_),casa(verde,_,_,_),V),
                V=[_,_,casa(_,"alemán",_,_)].
				
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
% intermedia_a/3. Verificar si dentro de dos casas existe otra casa de diferencia.
%     intermedia_a(<Casa 1>, <Casa 2>, <Vecindario>).
%       
%       Explicación: Verdadero si existe una casa en medio de <Casa 1> y <Casa 2> (sin importar cuál de 
%					las dos este antes o después) dentro de <Vecindario>.
%---------------
intermedia_a(Casa1,Casa2,Vecindario):-  append(_, [Casa1,_,Casa2|_], Vecindario).
intermedia_a(Casa1,Casa2,Vecindario):-  append(_, [Casa2,_,Casa1|_], Vecindario).