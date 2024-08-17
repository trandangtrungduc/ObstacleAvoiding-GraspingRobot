import numpy as np
from numpy import random

def init_robot(start, goal): # start is a matrix, goal is a matrix
    vmax = 1000/8.55
    wmax = np.pi
    av = 1000
    aw = 6*np.pi
    radRobot = 100
    robotParams = [radRobot, vmax, wmax, av, aw]

    countStart = start.shape[0]
    posStart = start[random.randint(countStart),:]
    """ Initial changeable parameters """
    vRobot = 0
    wRobot = 0
    dirRobot = 0
    posRobot = posStart
    robot = np.array([posRobot[0], posRobot[1], dirRobot, vRobot, wRobot])
        
    return [robot, robotParams, posStart]     