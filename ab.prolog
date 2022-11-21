:-consult("g.prolog").

alpha_beta(Tablero,Jugador,Limite,Evaluacion):- once(ab_minimax(Tablero,Jugador,Limite,-100,100,Evaluacion)).

%Casos en donde llegamos al limite de busqueda y verificamos si el estado es ganador o empate o sino evaluamos
ab_minimax( Tablero,Jugador,0,_,_,Evaluacion ):-( gano(Tablero,1) -> Evaluacion is -15 ;
                                                    (gano(Tablero,2) -> Evaluacion is 15; 
                                                        empate(Tablero,Jugador) -> Evaluacion is 0 ;
                                                            evaluar(Tablero,Evaluacion)
                                                    )      
                                                ).

%Casos en donde NO hemos llegado limite de busqueda y verificamos si el estado es ganador o empate.
ab_minimax( Tablero,_,N,_,_,Evaluacion ):- N>0, gano(Tablero,1), Evaluacion is -15.
ab_minimax( Tablero,_,N,_,_,Evaluacion ):- N>0, gano(Tablero,2), Evaluacion is 15.
ab_minimax( Tablero,Jugador,N,_,_,Evaluacion ):- N>0, empate(Tablero,Jugador), Evaluacion is 0.

ab_minimax( Tablero,Jugador,N,Alpha,Beta,Evaluacion ):- N>0,Jugador=2,\+(gano(Tablero,1)),\+(gano(Tablero,2)),\+(empate(Tablero,Jugador)),
                                                        posibles_jugadas((Tablero,Jugador),(Jugadas,NuevoJugador)), 
                                                        N2 is N-1, ab_max_children( Jugadas, NuevoJugador, N2, Alpha, Beta, -100 ,Evaluacion ).

ab_minimax( Tablero,Jugador,N,Alpha,Beta,Evaluacion ):- N>0,Jugador=1,\+(gano(Tablero,1)),\+(gano(Tablero,2)),\+(empate(Tablero,Jugador)),
                                                        posibles_jugadas((Tablero,Jugador),(Jugadas,NuevoJugador)),
                                                        N2 is N-1, ab_min_children( Jugadas, NuevoJugador, N2, Alpha, Beta, 100,Evaluacion ).

ab_max_children( [],_ ,_ ,_ , _,Max,Max).
ab_max_children( [Child|Children],Jugador,N,Alpha,Beta,MaxO,Max ):- ab_minimax( Child,Jugador,N,Alpha,Beta,Evaluacion),
                                                                    ( greater(Evaluacion,Beta) -> 
                                                                        Max = Beta % Poda
                                                                        ; 
                                                                        ab_max( Evaluacion, Alpha, AlphaO ), % Actualizacion de Alpha
                                                                        ab_max( Evaluacion, MaxO, Max1 ),   % Actualizacion del valor maximo
                                                                        ab_max_children(Children, Jugador, N, AlphaO, Beta, Max1, Max ) 
                                                                    ).

ab_min_children( [],_ ,_ ,_ , _, Min,Min).
ab_min_children( [Child|Children],Jugador,N,Alpha,Beta,MinO,Min ):- ab_minimax( Child,Jugador,N,Alpha,Beta,Evaluacion ),
                                                                    ( greater( Alpha, Evaluacion ) -> 
                                                                        Min = Alpha % Poda
                                                                        ; 
                                                                        ab_min( Evaluacion, Beta, BetaO ), % Actualizacion de Beta
                                                                        ab_min( Evaluacion, MinO, Min1 ),   % Actualizacion del valor minimo
                                                                        ab_min_children( Children, Jugador, N, Alpha, BetaO, Min1, Min ) 
                                                                    ).

ab_max(X,Y,Z):- greater(Y,X),!,Z=Y.
ab_max(X,_,X).

ab_min(X,Y,Z):- greater(X,Y),!,Z=Y.
ab_min(X,_,X).

greater(_,-100).
greater(100,_).
greater(-100,_):- ! , fail.
greater(_,100):- !, fail.
greater(A,B) :- A > B.