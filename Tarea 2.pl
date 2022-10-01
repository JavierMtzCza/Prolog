%=========================================================================
% Javier Martìnez Carranza  
%  
%   Tarea 2: Paquete de ejercicios Prolog...
%       Resuelver los 15 ejercicios del paquete de ejercicios.
%=========================================================================

                % ---------------Problema 1--------------- %
%--------------- 
% [ ] contiene_número/1. Verificar si una lista contiene algún elemento numérico.
%     contiene_numero(<lista>).
%       
%       Explicación: verdadero si <lista> es una lista que contiene algún elemento numérico,
%                   falso en cualquier otro caso
%---------------
contiene_numero([X|_]):- number(X),!.
contiene_numero([_|Resto]):- contiene_numero(Resto).

                % ---------------Problema 2--------------- %
%--------------- 
% [ ] inserta_ceros/2. Intercalar ceros después de cada elemento original.
%     inserta_ceros(<lista>, <respuesta>).
%       
%       Explicación: Verdadero si <respuesta> es una lista con los mismos elementos que
%                   <lista>, pero con un cero agregado después de cada elemento original.
%                   La lista vacía debe conservarse.
%---------------
inserta_ceros([],[]).
inserta_ceros([X|Resto],[X,0|Resto2]):- inserta_ceros(Resto,Resto2).

                % ---------------Problema 3--------------- %
%--------------- 
% [sin usar append] rota/3. Rotar los elementos de una lista algún número de posiciones hacia la derecha.
%     rota(<lista>, <n>, <respuesta>).
%       
%       Explicación: Verdadero si <respuesta> es una lista con los mismos elementos que
%                   <lista>, pero rotados hacia la derecha <n> posiciones.
%---------------
rotar(Lista_rotada,0,Lista_rotada):- !.
rotar(Lista,N,Res):-    N>0,
                        last(Lista,Last),
                        delete(Lista,Last,Resto),
						inserta_inicio(Last,Resto,L1),
						N2 is N-1,
						rotar(L1,N2,Res).
/*
inserta_inicio/3. Insertar un elemento al inicio de una lista.
inserta_inicio(<y>,<lista>,<respuesta>)

        Explicación: Verdadero si <respuesta> es una lista  que comience 
                    con <y> y tenga los mismos elementos de <lista> como resto.
*/
inserta_inicio(Y,[X|Resto],[Y,X|Resto]).  

                % ---------------Problema 4--------------- %
%--------------- 
% [sin usar reverse, ni append] reversa_simple/2. Invertir una lista.
%     reversa_simple(<lista>, <respuesta>).
%       
%       Explicación: Verdadero si <respuesta> es la inversión de primer nivel de <lista>.
%---------------
reversa_simple(Lista,Respuesta) :- acumular(Lista,Respuesta,[]).

/*
acumular/3. acumular elementos al inicio de una lista.
acumular(<lista>,<respuesta>,<acumulador>)

        Explicación: Verdadero si <respuesta> es resultado de invertir <lista>.
                    El <acumulador> en este enunciado funciona como una variable de apoyo que va insertando 
                    elementos al inicio de una lista, una vez recorridos todos los elementos de <lista>, el resultado 
                    final de <acumulador> será nuestra <respuesta>.
        Forma de uso: acumular(<lista>,<respuesta>,[]). al usar el enunciado el acumulador debe empezar por ser una lista vacia.
*/
acumular([],Lista_invertida,Lista_invertida) :- !.
acumular([X|Resto],Lista_invertida,Acumulador) :- acumular(Resto,Lista_invertida,[X|Acumulador]).

                % ---------------Problema 5--------------- %
%--------------- 
% [sin usar select] inserta0_en/4. Insertar un término arbitrario en alguna posición específica de una lista.
%     inserta0_en(<término>, <lista>, <posición>, <resultado>).
%       
%       Explicación: Verdadero si <resultado> es una lista con los mismos elementos que <lista>
%                   pero con <término> insertado en la posición <posición>, considerando el
%                   inicio de la lista como la posición 0.
%---------------
inserta0_en(_,[],N,[]):-number(N).
inserta0_en(X,[A|Resto],N,[X|[A|Resto]]):- N=0.
inserta0_en(X,[A|Resto],N,[A|Resto2]):- N>0, N2 is N-1, inserta0_en(X,Resto,N2,Resto2).


                % ---------------Problema 6--------------- %
