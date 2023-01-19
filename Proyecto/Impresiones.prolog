%--------------- 
% imp_tablero_global/0. Imprimir en pantalla el tablero global.
%---------------
imp_tablero_global():-tablero_global(Tab_Global),imp_Fila_Grande(Tab_Global,5,5,1).

%--------------- 
% imp_tablero_global/2. Imprimir en pantalla el tablero global y remarcar el tablero que se estará jugando.
%     imp_tablero_global(+Fila,+Columna).
%       
%       Explicación: Verdadero si se imprime en pantalla con otro color el tablero en la <Fila> y <Columna> seleccionados.
%---------------
imp_tablero_global_juego(Fil,Col):-tablero_global(Tab_Global),imp_Fila_Grande(Tab_Global,Fil,Col,1),
                                    obtener_tablero(Fil-Col,Tablero-_),imp_tablero(Tablero).

imp_Fila_Grande([[A-_,B-_,C-_]],Fil,Col,I):- ( I=Fil-> imp_Fila_Chica(A,B,C,Col) ; imp_Fila_Chica(A,B,C,0)),!.
imp_Fila_Grande([[A-_,B-_,C-_]|Resto],Fil,Col,I):- ( I=Fil-> imp_Fila_Chica(A,B,C,Col) ; imp_Fila_Chica(A,B,C,0)),
                                format('~n~t~8| ════════════╬═════════════╬═════════════ '),I1 is I+1,imp_Fila_Grande(Resto,Fil,Col,I1).

imp_Fila_Chica([L1],[L2],[L3],Col):- nl,(Col>0 -> imp_Fila_Tab([L1,L2,L3],Col,1); imp_Fila_Tab([L1,L2,L3])),!.
imp_Fila_Chica([L1|R1],[L2|R2],[L3|R3],Col):- nl,(Col>0 ->
                                                    imp_Fila_Tab([L1,L2,L3],Col,1),format('~n~t~8| '),imp_Conectores(Col,1)
                                                    ; 
                                                    imp_Fila_Tab([L1,L2,L3]),format('~n~t~8| ───┼───┼─── ║ ───┼───┼─── ║ ───┼───┼───')
                                                ),imp_Fila_Chica(R1,R2,R3,Col).

imp_Elem([],_):-!.
imp_Elem([A,B,C],N):-( N=0 -> format('~t~8|  ~w | ~w | ~w  ',[A,B,C]) ; ansi_format([bold,fg(green)],'~t~8|  ~w | ~w | ~w  ',[A,B,C]) ).

imp_Conectores(Col,3):- (Col=3 -> ansi_format([bold,fg(green)],'───┼───┼───  ',[]) ;  format('───┼───┼───  ')),!.
imp_Conectores(Col,N):- (Col=N -> ansi_format([bold,fg(green)],'───┼───┼─── ',[]),write('║ ') ; format('───┼───┼─── ║ ')),
                N1 is N+1,imp_Conectores(Col,N1).

imp_Fila_Tab([Fila]):- imp_Elem(Fila,0),!.
imp_Fila_Tab([Fila|Resto]):- imp_Elem(Fila,0),write('║'),imp_Fila_Tab(Resto).

imp_Fila_Tab([Fila],Col,N):- ( N=Col-> imp_Elem(Fila,1) ; imp_Elem(Fila,0)),!.
imp_Fila_Tab([Fila|Resto],Col,N):- ( N=Col-> imp_Elem(Fila,1) ; imp_Elem(Fila,0)), write('║'),N1 is N+1,imp_Fila_Tab(Resto,Col,N1).
 
%--------------- 
% imp_tablero_global/1. Imprimir en pantalla un tablero pequeño.
%     imp_tablero_global(+Tablero).
%---------------
imp_tablero(Tablero):-format('~n~n~t~2| -----Seleccione la casilla en donde desee jugar-----'),
                        ansi_format([bold,fg(green)],'~n~t~20|    1   2   3  ',[]),imp(Tablero,1),
                        nl,nl,write(' --> Para seleccionar la casilla, hágalo de la forma fila-columna.'),
                        ansi_format([bold,fg(blue)],' Ejemplo: 2-3. ~n',[]).

imp([[L1,L2,L3]],N):- N=3,ansi_format([bold,fg(green)],'~n~t~20| ~w  ~w | ~w | ~w ',[N,L1,L2,L3]),!.
imp([[L1,L2,L3]|Resto],N):- ansi_format([bold,fg(green)],'~n~t~20| ~w  ~w | ~w | ~w ',[N,L1,L2,L3]),
                                ansi_format([bold,fg(green)],'~n~t~20|   ───┼───┼───',[]),
                                N2 is N+1,imp(Resto,N2).

