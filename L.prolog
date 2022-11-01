
meta([0,0,3,3,d]).
inicial([3,3,0,0,d]).

edo_valido([Mis1,Can1,Mis2,Can2]):- Mis1 >= 0, Can1 >=0,
                                    Mis2 >= 0, Can2 >=0,
                                    (Mis1 >= Can1 ; Mis1 is 0),
                                    (Mis2 >= Can2 ; Mis2 is 0).

movimiento([MO,CO,MD,Cd,L1],[MO2,CO2,MD2,Cd2,L2]-Res):-
    (
        % UN MISIONERO
        (MO2 is MO-1, CO2 is CO, MD2 is MD+1, Cd2 is Cd, L1=o,L2=d,Res="1 Misionero hacia destino");
        (MO2 is MO+1, CO2 is CO, MD2 is MD-1, Cd2 is Cd, L1=d,L2=o,Res="1 Misionero hacia origen");
        % DOS MISIONEROS
        (MO2 is MO-2, CO2 is CO, MD2 is MD+2, Cd2 is Cd, L1=o,L2=d,Res="2 Misioneros hacia destino");
        (MO2 is MO+2, CO2 is CO, MD2 is MD-2, Cd2 is Cd, L1=d,L2=o,Res="2 Misioneros hacia origen");
        % MISIONERO Y CANIBAL
        (MO2 is MO-1, CO2 is CO-1, MD2 is MD+1, Cd2 is Cd+1, L1=o,L2=d,Res="Misionero y canibal hacia destino");
        (MO2 is MO+1, CO2 is CO+1, MD2 is MD-1, Cd2 is Cd-1, L1=d,L2=o,Res="Misionero y canibal hacia origen");
        % UN CANIBAL
        (MO2 is MO, CO2 is CO-1, MD2 is MD, Cd2 is Cd+1, L1=o, L2=d,Res="1 Canibal hacia destino");
        (MO2 is MO, CO2 is CO+1, MD2 is MD, Cd2 is Cd-1, L1=d, L2=o,Res="1 Canibal hacia origen");   
        % DOS CANIBALES
        (MO2 is MO, CO2 is CO-2, MD2 is MD, Cd2 is Cd+2, L1=o, L2=d,Res="2 Canibales hacia destino");
        (MO2 is MO, CO2 is CO+2, MD2 is MD, Cd2 is Cd-2, L1=d, L2=o,Res="2 Canibales hacia origen")        
    ),
    edo_valido([MO2,CO2,MD2,Cd2]).

sucesores([Estado-R1|Resto],Sucesores):-    setof([S-R,Estado-R1|Resto], 
                                                (movimiento(Estado,S-R), \+member(S-R,[Estado-R1|Resto])),
                                            Sucesores ),
                                        print_term(Sucesores,[]).

busca_BFS():- bfs([0,0,3,3,d]-_,[[[3,3,0,0,o]-"Inicio"]],M),
                reverse(M, Movimientos),
                print_term(Movimientos,[]).

bfs(Estado_meta-_, [[Estado_meta|Trayecto]|_], [Estado_meta-_|Trayecto]).
bfs(Estado_meta-_, [Candidato|Frontera], Ruta):-  sucesores(Candidato,Sucesores),
                                                    append(Frontera, Sucesores, NuevaAgenda),
                                                    bfs(Estado_meta, NuevaAgenda, Ruta).


ruta(Nodo, Nodo, [Nodo]).
ruta(Inicio, Nodo_goal, [Nodo_goal|Ruta]):- ruta(Inicio , Penultimo_nodo , Ruta),
                                            movimiento(Penultimo_nodo, Nodo_goal),
                                            \+ member(Nodo_goal,Ruta).    

busqueda_iterativa_profunda():- ruta([3,3,0,0,o], Goal, R),
                                meta(Goal),
                                reverse(R,Solucion),
                                print_term(Solucion,[]).