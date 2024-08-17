
from helper.calc_vector_limit_angle import calc_vector
def get_action_state(robot, robotParams, nearestObs, goal, disSafe):
# % get_action_state - determine safe or danger state of the robot to calculate
# % the reward or terminate the movement of the robot (reached goal or
# % collided with an obstacle)
# %-------------------------------------------------------------------------%
# %    Set of states that robot might be included to determine the reward
# % 
# % - Safe State (SS): robot has a low or no possibility for collision with any
# % of the obstacles in the environment.
# % - Non-Safe State (NS): robot has a high possibility for collision with
# % any of the obstacles in the environment
# % 
# % 2 terminate state:
# % - Winning State (WS): robot reaches its goal
# % - Failure State (FS): robot collides with an obstacle

    # % Compute necessary variables for determine the state
    radRobot = robotParams(1)
    radObs   = nearestObs(4)
    disWin = 30;    # Minimum distance between robot and goal to count as reach goal
    disCol = radRobot + radObs - 20
    disObs = nearestObs[2]
    disGoal= calc_vector(robot[0:2], goal)[1]

    # % Denote each state as a number
    WS = 0
    SS = 1
    NS = 2
    FS = 3

    # % Identify the state depend on the codition
    if disGoal < disWin:
        state = WS
    elif disObs <= disCol:
        state = FS
    elif disObs <= disSafe:
        state = NS
    elif disObs > disSafe:
        state = SS

    actionState = [state, disObs, disGoal]
    return actionState

