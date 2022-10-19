%=========================================================================
% Javier Martìnez Carranza  
%  
%   Tarea 1: Modelado de "manos" en Poker...
%       Modele  el  dominio Poker  en  una  base  de  conocimiento Prolog 
%       y  construya  un  programa  para generar  aleatoriamente "manos" de Poker, 
%       compararlas y ordenarlas descendentemente...
%
%   Predicados relevantes:
%       crear_una_mano(-Jugada,-Baraja_restante).
%
%=========================================================================

%---------------------------
% carta_figura/1.
% carta_figura(-Personaje-Palo).
%   Explicacion: Este predicado pide como parámetro dos variables en forma de pareja, 
%               con el cual podemos saber si una carta es de tipo de figura, también se 
%               usa para obtener todas las posibilidades de cartas de parejas que existan.
%-------------------
carta_figura(Personaje-Palo):-   member(Palo,['\u2660','\u2663','\u2665','\u2666']),
                                    member(Personaje,['A','J','Q','K']).


%---------------------------
% carta_numero/1.
% carta_numero(-Número-Palo).
%   Explicacion: Este predicado pide como parámetro dos variables en forma de pareja, 
%               con el cual podemos saber si una carta es de tipo de número, también se 
%               usa para obtener todas las posibilidades de cartas de parejas que existan.
%-------------------
carta_numero(Número-Palo):-     between(2,10,Número),
                                member(Palo,['\u2660','\u2663','\u2665','\u2666']).


%---------------------------
% carta/1.
% carta(-Carta).
%   Explicacion: Este predicado pide como parámetro una carta, esta puede ser cualquiera 
%               en todo el mazo y se verificara si pertenece a alguno de los dos grupos existentes 
%               (numérico o símbolos), también podemos obtener todas las posibilidades de cartas en una baraja.
%-------------------
carta(Carta):-  carta_numero(Carta) ;
                carta_figura(Carta).


%---------------------------
% crear_una_mano/2.
% carta(-Jugada,-Baraja_restante).
%   Explicacion: Este predicado tiene el fin de crear mazos de 5 cartas cada uno, obtenemos todas las 
%                cartas en el mazo, las barajamos y finalmente creamos una mano que se devuelve en el parámetro 
%                "Jugada" y el resto de la baraja se devuelve en el parámetro "Baraja_restante" por lo que ambas 
%                deben ser variables al momento de usar este predicado.
%                En principio se debe aplicar iteración para generar N mazos de cartas.
%-------------------
crear_una_mano(Jugada,Baraja_restante):-    findall(Cartas,carta(Cartas),Mazo),
                                            barajar(Mazo,Baraja_revuelta),
                                            length(Jugada,5),
                                            subtract(Baraja_revuelta,Jugada,Baraja_restante).


%---------------------------
% barajar/2.
% barajar(+Baraja1,-Baraja2).
%   Explicacion: Por medio de este predicado podemos barajar nuestra baraja, pedimos como parámetro de entrada
%                la baraja sin revolver y como salida obtenemos esa misma baraja revuelta para poder usarla en otros 
%                procesos como repartir cartas.
%-------------------
barajar(Baraja1,Baraja2):- random_permutation(Baraja1,Baraja2).

%---------------------------
% insertar_al_final/3.
% insertar_al_final(+Elemento,+Lista,-Lista_final).
%   Explicacion: Con este par de predicados tenemos una forma recursiva de agregar el Elemento deseado por el usuario
%                al final de la Lista y como resultado tendremos la Lista_Final.
%-------------------
insertar_al_final(X,[],[X]).
insertar_al_final(X,[H|T],[H|T2]):-insertar_al_final(X,T,T2).


%% Pruebas e intentos
repartir_mano():-   findall(Mazo,limit(5,findnsols(5,Cartas,carta(Cartas),Mazo)),Juegos),
                    write(Juegos).

listar(N,L):- findall(Cartas,carta(Cartas),Mazo),
                insertar_al_final(Mazo,[],Lista),
                append(Lista,[],L),
                listar(N,L).

/*carta_al_azar(Baraja,Jugada):- length(Jugada,N),
                                N=5.
carta_al_azar(Baraja,Jugada):-  length(Baraja,N),
                                N>=2,
                                random_between(1,N,Pos),
                                nth1(Pos,Baraja,Carta),
                                delete(Baraja,Carta,Baraja_res),
                                Carta1=[Carta],
                                append([],Carta1,Jugada),
                                carta_al_azar(Baraja_res,Jugada).*/
