%=========================================================================
% Javier Martínez Carranza  
%  
%   Tarea 6: Búsqueda informada con A*
%             - Construya un programa Prolog  para resolver el laberinto que se codifica en el archivo Laberinto.prolog...
%             - Debe usar 2 funciones de evaluación heurística para la aptitud, Distancia Manhattan  y  Distancia euclidiana,  así como algoritmo A*...
%   
%   Predicados relevantes:
%       busca_A_estrella(Estado_inicial, Estado_final, Plan)
%=========================================================================
:-consult("Laberinto.prolog").
:-use_module(library(clpfd)).

:-dynamic(edo_meta/1).

edo_meta([25,25]).
edo_inicial([1,1]).

%--------------- 
% inserta/4. Insertar dentro de la agenda nuevos sucesores dependiendo su aptitud.
%     inserta( +Sucesores,+Costo, Agenda, -Nueva_agenda).
%       
%       Explicación: Verdadero si <Nueva_agenda> es la union de <Agenda> y los <Sucesores> siempre y cuando estén ordenados por su aptitud.
%---------------
inserta([],_,Respuesta,Respuesta).
inserta([[Sucesor|Tray1]|Resto_Suc],C,[],R):- inserta(Resto_Suc,C,[[Sucesor|Tray1]],R).
inserta([[Sucesor|Tray1]|Resto_Suc],C,[[X|Tray2]|Resto_Front],R):- aptitud(Sucesor,C,Apt1),aptitud(X,C,Apt2), 
                                                                    Apt1 =< Apt2,
                                                                    inserta(Resto_Suc,C,[[Sucesor|Tray1],[X|Tray2]|Resto_Front],R).
inserta([[Sucesor|Tray1]|Resto_Suc],C,[[X|Tray2]|Resto_Front],R):- aptitud(Sucesor,C,Apt1),aptitud(X,C,Apt2), 
                                                                    Apt1 >= Apt2,
                                                                    inserta(Resto_Suc,C,[[X|Tray2],[Sucesor|Tray1]|Resto_Front],R).

%--------------- 
% aptitud/3. Obtener la aptitud de un sucesor con distancia Manhattan.
%     aptitud( +Sucesor, +Costo, -Aptitud).
%       
%       Explicación: Verdadero si <Aptitud> es la suma de la distancia Manhattan y el Costo.
%---------------
aptitud([X1,Y1], Costo, Aptitud):- edo_meta([X2,Y2]),
                                    Manha #= abs(X1-X2)+abs(Y1-Y2),
                                    Aptitud is Manha+Costo,!.
                                    
%--------------- 
% busca_A_estrella/3. Realizar búsqueda informada con A*.
%     busca_A_estrella(+Estado_inicial, +Estado_final, -Plan)
%       
%       Explicación: Verdadero si <Plan> es una solución valida para llegar del <Estado_inicial> a <Estado_final>.
%---------------
busca_A_estrella(Edo_inicial, Edo_final, Plan):- retractall(edo_meta(_)),
                                                assert(edo_meta(Edo_final)),
                                                a_estrella([[Edo_inicial]],0,Plan),
                                                reverse(Plan,Plan1),
                                                print_term(Plan1,[]).
                                                
a_estrella([[Estado|Resto]|_],_,[Estado|Resto]):- edo_meta(Estado).
a_estrella([Candidato|Frontera],Costo,Plan):- sucesores(Candidato,S),
                                                %filtra(S,Costo,Succ),
                                                inserta(S,Costo,Frontera,NuevaAgenda),
                                                Costo1 #= Costo+1,
                                                a_estrella(NuevaAgenda,Costo1,Plan).

%--------------- 
% sucesores/2. Obtener los posibles sucesores de un estado y añadirlo a la ruta actual.
%     sucesores( +Ruta, -Sucesores).
%       
%       Explicación: Verdadero si <Sucesores> es una lista de sucesores de un estado con la su <Ruta>.
%---------------
sucesores([Estado|Resto],Sucesores):- acceso(Estado,S),
                                        juntar(S,[Estado|Resto],Sucesores).

%--------------- 
% juntar/3. Juntar los sucesores de una ruta con su ruta y filtrar los sucesores que ya existen en la ruta.
%     juntar( +Sucesores, +Ruta, -Sucesores_ruta).
%       
%       Explicación: Verdadero si <Sucesores_ruta> contiene la union de cada uno de los <Sucesores> con la <Ruta>.
%---------------                               
juntar([],_,[]).
juntar([S|Sucesores],[Estado|Resto],[Res|Resto2]):- \+member(S,[Estado|Resto]),
                                                    Res=[S,Estado|Resto],
                                                    juntar(Sucesores,[Estado|Resto],Resto2).

juntar([S|Sucesores],[Estado|Resto],Sucesores_validos):- member(S,[Estado|Resto]), 
                                                        juntar(Sucesores,[Estado|Resto],Sucesores_validos).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%filtra(Sucesores,Costo,Mejor):-  descarta(Sucesores,Costo,Lista),
%                                    max_list(Lista,Min),
%                                    nth1(Index,Lista,Min),
%                                    nth1(Index,Sucesores,Mejor).                                   
%escarta([],_,[]):-!.
%escarta([[Sucesor|_]|Resto],Costo,[Apt|Resto2]):- aptitud(Sucesor,Costo,Apt),descarta(Resto,Costo,Resto2).



