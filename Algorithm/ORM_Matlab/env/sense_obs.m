 function senseObs = sense_obs(staticObs, movingObs, robot, radSafe)
% Calculate the distance and direction from each obstacle to the robot
[numSObs, ~] = size(staticObs);
[numMObs, ~] = size(movingObs);
senseObs = zeros(numSObs+numMObs, 5);
posRobot = robot(1:2);

for i=1:numSObs
    posObs = staticObs(i,1:2);
    radObs = staticObs(i, 3) + radSafe;
    [dirObs, disObs] = calc_vector(posRobot, posObs);
    senseObs(i,:) = [disObs, dirObs, radObs, 0, 0];
end

for i=1:numMObs
    posObs = movingObs(i, 1:2);
    radObs = movingObs(i, 4) + radSafe;
    vObs = movingObs(i,7);
    [dirObs, disObs] = calc_vector(posRobot, posObs);
    switch movingObs(i,8)
        case -1
            [dirMove, ~] = calc_vector(movingObs(i,5:6), posObs);
            dirMove = limit_angle(dirMove + pi/2);
        case 0
            dirMove = movingObs(i,6);
        case 1
            [dirMove, ~] = calc_vector(movingObs(i,5:6), posObs);
            dirMove = limit_angle(dirMove - pi/2);
    end
    senseObs(numSObs+i,:) = [disObs, dirObs, radObs, vObs, dirMove];
end

% Sort the senseObs from nearest to farest (bubble sort)
numObs = numSObs+numMObs;
if numObs > 1
    for i = 0:(numObs-1)
        not_swapped = true;
        for j = 1:(numObs-i-1)
            if senseObs(j,1) > senseObs(j+1,1)
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
    