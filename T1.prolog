:-dynamic(lista/1).
:-retractall(lista(_)).
:-assert(lista([])).

sigue(a,b).
sigue(b,d).
sigue(d,h).
sigue(d,i).
sigue(b,e).
sigue(e,j).
sigue(e,k).
sigue(e,l).
sigue(a,c).
sigue(c,f).
sigue(f,m).
sigue(f,n).
sigue(c,g).
sigue(g,o).
sigue(o,p).
sigue(o,q).
sigue(o,r).

valor(h,6).
valor(i,7).
valor(j,9).
valor(k,3).
valor(l,5).
valor(m,4).
valor(n,3).
valor(p,5).
valor(q,4).
valor(r,2).

sucesores(E,S):- findall(Sucesores, sigue(E,Sucesores), S).

max(S):- member(S,[a,d,e,f,g]).
min(S):- member(S,[b,c,o]).

alpha_beta( Tree,Value,Estado) :- ab_minimax(Tree,-100,100,Value),once((sigue(Tree,Estado),lista(L),member(Estado-Value,L))).

ab_minimax(S,_,_,Value) :-valor(S,Value),guardar(S-Value),format('Nodo ~w con valor ~w~n',[S,Value]).
ab_minimax(S,Alpha,Beta,Value):-max(S),sucesores(S,Suc),ab_max_children(Suc,Alpha,Beta,-100,Value),guardar(S-Value),format('Nodo ~w con valor ~w~n',[S,Value]).
ab_minimax(S,Alpha,Beta,Value):-min(S),sucesores(S,Suc),ab_min_children(Suc,Alpha,Beta, 100,Value),guardar(S-Value),format('Nodo ~w con valor ~w~n',[S,Value]).


ab_max_children( [],_,_,Max,Max).
ab_max_children( [Child|Children],Alpha,Beta,Max0,Max):- ab_minimax( Child,Alpha,Beta,Value),
                                                                    ( greater( Value, Beta ) -> 
                                                                        Max = Beta,format('poda ~n',[])
                                                                        ; 
                                                                        ab_max(Value,Alpha,AlphaO), %Actualizamos alpha
                                                                        ab_max(Value,Max0,Max1),
                                                                        ab_max_children(Children,AlphaO,Beta,Max1,Max) 
                                                                    ).

ab_min_children( [],_, _,Min,Min).
ab_min_children( [Child|Children],Alpha,Beta,Min0,Min ) :- ab_minimax( Child,Alpha,Beta,Value),
                                                                    ( greater( Alpha, Value ) -> 
                                                                        Min = Alpha,format('poda ~n',[])
                                                                        ; 
                                                                        ab_min(Value,Beta,BetaO),
                                                                        ab_min(Value,Min0,Min1),
                                                                        ab_min_children( Children,Alpha,BetaO,Min1,Min) 
                                                                    ).

guardar(Estado-Val):-lista(L), append(L,[Estado-Val],R),retractall(lista(_)),assert(lista(R)).

ab_max(X,Y,Z):- greater(Y,X),!,Z=Y.
ab_max(X,_,X).

ab_max_s(X,_,Y,Sy,Z,Sy):- greater(Y,X),!,Z=Y.
ab_max_s(X,Sx,_,_,X,Sx).

ab_min(X,Y,Z):- greater(X,Y),!,Z=Y.
ab_min(X,_,X).

ab_min_s(X,_,Y,Sy,Z,Sy):- greater(X,Y),!,Z=Y.
ab_min_s(X,Sx,_,_,X,Sx).

greater(_,-100).
greater(100,_).
greater(-100,_):- ! , fail.
greater(_,100):- !, fail.
greater(A,B) :- A > B.