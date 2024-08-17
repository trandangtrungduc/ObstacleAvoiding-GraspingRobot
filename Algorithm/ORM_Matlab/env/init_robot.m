function [robot, robotParams, hRobot, hStart] = init_robot(start, goal)
% Initialize paramater and handle of robot on figure

% % Get the parameter of the robot
% prompt = ["Enter robot's vmax (mm/s):"... 
%           "Enter robot's wmax (pi*rad/s):",...
%           "Enter robot's av(mms/s^2):",...
%           "Enter robot's aw(pi*rad/s^2):",...
%           "Enter robot's radius(mm)"];
% dlgtitle = 'Robot parameters';
% dims = [1, 35];
% definput = {'1000', '4', '1000', '4', '100'};
% params = inputdlg(prompt, dlgtitle, dims, definput, 'on');
% vmax = str2double(params{1});
% wmax = pi*str2double(params{2});
% av = str2double(params{3});
% aw = pi*str2double(params{4});
% radRobot = str2double(params{5});
vmax = 1000;
wmax = 2*pi;
av = 1000;
aw = 6*pi;
radRobot = 100;
robotParams = [radRobot, vmax, wmax, av, aw];

countStart = size(start, 1);
posStart = start(randi(countStart),:);
% Initial changeable params
vRobot = 0;
wRobot = 0;
dirRobot = 0;
posRobot = posStart;
robot = [posRobot, dirRobot, vRobot, wRobot];

hold on
h1 = plot(posStart(1), posStart(2), 'gp');
h2 = text(posStart(1)+100, posStart(2)+100, 'Start');
h3 = plot([posStart(1), goal(1)], [posStart(2), goal(2)], ':', 'Color', 'cyan');
hStart = [h1 h2 h3];
% Draw robot on figure
h1 = viscircles(posRobot, radRobot, 'LineWidth', 1, 'Color', 'green');
h2 = line([posRobot(1), posRobot(1)+radRobot*cos(dirRobot)],...
          [posRobot(2), posRobot(2)+radRobot*sin(dirRobot)],...
          'LineWidth', 1, 'Color', 'red');
hRobot = [h1, h2];    
hold off