import numpy as np
from numpy import random


def init_robot(start, goal):
    vmax = 750
    wmax = 2*np.pi
    av = 1000
    aw = 4*np.pi
    radRobot = 100
    robotParams = [radRobot, vmax, wmax, av, aw]

    countStart = start.shape[0]
    posStart = start[random.randint(countStart), :]
    """ Initial changeable parameters """
    vRobot = 0
    wRobot = 0
    dirRobot = 0
    posRobot = posStart
    robot = np.array([posRobot[0], posRobot[1], dirRobot, vRobot, wRobot])

    return [robot, robotParams, posStart]
