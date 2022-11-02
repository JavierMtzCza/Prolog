edo_valido([Mis1,Can1,Mis2,Can2]):- Mis1 >= 0, Can1 >=0, Mis2 >= 0, Can2 >=0,
                                    (Mis1 >= Can1 ; Mis1 is 0),
                                    (Mis2 >= Can2 ; Mis2 is 0).

movimiento([MO,CO,MD,Cd,L1],[MO2,CO2,MD2,Cd2,L2]):- 
    (   % UN MISIONERO
        (MO2 is MO-1, CO2 is CO, MD2 is MD+1, Cd2 is Cd, L1=o,L2=d);
        (MO2 is MO+1, CO2 is CO, MD2 is MD-1, Cd2 is Cd, L1=d,L2=o);
        % DOS MISIONEROS
        (MO2 is MO-2, CO2 is CO, MD2 is MD+2, Cd2 is Cd, L1=o,L2=d);
        (MO2 is MO+2, CO2 is CO, MD2 is MD-2, Cd2 is Cd, L1=d,L2=o);
        % MISIONERO Y CANIBAL
        (MO2 is MO-1, CO2 is CO-1, MD2 is MD+1, Cd2 is Cd+1, L1=o,L2=d);
        (MO2 is MO+1, CO2 is CO+1, MD2 is MD-1, Cd2 is Cd-1, L1=d,L2=o);
        % UN CANIBAL
        (MO2 is MO, CO2 is CO-1, MD2 is MD, Cd2 is Cd+1, L1=o, L2=d);
        (MO2 is MO, CO2 is CO+1, MD2 is MD, Cd2 is Cd-1, L1=d, L2=o);   
        % DOS CANIBALES
        (MO2 is MO, CO2 is CO-2, MD2 is MD, Cd2 is Cd+2, L1=o, L2=d);
        (MO2 is MO, CO2 is CO+2, MD2 is MD, Cd2 is Cd-2, L1=d, L2=o)        
    ),
    edo_valido([MO2,CO2,MD2,Cd2]).

tipo([MO,CO,MD,Cd,L1],[MO2,CO2,MD2,Cd2,L2],Tipo):- 
    (   % UN MISIONERO
        (MO2 is MO-1, CO2 is CO, MD2 is MD+1, Cd2 is Cd, L1=o,L2=d,Tipo="1 misionero a destino");
        (MO2 is MO+1, CO2 is CO, MD2 is MD-1, Cd2 is Cd, L1=d,L2=o,Tipo="1 misionero a origen");
        % DOS MISIONEROS
        (MO2 is MO-2, CO2 is CO, MD2 is MD+2, Cd2 is Cd, L1=o,L2=d,Tipo="2 misioneros a destino");
        (MO2 is MO+2, CO2 is CO, MD2 is MD-2, Cd2 is Cd, L1=d,L2=o,Tipo="2 misioneros a origen");
        % MISIONERO Y CANIBAL
        (MO2 is MO-1, CO2 is CO-1, MD2 is MD+1, Cd2 is Cd+1, L1=o,L2=d,Tipo="1 misionero y 1 canibal a destino");
        (MO2 is MO+1, CO2 is CO+1, MD2 is MD-1, Cd2 is Cd-1, L1=d,L2=o,Tipo="1 misionero y 1 canibal a origen");
        % UN CANIBAL
        (MO2 is MO, CO2 is CO-1, MD2 is MD, Cd2 is Cd+1, L1=o, L2=d,Tipo="1 canibal a destino");
        (MO2 is MO, CO2 is CO+1, MD2 is MD, Cd2 is Cd-1, L1=d, L2=o,Tipo="1 canibal a origen");   
        % DOS CANIBALES
        (MO2 is MO, CO2 is CO-2, MD2 is MD, Cd2 is Cd+2, L1=o, L2=d,Tipo="2 canibales a destino");
        (MO2 is MO, CO2 is CO+2, MD2 is MD, Cd2 is Cd-2, L1=d, L2=o,Tipo="2 canibales a origen")        
    ).

