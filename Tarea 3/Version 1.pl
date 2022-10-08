
% casa(color,país)

visualiza_vecindario(V):-	V=[_,_,_], 
							junto_a(casa(_,"español"),casa(roja,_),V),
							member(casa(azul,noruego),V),
							V=[_,casa(_,italiano),_].

junto_a(Casa1,Casa2,Lista):-  append(_, [Casa1,Casa2|_], Lista).
junto_a(Casa1,Casa2,Lista):-  append(_, [Casa2,Casa1|_], Lista).

