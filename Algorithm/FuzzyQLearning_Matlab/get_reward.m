function [reward, collided] = get_reward(d0, dn, disGoal_0, disGoal_n)
state0 = get_state(d0);
state1 = get_state(dn);
collided = 0;
FS = 1;
VNS = 2;
NS = 3;
SS = 4;

if state1 == FS
    reward = -2;
    collided = 1;
elseif state0 == NS
    if state1 == SS
        reward = 2;
    elseif state1 == VNS
        reward = -1;
    elseif dn < d0
        reward = -0.5;
    else
        reward = 0;
    end
elseif state0 == VNS && state1 == NS
    reward = 1;
elseif state0 == SS && (disGoal_0 > disGoal_n) 
    reward = 1;
elseif state1 == VNS && dn < d0
    reward = -1;
else
    reward = 0;
end

% if state1 == 1
%     reward = -2;
%     collided = 1;
% elseif state1 == 2
%     reward = -1;
% elseif state1 == 0
%     reward = 0;
% else
%     reward = 1;
% end
    
    

% function state = get_state(d)
%     if min(d) <= 0
%         state = 1; %Fail state
%     elseif d(3) < 200 || d(2) < 100 || d(4) < 100
%         state = 2; %Very non safe sate
%     elseif d(1) < 100 || d(2) < 300 || d(3) < 300 || d(4) < 300 || d(5) < 100
%         state = 3; %Non-safe state
%     elseif d(1) > 100 && d(2) > 300 && d(3) > 300 && d(4) > 300 && d(5) > 100
%         state = 4; %Safe state
%     end
% end
function state = get_state(d)
    if d <= -20
        state = 1; %Fail state
    elseif d < 200
        state = 2; %Very non safe sate
    elseif d < 500
        state = 3; %Non-safe state
    else
        state = 4; %Safe state
    end
end
end
