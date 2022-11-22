%=========================================================================
% Javier Martínez Carranza  
%  
%   Tarea 7: Construya un agente Prolog para jugar Gato 4x4 contra un oponente humano.
%   
%   Predicados relevantes:
%       inicia_juego(Horizonte).
%               Forma de uso:   iniciar_juego(1) media posibilidad de ganar
%                               iniciar_juego(2) baja posibilidad de ganar
%                               iniciar_juego(3) casi nula posibilidad de ganar
%               NO se recomienda un horizonte mas grande, de lo contrario tardaría mas y consumiría mas recursos.
%=========================================================================
%----
:-dynamic(tablero_global/1).
:-retractall(tablero_global(_)).
:-assert(tablero_global([[-,-,-,-],[-,-,-,-],[-,-,-,-],[-,-,-,-]])).
%----
:-dynamic(horizonte/1).
:-retractall(horizonte(_)).
:-assert(horizonte(1)).

símbolo(1,x).
símbolo(2,o).
siguiente_turno(1,2).
siguiente_turno(2,1).

%--------------- 
% iniciar_juego/1. Iniciar un juego con la maquina con cierto horizonte.
%     iniciar_juego(+Horizonte).
%       
%       Explicación: Verdadero si se inicia un juego con la maquina hasta que alguno de los dos gane o se llegue a un empate.
%       Forma de uso:   iniciar_juego(1) media posibilidad de ganar
%                       iniciar_juego(2) baja posibilidad de ganar
%                       iniciar_juego(3) casi nula posibilidad de ganar
%       NO se recomienda un horizonte mas grande, de lo contrario tardaría mas y consumiría mas recursos.
%---------------
iniciar_juego(Horizonte):- retractall(tablero_global(_)),assert(tablero_global([[-,-,-,-],[-,-,-,-],[-,-,-,-],[-,-,-,-]])),
                        retractall(horizonte(_)),assert(horizonte(Horizonte)),jugando().
%--------------- 
% posibles_jugadas/4. Obtener las jugadas posibles de un jugador con el tablero actual.
%     posibles_jugadas((+Tablero,+Jugador),(-Jugadas,-NuevoJugador)).
%       
%       Explicación: Verdadero si <Jugadas> son las jugadas posibles del <Jugador> y verdadero si <NuevoJugador> es 
%                   el jugador del siguiente turno. 
%---------------
posibles_jugadas((Tablero,Jugador),(Jugadas,NuevoJugador)):-findall(Jugada,juego((Tablero,Jugador),Jugada),Jugadas),
                                                            siguiente_turno(Jugador,NuevoJugador).

juego((Tablero,Jugador),NuevoTablero):- append(Arriba,[Renglón|Abajo],Tablero),
                                        append(Izquierda,[-|Derecha],Renglón),
                                        símbolo(Jugador,Símbolo),
                                        append(Izquierda,[Símbolo|Derecha],NuevoRenglón),
                                        append(Arriba,[NuevoRenglón|Abajo],NuevoTablero).
%--------------- 
% evaluar/2. Evaluar el estado actual del tablero con respecto a la ventaja que tiene la maquina sobre el jugador.
%     evaluar(+Tablero,-Evaluación).
%       
%       Explicación: Verdadero si <Evaluación> es la ventaja que tiene la maquina sobre el jugador humano, de forma que 
%                   Ventaja_maquina = posiciones_ganadoras_maquina - posiciones_ganadoras_humano 
%---------------
evaluar(Tablero,Evaluación):-estados(Tablero,Lista_estados),
                            contar_ventaja(Lista_estados,1,0,Opciones_perdedoras),contar_ventaja(Lista_estados,2,0,Opciones_ganadoras),
                            Evaluación is Opciones_ganadoras-Opciones_perdedoras.
%--------------- 
% gano/2. Saber si un jugador gano el juego.
%     gano(+Tablero,+Jugador).
%       
%       Explicación: Verdadero si <Jugador> gano en el <Tablero> actual.
%---------------
gano(Tablero,Jugador):- símbolo(Jugador,Símbolo), estados(Tablero,Lista_estados), 
                        member([Símbolo,Símbolo,Símbolo,Símbolo],Lista_estados).
%--------------- 
% empate/2. Saber si el juego se ha empatado.
%     empate(+Tablero,+Jugador).
%       
%       Explicación: Verdadero si no gano ni la maquina ni el humano y el <Jugador> ya no tiene mas movimientos en el <Tablero>.
%---------------
empate(Tablero,Jugador):- \+(gano(Tablero,1)), \+(gano(Tablero,2)), posibles_jugadas((Tablero,Jugador),(Jugadas,_)), Jugadas=[].

/* 
contar_ventaja/4. Obtener el numero de posiciones ganadoras para un jugador.
    contar_ventaja(+Estados,+Jugador,+N,-Opciones_ganadoras).
      
    Explicación: Verdadero si <Opciones_ganadoras> es el numero de filas, columnas y diagonales en las cuales todavía 
                le es posible ganar al <Jugador>.
    Forma de uso: contar_ventaja(Lista_estados,Jugador,0,Opciones_perdedoras)
*/    
contar_ventaja([],_,N,N).
contar_ventaja([Fila|Resto],Jugador,N,C):- símbolo(Jugador,Símbolo),
                                            ( (P=[-,-,-,-];permutation([Símbolo,-,-,-],P);permutation([Símbolo,Símbolo,-,-],P);permutation([Símbolo,Símbolo,Símbolo,-],P)), 
                                                P=Fila  ->  
                                                N2 is N+1,contar_ventaja(Resto,Jugador,N2,C)
                                                ;
                                                contar_ventaja(Resto,Jugador,N,C)
                                            ).
