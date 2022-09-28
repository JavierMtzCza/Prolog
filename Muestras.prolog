%% SABER SI UN ELEMENTO ESTA EN LA LISTA
buscar(_,[]):- fail.
buscar(X,[Y|_]):- X=Y, !.
buscar(X,[Y|Resto]):- \+(X=Y), buscar(X,Resto).

%% SUMAR DOS LISTAS O ENCONTRAR EL CONTEXTO

append([],L,L).
append([X|L1],L2,[X|L3]):- append(L1,L2,L3).

%% MODO DE FILTRADO 

filtrar_numeros([],[]).
filtrar_numeros([X|Resto],[X|Num]):- number(X), filtrar_numeros(Resto,Num).
filtrar_numeros([X|Resto],Num):- \+number(X), filtrar_numeros(Resto,Num).