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
promedio_parcial(Lista,N,Respuesta):-   filtrar_numeros(Lista , Lista_sin_letras , _ ),
                                        length(Sub_lista , N ), 
                                        subtract(Lista_sin_letras , Sub_lista , _ ), 
                                        sum_list(Sub_lista , Suma ), 
                                        Respuesta is Suma // N.

filtrar_numeros([],[],[]).
filtrar_numeros([X|Resto],[X|Num],Let):- number(X), filtrar_numeros(Resto,Num,Let).
filtrar_numeros([X|Resto],Num,[X|Let]):- \+number(X), filtrar_numeros(Resto,Num,Let).

%%%%%%%%%%%% ---------------Problema 10

maximo(Lista,Numero_maximo):- filtrar_numeros(Lista , Lista_numeros , _ ), max_list(Lista_numeros, Numero_maximo).