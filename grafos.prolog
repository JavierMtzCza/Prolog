%arco(a,b).
%arco(a,f).
%arco(b,c).
%arco(c,d).
%arco(c,e).
%arco(e,d).
%arco(f,c).
%arco(f,e).
%arco(f,g).
%arco(g,c).
%arco(e,a).
%arco(b,b).
%arco(d,g).
%
%rutaH(A,B,R):- navegar(A,B,[],R).
%navegar(A,A,_,[A]).
%navegar(A,B,_,[A,B]):- A \== B, arco(A,B).
%navegar(A,B,Mem,[A|Ruta]):- A \== B, arco(A,Z), Z \== B, \+member(Z,Mem), navegar(Z,B,[Z|Mem],Ruta).
%
%calcula_rutas(A,B,Rutas):- findall(R,rutaH(A,B,R),Rutas).
%
%mejor_ruta(A,B,Mejor):-findall(R,rutaH(A,B,R),Rutas), ruta_corta(Rutas,Mejor).
%ruta_corta([R],R).
%ruta_corta(Rutas,R):- maplist(length,Rutas,Len),min_list(Len,Min),member(R,Rutas), length(R,Min).

%% GRAFO BIDIRECCIONAL

arco(a,b,1).
arco(a,c,8).
arco(b,a,3).
arco(b,d,2).
arco(b,b,4).
arco(c,c,2).
arco(c,e,1).
arco(c,a,6).
arco(d,d,5).
arco(d,b,7).
arco(d,e,9).
arco(e,d,11).
arco(e,c,3).


ruta_corta(A,B,Mejor):- calcula_rutas(A,B,Rutas),
                        obtener_valores(Rutas,Pesos),
                        min_list(Pesos,Min),
                        findall(R-Min,navegar(A,B,[],R-Min),Mejor).

obtener_valores([],[]).
obtener_valores([_-P|Resto],[P|Pesos]):- obtener_valores(Resto,Pesos).

calcula_rutas(A,B,Rutas):-  . 

navegar(A,A,_,[A]-0):- \+arco(A,A,_).
navegar(A,A,_,[A]-Peso):- arco(A,A,Peso).
navegar(A,B,_,[A,B]-Peso):- A \== B, arco(A,B,Peso).
navegar(A,B,Memoria,[A|Ruta]-Peso):-   A \== B, 
                                       arco(A,Z,Peso1),
                                       Z \== B, 
                                       \+member(Z,Memoria), 
                                       navegar(Z,B,[Z|Memoria],Ruta-Peso2), 
                                       Peso is Peso1+Peso2.

