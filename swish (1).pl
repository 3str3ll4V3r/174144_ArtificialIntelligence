% Initial and goal configurations
initial_configuration([3,3,left,0,0]).
goal_configuration([0,0,right,3,3]).

% Check the legality of a configuration
is_legal(CL, ML, CR, MR) :-
    ML >= 0, CL >= 0, MR >= 0, CR >= 0,
    (ML >= CL ; ML = 0),
    (MR >= CR ; MR = 0).

% Define all possible movements
perform_movement([CL, ML, left, CR, MR], [CL, ML2, right, CR, MR2]) :-
    % Move two missionaries from left to right
    MR2 is MR + 2, ML2 is ML - 2, is_legal(CL, ML2, CR, MR2).

perform_movement([CL, ML, left, CR, MR], [CL2, ML, right, CR2, MR]) :-
    % Move two cannibals from left to right
    CR2 is CR + 2, CL2 is CL - 2, is_legal(CL2, ML, CR2, MR).

perform_movement([CL, ML, left, CR, MR], [CL2, ML2, right, CR2, MR2]) :-
    % Move one missionary and one cannibal from left to right
    CR2 is CR + 1, CL2 is CL - 1, MR2 is MR + 1, ML2 is ML - 1, is_legal(CL2, ML2, CR2, MR2).

perform_movement([CL, ML, left, CR, MR], [CL, ML2, right, CR, MR2]) :-
    % Move one missionary from left to right
    MR2 is MR + 1, ML2 is ML - 1, is_legal(CL, ML2, CR, MR2).

perform_movement([CL, ML, left, CR, MR], [CL2, ML, right, CR2, MR]) :-
    % Move one cannibal from left to right
    CR2 is CR + 1, CL2 is CL - 1, is_legal(CL2, ML, CR2, MR).

perform_movement([CL, ML, right, CR, MR], [CL, ML2, left, CR, MR2]) :-
    % Move two missionaries from right to left
    MR2 is MR - 2, ML2 is ML + 2, is_legal(CL, ML2, CR, MR2).

perform_movement([CL, ML, right, CR, MR], [CL2, ML, left, CR2, MR]) :-
    % Move two cannibals from right to left
    CR2 is CR - 2, CL2 is CL + 2, is_legal(CL2, ML, CR2, MR).

perform_movement([CL, ML, right, CR, MR], [CL2, ML2, left, CR2, MR2]) :-
    % Move one missionary and one cannibal from right to left
    CR2 is CR - 1, CL2 is CL + 1, MR2 is MR - 1, ML2 is ML + 1, is_legal(CL2, ML2, CR2, MR2).

perform_movement([CL, ML, right, CR, MR], [CL, ML2, left, CR, MR2]) :-
    % Move one missionary from right to left
    MR2 is MR - 1, ML2 is ML + 1, is_legal(CL, ML2, CR, MR2).

perform_movement([CL, ML, right, CR, MR], [CL2, ML, left, CR2, MR]) :-
    % Move one cannibal from right to left
    CR2 is CR - 1, CL2 is CL + 1, is_legal(CL2, ML, CR2, MR).

% Recursive path to find the solution
find_path([CL1, ML1, B1, CR1, MR1],
          [CL2, ML2, B2, CR2, MR2], Visited, Moves) :- 
    perform_movement([CL1, ML1, B1, CR1, MR1],
                     [CL3, ML3, B3, CR3, MR3]), 
    \+ member([CL3, ML3, B3, CR3, MR3], Visited),
    find_path([CL3, ML3, B3, CR3, MR3],
              [CL2, ML2, B2, CR2, MR2],
              [[CL3, ML3, B3, CR3, MR3] | Visited],
              [ [[CL3, ML3, B3, CR3, MR3], [CL1, ML1, B1, CR1, MR1]] | Moves ]).

% Reach the solution
find_path([CL, ML, B, CR, MR], [CL, ML, B, CR, MR], _, Moves) :- 
    print_solution(Moves).

% Print the solution
print_solution([]) :- nl.
print_solution([[E, M] | Moves]) :-
    print_solution(Moves),
    write('Boat: '), write(M), nl,
    write('Place: '), write(E), nl, nl.

% Solve the problem
solve :- 
    find_path([3,3,left,0,0], [0,0,right,3,3], [[3,3,left,0,0]], _).
