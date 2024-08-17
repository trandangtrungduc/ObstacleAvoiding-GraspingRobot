%% Simulation the trajectory of the mobile robot to avoid the obstacle and go to the desired goal
clc
clear
addpath(genpath(pwd));

% Very first variables
count = 0;
dt = 0.01;
radSafe = 20;
disDanger = 800;
error = 0;

% Intialize plot variables
global t posPlot dirPlot vPlot wPlot closestPlot
t           = zeros(5000, 1);
posPlot     = zeros(5000, 2);
dirPlot     = zeros(5000, 1);
vPlot       = zeros(5000, 1);
wPlot       = zeros(5000, 1);
closestPlot = zeros(5000, 1);

% Initialize environment(moving and static obstacle) and robot parameters
[start, goal, staticObs, movingObs, hMObs] = init_env();
[robot, robotParams, hRobot] = init_robot(start);
count = count + 1;
posPlot(count, :) = robot(1:2);
dirPlot(count, :) = robot(3);
vPlot(count) = robot(4);
wPlot(count) = robot(5);
closestPlot(count) = disDanger;
eGoal = sense_goal(robot, goal);
collided = 0;
while (abs(eGoal(1)) > 5 || abs(eGoal(2)) > 5)
    % Motion of the robot and moving obstacles
    count = count + 1;
    prev_posRobot = robot(1:2);
    [movingObs, hMObs] = update_mObs(movingObs, hMObs, dt);
    senseObs = sense_obs(staticObs, movingObs, robot, radSafe, dt);
    dangerObs = sense_danger(senseObs, robotParams, disDanger);
    nearestObs = senseObs(1,:);
    disClosestObs = nearestObs(1)- nearestObs(3) - robotParams(1)+radSafe;
    refParams = calc_ref(robot, dangerObs, goal);
    [robot, hRobot] = update_robot(robot, hRobot, robotParams, refParams, dt);
    t(count) = t(count-1) + dt;
    posRobot = robot(1:2);
    hold on
    plot([prev_posRobot(1), posRobot(1)], [prev_posRobot(2), posRobot(2)], ":r");
    hold off
    posPlot(count, :) = robot(1:2);
    dirPlot(count, :) = robot(3);
    vPlot(count) = robot(4);
    wPlot(count) = robot(5);
    closestPlot(count) = disClosestObs ;
    if disClosestObs < 0
        disp('Robot collided with an obstacle');
        collided = 1;
        break;
    end
    eGoal = sense_goal(robot, goal);
    pause(dt);
end
% Turn back to the origin
temp = goal;
goal = start;
start = temp;
eGoal = sense_goal(robot, goal);
while (abs(eGoal(1)) > 5 || abs(eGoal(2)) > 5) && ~collided
    % Motion of the robot and moving obstacles
    count = count + 1;
    prev_posRobot = robot(1:2);
    [movingObs, hMObs] = update_mObs(movingObs, hMObs, dt);
    senseObs = sense_obs(staticObs, movingObs, robot, radSafe, dt);
    dangerObs = sense_danger(senseObs, robotParams, disDanger);
    nearestObs = senseObs(1,:);
    disClosestObs = nearestObs(1)- nearestObs(3) - robotParams(1) + radSafe;
    refParams = calc_ref(robot, dangerObs, goal);
    [robot, hRobot] = update_robot(robot, hRobot, robotParams, refParams, dt);
    t(count) = t(count-1) + dt;
    posRobot = robot(1:2);
    hold on
    plot([prev_posRobot(1), posRobot(1)], [prev_posRobot(2), posRobot(2)], ":r");
    hold off
    posPlot(count, :) = robot(1:2);
    dirPlot(count, :) = robot(3);
    vPlot(count) = robot(4);
    wPlot(count) = robot(5);
    closestPlot(count) = disClosestObs ;
    if disClosestObs < 0
        disp('Robot collided with an obstacle');
        break;
    end
    eGoal = sense_goal(robot, goal);
    pause(dt);
end

% Plot the final results
plot_results(count);

% Remove the path to avoid conflict with other function
rmpath(genpath(pwd))
%% Helper function
%-------------------------------------------------------------------------%
function plot_results(count)
    global t posPlot dirPlot vPlot wPlot closestPlot
    % Plot the info about the robot
    figure('Name','Robot parameters');
    % Create a position graph
    subplot(2,2,1)
    plot(t(1:count), posPlot(1:count,:), 'LineWidth', 2);
    title('Robot Position');
    ylabel('Position(mm)');
    xlabel('time(s)');
    hold on;

    % Create a direction graph
    subplot(2,2,2)
    plot(t(1:count), dirPlot(1:count), 'LineWidth', 2);
    title('Robot Direction');
    ylabel('Direction(rad)');
    xlabel('time(s)');
    hold on;

    % Create a position graph
    subplot(2,2,3)
    plot(t(1:count), vPlot(1:count), 'LineWidth', 2);
    title('Robot Velocity');
    ylabel('v(mm/s^2)');
    xlabel('time(s)');
    hold on;

    % Create a direction graph
    subplot(2,2,4)
    plot(t(1:count), wPlot(1:count), 'LineWidth', 2);
    title('Robot Angular Velocity');
    ylabel('\omega(rad/s)');
    xlabel('time(s)');
    hold off;

    % Create closest distance graph
    figure('Name', 'Closest distance');
    plot(t(1:count), closestPlot(1:count), 'LineWidth', 2);
    title('Obstacle Closest Distance');
    ylabel('distance (mm)');
    xlabel('time(s)');
end
%-------------------------------------------------------------------------%
