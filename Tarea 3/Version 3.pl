
% casa(color,país,mascota,deporte)

visualiza_vecindario(V):-	V=[_,_,_,_],
                            dos_casas(casa(_,_,_,bolichista),casa(_,_,_,nadador),V),
                            casa_intermedia(casa(_,"irlandés",_,_),casa(_,_,_,volleyball),V),
                            V=[_,casa(negra,_,_,_),_,_],
                            casa_intermedia(casa(_,_,caballos,_),casa(roja,_,_,_),V),
                            junto_a(casa(_,"escocés",_,_),casa(_,_,tortugas,_),V),
                            dos_casas(casa(_,_,caballos,_),casa(_,_,mariposas,_),V),
                            después_de(casa(_,_,_,bolichista),casa(_,_,_,tenista),V),
                            casa_intermedia(casa(_,_,_,volleyball),casa(blanca,_,_,_),V),
                            V=[casa(_,ruso,_,_),_,_,_].


junto_a(Casa1,Casa2,Lista):-  append(_, [Casa1,Casa2|_], Lista).
junto_a(Casa1,Casa2,Lista):-  append(_, [Casa2,Casa1|_], Lista).

casa_intermedia(Casa1,Casa2,Lista):-  append(_, [Casa1,_,Casa2|_], Lista).
casa_intermedia(Casa1,Casa2,Lista):-  append(_, [Casa2,_,Casa1|_], Lista).

dos_casas(Casa1,Casa2,Lista):-  append(_, [Casa1,_,_,Casa2|_], Lista).
dos_casas(Casa1,Casa2,Lista):-  append(_, [Casa2,_,_,Casa1|_], Lista).

después_de(Casa1,Casa2,Lista):-  append(_, [Casa1|Resto], Lista), member(Casa2,Resto).
