:-dynamic(lista/1).
:-retractall(lista(_)).
:-assert(lista([])).

%--------------- 
% alpha_beta/0. Elegir la mejor jugada con el algoritmo de min-max combinado con podas alpha-beta.
%     alpha_beta().
%       
%       Explicación: Verdadero se elige la jugada con mas ventaja hasta cierto horizonte. 
%---------------
alpha_beta():-retractall(lista(_)),assert(lista([])),
                tablero_global(Tablero), 
                ab_minimax(Tablero,2,3,-10000,10000,Evaluación),
                once((juego((Tablero,2),Jugada),lista(L),member(Jugada-Evaluación,L))),
                retractall(tablero_global(_)),assert(tablero_global(Jugada)).

%Casos en donde llegamos al limite de búsqueda y verificamos si el estado es ganador o empate, sino evaluamos.
ab_minimax( Tablero,_,0,_,_,Evaluación ):-( gano_Tgrande(Tablero,1) -> Evaluación is -100 ;
                                                    (gano_Tgrande(Tablero,2) -> Evaluación is 100; 
                                                            evaluar(Tablero,Evaluación)
                                                    )      
                                                ),guardar(Tablero-Evaluación).
%Casos en donde NO hemos llegado limite de búsqueda y verificamos si el estado es ganador o empate.
ab_minimax( Tablero,_,N,_,_,Evaluación ):- N>0, gano_Tgrande(Tablero,1), Evaluación is -100,guardar(Tablero-Evaluación).
ab_minimax( Tablero,_,N,_,_,Evaluación ):- N>0, gano_Tgrande(Tablero,2), Evaluación is 100,guardar(Tablero-Evaluación).
%ab_minimax( Tablero,Jugador,N,_,_,Evaluación ):- N>0, empate(Tablero,Jugador), Evaluación is 0,guardar(Tablero-Evaluación).

ab_minimax( Tablero,Jugador,N,Alpha,Beta,Evaluación):- N>0,Jugador=2,\+(gano(Tablero,1)),\+(gano(Tablero,2)),
                                                        posibles_jugadas((Tablero,Jugador),(Jugadas,NuevoJugador)), 
                                                        N2 is N-1, ab_max_children( Jugadas,NuevoJugador,N2,Alpha,Beta,-100,Evaluación),
                                                        guardar(Tablero-Evaluación).

ab_minimax( Tablero,Jugador,N,Alpha,Beta,Evaluación):- N>0,Jugador=1,\+(gano(Tablero,1)),\+(gano(Tablero,2)),
                                                        posibles_jugadas((Tablero,Jugador),(Jugadas,NuevoJugador)),
                                                        N2 is N-1, ab_min_children( Jugadas,NuevoJugador,N2,Alpha,Beta, 100,Evaluación),
                                                        guardar(Tablero-Evaluación).

ab_max_children( [],_ ,_ ,_ , _,Max,Max).
ab_max_children( [Child|Children],Jugador,N,Alpha,Beta,MaxO,Max):- ab_minimax( Child,Jugador,N,Alpha,Beta,Evaluación),
                                                                ( greater(Evaluación,Beta) -> 
                                                                    Max = Beta % Poda
                                                                    ; 
                                                                    ab_max( Evaluación, Alpha, AlphaO ), % Actualización de Alpha
                                                                    ab_max( Evaluación, MaxO, Max1 ),   % Actualización del valor máximo
                                                                    ab_max_children(Children,Jugador,N,AlphaO,Beta,Max1,Max) 
                                                                ).

ab_min_children( [],_ ,_ ,_ , _, Min,Min).
ab_min_children( [Child|Children],Jugador,N,Alpha,Beta,MinO,Min):- ab_minimax( Child,Jugador,N,Alpha,Beta,Evaluación),
                                                                ( greater( Alpha, Evaluación ) -> 
                                                                    Min = Alpha % Poda
                                                                    ; 
                                                                    ab_min( Evaluación, Beta, BetaO ), % Actualización de Beta
                                                                    ab_min( Evaluación, MinO, Min1 ),   % Actualización del valor mínimo
                                                                    ab_min_children( Children,Jugador,N,Alpha,BetaO,Min1,Min) 
                                                                ).

guardar(Estado-Val):-lista(L), append1(L,[Estado-Val],R),retractall(lista(_)),assert(lista(R)).

ab_max(X,Y,Z):- greater(Y,X),!,Z=Y.
ab_max(X,_,X).

ab_min(X,Y,Z):- greater(X,Y),!,Z=Y.
ab_min(X,_,X).

greater(_,-100).
greater(100,_).
greater(-100,_):- ! , fail.
greater(_,100):- !, fail.
greater(A,B) :- A > B.