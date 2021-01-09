# Prolog A* algorithm

## Closures

- **start_A_star**(InitState, PathCost, N, MaxStep)
- **search_A_star**(Queue, ClosedSet, PathCost, N, Step, MaxStep) is a main function
- **expand**(Node, ChildNodes) generates child nodes
- **insert_new_nodes**(NodesToInsert, InQueue, OutQueue) inserts into the InQueue
- **insert_p_queue**(Node, PriorityQueue, OutQueue) inserts into the priority queue (called by insert_new_nodes)
- **continue**(Node, Queue, ClosedSet, Path) is called inside the search_A_star(). It checks if the given Node satisfies the goal and goes on if not.
- **score**(State, ParentCost, StepCost, Cost, FScore) calculates f (FScore) and g (Cost); *(f = h + g)*
- **build_path**(Node, ClosedSet, PathSoFar, Path)
- **del**(List, Element, OutList) deletes a first occurence of the *Element* in the *List*

### New Closures

- **fetch_node_using_choice_list**(Node, Order, Queue, ClosedSet, RestQueue) fetches the node from the queue at the position that is provided in the Order. The first position will be taken from the Order[0].
- **fetch_nth_node_non_existing_in_closedset**(FetchedNode, Queue, ClosedSet, RestQueue, N) fetches the node from the queue at the Nth position starting from the index 1. If the node at the given postion exists in the ClosedSet then it skips this node.
- **get_nodes_order**(Order, Queue, ClosedSet, N) prints first N nodes from the queue that don't exist in the ClosedSet and read the ChoiceList of node postions from the user.
- **fetch_n_nodes**(Nodes, Queue, ClosedSet, N) returns in Nodes all the first N nodes fetched from the queue that don't exist in the ClosedSet.
- **fetch_node**(Node, Queue, ClosedSet, RestQueu, N) is auxillary closure that is used by fetch_n_nodes
- **should_increase_limit** reads the response from the user. If users says 'yes' then it returns with the success.

## Structures

- **node**(State, Action, PreviousState, ActualCost, FCost)\
    FCost - cost according to the F function
- **path_cost(Path, Cost)**

## Some graph visualizations of function calls and facts

- [Diagrams.net (there are 2 pages explaining closures dependencies and an example states graph)](https://drive.google.com/file/d/1jFAwxYKgoOpynddCwh-978AElifYfKYl/view?usp=sharing)
