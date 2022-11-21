%=========================================================================
% Javier Martínez Carranza  
%  
%   Tarea 5: Complete el programa para resolver el problema de Misioneros y caníbales, usando las indicaciones y los predicados de la presentación #21...
%             - Su programa debe poder entregar la solución al problema, buscando en tres órdenes diferentes: profundo, ancho y profundización iterativa...
%             - La salida del programa debe tener la estructura que se muestra en la lámina #37 de esa misma presentación...
%
%   Predicados relevantes:
%       busca_DFS( +Estado_inicial , +Estado_meta, -Plan).
%       busca_BFS( +Estado_inicial , +Estado_meta, -Plan).
%       busca_IDS( +Estado_inicial , +Estado_meta, -Plan).
%       despliega().
%=========================================================================

edo_valido([Mis1,Can1,Mis2,Can2]):- Mis1 >= 0, Can1 >=0, Mis2 >= 0, Can2 >=0,
                                    (Mis1 >= Can1 ; Mis1 is 0),
                                    (Mis2 >= Can2 ; Mis2 is 0).

movimiento([MO,CO,MD,Cd,L1],[MO2,CO2,MD2,Cd2,L2]):- 
    (
        (MO2 is MO-1, CO2 is CO, MD2 is MD+1, Cd2 is Cd, L1=o,L2=d);
        (MO2 is MO+1, CO2 is CO, MD2 is MD-1, Cd2 is Cd, L1=d,L2=o);
        (MO2 is MO-2, CO2 is CO, MD2 is MD+2, Cd2 is Cd, L1=o,L2=d);
        (MO2 is MO+2, CO2 is CO, MD2 is MD-2, Cd2 is Cd, L1=d,L2=o);
        (MO2 is MO-1, CO2 is CO-1, MD2 is MD+1, Cd2 is Cd+1, L1=o,L2=d);
        (MO2 is MO+1, CO2 is CO+1, MD2 is MD-1, Cd2 is Cd-1, L1=d,L2=o);
        (MO2 is MO, CO2 is CO-1, MD2 is MD, Cd2 is Cd+1, L1=o, L2=d);
        (MO2 is MO, CO2 is CO+1, MD2 is MD, Cd2 is Cd-1, L1=d, L2=o);   
        (MO2 is MO, CO2 is CO-2, MD2 is MD, Cd2 is Cd+2, L1=o, L2=d);
        (MO2 is MO, CO2 is CO+2, MD2 is MD, Cd2 is Cd-2, L1=d, L2=o)        
    ),edo_valido([MO2,CO2,MD2,Cd2]).
%--------------- 
% tipo/3. Obtener el tipo de movimiento que se realiza al pasar de un estado a otro.
%     tipo( +Estado1,+Estado2, -Tipo).
%       
%       Explicación: Verdadero si <Tipo> es el tipo de movimiento para pasar de <Estado1> a <Estado2>.
%---------------
tipo([MO,CO,MD,Cd,L1],[MO2,CO2,MD2,Cd2,L2],Tipo):- 
    (
        (MO2 is MO-1, CO2 is CO, MD2 is MD+1, Cd2 is Cd, L1=o,L2=d,Tipo="1 misionero a destino");
        (MO2 is MO+1, CO2 is CO, MD2 is MD-1, Cd2 is Cd, L1=d,L2=o,Tipo="1 misionero a origen");
        (MO2 is MO-2, CO2 is CO, MD2 is MD+2, Cd2 is Cd, L1=o,L2=d,Tipo="2 misioneros a destino");
        (MO2 is MO+2, CO2 is CO, MD2 is MD-2, Cd2 is Cd, L1=d,L2=o,Tipo="2 misioneros a origen");
        (MO2 is MO-1, CO2 is CO-1, MD2 is MD+1, Cd2 is Cd+1, L1=o,L2=d,Tipo="misionero y canibal a destino");
        (MO2 is MO+1, CO2 is CO+1, MD2 is MD-1, Cd2 is Cd-1, L1=d,L2=o,Tipo="misionero y canibal a origen");
        (MO2 is MO, CO2 is CO-1, MD2 is MD, Cd2 is Cd+1, L1=o, L2=d,Tipo="1 canibal a destino");
        (MO2 is MO, CO2 is CO+1, MD2 is MD, Cd2 is Cd-1, L1=d, L2=o,Tipo="1 canibal a origen");   
        (MO2 is MO, CO2 is CO-2, MD2 is MD, Cd2 is Cd+2, L1=o, L2=d,Tipo="2 canibales a destino");
        (MO2 is MO, CO2 is CO+2, MD2 is MD, Cd2 is Cd-2, L1=d, L2=o,Tipo="2 canibales a origen")        
    ).
