function [refParams, rangeRobot, dirRef] = calc_ref(robot, dangerObs, goal)
%Calculate the reference velocity and angular speed depend on goal and
%danger obstacles.
[numObs, ~] = size(dangerObs);
k1 = 1.5;
k2 = 10;
k3 = 1.5;
k4 = 5;
kv = 20;
dirRobot = robot(3);
eGoal = sense_goal(robot, goal);
[dirGoal, disGoal] = calc_vector(robot(1:2), goal);
rangeRobot(1,:) = [-pi, pi];
vObsMin = 300;
dirRef = dirGoal;
% When no obstacle is detected in the danger zone
vRef = k1*eGoal(1);
wRef = k2*sin(eGoal(3));
if numObs ~= 0 && disGoal > 300
    % There are obstacles in danger zone
    nearestObs = dangerObs(1,:);
    for i=1:numObs
        disObs = dangerObs(i,1);
        rangeObs = dangerObs(i,2:3);
        if disObs < 300
            rangeRobot = update_rangeRobot(rangeRobot, rangeObs);
        end
        if numel(rangeRobot) == 0
            break
        end
    end
    dirRef = calc_dirRef(rangeRobot, nearestObs, dirGoal);
    % vRef proportional to distance of closest obstacle
    del_theta = abs(limit_angle(nearestObs(3)-dirRobot));
    if  del_theta < pi/2
        vObsMin = min((vObsMin)*sin(del_theta)*kv, vObsMin);
    end
    vRef = min(vRef, max(0, vObsMin + k3*nearestObs(1)));
    wRef = k4*sin(dirRef - dirRobot);
end

refParams = [vRef, wRef];
%--------------------------------End--------------------------------------%

%-------------------------Helper Function---------------------------------%
% Add a new accepted range of direction into current list of available
% range
function new_rangeRobot = update_rangeRobot(rangeRobot, rangeObs)
    new_numRange = 0;
    [numRange, ~] = size(rangeRobot); 
    new_rangeRobot = zeros(numRange+1, 2);
    if rangeObs(2) - rangeObs(1) <= pi
        range(1,:) = [-pi, rangeObs(1)];
        range(2,:) = [rangeObs(2), pi];
        for j = 1:numRange
            new_range1 = intersect(range(1,:), rangeRobot(j,:));
            new_range2 = intersect(range(2,:), rangeRobot(j,:));
            if numel(new_range1) ~= 0
                new_numRange= new_numRange + 1;
                new_rangeRobot(new_numRange, :) = new_range1;
            end
            if numel(new_range2) ~= 0
                new_numRange= new_numRange + 1;
                new_rangeRobot(new_numRange, :) = new_range2; 
            end
        end
            
    else
        range = rangeObs;
        for j = 1:numRange
            new_range = intersect(range, rangeRobot(j,:));
            if numel(new_range) ~= 0
                new_numRange= new_numRange + 1;
                new_rangeRobot(new_numRange, :) = new_range; 
            end
        end     
    end
    
    % In case the new range of obstacle cover all available range of robot
    if new_numRange == 0
        new_rangeRobot = [];
    else
        new_rangeRobot = new_rangeRobot(1:new_numRange,:); 
    end
end

% Calculate dirRef of robot depend on rangeRobot, dirGoal and closestObs
function dirRef = calc_dirRef(rangeRobot, closestObs, dirGoal)
    maxDis = 300;
    minDis = 100;
    k = pi/180;
    if numel(rangeRobot) == 0
        if abs(closestObs(2) - dirGoal) > abs(closestObs(3) - dirGoal)
            dirRef = closestObs(3)-k*maxDis/(minDis+closestObs(1));
        else
            dirRef = closestObs(2)+k*maxDis/(minDis+closestObs(1));
        end
    else
        [numRange, ~] = size(rangeRobot);
        if dirGoal < rangeRobot(1,1)
            dirRef = rangeRobot(1,1)+k*maxDis/(minDis+closestObs(1));
        elseif dirGoal > rangeRobot(numRange,2)
            dirRef = rangeRobot(numRange, 2)-k*maxDis/(minDis+closestObs(1));
        else
            for j=1:numRange
                if (dirGoal >= rangeRobot(j,1)) && (dirGoal <= rangeRobot(j, 2))
                    dirRef = dirGoal;
                    break;
                elseif (j+1<=numRange) && (dirGoal < rangeRobot(j+1,1))
                    if (dirGoal - rangeRobot(j,2)) > (rangeRobot(j+1,1) - dirGoal)
                        dirRef = rangeRobot(j+1, 1) + min(k*maxDis/(minDis+closestObs(1)), (rangeRobot(j+1, 2) - rangeRobot(j+1, 1))/2);
                    else
                        dirRef = rangeRobot(j, 2) - min(k*maxDis/(minDis+closestObs(1)), (rangeRobot(j, 2) - rangeRobot(j, 1))/2);
                    end
                    break;
                end
            end
        end            
    end
end

% Find the intersect of two range [a1, b1] and [a2, b2]
function range = intersect(range1, range2)
    a = max(range1(1), range2(1));
    b = min(range1(2), range2(2));
    if a > b
        range = [];
    else
        range = [a, b];
    end
end

end