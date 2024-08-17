from get_reward import get_reward
def updateQ(Q, action, currentEnvState, currentActionState, nextEnvState,nextActionState):

# % discount factor
    gamma = 0.6
    reward = get_reward(currentActionState, nextActionState)
    MaxQ_nextState = max(Q[nextEnvState,:])             
    Q[currentEnvState, action] = reward + gamma*MaxQ_nextState
    return Q