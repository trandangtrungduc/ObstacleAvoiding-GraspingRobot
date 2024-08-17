import numpy as np
from numpy import random

def reset_robot(start, hRobot, robotParams, goal, hStart):
    countStart = start.shape[0]
    posStart = start[random.randint(countStart), :]
    vRobot = 0
    wRobot = 0
    dirRobot = 0
    posRobot = posStart
    robot = np.array([posRobot[0], posRobot[1], dirRobot, vRobot, wRobot])
    # radRobot = robotParams[0]
    return [robot, hRobot, hStart]
    