function dangerObs = sense_danger(senseObs, robotParams, disDanger)
%Detect dangerous obstacle which can collide with robot
radRobot = robotParams(1);
[numObs, ~] = size(senseObs);
dangerObs = zeros(numObs, 4);
countDanger = 0;

for i=1:numObs
    disObs = senseObs(i, 1);
    radObs = senseObs(i, 3);
    dirObs = senseObs(i, 2);
    vObs = senseObs(i,4);
    disSafe = radObs + radRobot;
    disObs_real = disObs - disSafe;
    if  disObs_real < disDanger
        countDanger = countDanger + 1;
        try
            beta_high = abs(atan2(disSafe, sqrt(disObs^2 - disSafe^2)));
            beta_low = beta_high;
            if vObs ~= 0
                k1 = min(1, 150/(50+disObs_real));
                k2 = 1;
                del_angle = limit_angle(senseObs(i,5) - dirObs);              
                if del_angle > 0
                    
                    beta_high = pi/2;
%                     beta_high = min(beta_high*(k1 + k2*abs(cos(del_angle))), pi/2);
                    beta_low = min(beta_low*(k1), pi/2);
                elseif del_angle < 0
                    beta_high = min(beta_high*(k1), pi/2);
%                     beta_low = pi/2;
                    beta_low = min(beta_low*(k1 + k2*abs(cos(del_angle))), pi/2);
                end
                vObs = cos(del_angle)*vObs;
            end
        catch
            beta_high = pi/2;
            beta_low = beta_high;
        end
        rangeObs =  sort_range([limit_angle(dirObs+beta_high) , limit_angle(dirObs-beta_low)]);
        dangerObs(countDanger, :) = [disObs_real, rangeObs, vObs];
    end
end

if countDanger == 0
    dangerObs = [];
else
    dangerObs = dangerObs(1:countDanger,:);
end

function pair = sort_range(pair)
    if pair(1) > pair(2)
        pair = [pair(2), pair(1)];
    end
end

end
        
        
