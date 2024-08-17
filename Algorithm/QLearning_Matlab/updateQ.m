function Q = updateQ(Q, action, currentEnvState, currentActionState, nextEnvState,...
                    nextActionState)

% discount factor
gamma = 0.7;
reward = get_reward(currentActionState, nextActionState);
MaxQ_nextState = max(Q(nextEnvState,:));                
Q(currentEnvState, action) = reward + gamma*MaxQ_nextState;