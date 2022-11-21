:-dynamic(estado/1).
:-assert(estado([[v,v,v],[v,v,v],[v,v,v]])).

cambiar():- retractall(estado(_)),
            Edo_actualizado = [[x,v,v],
                               [v,v,v],
                               [x,o,v]],
            assert(estado(Edo_actualizado)),
            print_term(Edo_actualizado, []).

jugar(X,Res):-estado(Edo),jugada(X,Edo,Res).

jugada(X,[Fila|Resto],[Fila_mod|Resto]) :- eleccion_fila(X,Fila,Fila_mod).
jugada(X,[Fila|Resto],[Fila|Resto1]) :- jugada(X,Resto,Resto1).

eleccion_fila(X,[v|Posiciones],[X|Posiciones]).
eleccion_fila(X,[Y|Posiciones],[Y|Resto]) :- eleccion_fila(X,Posiciones,Resto).

gano(Jugador,Win) :- estado(Edo),member([Jugador,Jugador,Jugador],Edo),Win=Edo.
gano(Jugador,Win) :- estado(Edo),traspuesta(Edo,Tran),member([Jugador,Jugador,Jugador],Tran),Win=Edo.
gano(Jugador,Win) :- estado(Edo),Edo=[[Jugador,_,_],[_,Jugador,_],[_,_,Jugador]],Win=Edo.
gano(Jugador,Win) :- estado(Edo),Edo=[[_,_,Jugador],[_,Jugador,_],[Jugador,_,_]],Win=Edo.

traspuesta([[]|_],[]).
traspuesta(M,[C|T]) :- separar(M,C,MT),traspuesta(MT,T).

separar([[X|F]|M],[X|C],[F|MT]) :- separar(M,C,MT).
separar([],[],[]).


j(X,Y,R):- estado(Edo),jugada_ganadora(X,Y,Edo,R).

jugada_ganadora(X,Y,M,R) :- not(gano(Y,M)), jugada(X,M,R), pos_ganadora(X,Y,R).

pos_ganadora(X,_,R) :- gano(X,R).
pos_ganadora(X,Y,R) :- not(salvacion(Y,X,R)).

salvacion(Y,_,R) :- not(jugada(Y,R,_)).
salvacion(Y,X,R) :- jugada(Y,R,S),not(jugada_ganadora(X,Y,S,_)).