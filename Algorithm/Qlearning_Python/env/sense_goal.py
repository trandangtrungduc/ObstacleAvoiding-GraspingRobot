import numpy as np
from helper.calc_add_limit_vector import calc_vector


def sense_goal(robot, goal):
    """ Calculate the longitudinal and angular error respect to dir of the robot """
    posRobot = robot[0:2]
    dirRobot = robot[2]
    eGoal = np.zeros(3, dtype=np.float64)
    [dirGoal, disGoal] = calc_vector(posRobot, goal)
    eGoal[2] = dirGoal - dirRobot
    eGoal[0] = disGoal * np.cos(eGoal[2])
    eGoal[1] = disGoal * np.sin(eGoal[2])
    return eGoal
