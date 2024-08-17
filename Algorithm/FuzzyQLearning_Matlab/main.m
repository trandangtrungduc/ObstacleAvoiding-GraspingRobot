%% Before running the program
addpath(genpath(pwd));
clearvars;
clc;
close all;

% Simulation params
tmax = 20;
dt = 0.03;
Nespisodes = 100;
vmax = 750;
kv = 2.5;
kw = 5;

% Record the video of the training phase
frame = 0;
vid = VideoWriter('testing.avi');
vid.Quality = 100;
vid.FrameRate = 20;
open(vid);

% Intialize plot variables
global t posPlot dirPlot vPlot wPlot closestPlot
t           = zeros(5000, 1);
posPlot     = zeros(5000, 2);
dirPlot     = zeros(5000, 1);
vPlot       = zeros(5000, 1);
wPlot       = zeros(5000, 1);
closestPlot = zeros(5000, 1);

%% Initialize fuzzy parameters
NConclusions = 5;
NRules = 25;
q = load("q1.mat", "q").q;
conclusions = zeros(NRules,1);
% Fuzzy output
NB = -pi/2;    
NS = -pi/4;    
Z  =  0;       
PS =  pi/4;    
PB =  pi/2;    
action = [NB; NS; Z; PS; PB];
seleced_action = zeros(NRules, 1);


%% Load the environment and confirm to start
f = figure('Name', 'Motion simulation');
[start, goal, staticObs, movingObs, hMObs, hStart] = init_env();
question = 'Are you ready to start?';
dlgtitle = 'Begin';
option1 = 'Yes';
option2 = 'No';
option = questdlg(question, dlgtitle, option1, option2, option1);

%% Main function
if strcmp(option, option1)
    delete(hStart);
    [robot, robotParams, hRobot, hStart] = init_robot(start, goal);
    initialMovingObs = movingObs;
    radRobot = robotParams(1);
    addedRandom = false;
    fprintf('Testing phase\n');
    for i=1:size(start,1)
        title(strcat(["Testing phase: Test case "], [string(i)]));
        [robot, hRobot, hStart] = reset_robot(start(i,:), hRobot, robotParams, goal, hStart);
        [movingObs, hMObs] = reset_mObs(initialMovingObs, hMObs);
        fprintf('Test case %d:', i);
        
        % Initialise plot variables
        count = 1;
        trace = [];
        posPlot(count, :) = robot(1:2);
        dirPlot(count, :) = robot(3);
        vPlot(count) = robot(4);
        wPlot(count) = robot(5);
        closestPlot(count) = 1000;
        
        % Initialise Q learning params
        collided = 0;
        
        [dirGoal, disGoal0] = calc_vector(robot(1:2), goal);
        while (t(count) < tmax && ~collided && disGoal0 > 20)
            xlabel(strcat(["t = "], [string(t(count))]));
           [dirGoal, disGoal0] = calc_vector(robot(1:2), goal);
            heading_angle = limit_angle(dirGoal-robot(3));
            senseObs = sense_obs(staticObs, movingObs, robot);
            nearestObs = senseObs(1,:);
            d0 = nearestObs(3) - radRobot - nearestObs(5);
            danger_angle = nearestObs(4) - robot(3);
            prev_posRobot = robot(1:2);
            if d0 > 600 || disGoal0 < 400
                vRef = kv*disGoal0;
                wRef = 2.5*(heading_angle);
                [robot, hRobot] = update_robot(robot, hRobot, robotParams, [vRef, wRef], dt);
                [movingObs, hMObs] = update_mObs(movingObs, hMObs, dt);
            else
                
                %% 2-select an action for each rule
                for rule=1:NRules
                    [~, Curr_Conclusion] = max(q(rule,:));     % the q table is in order
                    conclusions(rule)=Curr_Conclusion;              % update the conclusion of each rule
                end
                
                %% 3-calculate the control action by the fuzzy controller 
                %obs_data = get_obs(d0);
                rule_deg = get_rules(min(max(heading_angle/pi*180, -90), 90), min(max(danger_angle/pi*180, -120), 120));  % rule activation
                w_rule = rule_deg/sum(rule_deg);  
                selected_action = action(conclusions); 
                dirRef = selected_action'*w_rule;

                %% 5-take action a and let the system goes to the next state  
                vRef = vmax;
                wRef = kw*sin(dirRef + heading_angle);
                [robot, hRobot] = update_robot(robot, hRobot, robotParams, [vRef, wRef], dt);
                [movingObs, hMObs] = update_mObs(movingObs, hMObs, dt);
                [dirGoal, disGoaln] = calc_vector(robot(1:2), goal);
                heading_angle = limit_angle(dirGoal-robot(3));
                senseObs = sense_obs(staticObs, movingObs,  robot);
                nearestObs = senseObs(1,:);
                dn = nearestObs(3) - radRobot - nearestObs(5);
                danger_angle = nearestObs(4) - robot(3);
                
                %% 6- observe the reinforcement signal r(t+1) and compute the value for new state
                [~, collided]= get_reward(d0, dn, disGoal0, disGoaln);
            end
            %% Add random obstacles and record the video
            [~, disGoal] = calc_vector(robot(1:2), goal);
            if (disGoal < 800) && (~addedRandom)
                [randomObs, hRandom] = addRandomObs(robot, goal);
                staticObs = [staticObs; randomObs];
                addedRandom = true;
            end
                
            % Update the simulation at current time and record the frame
            drawnow
            frame = frame+1;
            M(frame) = getframe();
            writeVideo(vid,M(frame));
            
            % Update trace of the robot movement
            posRobot = robot(1:2);
            hold on
            h1 = plot([prev_posRobot(1), posRobot(1)], [prev_posRobot(2), posRobot(2)], ":r");
            trace = [trace h1];
            hold off
            
            % Update plotting record
            count = count+1;
            t(count) = t(count-1) + dt;
            posPlot(count, :) = robot(1:2);
            dirPlot(count, :) = robot(3);
            vPlot(count) = robot(4);
            wPlot(count) = robot(5);
            closestPlot(count) = dn;
        end
        
        %% Print out the results of the espisode
        if disGoal0 < 20
            fprintf(' Success \n');    
        elseif t(count) >= tmax
            fprintf(' Time out \n');
        else
            fprintf(' Collided \n');
        end
        
        %% Clear the environment after an espisode
        % Delete random obstacle if exists
        if addedRandom
            addedRandom = false;
            staticObs = staticObs(1:(end-1),:);
            delete(hRandom);
        end
        
        % Delete the trace line that the robot moving in this espisodes
        delete(trace);
    end
    plot_results(count);
end

%% After running the program 
close(vid);
rmpath(genpath(pwd));

%% Helper function
%-------------------------------------------------------------------------%
function [randomObs, hRandom] = addRandomObs(robot, goal)
    radObs = 80;
    distance = 300;
    dirGoal = calc_vector(robot(1:2), goal);
    posObs = goal + distance*[cos(dirGoal-pi) sin(dirGoal-pi)];
    hold on
    hRandom = viscircles(posObs, radObs, 'LineWidth', 1, 'Color', 'black');
    hold off
    randomObs = [posObs radObs];
end

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