

% constraints

/* search graph root node */
start([3, 3, 0]).

/* search graph terminal node */
goal([0, 0, 1]).

/* enforces state constraints */
valid_state(CL, ML, B) :-
% check values are integers in range
(CL is 0 ; CL is 1 ; CL is 2 ; CL is 3),
(ML is 0 ; ML is 1 ; ML is 2 ; ML is 3),
(B is 0 ; B is 1),
% check cannibals not converted
(CL is 0 ; CL >= ML),
(CL is 3 ; CL =< ML),
% check boat not autonomous
\+ (B is 0, 0 is CL + ML),
\+ (B is 1, 6 is CL + ML).

/* enforces transition rules/constraints */
valid_trans(CL, CLs, ML, MLs, B, Bs) :-
% just one
(CLs is CL, MLs is ML + 1, B is 1, Bs is 0) ;
(CLs is CL, MLs is ML - 1, B is 0, Bs is 1) ;
(CLs is CL + 1, MLs is ML, B is 1, Bs is 0) ;
(CLs is CL - 1, MLs is ML, B is 0, Bs is 1) ;
% two of same
(CLs is CL, MLs is ML + 2, B is 1, Bs is 0) ;
(CLs is CL, MLs is ML - 2, B is 0, Bs is 1) ;
(CLs is CL + 2, MLs is ML, B is 1, Bs is 0) ;
(CLs is CL - 2, MLs is ML, B is 0, Bs is 1) ;
% one of each
(CLs is CL + 1, MLs is ML + 1, B is 1, Bs is 0) ;
(CLs is CL - 1, MLs is ML - 1, B is 0, Bs is 1).

/* generates all state space successors which hold under constraints */
successor([CL, ML, B],[CLs, MLs, Bs]) :-valid_state(CLs, MLs, Bs),valid_trans(CL, CLs, ML, MLs, B, Bs).

/* recrusive depth-first search call */
depth_first(Path, Node, Sol) :-successor(Node, Node1),\+ member(Node1,Path),depth_first([Node|Path], Node1, Sol).

/* goal found - terminal tail call */
depth_first(Path, Node, [Node| Path]):- goal(Node).
/* initiate dfs graph search for path from start node to goal node */
depth_first(Path) :-start(Node),depth_first([], Node , Path).


/* generate all valid extensions of a path by a single state */
extend([Node|Path], NewPaths):-
findall([NewNode, Node|Path],
(successor(Node, NewNode), \+member(NewNode, [Node|Path])),
NewPaths).

/* recusrive depth-first graph search call */
breadth_first([Path|Paths], Sol):-extend(Path, NewPaths),append(Paths, NewPaths, Paths1),breadth_first(Paths1, Sol).
/* goal found - terminal tail call */
breadth_first([[Node|Path]|_], [Node | Path]) :- goal(Node).
/* initiate bfs graph search for path from start node to goal node */
breadth_first(Path) :-start(Start),breadth_first([[Start]], Path),  print_term(Path,[]).