
%de(1,Treboles).
%de(1,corazones).
%de(1,picas).
%de(2,Treboles).
%de(2,corazones).
%de(2,picas).
%de(3,Treboles).
%de(3,corazones).
%de(3,picas).

corazones(1).
corazones(2).
corazones(3).

diamantes(1).
diamantes(2).
diamantes(3).

%checar:- 1=:=1.

%main:-  ,
%        write('Hola mundo'),
%        nl,
        %write('escribe el numero de integrantes'),
        %nl,
        %read(Integrantes),
        %random(1,3,X),
        %answer(Integrantes,Treboles).

answer():- Treboles = ['4☘','5☘','6☘','7☘','8☘','9☘'], 
           write(random_member(1,Treboles)),
           write(random_member(2,Treboles)),nl,
           write(random_member(3,Treboles)),nl,
           write(random_member(4,Treboles)),nl.


generar_random():- random(1,6,X),random(1,6,Y),Y=\=X,
        write(Y),
        write(X).

%member(Integrantes,Treboles)