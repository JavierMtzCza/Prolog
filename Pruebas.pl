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

answer():-	Cartas = [
					'1☘','2☘','3☘','4☘','5☘','6☘','7☘','8☘','9☘','10☘','11☘','12☘','13☘',
					'1♠','2♠','3♠','4♠','5♠','6♠','7♠','8♠','9♠','10♠','11♠','12♠','13♠',
					'1♦','2♦','3♦','4♦','5♦','6♦','7♦','8♦','9♦','10♦','11♦','12♦','13♦',
					'1♥','2♥','3♥','4♥','5♥','6♥','7♥','8♥','9♥','10♥','11♥','12♥','13♥'
				],
				randseq(5,52,L),
				
            nth0(nth0(1,L,Y),Cartas,X),
				write(X).
%crear_random(X):- random(0,10,Z),
%						Z\==X, write(Z) ; write(Z), crear_random(X).