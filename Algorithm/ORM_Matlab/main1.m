%% Simulation the trajectory of the mobile robot to avoid the obstacle and go to the desired goal
clc
clear
addpath(genpath(pwd));

% Very first variables
count = 0;
dt = 0.01;
disDanger = 800;
radSafe = 50;
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
[start, goal, staticObs, movingObs, hMObs, hStart] = init_env();
[robot, robotParams, hRobot] = init_robot(start, goal);
question = 'Are you ready to start?';
dlgtitle = 'Begin';
option1 = 'Yes';
option2 = 'No';
option = questdlg(question, dlgtitle, option1, option2, option1);

if strcmp(option, option1)
    delete(hStart);
    
    count = count + 1;
    posPlot(count, :) = robot(1:2);
    dirPlot(count, :) = robot(3);
    vPlot(count) = robot(4);
    wPlot(count) = robot(5);
    closestPlot(count) = disDanger;
    eGoal = sense_goal(robot, goal);

    while (~error && (abs(eGoal(1)) > 10 || abs(eGoal(2)) > 10))
        % Motion of the robot and moving obstacles
        count = count + 1;
        t(count) = t(count-1) + dt;
        prev_posRobot = robot(1:2);
        [movingObs, hMObs] = update_mObs(movingObs, hMObs, dt);
        senseObs = sense_obs(staticObs, movingObs, robot, radSafe);
        dangerObs = sense_danger(senseObs, robotParams, disDanger);
        nearestObs = senseObs(1,:);
        disClosestObs = nearestObs(1)- nearestObs(3) - robotParams(1) + radSafe;
        [refParams, rangeRobot, dirRef] = calc_ref(robot, dangerObs, goal);
        [robot, hRobot] = update_robot(robot, hRobot, robotParams, refParams, dt);
        
        % Update trace of the robot
        posRobot = robot(1:2);
        hold on
        plot([prev_posRobot(1), posRobot(1)], [prev_posRobot(2), posRobot(2)], ":r");
        hold off
        
        % Update plot variables
        posPlot(count, :) = robot(1:2);
        dirPlot(count, :) = robot(3);
        vPlot(count) = robot(4);
        wPlot(count) = robot(5);
        closestPlot(count) = disClosestObs ;
        
        % Check if the robot collided with an obstacle
        if disClosestObs < 0
            uiwait(msgbox('Robot collided with an obstacle', 'Error', 'error'));
            disp('Robot collided with an obstacle');
            break;
        end
        eGoal = sense_goal(robot, goal);
        pause(dt);
    end

% Plot the final results
plot_results(count);
end


% Remove the path to avoid conflict with other function
rmpath(genpath(pwd))
%% Helper function
%-------------------------------------------------------------------------%
function plot_results(count)
    global t posPlot dirPlot vPlot wPlot closestPlot
    % Plot the info about the robot
    figure('Name','Robot parameters');
    % Create a position graph
    subplot(3,2,1)
    plot(t(1:count), posPlot(1:count,:), 'LineWidth', 2);
    title('Robot Position');
    ylabel('Position(mm)');
    xlabel('time(s)');
    hold on;

    % Create a direction graph
    subplot(3,2,2)
    plot(t(1:count), dirPlot(1:count), 'LineWidth', 2);
    title('Robot Direction');
    ylabel('Direction(rad)');
    xlabel('time(s)');
    hold on;

    % Create a position graph
    subplot(3,2,3)
    plot(t(1:count), vPlot(1:count), 'LineWidth', 2);
    title('Robot Velocity');
    ylabel('v(mm/s^2)');
    xlabel('time(s)');
    hold on;

    % Create a direction graph
    subplot(3,2,4)
    plot(t(1:count), wPlot(1:count), 'LineWidth', 2);
    title('Robot Angular Velocity');
    ylabel('\omega(rad/s)');
    xlabel('time(s)');
    hold off;

    % Create closest distance graph
    subplot(3,2,5:6)
    plot(t(1:count), closestPlot(1:count), 'LineWidth', 2);
    title('Obstacle Closest Distance');
    ylabel('distance (mm)');
    xlabel('time(s)');
end
%-------------------------------------------------------------------------%