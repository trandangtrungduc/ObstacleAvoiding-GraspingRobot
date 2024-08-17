function eGoal = sense_goal(robot, goal)
%Calculate the longitudinal and angular error respect to dir of the robot
posRobot = robot(1:2);
dirRobot = robot(3);

[dirGoal, disGoal] = calc_vector(posRobot, goal);
eGoal(3) = dirGoal - dirRobot;
eGoal(1) = disGoal * cos(eGoal(3));
eGoal(2) = disGoal * sin(eGoal(3));