sucesores([Estado|Resto],Sucesores):-findall([S,Estado|Resto], 
                                            (movimiento(Estado,S), \+member(S,[Estado|Resto])),
                                            Sucesores ).

%% ----------------------------------------------- DFS -------------------------------------------
busca_DFS(Rutas):-findall(Ruta-Intentos,
                        (dfs([0,0,3,3,d],0,Intentos,[[[3,3,0,0,o]]],R),reverse(R,Ruta))
                        ,Rutas).
%busca_DFS():- dfs([0,0,3,3,d],0,Intentos,[[[3,3,0,0,o]]],M),
%              reverse(M, Movimientos),
%              write(Intentos),
%              print_term(Movimientos,[]).

dfs(Estado_meta,Intentos,Intentos,[[Estado_meta|Trayecto]|_],[Estado_meta|Trayecto]).
dfs(Estado_meta,Cuenta,Intentos,[Candidato|Frontera],Ruta):-sucesores(Candidato,Sucesores),
                                                            append(Sucesores,Frontera,NuevaAgenda),
                                                            Cuenta2 is Cuenta+1,
                                                            dfs(Estado_meta, Cuenta2,Intentos,NuevaAgenda, Ruta).

%% ----------------------------------------------- BFS -------------------------------------------
busca_BFS(Ruta_final):-findall(Ruta-Intentos,
                        (bfs([0,0,3,3,d],0,Intentos,[[[3,3,0,0,o]]],R),reverse(R,Ruta))
                        ,Rutas),
                        listar_tiempos(Rutas,Tiempos),
                        min_list(Tiempos,Num),
                        nth1(Index,Tiempos,Num),
                        nth1(Index,Rutas,Ruta_final).
                  
%busca_BFS():- bfs([0,0,3,3,d],0,Intentos,[[[3,3,0,0,o]]],M),
%              reverse(M, Movimientos),
%              write(Intentos),
%              print_term(Movimientos,[]).

bfs(Estado_meta,Intentos,Intentos,[[Estado_meta|Ruta]|_],[Estado_meta|Ruta]).
bfs(Estado_meta,Cuenta,Intentos,[Candidato|Frontera],Ruta):-sucesores(Candidato,Sucesores),
                                                            append(Frontera, Sucesores, NuevaAgenda),
                                                            Cuenta2 is Cuenta+1,
                                                            bfs(Estado_meta,Cuenta2,Intentos,NuevaAgenda,Ruta).

%% ----------------------------------------------- DIS -------------------------------------------
busca_IDS():-ruta([3,3,0,0,o],0,Intentos,[0,0,3,3,d],R),
            reverse(R,Solución),
            write(Intentos),
            print_term(Solución,[]).

ruta(Estado,Intentos,Intentos,Estado,[Estado]).                     
ruta(Inicio,Cuenta,Intentos,Estado_meta,[Estado_meta|Ruta]):-Cuenta2 is Cuenta+1,
                                                            ruta(Inicio,Cuenta2,Intentos,Penúltimo_Estado,Ruta),
                                                            movimiento(Penúltimo_Estado,Estado_meta),
                                                            \+member(Estado_meta,Ruta).    

listar_tiempos([],[]).
listar_tiempos([_-T|Resto],[T|Tiempos]):- listar_tiempos(Resto,Tiempos).

despliega():-busca_BFS(Ruta_final),
                Ruta-Tiempo = Ruta_final,
 format('exito!!!  ruta encontrada en ~d intentos ~n',[Tiempo]),
Length(Ruta, Longitud),
format('ruta con ~d pasos ~n',[Longitud]),
                imprime(Ruta,1).
            

imprime([R1,R2],Tramo):-tipo(R1,R2,Tipo),
                        format('( ~d )   aplicando ~w se llega a ~t ~w~5| ~n',[Tramo,Tipo,R2]),!.
imprime([R1,R2|Resto],Tramo):- tipo(R1,R2,Tipo),
                                format('( ~d )   aplicando ~w se llega a ~t ~w~5| ~n',[Tramo,Tipo,R2]),
                                Tramo2 is Tramo+1,
                                imprime([R2|Resto],Tramo2).

            
