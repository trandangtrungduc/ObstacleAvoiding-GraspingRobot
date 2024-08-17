function action = get_action(envState, Q)
% get_action - function to get possible action based on the state in Qtable
% Index in Q table corespond with those actions
% go_ahead   = 1;
% turn_left  = 2;
% turn_right = 3;

[~, action] = max(Q(envState,:));