%--------------- 
% sucesores/2. Obtener los sucesores directos de un estado.
%     sucesores( +Estado, -Sucesores).
%       
%       Explicación: Verdadero si <Sucesores> es una lista con todos los sucesores directos de <Estado>.
%                   Este predicado hace uso de movimiento/2.
%---------------
sucesores([Estado|Resto],Sucesores):-findall([S,Estado|Resto], 
                                            (movimiento(Estado,S), \+member(S,[Estado|Resto])),
                                            Sucesores ),
                                        print_term(Sucesores,[]).
%--------------- 
% busca_DFS/3. Obtener las rutas para resolver el problema de misioneros y caníbales usando búsqueda a lo profundo.
%     busca_DFS( +Estado_inicial, +Estado_meta, -Plan).
%       
%       Explicación: Verdadero si <Plan> es una solución del problema de misioneros y caníbales partiendo de <Estado_inicial> a <Estado_meta>.
%                   Este predicado hace uso de dfs/5.
%---------------
busca_DFS(Estado_inicial,Estado_meta,Plan):-dfs(Estado_inicial,0,_,[[Estado_meta]],P),
                                            reverse(P,Plan),
                                            print_term(Plan,[]).

dfs(Estado_meta,Intentos,Intentos,[[Estado_meta|Trayecto]|_],[Estado_meta|Trayecto]).
dfs(Estado_meta,Cuenta,Intentos,[Candidato|Frontera],Ruta):-sucesores(Candidato,Sucesores),
                                                            append(Sucesores,Frontera,NuevaAgenda),
                                                            Cuenta2 is Cuenta+1,
                                                            dfs(Estado_meta, Cuenta2,Intentos,NuevaAgenda,Ruta).
%--------------- 
% mejor_ruta_DFS/1. Obtener la ruta con menos intentos para resolver el problema de misioneros y caníbales usando búsqueda a lo profundo.
%     mejor_ruta_DFS( -Mejor_ruta).
%       
%       Explicación: Verdadero si <Mejor_ruta> es la solución con menos intentos que resuelve el problema de misioneros y caníbales.
%                   Este predicado hace uso de dfs/5 y mejor_ruta/2.
%---------------
mejor_ruta_DFS(Mejor_ruta):-findall(Ruta-Intentos, 
                                (dfs([0,0,3,3,d],0,Intentos,[[[3,3,0,0,o]]],R),reverse(R,Ruta)) ,
                                Rutas),
                            mejor_ruta(Rutas,Mejor_ruta).
%--------------- 
% busca_BFS/3. Obtener las rutas para resolver el problema de misioneros y caníbales usando búsqueda a lo ancho.
%     busca_BFS( +Estado_inicial, +Estado_meta, -Plan).
%       
%       Explicación: Verdadero si <Plan> es una solución del problema de misioneros y caníbales partiendo de <Estado_inicial> a <Estado_meta>.
%                   Este predicado hace uso de bfs/5.
%---------------
busca_BFS(Estado_inicial,Estado_meta,Plan):-bfs(Estado_inicial,0,_,[[Estado_meta]],P),
                                            reverse(P,Plan),
                                            print_term(Plan,[]).

bfs(Estado_meta,Intentos,Intentos,[[Estado_meta|Trayecto]|_],[Estado_meta|Trayecto]).
bfs(Estado_meta,Cuenta,Intentos,[Candidato|Frontera],Ruta):-sucesores(Candidato,Sucesores),
                                                            append(Frontera, Sucesores, NuevaAgenda),
                                                            Cuenta2 is Cuenta+1,
                                                            bfs(Estado_meta,Cuenta2,Intentos,NuevaAgenda,Ruta).
%--------------- 
% mejor_ruta_BFS/1. Obtener la ruta con menos intentos para resolver el problema de misioneros y caníbales usando búsqueda a lo ancho.
%     mejor_ruta_BFS( -Mejor_ruta).
%       
%       Explicación: Verdadero si <Mejor_ruta> es la solución con menos intentos que resuelve el problema de misioneros y caníbales.
%                   Este predicado hace uso de bfs/5 y mejor_ruta/2.
%---------------
mejor_ruta_BFS(Mejor_ruta):-findall(Ruta-Intentos,
                                (bfs([0,0,3,3,d],0,Intentos,[[[3,3,0,0,o]]],R),reverse(R,Ruta))
                                ,Rutas),
                            mejor_ruta(Rutas,Mejor_ruta).
