%=========================================================================
% Javier Martínez Carranza  
%  
%   Proyecto Final: Construya un agente Prolog para jugar Gato 4x4 contra un oponente humano.
%        - Programe en Prolog un agente jugador para uno de los tres juegos descritos en la presentación #27 Proyecto Final...
%        - El agente jugador debe usar algoritmo MiniMax/NegaMax, Podas Alfa-Beta  y  cuando menos una  heurística  
%           auxiliar,  que  puede  ser alguna de las clásicas o una de su propia invención.
%        - Ponga especial cuidado en la interfaz con el usuario.
%        - Este programa se deberá desarrollar  PARA CONSOLA Swipl,  NO USE  SWISH...
%   
%   Predicados relevantes:
%       inicia_juego().
%   
%   Modo de compilar: Consultar el archivo "Agente_jugador.prolog".
%=========================================================================

:-consult("Impresiones.prolog").
:-consult("ab.prolog").

:-dynamic(mov/1).
:-retractall(mov(_)).
:-assert(mov([[],[],[]]-0-0)).
:-dynamic(lista/1).
:-retractall(lista(_)).
:-assert(lista([])).
:-dynamic(tablero_global/1).
:-retractall(tablero_global(_)).
:-assert(tablero_global([  [[[-,-,-],[-,-,-],[-,-,-]]-(-),[[-,-,-],[-,-,-],[-,-,-]]-(-),[[-,-,-],[-,-,-],[-,-,-]]-(-)],
                           [[[-,-,-],[-,-,-],[-,-,-]]-(-),[[-,-,-],[-,-,-],[-,-,-]]-(-),[[-,-,-],[-,-,-],[-,-,-]]-(-)],
                           [[[-,-,-],[-,-,-],[-,-,-]]-(-),[[-,-,-],[-,-,-],[-,-,-]]-(-),[[-,-,-],[-,-,-],[-,-,-]]-(-)]
                        ])).

símbolo(1,x).
símbolo(2,o).
siguiente_turno(1,2).
siguiente_turno(2,1).

%--------------- 
% obtener_tablero/2. Obtener el tablero en una coordenada especifica.
%     obtener_tablero(+Fila-Columna,-Tablero-Ganador).
%       
%       Explicación: Verdadero si <Tablero-Ganador>  es el tablero chico que se encuentra en la Fila y Columna del tablero grande.
%---------------
obtener_tablero(Fila-Columna,Tablero-W):-tablero_global(Tab_Global),nth1(Fila,Tab_Global,Renglon),nth1(Columna,Renglon,Tablero-W).

%--------------- 
% posibles_tableros/1. Obtener los tableros en los cuales no haya ganado ningún jugador o empatado.
%     posibles_tableros(+Tableros).
%       
%       Explicación: Verdadero si <Tableros>  es una lista de tableros que aun no han sido ganados o empatados.
%---------------
posibles_tableros(Tableros):- findall(T-(F,C),indices_tab(F,C,T),Tableros).
indices_tab(F,C,T):- tablero_global(Tablero),nth1(F,Tablero,Elem),nth1(C,Elem,T-('-')).

%--------------- 
% estados_Tchico/2. Obtener los estados de un tablero chico.
%     estados_Tchico(+Tablero,-ListaEstados).
%       
%       Explicación: Verdadero si <ListaEstados> es una lista con los estados del Tablero. Con estados nos referimos a
%                    filas,columnas y diagonales del tablero en cuestión.    
%---------------
estados_Tchico(Tablero,Lista_estados):-Tablero=[[A,B,C],[D,E,F],[G,H,I]], 
                                       Lista_estados=[[A,B,C],[D,E,F],[G,H,I],[A,E,I],[C,E,G],[A,D,G],[B,E,H],[C,F,I]].
%--------------- 
% estados_Tgrande/2. Obtener los estados del tablero general.
%     estados_Tgrande(+Tablero,-ListaEstados).
%       
%       Explicación: Verdadero si <ListaEstados> es una lista con los estados del Tablero general. Con estados nos referimos a
%                    filas,columnas y diagonales del tablero en cuestión.    
%---------------
estados_Tgrande(Tablero,Lista_estados):-Tablero=[[_-(A),_-(B),_-(C)],[_-(D),_-(E),_-(F)],[_-(G),_-(H),_-(I)]],
                                          Lista_estados=[[A,B,C],[D,E,F],[G,H,I],[A,E,I],[C,E,G],[A,D,G],[B,E,H],[C,F,I]].

