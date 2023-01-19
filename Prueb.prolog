%   juntar( [1,2,3|B]-B , [4,5] , Z )
ldif(A-B,B,A).

formato_ldif([],[]-_).
formato_ldif([X],[X|Y]-Y):-!.
formato_ldif([X|Y],L):-append1([X|Y],A,Z), L=Z-A.

concatenar_ldif([],L,L):-!.
concatenar_ldif(L1,L2,R):-formato_ldif(L1,LD), ldif(LD,L2,R).

append1([],L,L).
append1([H|T],L,[H|R]):- append1(T,L,R).
