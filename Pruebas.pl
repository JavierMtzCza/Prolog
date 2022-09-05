
%de(1,treboles).
%de(1,corazones).
%de(1,picas).
%de(2,treboles).
%de(2,corazones).
%de(2,picas).
%de(3,treboles).
%de(3,corazones).
%de(3,picas).

treboles(1).
treboles(2).
treboles(3).

corazones(1).
corazones(2).
corazones(3).

diamantes(1).
diamantes(2).
diamantes(3).

checar:- 1=:=1.

listar:- var(lista=[1,2,3]).

main:- write('Hola mundo'),
        nl,
        