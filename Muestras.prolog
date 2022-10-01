%% SABER SI UN ELEMENTO ESTA EN LA LISTA
    buscar(_,[]):- fail.
    buscar(X,[X|_]):- !.
    buscar(X,[Y|Resto]):- \+(X=Y), buscar(X,Resto).

%% SUMAR DOS LISTAS O ENCONTRAR EL CONTEXTO

    append([],L,L).
    append([X|L1],L2,[X|L3]):- append(L1,L2,L3).

%% MODO DE FILTRADO 

    filtrar_numeros([],[]).
    filtrar_numeros([X|Resto],[X|Num]):- number(X), filtrar_numeros(Resto,Num).
    filtrar_numeros([X|Resto],Num):- \+number(X), filtrar_numeros(Resto,Num).

%% INSERTAR AL FINAL DE UNA LISTA UN LEMENTO

    inserta_final(X,[],[X]):- !.
    inserta_final(X,[H|T],[H|T2]):- inserta_final(X,T,T2).

%% ELIMINAR DUPLICADOS TOTALMENTE 

    simplifica([],[]).
    simplifica([X|Ys],Zs) :- member(X,Ys),subtract([X|Ys],[_],Res), simplifica(Res,Zs),!.
    simplifica([X|Ys],[X|Zs]) :- \+(member(X,Ys)), simplifica(Ys,Zs).

%% ELIMINAR ELEMENTOS DE UNA LISTA
    elimina_de_lista([],_,[]).
    elimina_de_lista(Lista,0,Lista):- !.
    elimina_de_lista([_|Resto],N,L):-N>0, N2 is N-1 ,elimina_de_lista(Resto,N2,L).

%% PARTIR UNA LISTA EN 2
    particiona(Lista2,0,[],Lista2).
    particiona([X|Resto],N,[X|Lista1],Lista2) :- N > 0, N1 is N - 1, particiona(Resto,N1,Lista1,Lista2).