def get_reward(currentActionState, nextActionState):
    # % getReward() - reward function immediately evaluate the action at a given
    # % sate
    # % Input:  robot    - current state of the robot
    # %         obstacle - nearest obstacle
    # %         action   - action of the robot.
    # % Output: reward   - the reward according to the action
    # %-------------------------------------------------------------------------%
    # %               Reward of transition between each state
    # %
    # % r = 2  - SS -> WS
    # % r = 1  - SS -> SS moving closer to the goal
    # % r = 1  - NS -> SS 
    # % r = -1 - SS -> NS
    # % r = -1 - NS -> NS moving closer to the obs
    # % r = 0  - NS -> NS moving further from the obs
    # % r = 0  - SS -> SS moving further from the goal
    # % r = -2 - NS -> FS

    # % Denote each state as a number
    WS = 0
    SS = 1
    NS = 2
    FS = 3

    currentState = currentActionState[0]
    currentDisObs = currentActionState[1]
    currentDisGoal = currentActionState[2]

    nextState = nextActionState[0]
    nextDisObs = nextActionState[1]
    nextDisGoal = nextActionState[2]

    if currentState == SS:
        if nextState == WS:
            reward = 2
        elif nextState == NS:
            reward = -1
        elif nextState == SS:
            if nextDisGoal < currentDisGoal:
                reward = 1
            else:
                reward = 0
    elif currentState == NS:
        if nextState == FS:
            reward = -2
        elif nextState == SS:
            reward = 1
        elif nextState == NS:
            if nextDisObs < currentDisObs:
                reward = -1
            else:
                reward = 0
        elif nextState == WS:
            reward = 2
    elif currentState == FS:
        reward = -2
    elif currentState == WS:
        reward = 2
    return reward

    # % if currentState == FS
    # %     reward = -2;
    # % elseif currentState == WS
    # %     reward = 2;
    # % else
    # %     if nextDisObs <= currentDisObs
    # %         reward = -1;
    # %     elseif nextDisGoal < currentDisGoal
    # %         reward = 1;
    # %     else
    # %         reward = 0;
    # %     end
    # % end


