%%%%%%%%%%%% ---------------Problema 1
contiene_numero([X|_]):- number(X),!.
contiene_numero([_|Resto]):- contiene_numero(Resto).

%%%%%%%%%%%% ---------------Problema 2
inserta_ceros([],[]).
inserta_ceros([X|Resto],[X,0|Resto2]):- inserta_ceros(Resto,Resto2).

/*
rota([],N,[]).
rota([X],N,[X]).
rota([X|Resto],N,[Y|Resto2]):- N > 0, N1 is N-1 , rota(Resto,N1,[Y|Resto2])   
*/

%%%%%%%%%%%% ---------------Problema 5
inserta0_en(_,[],N,[]):-number(N).
inserta0_en(X,[A|Resto],N,[X|[A|Resto]]):- N=0.
inserta0_en(X,[A|Resto],N,[A|Resto2]):- N>0, N2 is N-1, inserta0_en(X,Resto,N2,Resto2).


%%%%%%%%%%%% ---------------Problema 6
promedio_parcial(Lista,N,Respuesta):-   filtrar_numeros(Lista , Lista_sin_letras ),
                                        length(Sub_lista , N ), 
                                        subtract(Lista_sin_letras , Sub_lista , _ ), 
                                        sum_list(Sub_lista , Suma ), 
                                        Respuesta is Suma // N.

filtrar_numeros([],[]).
filtrar_numeros([X|Resto],[X|Num]):- number(X), filtrar_numeros(Resto,Num).
filtrar_numeros([X|Resto],Num):- \+number(X), filtrar_numeros(Resto,Num).

%%%%%%%%%%%% ---------------Problema 10

maximo(Lista,Numero_maximo):- filtrar_numeros(Lista , Lista_numeros ), max_list(Lista_numeros, Numero_maximo).

%%%%%%%%%%%% ---------------Problema 11

anti_consonante([],[]).
anti_consonante([X|Resto],[X|Sin_consonantes]):- (X = a ; X = e ; X = i ; X = o ; X = u ; number(X)), anti_consonante(Resto,Sin_consonantes).
anti_consonante([X|Resto],Sin_consonantes):- \+(X = a ; X = e ; X = i ; X = o ; X = u ; number(X)), anti_consonante(Resto,Sin_consonantes).

%%%%%%%%%%%% ---------------Problema 12

vocales([],[]).
vocales([X|Resto],[Y|Vocales]):- (X = a ; X = e ; X = i ; X = o ; X = u ), string_upper(X,Y),vocales(Resto,Vocales).
vocales([X|Resto],Vocales):- \+(X = a ; X = e ; X = i ; X = o ; X = u ), vocales(Resto,Vocales).

%%%%%%%%%%%% ---------------Problema 13

par([],[]).
par([X|Resto],[Y|Vocales]):- (), vocales(Resto,Vocales).
par([X|Resto],Vocales):- \+(), vocales(Resto,Vocales).

es_par(_,K,Max,_):- K >= Max, !.
es_par(Lista,K,Max,[K|Res]):- K > 0, K<Max, K2 is K+2, es_par(Lista,K2,Max,Res).

%%%%%%%%%%%% ---------------Problema 15
particiona(Lista,N,L1,L2):- length(Lista, Length), N2 is N-1, N2 = Length,
                            L1=Lista,
                            L2=[].
particiona(Lista,N,L1,L2):- length(Lista, Length), N < Length,
                            nth1(N,Lista,Elemento),
                            append(L1,[Elemento|L],Lista),
                            L2=[Elemento|L].
append([],L,L).
append([X|L1],L2,[X|L3]):- append(L1,L2,L3).


