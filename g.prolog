:-dynamic(estado/1).
:-retractall(estado(_)).
%:-assert(estado([[-,-,-],
%                 [-,-,-],
%                 [-,x,-]])).
simbolo(1,x).
simbolo(2,o).
siguiente_turno(1,2).
siguiente_turno(2,1).

%-------------------------------------------- IMPRESION
imp_edo():-estado(Tablero),format('~n~t~8|   1    2    3  '),imprime(Tablero,1).
imprime([],_):-format('~n~t~8|  ------------- ~n').
imprime([[L1,L2,L3]|Resto],N):- format('~n~t~8|  -------------'),
                                format('~n~t~8|~w | ~w | ~w | ~w |',[N,L1,L2,L3]),
                                N2 is N+1,imprime(Resto,N2).

iniciar():- imp_edo(),
            nl,write('Digite en el formato Fila-Columna la posicion a jugar, seguido de un "." *ejemplo: 1-2. '),nl,
            read(X-Y),validar_y_reemplazar(X,Y).

validar_y_reemplazar(X,Y):- number(X),number(Y),X>0,X=<3,Y>0,Y=<3,
                            estado(Edo), nth1(X,Edo,Fila), nth1(Y,Fila,Elem), \+member(Elem,[x,o]),
                            reemplazar_elem(Y,x,Fila,FilaNUeva),
                            reemplazar_elem(X,FilaNUeva,Edo,NuevoEstado),
                            retractall(estado(_)),assert(estado(NuevoEstado)),
                            iniciar().
validar_y_reemplazar(_,_):- nl,write('Entrada invalida o espacio ocupado'),iniciar().

reemplazar_elem(1,Nuevo_Elem,[_|Resto],[Nuevo_Elem|Resto]).
reemplazar_elem(N,Nuevo_Elem,[I|Resto],[I|Resto1]):-N>0,N2 is N-1,reemplazar_elem(N2,Nuevo_Elem,Resto,Resto1).

%-------------------------------------------- JUGADAS
posibles_jugadas((Tablero,Jugador),(Jugadas,NuevoJugador)):-findall(Jugada,juego((Tablero,Jugador),Jugada),Jugadas),
                                                            siguiente_turno(Jugador,NuevoJugador).

juego((Tablero,Jugador),NuevoTablero):- append(Arriba,[Renglon|Abajo],Tablero),
                                        append(Izquierda,[-|Derecha],Renglon),
                                        simbolo(Jugador,Simbolo),
                                        append(Izquierda,[Simbolo|Derecha],NuevoRenglon),
                                        append(Arriba,[NuevoRenglon|Abajo],NuevoTablero).

%-------------------------------------------- CONDICIONES
evaluar(Tablero,Evaluacion):-estados(Tablero,Lista_estados),
                            contar_ventaja(Lista_estados,1,0,Opciones_perderoras),contar_ventaja(Lista_estados,2,0,Opciones_ganadoras),
                            Evaluacion is Opciones_ganadoras-Opciones_perderoras.

gano(Tablero,Jugador):- simbolo(Jugador,Simbolo), estados(Tablero,Lista_estados), member([Simbolo,Simbolo,Simbolo],Lista_estados).

empate(Tablero,Jugador):- \+(gano(Tablero,1)), \+(gano(Tablero,2)), posibles_jugadas((Tablero,Jugador),(Jugadas,_)), Jugadas=[].
          
contar_ventaja([],_,N,N).
contar_ventaja([Fila|Resto],Jugador,N,C):- simbolo(Jugador,Simbolo),
                                            ( (P=[-,-,-];permutation([Simbolo,-,-],P);permutation([Simbolo,Simbolo,-],P)), 
                                                P=Fila  ->  
                                                N2 is N+1,contar_ventaja(Resto,Jugador,N2,C)
                                                ;
                                                contar_ventaja(Resto,Jugador,N,C)
                                            ).

estados(Tablero,Lista_estados):-traspuesta(Tablero,Tras),length(Tablero,N),diagonales(Tablero,1,N,D1,D2),
                                append([Tablero,Tras,[D1],[D2]],Lista_estados).




%-------------------------------------------- ESTADOS
traspuesta([[]|_],[]).
traspuesta(M,[C|T]) :- separar(M,C,MT),traspuesta(MT,T).

separar([[X|F]|M],[X|C],[F|MT]) :- separar(M,C,MT).
separar([],[],[]).  

diagonales([],_,_,[],[]).
diagonales([Fila|Resto],N1,N2,[E1|R1],[E2|R2]):-nth1(N1,Fila,E1),nth1(N2,Fila,E2),
                                                N3 is N1+1,N4 is N2-1,
                                                diagonales(Resto,N3,N4,R1,R2).