%--------------- 
% impresion_elegir_tablero/0. Imprimir el tablero global con coordenadas.
%     impresion_elegir_tablero(0).
%---------------
impresion_elegir_tablero():-tablero_global([ [[[A1,A2,A3],[A4,A5,A6],[A7,A8,A9]]-_,[[B1,B2,B3],[B4,B5,B6],[B7,B8,B9]]-_,[[C1,C2,C3],[C4,C5,C6],[C7,C8,C9]]-_],
                            [[[D1,D2,D3],[D4,D5,D6],[D7,D8,D9]]-_,[[E1,E2,E3],[E4,E5,E6],[E7,E8,E9]]-_,[[F1,F2,F3],[F4,F5,F6],[F7,F8,F9]]-_],
                            [[[G1,G2,G3],[G4,G5,G6],[G7,G8,G9]]-_,[[H1,H2,H3],[H4,H5,H6],[H7,H8,H9]]-_,[[I1,I2,I3],[I4,I5,I6],[I7,I8,I9]]-_]]),
            format('~n~t~8|         1             2            3'),
            format('~n~t~8| ┼────────────────────────────────────────── '),
            format('~n~t~8| | ~t~11|  ~w | ~w | ~w  ║  ~w | ~w | ~w  ║  ~w | ~w | ~w ',[A1,A2,A3,B1,B2,B3,C1,C2,C3]),
            format('~n~t~8| | ~t~11| ───┼───┼─── ║ ───┼───┼─── ║ ───┼───┼───'),
            format('~n~t~7|1 | ~t~11|  ~w | ~w | ~w  ║  ~w | ~w | ~w  ║  ~w | ~w | ~w ',[A4,A5,A6,B4,B5,B6,C4,C5,C6]),
            format('~n~t~8| | ~t~11| ───┼───┼─── ║ ───┼───┼─── ║ ───┼───┼───'),
            format('~n~t~8| | ~t~11|  ~w | ~w | ~w  ║  ~w | ~w | ~w  ║  ~w | ~w | ~w ',[A7,A8,A9,B7,B8,B9,C7,C8,C9]),
            format('~n~t~8| | ═════════════╬═════════════╬═════════════ '),
            format('~n~t~8| | ~t~11|  ~w | ~w | ~w  ║  ~w | ~w | ~w  ║  ~w | ~w | ~w ',[D1,D2,D3,E1,E2,E3,F1,F2,F3]),
            format('~n~t~8| | ~t~11| ───┼───┼─── ║ ───┼───┼─── ║ ───┼───┼───'),
            format('~n~t~7|2 | ~t~11|  ~w | ~w | ~w  ║  ~w | ~w | ~w  ║  ~w | ~w | ~w ',[D4,D5,D6,E4,E5,E6,F4,F5,F6]),
            format('~n~t~8| | ~t~11| ───┼───┼─── ║ ───┼───┼─── ║ ───┼───┼───'),
            format('~n~t~8| | ~t~11|  ~w | ~w | ~w  ║  ~w | ~w | ~w  ║  ~w | ~w | ~w ',[D7,D8,D9,E7,E8,E9,F7,F8,F9]),
            format('~n~t~8| | ═════════════╬═════════════╬═════════════ '),
            format('~n~t~8| | ~t~11|  ~w | ~w | ~w  ║  ~w | ~w | ~w  ║  ~w | ~w | ~w ',[G1,G2,G3,H1,H2,H3,I1,I2,I3]),
            format('~n~t~8| | ~t~11| ───┼───┼─── ║ ───┼───┼─── ║ ───┼───┼───'),
            format('~n~t~7|3 | ~t~11|  ~w | ~w | ~w  ║  ~w | ~w | ~w  ║  ~w | ~w | ~w ',[G4,G5,G6,H4,H5,H6,I4,I5,I6]),
            format('~n~t~8| | ~t~11| ───┼───┼─── ║ ───┼───┼─── ║ ───┼───┼───'),
            format('~n~t~8| | ~t~11|  ~w | ~w | ~w  ║  ~w | ~w | ~w  ║  ~w | ~w | ~w ',[G7,G8,G9,H7,H8,H9,I7,I8,I9]).
            