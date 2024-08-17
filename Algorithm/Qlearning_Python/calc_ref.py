from matplotlib.pyplot import switch_backend
from helper.calc_vector_limit_angle import calc_vector, limit_angle
import math
def calc_ref(action, robot, goal, nearestObs, vmax):
    kw = 5
    dirRobot = robot[2]
    [dirGoal, disGoal] = calc_vector(robot[0:2], goal)
    radObs = nearestObs[4]
    dirObs = nearestObs[3]
    disObs = nearestObs[2]
    # % Define list of possible action
    go_ahead   = 1
    turn_left  = 2
    turn_right = 3
    pi = math.pi
    if action == go_ahead: dirRef = dirGoal
    elif action == turn_left:
        if abs(limit_angle(dirObs - dirRobot)) < math.pi/3:
            dirRef = dirObs + math.pi/2
        else:
            dirRef = dirGoal
    elif action == turn_right:
        if abs(limit_angle(dirObs - dirRobot)) < pi/3:
            dirRef = dirObs - pi/2
        else :
            dirRef = dirGoal
    vRef = vmax
    wRef = kw*limit_angle(dirRef - dirRobot)
    return vRef, wRef