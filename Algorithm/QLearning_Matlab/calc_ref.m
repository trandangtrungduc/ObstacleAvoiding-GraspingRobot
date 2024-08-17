function [vRef, wRef] = calc_ref(action, robot, goal, nearestObs)
% getAction - calculate the reference speed of the mobile robot respect to
% the action 
v = 750;
kv = 2.5;
kw = 3;
dirRobot = robot(3);
[dirGoal, disGoal] = calc_vector(robot(1:2), goal);
radObs = nearestObs(5);
disObs = nearestObs(3);
% Define list of possible action
go_ahead   = 1;
turn_left  = 2;
turn_right = 3;

switch action
    case go_ahead
        dirRef = dirGoal;
        
    case turn_left
        dirRef = dirGoal + pi/2*(radObs*2/disObs);    
        
    case turn_right
        dirRef = dirGoal - pi/2*(radObs*2/disObs);
end

if disGoal < 500
    vRef = kv*disGoal;
    dirRef = dirGoal;
else
    vRef = v;
end
wRef = kw*(dirRef - dirRobot);