%--------------- 
% [ ] promedio_parcial/3. Calcular el promedio (media aritmética) de los primeros n elementos de una lista.
%     promedio_parcial(<lista>, <n>, <resultado>).
%       
%       Explicación: Verdadero si <resultado> es un número que representa el promedio de los
%                   primeros <n> elementos numéricos de <lista> (que puede tener otros
%                   elementos no-numéricos).
%---------------
promedio_parcial(Lista,N,Respuesta):-   filtrado_de_numeros(Lista , Lista_sin_letras ),
                                        length(Sub_lista , N ), 
                                        subtract(Lista_sin_letras , Sub_lista , _ ), 
                                        sum_list(Sub_lista , Suma ), 
                                        Respuesta is Suma // N.
/*
filtrado_de_numeros/2. Eliminar de una lista todos los elementos que no sean números.
filtrado_de_numeros(<lista>,<respuesta>)

        Explicación: Verdadero si <respuesta> es el resultado de eliminar todos los elementos de <lista> 
                    que no sean números.
*/                  
filtrado_de_numeros([],[]).
filtrado_de_numeros([X|Resto],[X|Num]):- number(X), filtrado_de_numeros(Resto,Num).
filtrado_de_numeros([X|Resto],Num):- \+number(X), filtrado_de_numeros(Resto,Num).

                % ---------------Problema 7--------------- %
%--------------- 
% [sin cortes] fibonacci/2. Calcular cada término en la serie de Fibonacci.
%     fibonacci(<n>, <resultado>).
%       
%       Explicación: Verdadero si <resultado> es el número Fibonacci correspondiente a <n>.
%---------------
fibonacci(N,N):- N<2, N>=0.
fibonacci(N,Res):- N>=2, N1 is N-1, N2 is N-2, fibonacci(N1,R1), fibonacci(N2,R2), Res is R1+R2.

                % ---------------Problema 8--------------- %
%--------------- 
% [sin usar sort ni list_to_set, ni list_to_ord_set] simplifica/2. Eliminar de una lista todos los elementos que se encuentren duplicados.
%     simplifica(<lista>, <resultado>).
%       
%       Explicación: Verdadero si <resultado> es una lista con los mismos elementos que
%                   <lista> pero con sólo una instancia de cada elemento.
%---------------
simplifica([],[]).
simplifica([X|Resto],Res) :- member(X,Resto), simplifica(Resto,Res),!.
simplifica([X|Resto],[X|Res]) :- \+(member(X,Resto)), simplifica(Resto,Res).

                % ---------------Problema 9--------------- %
%--------------- 
% [ ] depura/2. Eliminar de una lista todos los elementos que NO se encuentren duplicados, cuando menos, una vez.
%     depura(<lista>, <resultado>).
%       
%       Explicación: Verdadero si <resultado> es una lista conteniendo sólo una instancia de
%                   cada elemento en <lista> que sí tenía repeticiones.
%---------------
depura([],[]).
depura([X|Resto],[X|Respuesta]) :- member(X,Resto),subtract([X|Resto],[_],Res), depura(Res,Respuesta),!.
depura([X|Resto],Respuesta) :- \+(member(X,Resto)), depura(Resto,Respuesta).

                % ---------------Problema 10--------------- %
%--------------- 
% [ ] máximo/2. Identificar el mayor valor de entre aquellos contenidos en una lista.
%     máximo(<lista>, <resultado>).
%       
%       Explicación: Verdadero si <resultado> es el mayor valor numérico contenido en
%                   <lista>. No todos los elementos necesitan ser numéricos.
%---------------
maximo(Lista,Numero_maximo):- filtrado_de_numeros(Lista , Lista_numeros ), max_list(Lista_numeros, Numero_maximo).

                % ---------------Problema 11--------------- %
%--------------- 
% [ ] anti_consonante/2. Elimina de una lista todos los elementos que sean consonantes o que tengan longitud mayor a una letra
%     anti_consonante(<lista>, <resultado>).
%       
%       Explicación: Verdadero si <resultado> es una lista con los mismos elementos que
%                   <lista> excepto aquellos elementos que sean consonantes del abecedario.
%---------------
anti_consonante([],[]).
anti_consonante([X|Resto],[X|Sin_consonantes]):- (X = a ; X = e ; X = i ; X = o ; X = u ; number(X)), anti_consonante(Resto,Sin_consonantes).
anti_consonante([X|Resto],Sin_consonantes):- \+(X = a ; X = e ; X = i ; X = o ; X = u ; number(X)), anti_consonante(Resto,Sin_consonantes).

                % ---------------Problema 12--------------- %
