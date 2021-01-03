start_A_star( InitState, PathCost, N, MaxStep) :-
	score(InitState, 0, 0, InitCost, InitScore),
	search_A_star([node(InitState, nil, nil, InitCost , InitScore )],
                    [ ], PathCost, N, 0, MaxStep).


search_A_star(Queue, ClosedSet, PathCost, N, Step, MaxStep) :-
    Step < MaxStep,
    format('~nCurrent step: ~w,~nFeasible steps: ~w~n', [Step, MaxStep]), nl,
    get_nodes_order(Order, Queue, ClosedSet, N),
    fetch_node_using_choice_list(Node, Order, Queue, ClosedSet, RestQueue),
	continue(Node, RestQueue, ClosedSet, PathCost, N, Step, MaxStep).

search_A_star(Queue, ClosedSet, PathCost, N, Step, MaxStep) :-
    Step = MaxStep,
    format('~nCurrent step: ~w,~nFeasible steps: ~w~n', [Step, MaxStep]), nl,
    should_increase_limit,
    NewMaxStep is MaxStep + 1,
    search_A_star(Queue, ClosedSet, Path, N, Step, NewMaxStep).


continue(node(State, Action, Parent, Cost, _ ) , _  ,  ClosedSet,
		path_cost(Path, Cost) , N , Step, MaxStep) :-
	        goal( State), ! ,
	        build_path(node(Parent, _ ,_ , _ , _ ) , ClosedSet, [Action/State], Path).

continue(Node, RestQueue, ClosedSet, Path, N, Step, MaxStep) :-
	expand( Node, NewNodes),
	insert_new_nodes(NewNodes, RestQueue, NewQueue),
    NextStep is Step + 1,
	search_A_star(NewQueue, [Node | ClosedSet ], Path, N, NextStep, MaxStep).


fetch_n_nodes(Nodes, Queue, ClosedSet, N) :-
    findall(Node, fetch_node(Node, Queue, ClosedSet, _, N), Nodes).


/* gdy n >= 1 wyciągamy pierwszy węzeł z kolejki 
gdy nie należy do zbioru węzłów przetworzonych, zwraca węzeł*/
fetch_node(node(State, Action,Parent, Cost, Score), 
            [node(State, Action,Parent, Cost, Score) | RestQueue],
            ClosedSet, RestQueue, N) :-
                N >= 1,
                not(member(node(State, _, _, _, _), ClosedSet)).

/* gdy węzeł jest już przetowrzony, to rekurencyjnie szukamy dalej w kolejce,
zwraca węzeł */
fetch_node(Node, [node(State, Action,Parent, Cost, Score) | RestQueue],
            ClosedSet, NewQueue, N) :-
                N >= 1,
                member(node(State, _, _, _, _), ClosedSet),
                fetch_node(Node, RestQueue, ClosedSet, NewQueue, N).

/* wymuszenie dekrementacji n */
fetch_node(Node, [_ | RestQueue],
            ClosedSet, NewQueue, N) :-
                N > 1,
                M is N - 1,
                fetch_node(Node, RestQueue, ClosedSet, NewQueue, M).


/* gdy n == 1 to zwróć pierwszy element z kolejki */
fetch_nth_node(node(State, Action, Parent, Cost, Score),
            [node(State, Action,Parent, Cost, Score) | RestQueue],
            ClosedSet, RestQueue, 1).

/* gdy N jest > 1 szukaj tego węzła głębiej */
fetch_nth_node(Node,
            [node(State, Action,Parent, Cost, Score) | RestQueue],
            ClosedSet, 
            [node(State, Action,Parent, Cost, Score) | NewQueue], N) :- 
                N > 1,
                M is N - 1,
                fetch_nth_node(Node, RestQueue, ClosedSet, NewQueue, M).

/* wybierz węzeł na który wskazuje pierwszy element z listy wyboru */
fetch_node_using_choice_list(Node, [N | _], Queue, ClosedSet, RestQueue) :-
    fetch_nth_node(Node, Queue, ClosedSet, RestQueue, N).

/*kolejny element z listy wyboru przy nawrocie */
fetch_node_using_choice_list(Node, [_ | RestChoiceList], Queue, ClosedSet, RestQueue) :-
    fetch_node_using_choice_list(Node, RestChoiceList, Queue, ClosedSet, RestQueue).


expand(node(State, _ ,_ , Cost, _ ), NewNodes)  :-
	findall(node(ChildState, Action, State, NewCost, ChildScore) ,
			(succ(State, Action, StepCost, ChildState),
			    score(ChildState, Cost, StepCost, NewCost, ChildScore) ),
            NewNodes).


score(State, ParentCost, StepCost, Cost, FScore)  :-
	Cost is ParentCost + StepCost ,
	hScore(State, HScore),
	FScore is Cost + HScore.


insert_new_nodes( [ ], Queue, Queue).

insert_new_nodes( [Node|RestNodes], Queue, NewQueue) :-
	insert_p_queue(Node, Queue, Queue1),
	insert_new_nodes( RestNodes, Queue1, NewQueue).


insert_p_queue(Node,  [ ], [Node] ) :- !.

insert_p_queue(node(State, Action, Parent, Cost, FScore),
		[node(State1, Action1, Parent1, Cost1, FScore1) | RestQueue],
		[node(State1, Action1, Parent1, Cost1, FScore1)|Rest1] )  :-
	        FScore >= FScore1,  ! ,
	        insert_p_queue(node(State, Action, Parent, Cost, FScore), RestQueue, Rest1) .

insert_p_queue(node(State, Action, Parent, Cost, FScore),  Queue,
				[node(State, Action, Parent, Cost, FScore)|Queue]).


build_path(node(nil, _, _, _, _ ), _, Path, Path) :- !.

build_path(node(EndState, _ , _ , _, _ ), Nodes, PartialPath, Path)  :-
	del(Nodes, node(EndState, Action, Parent , _ , _  ) , Nodes1),
	build_path( node(Parent,_ ,_ , _ , _ ) , Nodes1,
				[Action/EndState|PartialPath],Path).


del([X|R],X,R).
del([Y|R],X,[Y|R1]) :-
	X\=Y,
	del(R,X,R1).

/* czy limit powninien zostać zwiększony */
should_increase_limit :- 
    write('Do you want to increase limit? (yes/no)'), nl,
    read(Response),
    Response = 'yes'.

/* wypisuje n pierwszych węzłów  z kolejki i pobiera listę wyboru od użytkownika */
get_nodes_order(Order, Queue, ClosedSet, N) :-
    fetch_n_nodes(Nodes, Queue, ClosedSet, N),
    format('First ~w nodes from the queue:', [N]), nl, nl,
    write(Nodes), nl,
    read(Order).


    
succ(a,ab,1,b).
succ(b,bd,3,d).
succ(a,ac,2,c).
succ(d,de,4,e).
succ(c,ce,5,e).

goal(e).

hScore(a,7).
hScore(b,5).
hScore(c,3).
hScore(d,2).
hScore(e,0).

