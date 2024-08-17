function [robot, hRobot, hStart] = reset_robot(start, hRobot, robotParams, goal, hStart)
% Reset state of the robot after an espisode

countStart = size(start, 1);
posStart = start(randi(countStart),:);
% Initial changeable params
vRobot = 0;
wRobot = 0;
dirRobot = 0;
posRobot = posStart;
robot = [posRobot, dirRobot, vRobot, wRobot];
radRobot = robotParams(1);
hold on
delete(hStart);
h1 = plot(posStart(1), posStart(2), 'gp');
h2 = text(posStart(1)+100, posStart(2)+100, 'Start');
h3 = plot([posStart(1), goal(1)], [posStart(2), goal(2)], ':', 'Color', 'cyan');
hStart = [h1 h2 h3];
delete(hRobot);
% Draw robot on figure
h1 = viscircles(posRobot, radRobot, 'LineWidth', 1, 'Color', 'blue');
h2 = line([posRobot(1), posRobot(1)+radRobot*cos(dirRobot)],...
          [posRobot(2), posRobot(2)+radRobot*sin(dirRobot)],...
          'LineWidth', 1, 'Color', 'red');
hRobot = [h1, h2];
hold off
