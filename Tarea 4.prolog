
%sucesor(a,b).
sucesor(a,c).
sucesor(b,d).
sucesor(b,e).
sucesor(d,h).
sucesor(e,i).
sucesor(e,j).
sucesor(c,f).
sucesor(c,g).
sucesor(f,k).


%Solo funciona en arboles porque le indicamos el nodo origen y solo busca sucesores directos
ruta(Nodo, Nodo, [Nodo]).
ruta(Inicio, Nodo_goal, [Nodo_goal|Ruta]):- ruta(Inicio , Penultimo_nodo , Ruta),
                                            sucesor(Penultimo_nodo, Nodo_goal),
                                            \+ member(Nodo_goal,Ruta).    

busqueda_iterativa_profunda(Inicio,Solucion):- ruta(Inicio, Goal, R),
                                                    (Goal=c ; Goal=b),
                                                    reverse(R,Solucion).

