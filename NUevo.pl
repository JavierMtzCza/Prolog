treboles('1☘').
treboles('2☘').
treboles('3☘').
treboles('4☘').
treboles('5☘').
treboles('6☘').
treboles('7☘').
treboles('8☘').
treboles('9☘').
treboles('10☘').
treboles('11☘').
treboles('12☘').
treboles('13☘').

picas('1♠').
picas('2♠').
picas('3♠').
picas('4♠').
picas('5♠').
picas('6♠').
picas('7♠').
picas('8♠').
picas('9♠').
picas('10♠').
picas('11♠').
picas('12♠').
picas('13♠').

diamantes('1♦').
diamantes('2♦').
diamantes('3♦').
diamantes('4♦').
diamantes('5♦').
diamantes('6♦').
diamantes('7♦').
diamantes('8♦').
diamantes('9♦').
diamantes('10♦').
diamantes('11♦').
diamantes('12♦').
diamantes('13♦').

corazones('1♥').
corazones('2♥').
corazones('3♥').
corazones('4♥').
corazones('5♥').
corazones('6♥').
corazones('7♥').
corazones('8♥').
corazones('9♥').
corazones('10♥').
corazones('11♥').
corazones('12♥').
corazones('13♥').

palo(corazones).
palo(treboles).
palo(diamantes).
palo(picas).

sonnegras(X):- picas(X) ; treboles(X).
sonrojas(Y):- diamantes(Y) ; corazones(Y).

mismopalo(X,Y,Z,O,P):- (corazones(X),corazones(Y),corazones(Z),corazones(O),corazones(P)) ; (diamantes(X),diamantes(Y),diamantes(Z),diamantes(O),diamantes(P)) ; (picas(X),picas(Y),picas(Z),picas(O),picas(P)) ; (treboles(X),treboles(Y),treboles(Z),treboles(O),treboles(P)). 

escalerareal([A]):-  ('1☘'=A;'10☘'=A;'11☘'=A;'12☘'=A;'13☘'=A);('1♠'=A;'10♠'=A;'11♠'=A;'12♠'=A;'13♠'=A). 

%escalerareal(['1☘','10☘','11☘','12☘','13☘']).

es(X):- '1☘' = X.