%--------------- 
% evaluar/2. Obtener la evaluación de un tablero global.
%     evaluar(+TableroGlobal,-Evaluación).
%       
%       Explicación: Verdadero si <Evaluación> son las filas,columnas y diagonales en las cuales tenemos o 
%                    podríamos tener ventaja menos en las que el otro jugador tiene ventaja en cada uno de los tableros
%                    pequeños y en el tablero grande.  
%                     
%        Ventaja_maquina = posiciones_ganadoras_maquina - posiciones_ganadoras_humano.
%---------------
evaluar(TableroGlob,Evaluación):-evaluar_tab_glob(TableroGlob,0,Evaluación1),estados_Tgrande(TableroGlob,EstadosGlob),
                                 contar_ventaja(EstadosGlob,1,0,Op_perdedoras),
                                 contar_ventaja(EstadosGlob,2,0,Op_ganadoras),
                                 Evaluación is Evaluación1+Op_ganadoras-Op_perdedoras.

evaluar_tab_glob([],Res,Res):-!.  
evaluar_tab_glob([[A-N1,B-N2,C-N3]|Resto],N,Res):-evaluar_tab(A-N1,E1),evaluar_tab(B-N2,E2),evaluar_tab(C-N3,E3),
                                                   Nsig is N+E1+E2+E3,evaluar_tab_glob(Resto,Nsig,Res).  

evaluar_tab(Tablero-N,Evaluación):-( N='-' -> estados_Tchico(Tablero,Lista_estados),
                                    contar_ventaja(Lista_estados,1,0,Opciones_perdedoras),
                                    contar_ventaja(Lista_estados,2,0,Opciones_ganadoras),
                                    Evaluación is Opciones_ganadoras-Opciones_perdedoras 
                                    ; 
                                    ( N=o -> Evaluación is 15 ; 
                                       (N=x -> Evaluación is -15 ;
                                          N='/' -> Evaluación is 0 ; false
                                       ) 
                                    )  
                              ).
                              
contar_ventaja([],_,N,N).
contar_ventaja([Fila|Resto],Jugador,N,C):- símbolo(Jugador,Símbolo),
                                            ( (P=[-,-,-];permutation([Símbolo,-,-],P);permutation([Símbolo,Símbolo,-],P)), P=Fila ->  
                                                N2 is N+1,contar_ventaja(Resto,Jugador,N2,C)  ;  contar_ventaja(Resto,Jugador,N,C)
                                            ).
%--------------- 
% gano_Tchico/2. Saber si un jugador gano en un tablero chico.
%     gano_Tchico(+Tablero,+Jugador).
%       
%       Explicación: Verdadero si el <Jugador> gano en el <Tablero> chico.  
%---------------
gano_Tchico(Tablero,Jugador):-símbolo(Jugador,Símbolo), estados_Tchico(Tablero,Lista_estados), 
                              member([Símbolo,Símbolo,Símbolo],Lista_estados).
%--------------- 
% gano_Tgrande/2. Saber si un jugador gano en el tablero general.
%     gano_Tgrande(+Tablero,+Jugador).
%       
%       Explicación: Verdadero si el <Jugador> gano en el <Tablero> general.  
%---------------
gano_Tgrande(TableroGlob,Jugador):-símbolo(Jugador,Símbolo), estados_Tgrande(TableroGlob,Lista_estados), 
                                    member([Símbolo,Símbolo,Símbolo],Lista_estados).
%--------------- 
% empate_Tchico/2. Saber si un jugador empato en un tablero chico.
%     empate_Tchico(+Tablero,+Jugador).
%       
%       Explicación: Verdadero si el <Jugador> no gano y ya no tiene mas movimientos en el <Tablero> chico.  
%---------------
empate_Tchico(Tablero,Jugador):- \+(gano_Tchico(Tablero,1)), \+(gano_Tchico(Tablero,2)), posibles_jugadas(Tablero,Jugador,Jugadas,_),Jugadas=[].
%--------------- 
% empate_Tgrande/2. Saber si un jugador empato en el tablero grande.
%     empate_Tgrande(+Tablero,+Jugador).
%       
%       Explicación: Verdadero si el <Jugador> no gano y ya no tiene mas movimientos en el <Tablero> general.  
%---------------
empate_Tgrande(Tablero,Jugador):- \+(gano_Tgrande(Tablero,1)), \+(gano_Tgrande(Tablero,2)),
                                 posibles_jugadas(Tablero,Jugador,Jugadas,_),Jugadas=[].

