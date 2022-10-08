
% casa(color,país,mascota,deporte)

vecindario(V):-	V=[_,_,_],
                (V=[casa(_,"brasileño",_,_),_,_];V=[_,_,casa(_,"brasileño",_,_)]),
				member(casa(_,_,perros,baloncesto),V),
                intermedia_a(casa(_,_,_,"fútbol"),casa(roja,_,_,_),V),
                junto_a(casa(_,_,peces,_),casa(_,_,gatos,_),V),
                junto_a(casa(_,_,perros,_),casa(verde,_,_,_),V),
                V=[_,_,casa(_,"alemán",_,_)].
				

junto_a(Casa1,Casa2,Lista):-  append(_, [Casa1,Casa2|_], Lista).
junto_a(Casa1,Casa2,Lista):-  append(_, [Casa2,Casa1|_], Lista).

intermedia_a(Casa1,Casa2,Lista):-  append(_, [Casa1,_,Casa2|_], Lista).
intermedia_a(Casa1,Casa2,Lista):-  append(_, [Casa2,_,Casa1|_], Lista).