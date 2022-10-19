%=========================================================================
% Javier Martìnez Carranza  
%  
%   Tarea 3: Problemas tipo cebra...
%       Resolver en Prolog el problema recortado tipo cebra versión 1:
%			Sólo 3 casas con 2 atributos y 3 pistas...
%				1) El español vive junto a la casa roja...
%				2) El noruego vive en la casa azul...
%				3) Un italiano vive en la segunda casa...		
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
visualiza_vecindario(V):-	V=[_,_,_], 
							junto_a(casa(_,"español"),casa(roja,_),V),
							member(casa(azul,noruego),V),
							V=[_,casa(_,italiano),_].

%--------------- 
% junto_a/3. Verificar si una casa está junto a otra.
%     junto_a(<Casa 1>, <Casa 2>, <Vecindario>).
%       
%       Explicación: Verdadero si <Casa 1> y <Casa 2> se encuentran a un lado de la otra (sin importar cuál de 
%					las dos este antes o después) dentro de <Vecindario>.
%---------------
junto_a(Casa1,Casa2,Vecindario):-  append(_, [Casa1,Casa2|_], Vecindario).
junto_a(Casa1,Casa2,Vecindario):-  append(_, [Casa2,Casa1|_], Vecindario).