%--------------- 
% inicia_juego/0. Iniciar un juego.
%     inicia_juego().
%       
%       Explicación: Verdadero si se inicia un juego contra la maquina.  
%---------------
inicia_juego():- write('seleccione en que tablero deseea jugar'),nl,impresion_elegir_tablero(),nl,
            nl,nl,write(' --> Para seleccionar un tablero, hágalo de la forma fila-columna.'),
            ansi_format([bold,fg(blue)],' Ejemplo: 2-3. ~n',[]),read(Fila-Columna),validar_jugada_grande(Fila-Columna).

%--------------- 
% validar_jugada_grande/2. Validar que un tablero en el que se desea jugar ya ha sido ganado por alguien o empatado, si esto no ocurre
%                 se jugara en el tablero y se imprimirá en pantalla el resultado.
%     validar_jugada_grande(Fila-Columna).
%---------------
validar_jugada_grande(NFila-NColumna):-sleep(1),tablero_global(TableroGlob),
                                       nth1(NFila, TableroGlob, F1),
                                       nth1(NColumna, F1, NTablero-N),
                                       ((N\=x,N\=o,N\='/') -> 
                                          imp_tablero_global_juego(NFila,NColumna),
                                          jugar_en_tablero(NTablero),
                                          mov(TableroNuevo-Fila-Columna),
                                          ( gano_Tchico(TableroNuevo,1) -> N1=x ; N1=N),                                          
                                          reemplazar_elem(NColumna,TableroNuevo-N1,F1,FilaNueva),
                                          reemplazar_elem(NFila,FilaNueva,TableroGlob,NuevoTableroGlob),
                                          estado_global(NuevoTableroGlob),
                                          validar_jugada_grande(Fila-Columna)
                                          ; 
                                          nl,write('       *** En ese tablero ya se ha ganado o empatado, '),inicia_juego()
                                       ).
%--------------- 
% jugar_en_tablero/1. Validar que la posición dentro del tablero chico en donde se desea jugar este libre.
%     jugar_en_tablero(+Tablero).
%
%        Explicación: Verdadero el usuario elige una coordenada que no tenga ningún elemento anteriormente.
%---------------
jugar_en_tablero(Tablero):- read(Fila-Columna),
                           (validar_jugada_chico(Fila-Columna,Tablero,NuevoTabChico) -> 
                                 ultimo_mov(NuevoTabChico-Fila-Columna)  
                              ;
                                 write('La posición esta ocupada'),nl,jugar_en_tablero(Tablero)
                           ).             

validar_jugada_chico(Fila-Columna,Tablero,NuevoTablero):-Fila>0, Columna>0,Fila=<3,Columna=<3,
                                                         nth1(Fila,Tablero,F1), nth1(Columna,F1,Elem), Elem\=x,Elem\=o,
                                                         reemplazar_elem(Columna,x,F1,FilaNueva),
                                                         reemplazar_elem(Fila,FilaNueva,Tablero,NuevoTablero).

%--------------- 
% reemplazar_elem/4. Reemplazar un elemento en un indice de cierta lista.
%     reemplazar_elem(+Indice,+Elemento,+Lista,-Lista_Final).
%
%        Explicación: Verdadero si se cambia en la posición <Index> dentro de <Lista> el <Elemento> y como resultado nos 
%                       queda una <Lista_final>.
%---------------
reemplazar_elem(1,Nuevo_Elem,[_|Resto],[Nuevo_Elem|Resto]):-!.
reemplazar_elem(N,Nuevo_Elem,[I|Resto],[I|Resto1]):-N>0,N2 is N-1,reemplazar_elem(N2,Nuevo_Elem,Resto,Resto1).

ultimo_mov(Tablero-Fila-Columna):- retractall(mov(_)),assert(mov(Tablero-Fila-Columna)).
estado_global(Tablero):- retractall(tablero_global(_)),assert(tablero_global(Tablero)).

%--------------- 
% posibles_jugadas/4. Obtener las posibles jugadas dentro de un tablero, y las coordenadas de esa jugada.
%     posibles_jugadas(+Tablero,+Jugador,-Nuevo_jugador,-Jugadas).
%
%        Explicación: Verdadero si <Jugadas> es una lista con ls jugadas que puede hacer el <Jugador> dentro del <Tablero>.
%---------------
posibles_jugadas(Tablero,Jugador,NuevoJugador,Jugadas):- símbolo(Jugador,Sim),siguiente_turno(Jugador,NuevoJugador),
                                                         findall(Res-(I-N),indices(Tablero,Sim,I,N,Res),Jugadas),print_term(Jugadas,[]).

indices(Lista,Jugador,I,N,Res):- nth1(I,Lista,Elem),nth1(N,Elem,-),reemplazar_elem(N,Jugador,Elem,NuevElem),reemplazar_elem(I,NuevElem,Lista,Res).
