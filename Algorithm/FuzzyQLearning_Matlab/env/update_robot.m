function [robot, hRobot] = update_robot(robot, hRobot, robotParams, refParams, dt)
%Update state of the robot after the time dt
posRobot = robot(1:2);
dirRobot = robot(3);
vRobot = robot(4);
wRobot = robot(5);
radRobot = robotParams(1);

[vRobot, wRobot] = actuator([vRobot, wRobot], refParams, robotParams, dt);
posRobot = posRobot + vRobot*dt*[cos(dirRobot), sin(dirRobot)];
dirRobot = dirRobot + wRobot*dt;
% Keep the dirRobot always in the range [-pi;pi]
if dirRobot > pi
    dirRobot = dirRobot - 2*pi;
elseif dirRobot < -pi
    dirRobot = dirRobot + 2*pi;
end
robot = [posRobot, dirRobot, vRobot, wRobot];
    
delete(hRobot);
vertices = zeros(4,2);
distance(1,:) = [-radRobot, radRobot];
distance(2,:) = [radRobot, radRobot];
distance(3,:) = [radRobot, -radRobot];
distance(4,:) = [-radRobot, -radRobot];
for i=1:4
    distance(i,:) = distance(i,:)*[cos(dirRobot) -sin(dirRobot);sin(dirRobot) cos(dirRobot)]';
    vertices(i,:) = posRobot + distance(i,:);
end
f1 = [1 2 3 4];
h1 = patch('Faces', f1, 'Vertices', vertices, 'EdgeColor', 'green', 'FaceColor', 'None', 'LineWidth', 1);
% h1 = viscircles(posRobot, radRobot, 'LineWidth', 1, 'Color', 'green');
h2 = line([posRobot(1), posRobot(1)+radRobot*cos(dirRobot)],...
          [posRobot(2), posRobot(2)+radRobot*sin(dirRobot)],...
          'LineWidth', 1, 'Color', 'red');
hRobot = [h1, h2];    