%--------------- 
% busca_IDS/3. Obtener las rutas para resolver el problema de misioneros y caníbales usando búsqueda de profundización iterativa.
%     busca_IDS( +Estado_inicial, +Estado_meta, -Plan).
%       
%       Explicación: Verdadero si <Plan> es una solución del problema de misioneros y caníbales partiendo de <Estado_inicial> a <Estado_meta>.
%                   Este predicado hace uso de ids/5.
%---------------
busca_IDS(Estado_inicial,Estado_meta,Plan):-ids(Estado_inicial,0,_,Estado_meta,P),
                                            reverse(P,Plan),
                                            print_term(Plan,[]).

ids(Estado,Intentos,Intentos,Estado,[Estado]).                     
ids(Inicio,Cuenta,Intentos,Estado_meta,[Estado_meta|Ruta]):-Cuenta2 is Cuenta+1,
                                                            ids(Inicio,Cuenta2,Intentos,Penúltimo_Estado,Ruta),
                                                            movimiento(Penúltimo_Estado,Estado_meta),
                                                            \+member(Estado_meta,Ruta).
%--------------- 
% mejor_ruta_IDS/1. Obtener la ruta con menos intentos para resolver el problema de misioneros y caníbales usando búsqueda de profundización iterativa.
%     mejor_ruta_IDS( -Mejor_ruta).
%       
%       Explicación: Verdadero si <Mejor_ruta> es la solución con menos intentos que resuelve el problema de misioneros y caníbales.
%                   Este predicado hace uso de ids/5.
%---------------
mejor_ruta_IDS(Mejor_ruta):-findall(Ruta-Intentos,
                                    ( limit(8,ids([3,3,0,0,o],0,Intentos,[0,0,3,3,d],Ruta)) )
                                    ,Rutas),
                            nth1(1,Rutas,Mejor_ruta).    
%--------------- 
% despliega/0. Mostrar en pantalla el plan para resolver el problema de misioneros y caníbales con los tres 
%               tipos de búsqueda y siempre en el menor numero de intentos en cada una.
%     despliega().
%---------------
despliega():-mejor_ruta_BFS(Mejor_ruta_BFS),
                Ruta1-Intentos1 = Mejor_ruta_BFS,
                format('~n~t~12| MEJOR RUTA BFS ~t~12|~n'),
                format('~t~3| éxito!!!. Meta encontrada en ~d intentos ~n',[Intentos1]),
                length(Ruta1, Longitud1),
                format('  Solución con ~d pasos ~n',[Longitud1-1]),
                imprime(Ruta1,1),
            mejor_ruta_DFS(Mejor_ruta_DFS),
                Ruta2-Intentos2 = Mejor_ruta_DFS,
                format('~n~n~t~12| MEJOR RUTA DFS ~t~12|~n'),
                format('~t~3| éxito!!!. Meta encontrada en ~d intentos ~n',[Intentos2]),
                length(Ruta2, Longitud2),
                format('  Solución con ~d pasos ~n',[Longitud2-1]),
                imprime(Ruta2,1),
            mejor_ruta_IDS(Mejor_ruta_IDS),
                Ruta3-Intentos3 = Mejor_ruta_IDS,
                format('~n~n~t~12| MEJOR RUTA IDS ~t~12|~n'),
                format('~t~3| éxito!!!. Meta encontrada en ~d intentos ~n',[Intentos3]),
                length(Ruta3, Longitud3),
                format('  Solución con ~d pasos ~n',[Longitud3-1]),
                imprime(Ruta3,1).

imprime([R1,R2],Tramo):-tipo(R1,R2,Tipo),
                        format('( ~d )   aplicando ~w ~t se llega a ~t~5| ~t ~w~5| ~n',[Tramo,Tipo,R2]),!.
imprime([R1,R2|Resto],Tramo):- tipo(R1,R2,Tipo),
                                format('( ~d )   aplicando ~w ~t se llega a ~t ~t ~w~5| ~n',[Tramo,Tipo,R2]),
                                Tramo2 is Tramo+1,
                                imprime([R2|Resto],Tramo2).

            
