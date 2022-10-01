%%%%%%%%%%%% ---------------Problema 1
contiene_numero([X|_]):- number(X),!.
contiene_numero([_|Resto]):- contiene_numero(Resto).

%%%%%%%%%%%% ---------------Problema 2
inserta_ceros([],[]).
inserta_ceros([X|Resto],[X,0|Resto2]):- inserta_ceros(Resto,Resto2).

%%%%%%%%%%%% ---------------Problema 3

rotar(Lista_rotada,0,Lista_rotada):- !.
rotar(Lista,N,Res):-    N>0,
                        last(Lista,Last),
                        delete(Lista,Last,Resto),
						inserta_inicio(Last,Resto,L1),
						N2 is N-1,
						rotar(L1,N2,Res).

inserta_inicio(Y,[X|Resto],[Y,X|Resto]).  

%%%%%%%%%%%% ---------------Problema 4
reversa_simple(Lista1,Lista2) :- acumular(Lista1,Lista2,[]).
 
acumular([],Lista_invertida,Lista_invertida) :- !.
acumular([X|Resto],Lista_invertida,Acumulador) :- acumular(Resto,Lista_invertida,[X|Acumulador]).

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

%%%%%%%%%%%% ---------------Problema 7
fibonacci(N,N):- N<2, N>=0.
fibonacci(N,Res):- N>=2, N1 is N-1, N2 is N-2, fibonacci(N1,R1), fibonacci(N2,R2), Res is R1+R2.

%%%%%%%%%%%% ---------------Problema 8
simplifica([],[]).
simplifica([X|Ys],Zs) :- member(X,Ys), simplifica(Ys,Zs),!.
simplifica([X|Ys],[X|Zs]) :- \+(member(X,Ys)), simplifica(Ys,Zs).

%%%%%%%%%%%% ---------------Problema 9
depura([],[]).
depura([X|Resto],[X|Respuesta]) :- member(X,Resto),subtract([X|Resto],[_],Res), depura(Res,Respuesta),!.
depura([X|Resto],Respuesta) :- \+(member(X,Resto)), depura(Resto,Respuesta).

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
cada_dos(Lista,Resultado):- elimina_de_lista(Lista,2,R), dos_en_dos(R,Resultado).

dos_en_dos([],[]):- !.
dos_en_dos([H|T],[H|T2]):- elimina_de_lista([H|T],2,T1),dos_en_dos(T1,T2).

elimina_de_lista([],N,[]):- number(N), !.
elimina_de_lista(Lista,0,Lista):- !.
elimina_de_lista([_|Resto],N,L):-N>0, N2 is N-1 ,elimina_de_lista(Resto,N2,L).

%%%%%%%%%%%% ---------------Problema 14 

contexto([X],X,[[],[]]):- !.
contexto(Lista,Elem,Res):- nth1(Index, Lista, Elem), 
                            partir_lista(Lista,Index,L1,L2),
                            nextto(X,Elem,L1),
                            Res=[X,Y].

%%%%%%%%%%%% ---------------Problema 15 
particiona(Lista,N,Res1,Res2):- N2 is N-1, partir_lista(Lista,N2,Res1,Res2).

partir_lista(Lista2,0,[],Lista2).
partir_lista([X|Resto],N,[X|Lista1],Lista2) :- N > 0, N1 is N - 1, partir_lista(Resto,N1,Lista1,Lista2).


