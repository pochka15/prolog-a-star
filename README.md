# Prolog A* algorithm

## Predicates

- **start_A_star**(InitState, PathCost)
- **search_A_star**(Queue, ClosedSet, PathCost) is a main function
- **fetch**(Node, Queue, ClosedSet , RestQueue) takes the first node from the Queue
- **expand**(Node, ChildNodes) generates child nodes
- **insert_new_nodes**(NodesToInsert, InQueue, OutQueue) inserts into the InQueue
- **insert_p_queue**(Node, PriorityQueue, OutQueue) inserts into the priority queue (called by insert_new_nodes)
- **continue**(Node, Queue, ClosedSet, Path) is called inside the search_A_star(). It checks if the given Node satisfies the goal and goes on if not.
- **score**(State, ParentCost, StepCost, Cost, FScore) calculates f (FScore) and g (Cost); *(f = h + g)*
- **build_path**(Node, ClosedSet, PathSoFar, Path)
- **del**(List, Element, OutList) deletes a first occurence of the *Element* in the *List*

## Structures

- **node**(State, Action, PreviousState, ActualCost, FCost)\
    FCost - ocena według funkcji f

## Some graph visualizations of function calls and facts

- [Diagrams.net](https://drive.google.com/file/d/1jFAwxYKgoOpynddCwh-978AElifYfKYl/view?usp=sharing)

## Auxillary information

### How to run the code in the vscode

- [Youtube tutorial](https://youtu.be/jvZ7XLK1fy0)\
  *Note: It's better to install [VSC-Prolog](https://github.com/arthwang/vsc-prolog.git) vscode extension*
