function reward = get_reward(currentActionState, nextActionState)
% getReward() - reward function immediately evaluate the action at a given
% sate
% Input:  robot    - current state of the robot
%         obstacle - nearest obstacle
%         action   - action of the robot.
% Output: reward   - the reward according to the action
%-------------------------------------------------------------------------%
%               Reward of transition between each state
%
% r = 2  - SS -> WS
% r = 1  - SS -> SS moving closer to the goal
% r = 1  - NS -> SS 
% r = -1 - SS -> NS
% r = -1 - NS -> NS moving closer to the obs
% r = 0  - NS -> NS moving further from the obs
% r = 0  - SS -> SS moving further from the goal
% r = -2 - NS -> FS

% Denote each state as a number
WS = 0;
SS = 1;
NS = 2;
FS = 3;

currentState = currentActionState(1);
currentDisObs = currentActionState(2);
currentDisGoal = currentActionState(3);

nextState = nextActionState(1);
nextDisObs = nextActionState(2);
nextDisGoal = nextActionState(3);

if currentState == SS
    if nextState == WS
        reward = 3;
    elseif nextState == NS
        reward = -1;
    elseif nextState == SS
        if nextDisGoal < currentDisGoal
            reward = 2;
        else 
            reward = 0;
        end
    end
elseif currentState == NS
    if nextState == FS
        reward = -3;
    elseif nextState == SS
        reward = 1;
    elseif nextState == NS
        if nextDisObs < currentDisObs
            reward = -1;
        else
            reward = 0;
        end
    end
elseif currentState == FS
    reward = -3;
elseif currentState == WS
    reward = 3;
end


