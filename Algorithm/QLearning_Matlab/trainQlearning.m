% trainQlearning - function to get right behaviour of the robot to move
% correctly from start to goal
clc
addpath(genpath(pwd));
espisodes = 100;
dt = 0.01;
N_State  = 8;
N_Action = 3;
disSafe = 500;

% Denote each state as a number
WS = 0; %winning state
SS = 1; %safe state
FS = 3; %failure state

% Intialize plot variables
global t posPlot dirPlot vPlot wPlot closestPlot
t           = zeros(5000, 1);
posPlot     = zeros(5000, 2);
dirPlot     = zeros(5000, 1);
vPlot       = zeros(5000, 1);
wPlot       = zeros(5000, 1);
closestPlot = zeros(5000, 1);

[start, goal, staticObs, movingObs, hMObs, hStart] = init_env();
question = 'Are you ready to start?';
dlgtitle = 'Begin';
option1 = 'Yes';
option2 = 'No';
option = questdlg(question, dlgtitle, option1, option2, option1);
count = 0;
if strcmp(option, option1)
    delete(hStart);
    [robot, robotParams, hRobot, hStart] = init_robot(start, goal);
    initialMovingObs = movingObs;
    question = 'Initialize Q-table';
    dlgtitle = 'Q-learning';
    option1 = 'Load a file';
    option2 = 'Create a new one';
    option = questdlg(question, dlgtitle, option1, option2, option1);
    if strcmp(option, option1)
        loadfile = inputdlg('Load file:', dlgtitle, [1 35], {'Q1.mat'}, 'on');
        loadfile = loadfile{1};
        load(loadfile, 'Q');
    else
        Q = zeros(N_State, N_Action);
    end

    for i=1:espisodes
        fprintf('Espisode %d:', i);
        senseObs = sense_obs(staticObs, movingObs, robot);
        nearestObs = senseObs(1,:);
        currentEnvState = get_env_state(robot, nearestObs);
        currentActionState = get_action_state(robot, robotParams, nearestObs, goal, disSafe);
        h = [];
        count = count+1;
        posPlot(count, :) = robot(1:2);
        dirPlot(count, :) = robot(3);
        vPlot(count) = robot(4);
        wPlot(count) = robot(5);
        closestPlot(count) = disDanger;
        eGoal = sense_goal(robot, goal);
        while (currentActionState(1) ~= WS) && (currentActionState(1) ~= FS)
            action = get_action(currentEnvState, Q);
%             if currentActionState(1) == SS
%                 action = 1;
%             end
            prev_posRobot = robot(1:2);
            [vRef, wRef] = calc_ref(action, robot, goal, nearestObs);
            [movingObs, hMObs] = update_mObs(movingObs, hMObs, dt);
            [robot, hRobot] = update_robot(robot, hRobot, robotParams, [vRef, wRef], dt);
            senseObs = sense_obs(staticObs, movingObs, robot);
            nearestObs = senseObs(1,:);
            count = count+1;
            t(count) = t(count-1) + dt;
            posRobot = robot(1:2);
            hold on
            h1 = plot([prev_posRobot(1), posRobot(1)], [prev_posRobot(2), posRobot(2)], ":r");
            h = [h h1];
            hold off
            posPlot(count, :) = robot(1:2);
            dirPlot(count, :) = robot(3);
            vPlot(count) = robot(4);
            wPlot(count) = robot(5);
            closestPlot(count) = nearestObs(3)-nearestObs(5)-robotParams(1);
            nextEnvState = get_env_state(robot, nearestObs);
            nextActionState = get_action_state(robot, robotParams, nearestObs, goal, disSafe);
            if true % nextActionState(1) ~= FS
                Q = updateQ(Q, action, currentEnvState, currentActionState, nextEnvState,...
                            nextActionState);
            end
            currentActionState = nextActionState;
            currentEnvState = nextEnvState;
            drawnow
        end
        if currentActionState(1) == WS
                fprintf(' Success\n');
                break;
        else
            fprintf(' Collided\n');
        end
        count = 0;
        delete(h);
        [robot, hRobot, hStart] = reset_robot(start, hRobot, robotParams, goal, hStart);
        [movingObs, hMObs] = reset_mObs(initialMovingObs, hMObs);
    end
    f = figure;   
    col = {'Go ahead', 'Turn left', 'Turn Right'};
    row = {'G1', 'G2', 'G3', 'G4', 'G5', 'G6', 'G7', 'G8'};
    uitable(f,'columnname', col,'rowname', row, 'Data', Q);
end
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
