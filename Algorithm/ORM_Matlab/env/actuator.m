function [vRobot, wRobot] = actuator(curParams, refParams, robotParams, dt)
%Calculate the next state of robot up to current and reference state
vMax = robotParams(2);
wMax = robotParams(3);
av = robotParams(4);
aw = robotParams(5);
vCur = curParams(1);
wCur = curParams(2);
vRef = refParams(1);
wRef = refParams(2);
dv = av*dt;
dw = aw*dt;

if vRef < 0
    vRef = 0;
end

vRobot = calc(vRef, vCur, vMax, dv);
wRobot = calc(wRef, wCur, wMax, dw);

% Assume that robot can not go backward
if vRobot < 0
    vRobot = 0;
end
    
function aNext = calc(aRef, aCur, aMax, da)
    if (aRef - aCur) < -da/2
        aNext = aCur - da;
    elseif (aRef - aCur) > da/2
        aNext = aCur + da;
    else
        aNext = aCur;
    end
    
    if aNext > aMax
        aNext = aMax;
    end
end

end