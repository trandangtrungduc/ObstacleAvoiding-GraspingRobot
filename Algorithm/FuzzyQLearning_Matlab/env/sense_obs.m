 function senseObs = sense_obs(staticObs, movingObs,  robot)
% sense_obs - Output list of position, calculated distance and direction, radius
% from each obstacle to the robot.
% Output: x y disObs dirObs radObs

[numSObs, ~] = size(staticObs);
[numMObs, ~] = size(movingObs);
senseObs = zeros(numSObs+numMObs, 5);
posRobot = robot(1:2);

for i=1:numSObs
    posObs = staticObs(i,1:2);
    radObs = staticObs(i, 3);
    [dirObs, disObs] = calc_vector(posRobot, posObs);
    senseObs(i,:) = [posObs, disObs, dirObs, radObs];
end

for i=1:numMObs
    posObs = movingObs(i, 1:2);
    radObs = movingObs(i, 4);
    [dirObs, disObs] = calc_vector(posRobot, posObs);
    senseObs(numSObs+i,:) = [posObs, disObs, dirObs, radObs];
end

% Sort the senseObs from nearest to farest (bubble sort)
numObs = numSObs+numMObs;
if numObs > 1
    for i = 0:(numObs-1)
        not_swapped = true;
        for j = 1:(numObs-i-1)
            if senseObs(j,3) > senseObs(j+1,3)
                temp = senseObs(j,:);
                senseObs(j,:) = senseObs(j+1,:);
                senseObs(j+1,:) = temp;
                not_swapped = false;
            end
        end
        if not_swapped
            break
        end
    end
end