%--------------- 
%  [ ] vocales/2. Elimina de una lista todos los elementos que no sean vocales y como resultado se tendrán esas mismas vocales en mayúscula.
%     vocales(<lista>, <resultado>).
%       
%       Explicación: Verdadero si <resultado> es una lista conteniendo exclusivamente los
%                   elementos de <lista> que son vocales, en el mismo orden y número
%                   que en la lista original, pero representadas como mayúsculas.
%---------------
vocales([],[]).
vocales([X|Resto],[Y|Vocales]):- (X = a ; X = e ; X = i ; X = o ; X = u ), string_upper(X,Y),vocales(Resto,Vocales).
vocales([X|Resto],Vocales):- \+(X = a ; X = e ; X = i ; X = o ; X = u ), vocales(Resto,Vocales).

                % ---------------Problema 13--------------- %
%--------------- 
% [ ] cada_dos/2. Selecciona los elementos intercalados de la lista oringial a partir del tercer elemento.
%     cada_dos(<lista>, <resultado>).
%       
%       Explicación: Verdadero si <resultado> es una lista conteniendo exclusivamente los
%                   elementos intercalados de uno en uno, a partir del tercer elemento en <lista>.
%---------------
cada_dos(Lista,Resultado):- elimina_de_lista(Lista,2,R), dos_en_dos(R,Resultado).

/*
dos_en_dos/2. Recupera los elementos en posición impar de una lista.
dos_en_dos(<lista>,<respuesta>)

        Explicación: Verdadero si <respuesta> es una lista que contiene unicamente los elementos de <lista> en posicion n
                    donde n es impar.
*/ 
dos_en_dos([],[]):- !.
dos_en_dos([H|T],[H|T2]):- elimina_de_lista([H|T],2,T1),dos_en_dos(T1,T2).

/*
elimina_de_lista/3. Eliminar los primeros n elementos de una lista.
elimina_de_lista(<lista>,<n>,<respuesta>)

        Explicación: Verdadero si <respuesta> es el resultado de eliminar los primeros <n> elementos de <lista>.
*/ 
elimina_de_lista([],N,[]):- number(N), !.
elimina_de_lista(Lista,0,Lista):- !.
elimina_de_lista([_|Resto],N,L):-N>0, N2 is N-1 ,elimina_de_lista(Resto,N2,L).

                % ---------------Problema 14--------------- %
%--------------- 
% [ ] contexto/3. Identifica los elementos contexto de una posición indicada en una lista.
%     contexto(<lista>, <elemento>,<resultado>).
%       
%       Explicación: Verdadero si <resultado> es una lista conteniendo exclusivamente el
%                   elemento anterior y el posterior, en la lista original, de cada instancia de <elemento>.
%---------------
contexto([X],X,[[],[]]):- !.
contexto(Lista,Elem,Res):- nth1(Index, Lista, Elem), 
                            partir_lista(Lista,Index,L1,L2),
                            nextto(X,Elem,L1),
                            Res=[X,Y].

                % ---------------Problema 15--------------- %
%--------------- 
% [ ] particiona/3. Parte una lista en dos listas a partir de alguna posición en la lista inicial.
%     particiona(<lista>, <pos1>,<lista1>,<lista2>).
%       
%       Explicación: Verdadero si <lista1> y <lista2> son listas conteniendo los mismos
%                   elementos de <lista> separados a partir de la posición <pos1>
%                   considerando el primer elemento como en la posición 1.
%---------------
particiona(Lista,N,Res1,Res2):- N2 is N-1, partir_lista(Lista,N2,Res1,Res2).

/*
partir_lista/3. Parte una lista en dos listas a partir de alguna posición en la lista inicial.
partir_lista(<lista>, <pos1>,<lista1>,<lista2>).

        Explicación: Verdadero si <lista1> y <lista2> son listas conteniendo los mismos
                    elementos de <lista> separados a partir de la posición <pos1>
                    considerando el primer elemento como en la posición 0.
*/ 
partir_lista(Lista2,0,[],Lista2).
partir_lista([X|Resto],N,[X|Lista1],Lista2) :- N > 0, N1 is N - 1, partir_lista(Resto,N1,Lista1,Lista2).