/* 
estados/2. Obtener las filas, columnas y diagonales de un tablero.
    traspuesta( +Tablero,-Estados).
      
    Explicación: Verdadero si <Estados> es una lista de las filas, columnas y diagonales de <Tablero>.
*/
estados(Tablero,Lista_estados):-traspuesta(Tablero,Tras),diagonales(Tablero,1,4,D1,D2),
                                append([Tablero,Tras,[D1],[D2]],Lista_estados).
/* 
traspuesta/2. Obtener la traspuesta de un tablero.
    traspuesta( +Tablero,-Traspuesta).
      
    Explicación: Verdadero si <Traspuesta> es la traspuesta de <Tablero>.
*/
traspuesta([[]|_],[]).
traspuesta(M,[C|T]) :- separar(M,C,MT),traspuesta(MT,T).

separar([[X|F]|M],[X|C],[F|MT]) :- separar(M,C,MT).
separar([],[],[]).  
/* 
diagonales/5. Obtener las diagonales del tablero.
    diagonales( +Tablero,+Inidice1,+Inidice2,-Diagonal1,-Diagonal2).
      
    Explicación: Verdadero si <Diagonal1> y <Diagonal2> son las diagonales de <Tablero>.
    Forma de uso: diagonales(Tablero,1,4,D1,D2).
*/
diagonales([],_,_,[],[]).
diagonales([Fila|Resto],N1,N2,[E1|R1],[E2|R2]):-nth1(N1,Fila,E1),nth1(N2,Fila,E2),N3 is N1+1,N4 is N2-1,diagonales(Resto,N3,N4,R1,R2).

%--------------- 
% jugando/0. Ciclo de juego, comprobación de empate o maquina ganadora.
%     jugando().
%       
%       Explicación: Verdadero si sigue el ciclo de juego hasta que alguno de los dos gane o queden empate.
%---------------
jugando():- tablero_global(Tablero), \+gano(Tablero,2),\+empate(Tablero,1),imp_edo(),
            nl,write('Digite en el formato Columna-Fila la posición a jugar, seguido de un "." -ejemplo: 1-2. '),nl,
            read(X-Y),validar_y_reemplazar(X,Y).

jugando():- tablero_global(Tablero),\+empate(Tablero,1),gano(Tablero,2),imp_edo(),
            nl,write('      -----GANO LA MAQUINA :(-----  '),nl.

jugando():- tablero_global(Tablero),empate(Tablero,1),imp_edo(),
            nl,write('      . . . EMPATE :) . . .  '),nl.
%--------------- 
% validar_y_reemplazar/2. Verificar que la casilla seleccionada por el usuario este disponible y obtener el nuevo estado.
%     validar_y_reemplazar(X,Y).
%       
%       Explicación: Verdadero si X y Y representan un espacio vació en el tablero o el jugador humano gana.
%---------------
validar_y_reemplazar(X,Y):- number(X),number(Y),X>0,X=<4,Y>0,Y=<4,
                            tablero_global(Tablero), nth1(Y,Tablero,Fila), nth1(X,Fila,Elem), \+member(Elem,[x,o]),
                            reemplazar_elem(X,x,Fila,FilaNueva),
                            reemplazar_elem(Y,FilaNueva,Tablero,NuevoTablero),
                            \+gano(NuevoTablero,1),
                            retractall(tablero_global(_)),assert(tablero_global(NuevoTablero)),
                            format('  Tu jugada es : ~n',[]),
                            imp_edo(),
                            sleep(3),
                            alpha_beta(),
                            format('    ~n--> La jugada de la maquina es : ~n',[]),
                            jugando().
validar_y_reemplazar(X,Y):- number(X),number(Y),X>0,X=<4,Y>0,Y=<4,
                            tablero_global(Tablero), nth1(Y,Tablero,Fila), nth1(X,Fila,Elem), \+member(Elem,[x,o]),
                            reemplazar_elem(X,x,Fila,FilaNueva),
                            reemplazar_elem(Y,FilaNueva,Tablero,NuevoTablero),
                            gano(NuevoTablero,1),
                            retractall(tablero_global(_)),assert(tablero_global(NuevoTablero)),
                            format('  Tu jugada es : ~n',[]),
                            imp_edo(),
                            format('  -----GANASTE!!----- ',[]).
validar_y_reemplazar(_,_):- nl,write('  ### Entrada invalida o espacio ocupado, vuelve a tirar ###'),jugando().

reemplazar_elem(1,Nuevo_Elem,[_|Resto],[Nuevo_Elem|Resto]).
reemplazar_elem(N,Nuevo_Elem,[I|Resto],[I|Resto1]):-N>0,N2 is N-1,reemplazar_elem(N2,Nuevo_Elem,Resto,Resto1).

%--------------- 
% imp_edo/0. Imprimir estado global.
%     imp_edo().
%       
%       Explicación: Verdadero si se imprime en pantalla el estado global.
%---------------
imp_edo():-tablero_global(Tablero),format('~n~t~8|    1   2   3   4  '),imprime(Tablero,1).
imprime([],_):-format('~n~t~8|  ----------------- ~n').
imprime([[L1,L2,L3,L4]|Resto],N):-  format('~n~t~8|  -----------------'),
                                    format('~n~t~8|~w | ~w | ~w | ~w | ~w |',[N,L1,L2,L3,L4]),
                                    N2 is N+1,imprime(Resto,N2).